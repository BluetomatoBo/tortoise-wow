package web

import (
	"net/http/httptest"
	"strings"
	"testing"

	"tortoiseweb/internal/i18n"
	"tortoiseweb/internal/store"
)

// tooltipItem is a fixture with one of everything a tooltip can show, so a
// template branch that breaks shows up here rather than on a live page.
func tooltipItem() store.ContentItem {
	return store.ContentItem{
		Entry: 80119, Name: "Mechanical Drumstick", Quality: 2,
		InventoryType: 13, ItemLevel: 30, RequiredLevel: 25,
		Bonding: 1, MaxCount: 1, SellPrice: 1234,
		DamageMin: 12.5, DamageMax: 20.5, Delay: 1800,
		Armor: 42, Block: 7,
		Stats:       []store.ContentItemStat{{Type: 7, Value: 15}, {Type: 6, Value: -3}},
		Resistances: []store.ContentItemResistance{{School: 2, Value: 10}},
		Spells:      []store.ContentItemSpell{{Slot: 1, SpellID: 133, Trigger: 0, Charges: 3}},
	}
}

func tooltipView(lang i18n.Lang) dbTooltipView {
	bundle, err := i18n.Load()
	if err != nil {
		panic(err)
	}
	item := tooltipItem()
	return dbTooltipView{
		PageData: PageData{Year: 2026, Tr: bundle.Translator(lang),
			Langs:  i18n.Supported,
			Config: PageConfig{SiteName: "T", PasswordMinLen: 6, SessionTTLHours: 1, DefaultLang: string(lang)}},
		Item:   item,
		Unique: item.MaxCount == 1,
		Spells: []dbTooltipSpell{{SpellID: 133, Name: "火球术", Trigger: 0}},
	}
}

// TestTooltipIsAFragment is the point of RenderFragment: a tooltip is dropped
// into an existing page, so the markup has to start at the box. A layout leaking
// in would put a nested <html> inside the page that fetched it.
func TestTooltipIsAFragment(t *testing.T) {
	rend, err := newRenderer()
	if err != nil {
		t.Fatal(err)
	}

	rec := httptest.NewRecorder()
	rend.RenderFragment(rec, "db_item_tooltip", tooltipView(i18n.ZH))

	if rec.Code != 200 {
		t.Fatalf("status = %d", rec.Code)
	}
	if ct := rec.Header().Get("Content-Type"); !strings.HasPrefix(ct, "text/html") {
		t.Errorf("content type = %q", ct)
	}
	body := rec.Body.String()
	for _, unwanted := range []string{"<!DOCTYPE", "<html", "<body"} {
		if strings.Contains(body, unwanted) {
			t.Errorf("fragment contains %q:\n%s", unwanted, body)
		}
	}
	if !strings.Contains(body, "Mechanical Drumstick") {
		t.Errorf("fragment does not name the item:\n%s", body)
	}
}

// TestTooltipShowsWhatTheItemDoes covers the lines the tooltip exists for: the
// damage range, the stats, the resistance and the spell behind the "use" line,
// whose name comes from the database rather than being the raw id.
func TestTooltipShowsWhatTheItemDoes(t *testing.T) {
	rend, err := newRenderer()
	if err != nil {
		t.Fatal(err)
	}

	rec := httptest.NewRecorder()
	rend.RenderFragment(rec, "db_item_tooltip", tooltipView(i18n.ZH))
	body := rec.Body.String()

	for _, want := range []string{
		"12 - 20", // the damage range
		"+42",     // armor
		"+15",     // a positive stat keeps its sign
		"-3",      // a negative one keeps its own
		"火球术",     // the spell name, not the id
		"唯一",      // max_count 1 is the game's "unique" line
		"需要等级",    // required level
		"12s 34c", // the sell price, formatted like the rest of the site
	} {
		if !strings.Contains(body, want) {
			t.Errorf("tooltip is missing %q:\n%s", want, body)
		}
	}
	if strings.Contains(body, "#133") {
		t.Errorf("tooltip fell back to the spell id although a name was available:\n%s", body)
	}
}

// TestTooltipTranslatesEverything catches a key that is used in the fragment but
// missing from a catalogue: the translator returns the key itself, so the page
// would show "db.tooltip.more".
func TestTooltipTranslatesEverything(t *testing.T) {
	rend, err := newRenderer()
	if err != nil {
		t.Fatal(err)
	}
	for _, meta := range i18n.Supported {
		rec := httptest.NewRecorder()
		rend.RenderFragment(rec, "db_item_tooltip", tooltipView(meta.Code))
		body := rec.Body.String()
		if i := strings.Index(body, "db."); i >= 0 {
			t.Errorf("%s: untranslated key in the tooltip near %q", meta.Code, body[i:i+30])
		}
	}
}

// TestTooltipWithoutOptionalParts is the other half of the template: an item with
// nothing but a name must not print empty lines or crash on a nil slice.
func TestTooltipWithoutOptionalParts(t *testing.T) {
	rend, err := newRenderer()
	if err != nil {
		t.Fatal(err)
	}

	view := tooltipView(i18n.EN)
	view.Item = store.ContentItem{Entry: 5, Name: "Rusty Screw", Quality: 1}
	view.Spells = nil
	view.Unique = false

	rec := httptest.NewRecorder()
	rend.RenderFragment(rec, "db_item_tooltip", view)
	if rec.Code != 200 {
		t.Fatalf("status = %d", rec.Code)
	}
	body := rec.Body.String()
	if !strings.Contains(body, "Rusty Screw") {
		t.Errorf("the name is missing:\n%s", body)
	}
	for _, unwanted := range []string{"Unique", "Requires Level", "Damage"} {
		if strings.Contains(body, unwanted) {
			t.Errorf("empty item printed %q:\n%s", unwanted, body)
		}
	}
}
