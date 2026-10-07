package web

import (
	"net/url"
	"testing"

	"tortoiseweb/internal/i18n"
	"tortoiseweb/internal/store"
)

// TestOptUint8 covers the filter parser. The interesting case is "0": a quality
// of 0 is a real filter, so it has to arrive as a pointer rather than as "no
// filter", and anything out of range counts as absent instead of being clamped
// to a different subset.
func TestOptUint8(t *testing.T) {
	cases := []struct {
		raw    string
		want   uint8
		wantOK bool
	}{
		{"", 0, false},
		{"   ", 0, false},
		{"0", 0, true},
		{"4", 4, true},
		{"255", 255, true},
		{"256", 0, false},
		{"-1", 0, false},
		{"abc", 0, false},
		{"4.5", 0, false},
		{" 7 ", 7, true},
	}

	for _, tc := range cases {
		q := url.Values{"x": {tc.raw}}
		got := optUint8(q, "x")
		if (got != nil) != tc.wantOK {
			t.Errorf("optUint8(%q) presence = %v, want %v", tc.raw, got != nil, tc.wantOK)
			continue
		}
		if got != nil && *got != tc.want {
			t.Errorf("optUint8(%q) = %d, want %d", tc.raw, *got, tc.want)
		}
	}

	// A filter that is not in the URL at all is absent, not zero.
	if got := optUint8(url.Values{}, "quality"); got != nil {
		t.Errorf("missing filter parsed as %d, want absent", *got)
	}
}

func TestDBPageNum(t *testing.T) {
	cases := []struct {
		raw  string
		want int
	}{
		{"", 1}, {"0", 1}, {"1", 1}, {"7", 7}, {"-3", 1}, {"abc", 1},
	}
	for _, tc := range cases {
		if got := dbPageNum(url.Values{"page": {tc.raw}}); got != tc.want {
			t.Errorf("dbPageNum(%q) = %d, want %d", tc.raw, got, tc.want)
		}
	}
}

// TestDBLocale pins which columns each site language reads. This realm's Chinese
// lives in the loc4 columns; a Chinese visitor must get those and nobody else.
func TestDBLocale(t *testing.T) {
	zh := PageData{Tr: translator(t, i18n.ZH)}
	en := PageData{Tr: translator(t, i18n.EN)}

	if got := dbLocale(&zh); got != store.ContentLocaleZH {
		t.Errorf("zh locale = %q, want loc4", got)
	}
	if got := dbLocale(&en); got != store.ContentLocaleBase {
		t.Errorf("en locale = %q, want the base columns", got)
	}
}

// TestPageDataNamedIsHonest checks the fallback: a value with no name in the
// catalogue shows its number rather than an empty cell or a wrong label.
func TestPageDataNamedIsHonest(t *testing.T) {
	p := PageData{Tr: translator(t, i18n.EN)}

	if got := p.QualityName(4); got == "#4" || got == "" {
		t.Errorf("quality 4 = %q, want its name from the catalogue", got)
	}
	if got := p.ItemClassName(2); got == "#2" || got == "" {
		t.Errorf("item class 2 = %q, want its name", got)
	}
	// 2 is a hole in ItemModType: 0, 1, 3, 4, 5, 6, 7 exist.
	if got := p.StatName(2); got != "#2" {
		t.Errorf("stat 2 = %q, want the number as a fallback", got)
	}
	// The same catalogue is used by both languages, so a Chinese reader sees
	// Chinese names.
	pz := PageData{Tr: translator(t, i18n.ZH)}
	if p.QualityName(4) == pz.QualityName(4) {
		t.Errorf("quality 4 reads %q in both languages", p.QualityName(4))
	}
}

// TestResistanceNameIsASchoolOffByOne pins the mapping that is easy to get
// wrong: the six resistance columns skip armor, so column 0 is holy (school 1)
// and column 5 is arcane (school 6). A plain +1 mistake would label every
// resistance as the one before it.
func TestResistanceNameIsASchoolOffByOne(t *testing.T) {
	p := PageData{Tr: translator(t, i18n.EN)}

	want := []string{"holy", "fire", "nature", "frost", "shadow", "arcane"}
	for column, school := range want {
		got := p.ResistanceName(column)
		if got != p.SchoolName(uint32(column+1)) {
			t.Errorf("resistance column %d = %q, want the %s school", column, got, school)
		}
	}
	// Out of range stays a number.
	if got := p.ResistanceName(9); got != "#9" {
		t.Errorf("resistance column 9 = %q, want #9", got)
	}
}

func TestItemNumberFormatting(t *testing.T) {
	p := PageData{Tr: translator(t, i18n.EN)}

	weapon := store.ContentItem{DamageMin: 10, DamageMax: 20, Delay: 2600}
	if got := p.DamageRange(weapon); got != "10 - 20" {
		t.Errorf("damage range = %q", got)
	}
	if got := p.Speed(weapon); got != "2.60" {
		t.Errorf("speed = %q, want the swing time in seconds", got)
	}
	// (10+20)/2 / 2.6s = 5.77 -> 5.8
	if got := p.DPS(weapon); got != "5.8" {
		t.Errorf("dps = %q, want 5.8", got)
	}

	// A plain trade good has none of these, and must render as nothing rather
	// than as a division by zero.
	plain := store.ContentItem{Name: "Rusty Screw"}
	if got := p.DamageRange(plain); got != "" {
		t.Errorf("damage range of a non-weapon = %q, want empty", got)
	}
	if got := p.Speed(plain); got != "" {
		t.Errorf("speed of a non-weapon = %q, want empty", got)
	}
	if got := p.DPS(plain); got != "" {
		t.Errorf("dps of a non-weapon = %q, want empty", got)
	}
}

func TestSpellRangeUsesTheStoredBasePoints(t *testing.T) {
	p := PageData{Tr: translator(t, i18n.EN)}

	// The tooltip range is base+1 .. base+dice: 9 base with 3 sides is 10-12.
	if got := p.SpellRange(store.ContentSpellEffect{BasePoints: 9, DieSides: 3}); got != "10 - 12" {
		t.Errorf("spell range = %q, want 10 - 12", got)
	}
	// One side means a single value, not "x - x".
	if got := p.SpellRange(store.ContentSpellEffect{BasePoints: -1, DieSides: 1}); got != "0" {
		t.Errorf("single-value spell range = %q, want 0", got)
	}
}

// TestQuestMoneyHandlesBothDirections covers RewOrReqMoney, which Player.cpp
// reads as a reward when positive and as a fee when negative.
func TestQuestMoneyHandlesBothDirections(t *testing.T) {
	p := PageData{Tr: translator(t, i18n.EN)}

	reward := p.QuestMoney(1200)
	fee := p.QuestMoney(-1200)
	if reward.Label == fee.Label {
		t.Errorf("both directions read %q, want different labels", reward.Label)
	}
	if reward.Amount != fee.Amount {
		t.Errorf("amounts differ: %q vs %q, want the same sum", reward.Amount, fee.Amount)
	}
	if reward.Amount != "12s 0c" {
		t.Errorf("1200 copper = %q", reward.Amount)
	}
}

func TestDBResultPath(t *testing.T) {
	cases := []struct {
		kind  string
		entry uint32
		want  string
	}{
		{"item", 1234, "/db/items/1234"},
		{"spell", 133, "/db/spells/133"},
		{"quest", 5, "/db/quests/5"},
		{"creature", 80117, "/db/npcs/80117"},
	}
	for _, tc := range cases {
		if got := dbKindPath(tc.kind) + "/" + itoa(int(tc.entry)); got != tc.want {
			t.Errorf("%s %d -> %q, want %q", tc.kind, tc.entry, got, tc.want)
		}
	}
}

// translator loads the real catalogue, so a missing key shows up as the key
// itself and fails the assertions above.
func translator(t *testing.T, lang i18n.Lang) i18n.Translator {
	t.Helper()
	bundle, err := i18n.Load()
	if err != nil {
		t.Fatalf("load translations: %v", err)
	}
	return bundle.Translator(lang)
}
