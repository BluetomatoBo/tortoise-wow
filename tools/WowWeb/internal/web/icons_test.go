package web

import (
	"bytes"
	"io"
	"io/fs"
	"log/slog"
	"net/http/httptest"
	"strings"
	"testing"

	"tortoiseweb/internal/config"
	"tortoiseweb/internal/i18n"
	"tortoiseweb/internal/store"
)

// TestIconFilesExist is the guard that matters: every id the mapping resolves
// has to have artwork in the binary.
//
// A mapping entry without a file is an <img> that 404s on a live page - the one
// failure mode of shipping a table and a directory that are generated
// separately. gen_icons.py drops names it has no PNG for, and this checks the
// result rather than trusting it.
func TestIconFilesExist(t *testing.T) {
	present := map[string]bool{}
	err := fs.WalkDir(templateFS, "assets/icons", func(path string, d fs.DirEntry, err error) error {
		if err != nil || d.IsDir() {
			return err
		}
		present[strings.TrimPrefix(path, "assets/icons/")] = true
		return nil
	})
	if err != nil {
		t.Fatal(err)
	}
	if len(present) == 0 {
		t.Fatal("no icons are embedded")
	}

	missing := map[string]uint32{}
	for id, name := range itemIconByDisplay {
		if !present[name+iconExt] {
			missing[name] = id
		}
	}
	for id, name := range spellIconBySpellID {
		if !present[name+iconExt] {
			missing[name] = id
		}
	}
	if len(missing) > 0 {
		i := 0
		for name, id := range missing {
			if i++; i > 5 {
				break
			}
			t.Errorf("icon %q (for id %d) is not embedded", name, id)
		}
		t.Errorf("%d mapped icons have no file; %d files are embedded", len(missing), len(present))
	}

	items, spells := IconCounts()
	t.Logf("映射：物品 %d 条、法术 %d 条；内置图标 %d 个", items, spells, len(present))
}

// TestIconLookup covers the two lookups the pages use, including the id that has
// no artwork: an empty string is what makes the templates draw nothing instead
// of a broken image.
func TestIconLookup(t *testing.T) {
	page := PageData{}

	// A display id every client has: the mapping must resolve it to a file.
	if got := page.ItemIcon(224); got != "/assets/icons/inv_jewelry_ring_03.png" {
		t.Errorf("ItemIcon(224) = %q", got)
	}
	if got := page.SpellIcon(9); got != "/assets/icons/spell_shadow_blackplague.png" {
		t.Errorf("SpellIcon(9) = %q", got)
	}

	// Ids that are not in the table at all.
	if got := page.ItemIcon(0); got != "" {
		t.Errorf("ItemIcon(0) = %q, want empty", got)
	}
	if got := page.ItemIcon(4294967295); got != "" {
		t.Errorf("unknown display id gave %q, want empty", got)
	}
	if got := page.SpellIcon(999999); got != "" {
		t.Errorf("unknown spell icon id gave %q, want empty", got)
	}
}

// TestPagesDrawIcons checks the wiring: the helpers exist, but a template that
// never calls them still ships no icons.
func TestPagesDrawIcons(t *testing.T) {
	rend, err := newRenderer()
	if err != nil {
		t.Fatal(err)
	}
	bundle, err := i18n.Load()
	if err != nil {
		t.Fatal(err)
	}
	page := PageData{Year: 2026, Tr: bundle.Translator(i18n.ZH), Config: PageConfig{SiteName: "s"}}

	render := func(name string, view any) string {
		var buf bytes.Buffer
		if err := rend.cache[name].ExecuteTemplate(&buf, "layout", view); err != nil {
			t.Fatalf("%s: %v", name, err)
		}
		return buf.String()
	}

	item := store.ContentItem{Entry: 224, Name: "Brass Collar", Quality: 2, DisplayID: 224}
	if got := render("db_item", dbItemView{PageData: page, Item: item}); !strings.Contains(got, "/assets/icons/inv_jewelry_ring_03.png") {
		t.Errorf("the item page draws no icon:\n%s", first(got, 600))
	}

	tip := dbTooltipView{PageData: page, Item: item}
	var buf bytes.Buffer
	if err := rend.cache["db_item_tooltip"].ExecuteTemplate(&buf, "content", tip); err != nil {
		t.Fatal(err)
	}
	if !strings.Contains(buf.String(), "/assets/icons/inv_jewelry_ring_03.png") {
		t.Errorf("the tooltip draws no icon:\n%s", buf.String())
	}

	spell := store.ContentSpell{Entry: 133, Name: "Fireball", SpellIconID: 9}
	if got := render("db_spell", dbSpellView{PageData: page, Spell: spell}); !strings.Contains(got, "/assets/icons/spell_shadow_blackplague.png") {
		t.Errorf("the spell page draws no icon:\n%s", first(got, 600))
	}

	// An item whose display id has no artwork still renders, without an <img>.
	plain := store.ContentItem{Entry: 5, Name: "Rusty Screw", DisplayID: 4294967295}
	got := render("db_item", dbItemView{PageData: page, Item: plain})
	if strings.Contains(got, "/assets/icons/") {
		t.Errorf("an item with no artwork printed an icon URL:\n%s", first(got, 600))
	}
	if !strings.Contains(got, "Rusty Screw") {
		t.Errorf("the page lost the name:\n%s", first(got, 600))
	}
}

// TestIconsAreServed is the other half of TestIconFilesExist: a file can be in
// the binary and still be unreachable if the URL the templates build does not
// match the route. This asks the real mux for one.
func TestIconsAreServed(t *testing.T) {
	srv, err := New(config.Config{RealmName: "Test", AdminMinRank: 4},
		(*store.Store)(nil), slog.New(slog.NewTextHandler(io.Discard, nil)))
	if err != nil {
		t.Fatalf("New: %v", err)
	}

	page := PageData{}
	url := page.ItemIcon(224)
	if url == "" {
		t.Fatal("no icon for display id 224")
	}

	rec := httptest.NewRecorder()
	srv.mux.ServeHTTP(rec, httptest.NewRequest("GET", url, nil))
	if rec.Code != 200 {
		t.Fatalf("GET %s = %d", url, rec.Code)
	}
	if ct := rec.Header().Get("Content-Type"); ct != "image/png" {
		t.Errorf("content type = %q, want image/png", ct)
	}
	if rec.Body.Len() == 0 {
		t.Errorf("GET %s served an empty body", url)
	}
	// The PNG magic number, so the route is not answering a redirect page.
	if !bytes.HasPrefix(rec.Body.Bytes(), []byte("\x89PNG")) {
		t.Errorf("GET %s did not serve a PNG: % x", url, rec.Body.Bytes()[:8])
	}
	if cc := rec.Header().Get("Cache-Control"); cc == "" {
		t.Errorf("no Cache-Control on an icon")
	}
}
