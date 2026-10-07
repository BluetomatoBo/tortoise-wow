package store

import (
	"strings"
	"testing"
)

// splitColumns splits a SELECT list into its top-level columns.
//
// A plain strings.Split would be wrong here: every localized column is a
// COALESCE(a, b, ”) and several are CAST(...), so commas inside parentheses do
// not separate columns. The scan targets below have to line up with what the
// query returns, which is exactly the mistake this test exists to catch.
func splitColumns(list string) []string {
	var (
		out   []string
		depth int
		start int
		quote rune
	)
	for i, r := range list {
		switch {
		case quote != 0:
			if r == quote {
				quote = 0
			}
		case r == '\'' || r == '"':
			quote = r
		case r == '(':
			depth++
		case r == ')':
			depth--
		case r == ',' && depth == 0:
			out = append(out, strings.TrimSpace(list[start:i]))
			start = i + 1
		}
	}
	return append(out, strings.TrimSpace(list[start:]))
}

// TestContentScanTargetsMatchColumns is the guard for the numbered columns.
//
// Each query's SELECT list and the matching scanTargets() are two lists that
// have to stay in the same order and the same length, and nothing else in Go
// checks that: a mismatch only shows up as a runtime scan error against a real
// database. itemColumns and friends already include everything after SELECT, so
// the scan targets can be compared with the column count directly.
func TestContentScanTargetsMatchColumns(t *testing.T) {
	for _, loc := range []ContentLocale{ContentLocaleBase, ContentLocaleZH} {
		var item ContentItem
		var spell ContentSpell
		var quest ContentQuest
		var creature ContentCreature

		cases := []struct {
			name    string
			columns string
			targets []any
		}{
			{"item_template", itemColumns(loc), item.scanTargets()},
			{"spell_template", spellColumns(loc), spell.scanTargets()},
			{"quest_template", questColumns(loc), quest.scanTargets()},
			{"creature_template", creatureColumns(loc), creature.scanTargets()},
		}

		for _, tc := range cases {
			cols := splitColumns(tc.columns)
			if len(cols) != len(tc.targets) {
				t.Errorf("locale %q: %s has %d columns but %d scan targets\ncolumns: %v",
					loc, tc.name, len(cols), len(tc.targets), cols)
			}
		}
	}
}

// TestContentLocaleColumns documents which column each locale reads.
func TestContentLocaleColumns(t *testing.T) {
	if got := ContentLocaleBase.column("name"); got != "name" {
		t.Errorf("base locale column = %q, want name", got)
	}
	if got := ContentLocaleZH.column("name"); got != "name_loc4" {
		t.Errorf("zh locale column = %q, want name_loc4", got)
	}
	if got := ContentLocaleZH.column("Title"); got != "Title_loc4" {
		t.Errorf("zh locale column for a capitalised column = %q, want Title_loc4", got)
	}

	// No locale join means nothing to read a translation from, so the expression
	// has to fall back to the base column instead of naming a table that is not
	// in the FROM clause.
	if got := ContentLocaleZH.localized("", "i", "name"); strings.Contains(got, "cl.") {
		t.Errorf("localized without a join = %q, want the base column only", got)
	}
	if got := ContentLocaleBase.localized("cl", "i", "name"); got != "COALESCE(i.name, '')" {
		t.Errorf("base localized = %q, want COALESCE(i.name, '')", got)
	}
	if got := ContentLocaleZH.localized("cl", "i", "name"); got != "COALESCE(cl.name_loc4, i.name, '')" {
		t.Errorf("zh localized = %q, want COALESCE(cl.name_loc4, i.name, '')", got)
	}

	if got := ContentLocaleBase.join("cl", "locales_item", "entry", "i"); got != "" {
		t.Errorf("base locale join = %q, want no join", got)
	}
	if got := ContentLocaleZH.join("cl", "locales_item", "entry", "i"); got !=
		" LEFT JOIN locales_item cl ON cl.entry = i.entry" {
		t.Errorf("zh locale join = %q", got)
	}
}

// TestContentQuestTextIsLocalized guards the quest page's prose columns.
//
// The quest columns are the ones that drifted once already: Title went through
// localized() while Details, Objectives, OfferRewardText, RequestItemsText,
// EndText and the four ObjectiveTexts were read straight from quest_template,
// so a Chinese page showed a Chinese title above an English body. Each of those
// columns has a slot in locales_quest, so each of them has to be read through
// localized() in the zh locale and through the base column otherwise.
func TestContentQuestTextIsLocalized(t *testing.T) {
	text := []string{
		"Title", "Details", "Objectives", "OfferRewardText",
		"RequestItemsText", "EndText",
		"ObjectiveText1", "ObjectiveText2", "ObjectiveText3", "ObjectiveText4",
	}

	zh := questColumns(ContentLocaleZH)
	for _, col := range text {
		want := "COALESCE(cl." + col + "_loc4, q." + col + ", '')"
		if !strings.Contains(zh, want) {
			t.Errorf("zh quest columns are missing %s: %s", want, zh)
		}
	}
	if strings.Contains(zh, "COALESCE(q.Details") {
		t.Errorf("zh quest columns still read the untranslated body: %s", zh)
	}

	base := questColumns(ContentLocaleBase)
	for _, col := range text {
		if !strings.Contains(base, "COALESCE(q."+col+", '')") {
			t.Errorf("base quest columns are missing %s: %s", col, base)
		}
		if strings.Contains(base, col+"_loc4") {
			t.Errorf("base quest columns name a locale slot: %s", base)
		}
	}
}

// TestContentSearchClause covers the search box: the shown name, the
// untranslated name, and an exact entry match when the term is a number.
func TestContentSearchClause(t *testing.T) {
	if clause, args := contentSearch(ContentLocaleZH, "cl", "i", "name", ""); clause != "" || args != nil {
		t.Errorf("empty search built %q with %v, want nothing", clause, args)
	}

	clause, args := contentSearch(ContentLocaleBase, "cl", "i", "name", "sword")
	if clause != "(i.name LIKE ?)" {
		t.Errorf("base search clause = %q", clause)
	}
	if len(args) != 1 || args[0] != "%sword%" {
		t.Errorf("base search args = %v, want one %%%%sword%%%%", args)
	}

	clause, args = contentSearch(ContentLocaleZH, "cl", "i", "name", "sword")
	if clause != "(i.name LIKE ? OR cl.name_loc4 LIKE ?)" {
		t.Errorf("zh search clause = %q", clause)
	}
	if len(args) != 2 {
		t.Fatalf("zh search args = %v, want two", args)
	}

	// A numeric term also matches the entry, which is how players paste an id.
	clause, args = contentSearch(ContentLocaleBase, "cl", "i", "name", "1234")
	if clause != "(i.name LIKE ? OR i.entry = ?)" {
		t.Errorf("numeric search clause = %q", clause)
	}
	if len(args) != 2 || args[1] != uint64(1234) {
		t.Errorf("numeric search args = %v, want a uint64 entry", args)
	}

	// The entry match must not overflow the column it compares against.
	clause, _ = contentSearch(ContentLocaleBase, "cl", "i", "name", "99999999999")
	if strings.Contains(clause, "entry =") {
		t.Errorf("an out-of-range id still produced an entry match: %q", clause)
	}
}

// TestItemFilterWhere covers the filter combinations and their argument order.
func TestItemFilterWhere(t *testing.T) {
	quality, class := uint8(4), uint8(2)
	minLevel, maxLevel := uint8(30), uint8(60)

	cases := []struct {
		name      string
		locale    ContentLocale
		filter    ContentItemFilter
		wantWhere string
		wantArgs  int
	}{
		{
			name: "no filter",
		},
		{
			name:      "search only",
			locale:    ContentLocaleZH,
			filter:    ContentItemFilter{Search: "wand"},
			wantWhere: " WHERE (i.name LIKE ? OR cl.name_loc4 LIKE ?)",
			wantArgs:  2,
		},
		{
			name:      "every filter",
			locale:    ContentLocaleBase,
			filter:    ContentItemFilter{Search: "wand", Quality: &quality, Class: &class, MinLevel: &minLevel, MaxLevel: &maxLevel},
			wantWhere: " WHERE (i.name LIKE ?) AND i.quality = ? AND i.class = ? AND i.item_level >= ? AND i.item_level <= ?",
			wantArgs:  5,
		},
		{
			name:      "a zero quality is a filter, not an absent one",
			locale:    ContentLocaleBase,
			filter:    ContentItemFilter{Quality: &quality},
			wantWhere: " WHERE i.quality = ?",
			wantArgs:  1,
		},
	}

	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			where, args := itemWhere(tc.locale, tc.filter)
			if where != tc.wantWhere {
				t.Errorf("where = %q, want %q", where, tc.wantWhere)
			}
			if len(args) != tc.wantArgs {
				t.Errorf("args = %v, want %d of them", args, tc.wantArgs)
			}
		})
	}

	// A quality filter for 0 must survive: pointer, not zero value.
	zero := uint8(0)
	if where, args := itemWhere(ContentLocaleBase, ContentItemFilter{Quality: &zero}); len(args) != 1 {
		t.Errorf("quality 0 produced %q / %v, want one filter", where, args)
	}
}

// TestContentLimitKeepsQueriesBounded makes sure a request cannot ask for
// everything at once and that the offset is never negative.
func TestContentLimitKeepsQueriesBounded(t *testing.T) {
	cases := []struct {
		size, offset int
		wantSize     int
		wantOffset   int
	}{
		{0, 0, ContentPageSize, 0},
		{-5, 0, ContentPageSize, 0},
		{25, 50, 25, 50},
		{1000, 25, ContentPageSize, 25},
		{25, -10, 25, 0},
	}

	for _, tc := range cases {
		_, args := contentLimit(tc.size, tc.offset)
		if len(args) != 2 {
			t.Fatalf("contentLimit(%d, %d) returned %v", tc.size, tc.offset, args)
		}
		if args[0] != tc.wantSize {
			t.Errorf("contentLimit(%d, %d) limit = %v, want %d", tc.size, tc.offset, args[0], tc.wantSize)
		}
		if args[1] != tc.wantOffset {
			t.Errorf("contentLimit(%d, %d) offset = %v, want %d", tc.size, tc.offset, args[1], tc.wantOffset)
		}
	}
}

// TestItemCollectDropsEmptySlots checks the numbered columns become the slices a
// template ranges over, without empty entries.
func TestItemCollectDropsEmptySlots(t *testing.T) {
	var it ContentItem
	it.statType[0], it.statValue[0] = 7, 15
	it.statType[1], it.statValue[1] = 0, 99 // value without a type is not a stat
	it.statType[2], it.statValue[2] = 4, -3
	it.frostRes = 10
	it.spellID[1] = 133
	it.spellTrigger[1] = 0
	it.spellCharges[1] = -5
	it.collect()

	if len(it.Stats) != 2 {
		t.Fatalf("stats = %+v, want two", it.Stats)
	}
	if it.Stats[0].Type != 7 || it.Stats[0].Value != 15 {
		t.Errorf("first stat = %+v", it.Stats[0])
	}
	if it.Stats[1].Type != 4 || it.Stats[1].Value != -3 {
		t.Errorf("second stat = %+v (a negative value is legitimate)", it.Stats[1])
	}
	if len(it.Resistances) != 1 || it.Resistances[0].School != 3 || it.Resistances[0].Value != 10 {
		t.Errorf("resistances = %+v, want one frost resistance", it.Resistances)
	}
	if len(it.Spells) != 1 || it.Spells[0].SpellID != 133 {
		t.Fatalf("spells = %+v, want one", it.Spells)
	}
	if it.Spells[0].Slot != 2 {
		t.Errorf("spell slot = %d, want 2 (the column number, not the index)", it.Spells[0].Slot)
	}
}

// TestQuestCollectSplitsGameObjects covers the signed column: the core stores a
// required game object as the negative of its entry, and a page that showed
// those as creature entries would link to the wrong thing.
func TestQuestCollectSplitsGameObjects(t *testing.T) {
	var q ContentQuest
	q.reqItemID[0], q.reqItemCount[0] = 80119, 5
	q.reqItemID[1], q.reqItemCount[1] = 80158, 0 // a count of zero is not a requirement
	q.rewChoiceID[5], q.rewChoiceCount[5] = 50071, 1
	q.reqMobID[0], q.reqMobCount[0] = 80117, 5
	q.reqMobID[1], q.reqMobCount[1] = -1234, 1
	q.collect()

	if len(q.RequiredItems) != 1 || q.RequiredItems[0].Entry != 80119 || q.RequiredItems[0].Count != 5 {
		t.Errorf("required items = %+v", q.RequiredItems)
	}
	if len(q.ChoiceItems) != 1 || q.ChoiceItems[0].Entry != 50071 {
		t.Errorf("choice items = %+v", q.ChoiceItems)
	}
	if len(q.RequiredMobs) != 2 {
		t.Fatalf("required mobs = %+v, want two", q.RequiredMobs)
	}
	if q.RequiredMobs[0].IsGameObject || q.RequiredMobs[0].Entry != 80117 {
		t.Errorf("a positive entry should be a creature: %+v", q.RequiredMobs[0])
	}
	if !q.RequiredMobs[1].IsGameObject || q.RequiredMobs[1].Entry != 1234 {
		t.Errorf("a negative entry should be that game object: %+v", q.RequiredMobs[1])
	}
}

// TestSpellCollectNumbersTheEffectSlots checks the slot numbers a page shows are
// the column numbers, since "effect2" is what a GM greps for in the table.
func TestSpellCollectNumbersTheEffectSlots(t *testing.T) {
	var sp ContentSpell
	sp.effect[0] = 6
	sp.basePoints[0] = 9
	sp.dieSides[0] = 3
	sp.effect[2] = 2
	sp.collect()

	if len(sp.Effects) != 2 {
		t.Fatalf("effects = %+v, want two (the empty middle slot must be skipped)", sp.Effects)
	}
	if sp.Effects[0].Slot != 1 || sp.Effects[1].Slot != 3 {
		t.Errorf("slots = %d, %d, want 1 and 3", sp.Effects[0].Slot, sp.Effects[1].Slot)
	}
	if sp.Effects[0].BasePoints != 9 || sp.Effects[0].DieSides != 3 {
		t.Errorf("first effect = %+v", sp.Effects[0])
	}
}
