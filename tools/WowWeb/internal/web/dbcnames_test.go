package web

import (
	"bytes"
	"strings"
	"testing"

	"tortoiseweb/internal/i18n"
	"tortoiseweb/internal/store"
)

func namePage(t *testing.T, lang i18n.Lang) PageData {
	t.Helper()
	bundle, err := i18n.Load()
	if err != nil {
		t.Fatal(err)
	}
	return PageData{Year: 2026, Tr: bundle.Translator(lang),
		Langs:  i18n.Supported,
		Config: PageConfig{SiteName: "T", PasswordMinLen: 6, SessionTTLHours: 1, DefaultLang: string(lang)}}
}

// TestDBCNamesLoad covers the tables the generator writes, and in both languages:
// the client's DBCs carry every locale in one record, so the site can label an id
// without a translation step.
func TestDBCNamesLoad(t *testing.T) {
	areas, factions, maps, sorts, subclasses, sets := DBCNameCounts()
	t.Logf("AREA %d、FACTION %d、MAP %d、QSORT %d、SUBCLASS %d、ITEMSET %d",
		areas, factions, maps, sorts, subclasses, sets)
	for _, c := range []struct {
		name string
		got  int
	}{
		{"AREA", areas}, {"FACTION", factions}, {"MAP", maps},
		{"QSORT", sorts}, {"SUBCLASS", subclasses}, {"ITEMSET", sets},
	} {
		if c.got < 10 {
			t.Errorf("%s has only %d rows; the generator did not run or the file is truncated", c.name, c.got)
		}
	}

	zh, en := namePage(t, i18n.ZH), namePage(t, i18n.EN)

	// Values checked against the client's own DBCs: 33 is Stranglethorn Vale,
	// 1519 Stormwind City, faction 72 Stormwind, subclass 2/7 a sword.
	if got := zh.AreaName(33); got != "荆棘谷" {
		t.Errorf("zh AreaName(33) = %q", got)
	}
	if got := en.AreaName(33); got != "Stranglethorn Vale" {
		t.Errorf("en AreaName(33) = %q", got)
	}
	if got := zh.FactionName(72); got != "暴风城" {
		t.Errorf("zh FactionName(72) = %q", got)
	}
	if got := en.SubClassName(2, 7); got != "Sword" {
		t.Errorf("en SubClassName(2,7) = %q", got)
	}
	if got := zh.SubClassName(2, 7); got != "剑" {
		t.Errorf("zh SubClassName(2,7) = %q", got)
	}

	// Unknown ids say nothing rather than something wrong.
	for _, c := range []struct {
		what string
		got  string
	}{
		{"AreaName(60000)", zh.AreaName(60000)},
		{"FactionName(9999)", zh.FactionName(9999)},
		{"MapName(9999)", zh.MapName(9999)},
		{"ItemSetName(99999)", zh.ItemSetName(99999)},
		{"SubClassName(99,99)", zh.SubClassName(99, 99)},
	} {
		if c.got != "" {
			t.Errorf("%s = %q, want empty", c.what, c.got)
		}
	}
}

// TestZoneOrSortName covers the one column with two meanings: the core reads a
// positive ZoneOrSort as a zone id and a negative one as the negated id of a
// quest sort (ObjectMgr.cpp validates exactly that), so a label has to follow the
// sign rather than look the number up in one table.
func TestZoneOrSortName(t *testing.T) {
	zh := namePage(t, i18n.ZH)
	cases := []struct {
		value int16
		want  string
	}{
		{33, "荆棘谷"},  // positive: a zone
		{-1, "史诗"},   // negative: quest sort 1
		{-24, "草药学"}, // negative: quest sort 24
		{0, ""},      // no zone, and not a missing name
		{-6000, ""},  // a sort id the client does not have
		{32000, ""},  // a zone id the client does not have
	}
	for _, c := range cases {
		if got := zh.ZoneOrSortName(c.value); got != c.want {
			t.Errorf("ZoneOrSortName(%d) = %q, want %q", c.value, got, c.want)
		}
	}

	// The negative case must not be looked up as a zone: zone 1 exists, so a
	// sign-blind implementation would answer "丹莫罗" for -1.
	if got := zh.ZoneOrSortName(-1); got == zh.AreaName(1) {
		t.Errorf("ZoneOrSortName(-1) fell back to the zone table: %q", got)
	}
}

// TestPagesShowNames checks the wiring: the helpers can be perfect and a page
// that still prints the raw number looks exactly as it did before.
func TestPagesShowNames(t *testing.T) {
	rend, err := newRenderer()
	if err != nil {
		t.Fatal(err)
	}
	page := namePage(t, i18n.ZH)

	render := func(name string, view any) string {
		var buf bytes.Buffer
		if err := rend.cache[name].ExecuteTemplate(&buf, "layout", view); err != nil {
			t.Fatalf("%s: %v", name, err)
		}
		return buf.String()
	}

	quest := render("db_quest", dbQuestView{PageData: page,
		Quest: store.ContentQuest{Entry: 41332, Title: "任务", ZoneOrSort: 33}})
	if !strings.Contains(quest, "荆棘谷") {
		t.Errorf("the quest page does not name its zone:\n%s", first(quest, 800))
	}
	if !strings.Contains(quest, "#33") {
		t.Errorf("the quest page dropped the raw id, which is what a GM greps for:\n%s", first(quest, 800))
	}

	npc := render("db_npc", dbCreatureView{PageData: page,
		Creature: store.ContentCreature{Entry: 1, Name: "海盗", Faction: 72}})
	if !strings.Contains(npc, "暴风城") {
		t.Errorf("the creature page does not name its faction:\n%s", first(npc, 800))
	}

	item := render("db_item", dbItemView{PageData: page, Item: store.ContentItem{
		Entry: 1, Name: "剑", Class: 2, SubClass: 7, SetID: 1}})
	if !strings.Contains(item, "剑") {
		t.Errorf("the item page does not name its subclass:\n%s", first(item, 800))
	}
	if !strings.Contains(item, "角斗士") {
		t.Errorf("the item page does not name its set:\n%s", first(item, 800))
	}

	// An id with no name still renders the number instead of an empty cell.
	odd := render("db_item", dbItemView{PageData: page, Item: store.ContentItem{
		Entry: 2, Name: "怪东西", Class: 9, SubClass: 9, SetID: 99999}})
	if !strings.Contains(odd, "#99999") {
		t.Errorf("an unknown set id printed nothing:\n%s", first(odd, 800))
	}
}

// TestDBCNameCountsMatchTheFile guards the parser against a partial read of
// dbcnames.txt - a truncated embed would otherwise show up as scattered missing
// names on live pages.
func TestDBCNameCountsMatchTheFile(t *testing.T) {
	lines := 0
	for _, line := range strings.Split(dbcNamesData, "\n") {
		if line != "" && !strings.HasPrefix(line, "#") {
			lines++
		}
	}
	areas, factions, maps, sorts, subclasses, sets := DBCNameCounts()
	if sum := areas + factions + maps + sorts + subclasses + sets; sum != lines {
		t.Errorf("parsed %d rows from %d lines of dbcnames.txt", sum, lines)
	}
}
