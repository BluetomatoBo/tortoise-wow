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
	areas, factions, maps, sorts, subclasses, sets, skills := DBCNameCounts()
	t.Logf("AREA %d、FACTION %d、MAP %d、QSORT %d、SUBCLASS %d、ITEMSET %d、SKILL %d",
		areas, factions, maps, sorts, subclasses, sets, skills)
	for _, c := range []struct {
		name string
		got  int
	}{
		{"AREA", areas}, {"FACTION", factions}, {"MAP", maps},
		{"QSORT", sorts}, {"SUBCLASS", subclasses}, {"ITEMSET", sets}, {"SKILL", skills},
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

	// A loot group and a condition have to reach the page: the header says the
	// group yields at most one item, and the condition says why a row may not
	// drop at all. Both are things a GM opens the loot table to find out.
	grouped := render("db_npc", dbCreatureView{PageData: page,
		Creature: store.ContentCreature{Entry: 1, Name: "海盗", Faction: 72},
		Relations: &store.CreatureRelations{
			Drops: []store.ContentLootItem{
				{Entry: 80120, Name: "齿轮", Chance: 60, Group: 4, GroupChance: 100},
				{Entry: 80121, Name: "弹簧", Chance: 0, Group: 4, GroupChance: 100, GroupEqual: 1,
					Condition: &store.LootCondition{Kind: store.CondQuestDone,
						Args: []store.CondArg{{Value: "80104", Name: "另一只白鸡"}}}},
			},
		}})
	for _, want := range []string{"掉落组", "每组只掉其中 1 件", "组内总概率 100.00%", "条件", "另一只白鸡", "#80104"} {
		if !strings.Contains(grouped, want) {
			t.Errorf("the creature page does not show %q:\n%s", want, first(grouped, 1500))
		}
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
	var nameLines, itemLines, bonusLines int
	for _, line := range strings.Split(dbcNamesData, "\n") {
		switch {
		case line == "" || strings.HasPrefix(line, "#"):
		case strings.HasPrefix(line, "SETITEM\t"):
			itemLines++
		case strings.HasPrefix(line, "SETBONUS\t"):
			bonusLines++
		default:
			nameLines++
		}
	}

	areas, factions, maps, sorts, subclasses, sets, skills := DBCNameCounts()
	if sum := areas + factions + maps + sorts + subclasses + sets + skills; sum != nameLines {
		t.Errorf("parsed %d name rows from %d name lines of dbcnames.txt", sum, nameLines)
	}

	// Every set line has to end up in one of the two maps: a line the parser skips
	// is a piece or a bonus that silently goes missing from the item page.
	var loadedItems, loadedBonuses int
	for _, items := range setItems {
		loadedItems += len(items)
	}
	for _, bonuses := range setBonuses {
		loadedBonuses += len(bonuses)
	}
	if loadedItems != itemLines {
		t.Errorf("parsed %d set pieces from %d lines", loadedItems, itemLines)
	}
	if loadedBonuses != bonusLines {
		t.Errorf("parsed %d set bonuses from %d lines", loadedBonuses, bonusLines)
	}
}

// TestSetDataLoads covers the set tables: 219 sets are referenced by this realm's
// items and 494 bonus spells ride on them, all of which have to be in the client
// data for the item page to say anything useful.
func TestSetDataLoads(t *testing.T) {
	withItems, withBonuses := SetDataCounts()
	t.Logf("套装：%d 个有部件列表，%d 个有奖励", withItems, withBonuses)
	if withItems < 300 || withBonuses < 300 {
		t.Fatalf("set tables look truncated: %d / %d", withItems, withBonuses)
	}

	page := namePage(t, i18n.ZH)

	// Set 1 is "The Gladiator": five pieces and four bonuses.
	if got := page.ItemSetName(1); got != "角斗士" {
		t.Errorf("ItemSetName(1) = %q", got)
	}
	if pieces := page.SetPieces(1); len(pieces) != 5 {
		t.Errorf("set 1 has %d pieces: %v", len(pieces), pieces)
	}
	bonuses := page.SetBonuses(1)
	if len(bonuses) != 4 {
		t.Fatalf("set 1 has %d bonuses: %+v", len(bonuses), bonuses)
	}
	// Sorted by the piece count that switches each one on, so a page reads in the
	// order a player earns them.
	for i := 1; i < len(bonuses); i++ {
		if bonuses[i-1].Pieces > bonuses[i].Pieces {
			t.Errorf("bonuses are out of order: %+v", bonuses)
			break
		}
	}
	for _, bonus := range bonuses {
		if bonus.Pieces == 0 || bonus.SpellID == 0 {
			t.Errorf("bonus with no pieces or spell: %+v", bonus)
		}
	}

	// A set nobody uses says nothing rather than inventing an empty one.
	if pieces := page.SetPieces(999999); len(pieces) != 0 {
		t.Errorf("unknown set returned %d pieces", len(pieces))
	}
	if bonuses := page.SetBonuses(999999); len(bonuses) != 0 {
		t.Errorf("unknown set returned %d bonuses", len(bonuses))
	}
}
