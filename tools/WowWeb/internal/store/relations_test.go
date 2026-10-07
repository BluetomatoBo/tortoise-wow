package store

import (
	"errors"
	"regexp"
	"strings"
	"testing"
)

// TestQuestItemQueryColumnNames pins the (id, count) column pairs.
//
// The count column is not the id column with "Count" glued on: ReqItemId1's count
// is ReqItemCount1, so the "Id" belongs to the slot number. Getting this wrong
// produces a query that only fails against a real database - "Unknown column
// q.ReqItemIdCount1" - which is exactly how the bug got in.
func TestQuestItemQueryColumnNames(t *testing.T) {
	cases := []struct {
		prefix     string
		slots      int
		wantID     []string
		wantCount  []string
		badPattern string
	}{
		{"ReqItemId", 4, []string{"q.ReqItemId1", "q.ReqItemId4"}, []string{"q.ReqItemCount1", "q.ReqItemCount4"}, "IdCount"},
		{"RewItemId", 4, []string{"q.RewItemId1", "q.RewItemId4"}, []string{"q.RewItemCount1", "q.RewItemCount4"}, "IdCount"},
		{"RewChoiceItemId", 6, []string{"q.RewChoiceItemId1", "q.RewChoiceItemId6"}, []string{"q.RewChoiceItemCount1", "q.RewChoiceItemCount6"}, "IdCount"},
	}
	for _, tc := range cases {
		q, args := questItemQuery(ContentLocaleBase, []string{tc.prefix}, tc.slots, 117)
		for _, want := range append(append([]string{}, tc.wantID...), tc.wantCount...) {
			if !strings.Contains(q, want) {
				t.Errorf("%s: query is missing %s: %s", tc.prefix, want, q)
			}
		}
		if strings.Contains(q, tc.badPattern) {
			t.Errorf("%s: query glues the wrong column name: %s", tc.prefix, q)
		}
		// Every slot is matched, and the list is capped.
		if n := strings.Count(q, " = ?"); n != tc.slots {
			t.Errorf("%s: %d equality predicates, want %d: %s", tc.prefix, n, tc.slots, q)
		}
		if !strings.Contains(q, "LIMIT ?") {
			t.Errorf("%s: query is not capped: %s", tc.prefix, q)
		}
		// One argument per predicate (the id and its count are a pair of
		// columns matched by the id alone), plus the limit.
		if want := tc.slots + 1; len(args) != want {
			t.Errorf("%s: %d args, want %d", tc.prefix, len(args), want)
		}
	}
}

// TestLootSourceQueryNames covers the pairing of the loot table's owner with the
// table its names come from.
//
// localized() drops the locale alias when the locale is the base one, so the
// owner alias has to be the one the FROM clause actually introduces: passing the
// creature alias for a gameobject loot table would build COALESCE(c.name, ”)
// against a query that never mentions c.
func TestLootSourceQueryNames(t *testing.T) {
	cases := []struct {
		table    string
		baseWant string
		zhWant   string
		zhJoin   string
	}{
		{"creature_loot_template", "COALESCE(c.name, '')", "COALESCE(lc.name_loc4, c.name, '')", "LEFT JOIN locales_creature lc ON lc.entry = c.entry"},
		{"gameobject_loot_template", "COALESCE(g.name, '')", "COALESCE(lg.name_loc4, g.name, '')", "LEFT JOIN locales_gameobject lg ON lg.entry = g.entry"},
		{"item_loot_template", "COALESCE(i.name, '')", "COALESCE(li.name_loc4, i.name, '')", "LEFT JOIN locales_item li ON li.entry = i.entry"},
	}
	for _, tc := range cases {
		base, _ := lootSourceQuery(ContentLocaleBase, tc.table, 7, nil)
		if !strings.Contains(base, tc.baseWant) {
			t.Errorf("%s base: want %s in %s", tc.table, tc.baseWant, base)
		}
		if strings.Contains(base, "_loc4") {
			t.Errorf("%s base: names a locale column: %s", tc.table, base)
		}

		zh, _ := lootSourceQuery(ContentLocaleZH, tc.table, 7, nil)
		if !strings.Contains(zh, tc.zhWant) || !strings.Contains(zh, tc.zhJoin) {
			t.Errorf("%s zh: want %s and the join in %s", tc.table, tc.zhWant, zh)
		}
	}
}

// relationQueries builds every query the relation loaders issue, so the checks
// below can walk all of them instead of a hand-picked few.
func relationQueries() map[string]string {
	out := map[string]string{}
	tables := []string{"creature_loot_template", "gameobject_loot_template", "item_loot_template",
		"skinning_loot_template", "pickpocketing_loot_template"}
	for _, loc := range []ContentLocale{ContentLocaleBase, ContentLocaleZH} {
		for _, tbl := range tables {
			q, _ := lootSourceQuery(loc, tbl, 7, []uint32{30016, 30017})
			out[string(loc)+" "+tbl+" with refs"] = q
			q, _ = lootSourceQuery(loc, tbl, 7, nil)
			out[string(loc)+" "+tbl] = q

			q, _ = lootItemsQuery(tbl, 3)
			out[string(loc)+" "+tbl+" items"] = q
		}
		q, _ := referenceParentsQuery([]uint32{1, 2})
		out[string(loc)+" ref parents"] = q
		q, _ = referenceItemsQuery(30016)
		out[string(loc)+" ref items"] = q
		q, _ = vendorSellersQuery(loc, 117)
		out[string(loc)+" vendors"] = q
		q, _ = vendorItemsQuery(3)
		out[string(loc)+" vendor items"] = q
		for _, g := range []struct {
			table string
			kind  DropKind
		}{
			{"creature_questrelation", DropCreature},
			{"creature_involvedrelation", DropCreature},
			{"gameobject_questrelation", DropGameObject},
			{"gameobject_involvedrelation", DropGameObject},
		} {
			q, _ = questActorQuery(loc, g.table, g.kind, 5)
			out[string(loc)+" "+g.table] = q
		}
		q, _ = questsOfActorQuery(loc, "creature_questrelation", 3)
		out[string(loc)+" actor quests"] = q
		out[string(loc)+" chain next"] = questChainNextQuery()
		out[string(loc)+" chain prev"] = questChainPrevQuery(loc)
		out[string(loc)+" own links"] = questOwnLinksQuery()
		out[string(loc)+" requirement links"] = questLinkQuery(loc)
		out[string(loc)+" exclusive group"] = questGroupQuery(loc)
		for _, kind := range []DropKind{DropCreature, DropGameObject} {
			out[string(loc)+" target spawns "+string(kind)] = targetSpawnQuery(loc, kind, 2)
		}
		out[string(loc)+" quest titles"] = questTitlesQuery(loc, 3)
		for _, p := range [][]string{questItemPrefixes("required"), questItemPrefixes("rewarded"), questItemPrefixes("choice")} {
			slots := 4
			if p[0] == "RewChoiceItemId" {
				slots = 6
			}
			q, _ = questItemQuery(loc, p, slots, 117)
			out[string(loc)+" "+p[0]] = q
		}
	}
	return out
}

// TestRelationQueriesBindEveryAlias is the guard for the whole class of bug that
// shipped once: a query that reads a name through an alias the FROM clause never
// introduces. MySQL answers those with "Unknown column 'c.name' in 'field
// list'", which is a 500 on the page, and nothing in Go notices beforehand
// because the query is only a string until it reaches a server.
//
// It walks every query the loaders build and checks that each "alias.column"
// reference names an alias bound by a FROM or JOIN in the same statement.
func TestRelationQueriesBindEveryAlias(t *testing.T) {
	for name, q := range relationQueries() {
		bound := map[string]bool{}
		for _, m := range regexp.MustCompile(`(?i)\b(?:FROM|JOIN)\s+([a-z_]+)\s+([a-z_]+)\b`).FindAllStringSubmatch(q, -1) {
			bound[m[2]] = true
		}
		for _, m := range regexp.MustCompile(`\b([a-z_]+)\.([A-Za-z_]+)\b`).FindAllStringSubmatch(q, -1) {
			if !bound[m[1]] {
				t.Errorf("%s: alias %q is used (%s.%s) but never bound by a FROM or JOIN:\n%s",
					name, m[1], m[1], m[2], q)
			}
		}
	}
}

// TestLootSourceQueryUsesTheLootID pins the join key of each loot table.
//
// The loot tables are keyed by the owner's loot id, not by the owner's entry.
// The two are equal for most creatures, so a wrong key still answers most rows
// and quietly drops or invents the rest.
func TestLootSourceQueryUsesTheLootID(t *testing.T) {
	cases := []struct {
		table   string
		wantKey string
	}{
		{"creature_loot_template", "c.loot_id = t.entry"},
		{"skinning_loot_template", "c.skinning_loot_id = t.entry"},
		{"pickpocketing_loot_template", "c.pickpocket_loot_id = t.entry"},
		{"gameobject_loot_template", "g.data1 = t.entry"},
		{"item_loot_template", "i.entry = t.entry"},
	}
	for _, tc := range cases {
		q, _ := lootSourceQuery(ContentLocaleBase, tc.table, 7, nil)
		if !strings.Contains(q, tc.wantKey) {
			t.Errorf("%s: want the join key %q in:\n%s", tc.table, tc.wantKey, q)
		}
	}

	// Only chests and fishing holes expose data1 as a loot id; for any other
	// gameobject type the column means something else.
	q, _ := lootSourceQuery(ContentLocaleBase, "gameobject_loot_template", 7, nil)
	if !strings.Contains(q, "AND (g.type IN (3, 25))") {
		t.Errorf("gameobject loot does not restrict the type:\n%s", q)
	}

	// With references the match is "direct OR reference", and the type has to
	// apply to both: "a OR b AND c" would leave the direct rows unchecked.
	withRefs, _ := lootSourceQuery(ContentLocaleBase, "gameobject_loot_template", 7, []uint32{1, 2})
	if !strings.Contains(withRefs, "WHERE ((t.mincountOrRef > 0") {
		t.Errorf("the direct/reference group is not parenthesised before the type filter:\n%s", withRefs)
	}
	for _, table := range []string{"creature_loot_template", "skinning_loot_template", "item_loot_template"} {
		q, _ := lootSourceQuery(ContentLocaleBase, table, 7, nil)
		if strings.Contains(q, "type IN") {
			t.Errorf("%s: unexpected type filter:\n%s", table, q)
		}
	}
}

// TestLootSourceQueryReferences covers the two shapes one query has to match: the
// row that names the item, and the row that points at a reference holding it.
func TestLootSourceQueryReferences(t *testing.T) {
	without, args := lootSourceQuery(ContentLocaleBase, "creature_loot_template", 7, nil)
	if strings.Contains(without, " IN (") {
		t.Errorf("no references should mean no IN list: %s", without)
	}
	if len(args) != 2 { // the item and the limit
		t.Errorf("args = %v, want the item and the limit", args)
	}

	with, args := lootSourceQuery(ContentLocaleBase, "creature_loot_template", 7, []uint32{30016, 30017})
	if !strings.Contains(with, "t.mincountOrRef < 0 AND t.item IN (?,?)") {
		t.Errorf("reference clause missing: %s", with)
	}
	if !strings.Contains(with, "t.mincountOrRef > 0 AND t.item = ?") {
		t.Errorf("direct clause missing: %s", with)
	}
	if len(args) != 4 { // item, two references, limit
		t.Errorf("args = %v, want four", args)
	}
}

// TestReferenceParentsQuery covers the single query that serves both kinds of
// reference row, because both keep the id being searched for in the item column.
func TestReferenceParentsQuery(t *testing.T) {
	q, args := referenceParentsQuery([]uint32{1, 2, 3})
	if q != "SELECT DISTINCT entry FROM reference_loot_template WHERE item IN (?,?,?)" {
		t.Errorf("query = %q", q)
	}
	if len(args) != 3 {
		t.Errorf("args = %v, want three", args)
	}
}

// TestVendorQueries are the two directions of npc_vendor.
func TestVendorQueries(t *testing.T) {
	sellers, args := vendorSellersQuery(ContentLocaleZH, 117)
	for _, want := range []string{"FROM npc_vendor v", "JOIN creature_template c ON c.entry = v.entry",
		"LEFT JOIN locales_creature lc ON lc.entry = c.entry", "WHERE v.item = ?"} {
		if !strings.Contains(sellers, want) {
			t.Errorf("sellers query is missing %q: %s", want, sellers)
		}
	}
	if len(args) != 2 {
		t.Errorf("sellers args = %v", args)
	}

	items, _ := vendorItemsQuery(80117)
	if !strings.Contains(items, "FROM npc_vendor WHERE entry = ?") {
		t.Errorf("items query = %s", items)
	}
}

// TestLootSourceQueryLinksTheOwner pins the entry a drop-source row carries.
//
// The loot tables are keyed by a loot id, and the page turns that column into a
// link to a creature page. Selecting the loot table's own entry links to the loot
// id instead: this realm has loot ids that belong to no creature at all (the page
// 404s) and loot ids that are some *other* creature's entry (the page opens the
// wrong creature). The owner's entry is the only correct answer.
func TestLootSourceQueryLinksTheOwner(t *testing.T) {
	cases := []struct {
		table   string
		wantCol string
	}{
		{"creature_loot_template", "c.entry"},
		{"skinning_loot_template", "c.entry"},
		{"pickpocketing_loot_template", "c.entry"},
		{"gameobject_loot_template", "g.entry"},
		// For items the owner key *is* the item entry, so the two agree; naming
		// the owner keeps the rule uniform.
		{"item_loot_template", "i.entry"},
	}
	for _, tc := range cases {
		q, _ := lootSourceQuery(ContentLocaleBase, tc.table, 7, nil)
		if !strings.HasPrefix(q, "SELECT "+tc.wantCol) {
			t.Errorf("%s selects something other than the owner's entry:\n%s", tc.table, q)
		}
		if strings.Contains(q, "SELECT t.entry") {
			t.Errorf("%s still selects the loot table's own entry:\n%s", tc.table, q)
		}
		if !strings.Contains(q, "ORDER BY "+tc.wantCol) {
			t.Errorf("%s does not order by the owner's entry:\n%s", tc.table, q)
		}
	}
}

// TestQuestChainWalkFollowsTheTrunk walks the longest chain in this realm's data
// - Sven's revenge, fifteen quests in Duskwood - from a fixed copy of its links.
//
// Two of those links matter for the shape: quest 322 (Blessed Arm) is chained into
// by both 324 (The Lost Ingots) and 526 (Lightforge Ingots), and only 324 has
// steps of its own in front of it. The walk has to follow 324 - the trunk - and
// keep 526 in the list as the other way in, which is what the game shows too.
func TestQuestChainWalkFollowsTheTrunk(t *testing.T) {
	// The real NextQuestInChain edges (quest_template in this realm's data).
	edge := map[uint32]uint32{
		95: 230, 230: 262, 262: 265, 265: 266, 266: 453, 453: 268, 268: 323,
		323: 269, 269: 270, 270: 321, 321: 324, 324: 322, 526: 322, 322: 325, 325: 55,
	}
	walk := questWalker{
		next: func(entry uint32) (uint32, error) { return edge[entry], nil },
		prevs: func(entry uint32) ([]QuestChainStep, error) {
			// The query reads the predecessors by entry, which is the order the
			// walk sees them in.
			var out []QuestChainStep
			for from := uint32(1); from <= 700; from++ {
				if edge[from] == entry {
					out = append(out, QuestChainStep{Entry: from})
				}
			}
			return out, nil
		},
		titles: func(entries []uint32) (map[uint32]string, error) {
			out := map[uint32]string{}
			for _, entry := range entries {
				out[entry] = "quest " + itoa(entry)
			}
			return out, nil
		},
	}

	steps, err := chainSteps(322, walk)
	if err != nil {
		t.Fatalf("walk: %v", err)
	}
	want := []uint32{95, 230, 262, 265, 266, 453, 268, 323, 269, 270, 321, 324, 526, 322, 325, 55}
	if len(steps) != len(want) {
		t.Fatalf("walked %d steps, want %d: %+v", len(steps), len(want), entries(steps))
	}
	for i, entry := range want {
		if steps[i].Entry != entry {
			t.Errorf("step %d is %d, want %d (whole walk: %v)", i, steps[i].Entry, entry, entries(steps))
		}
	}
	for _, step := range steps {
		switch step.Entry {
		case 322:
			if !step.Current {
				t.Error("the quest the walk started from is not marked current")
			}
		case 526:
			if !step.Alternate {
				t.Error("526 is the other way into 322 and has to be marked an alternate")
			}
		default:
			if step.Current || step.Alternate {
				t.Errorf("step %d is marked current or alternate: %+v", step.Entry, step)
			}
		}
	}
	if steps[len(steps)-1].Entry != 55 {
		t.Errorf("the walk does not end at the last step: %v", entries(steps))
	}
}

// TestQuestChainWalkStopsOnALoop covers the reason the walk is bounded: these are
// data tables and data can contain a cycle, which would otherwise hang a request.
func TestQuestChainWalkStopsOnALoop(t *testing.T) {
	edge := map[uint32]uint32{1: 2, 2: 3, 3: 1}
	walk := questWalker{
		next: func(entry uint32) (uint32, error) { return edge[entry], nil },
		prevs: func(entry uint32) ([]QuestChainStep, error) {
			var out []QuestChainStep
			for from := uint32(1); from <= 3; from++ {
				if edge[from] == entry {
					out = append(out, QuestChainStep{Entry: from})
				}
			}
			return out, nil
		},
		titles: func(entries []uint32) (map[uint32]string, error) {
			out := map[uint32]string{}
			for _, entry := range entries {
				out[entry] = "quest " + itoa(entry)
			}
			return out, nil
		},
	}
	steps, err := chainSteps(1, walk)
	if err != nil {
		t.Fatalf("walk: %v", err)
	}
	if len(steps) > 2*questChainLimit+1 {
		t.Errorf("a loop produced %d steps; the walk is not bounded", len(steps))
	}
}

// TestQuestChainErrorsAreReported keeps a failing lookup from being read as "the
// chain ends here", which would silently truncate a line.
func TestQuestChainErrorsAreReported(t *testing.T) {
	boom := errors.New("boom")
	walk := questWalker{
		next:   func(uint32) (uint32, error) { return 0, boom },
		prevs:  func(uint32) ([]QuestChainStep, error) { return nil, nil },
		titles: func([]uint32) (map[uint32]string, error) { return nil, nil },
	}
	if _, err := chainSteps(1, walk); !errors.Is(err, boom) {
		t.Errorf("a failed forward lookup was swallowed: %v", err)
	}
	walk.next = func(uint32) (uint32, error) { return 0, nil }
	walk.prevs = func(uint32) ([]QuestChainStep, error) { return nil, boom }
	if _, err := chainSteps(1, walk); !errors.Is(err, boom) {
		t.Errorf("a failed backward lookup was swallowed: %v", err)
	}
	walk.prevs = func(uint32) ([]QuestChainStep, error) { return nil, nil }
	walk.titles = func([]uint32) (map[uint32]string, error) { return nil, boom }
	if _, err := chainSteps(1, walk); !errors.Is(err, boom) {
		t.Errorf("a failed title lookup was swallowed: %v", err)
	}
}

// TestQuestRequirementSigns pins what the sign of a requirement means, on rows
// taken from the real data.
//
// A positive link means the named quest has to be rewarded; a negative one means
// it only has to be in the log. The core reads it that way in
// Player::SatisfyQuestPreviousQuest, and both ends of the link are stored: a quest
// names its own predecessor in PrevQuestId, and a quest names the quest it leads
// into in NextQuestId, which is the same requirement written from the other side.
func TestQuestRequirementSigns(t *testing.T) {
	// Quest 322 (Blessed Arm) names 324 (The Lost Ingots) in its own PrevQuestId.
	// A positive link: the named quest has to be finished, not merely taken.
	requires, unlocks := questRequirementLists(322, questOwnLinks{prev: 324}, nil,
		map[uint32]string{324: "The Lost Ingots"})
	if len(requires) != 1 {
		t.Fatalf("322 requires %d quests, want 1: %+v", len(requires), requires)
	}
	if requires[0].Entry != 324 || !requires[0].Finished {
		t.Errorf("322 requires %+v; a positive link means it has to be finished", requires[0])
	}
	if len(unlocks) != 0 {
		t.Errorf("322 unlocks something it does not lead into: %+v", unlocks)
	}

	// Quest 687 stores the same requirement on both ends - its own PrevQuestId
	// names 653, and 653 names 687 in its NextQuestId (82 quests here do that) -
	// so the two have to be recognised as one requirement, not two.
	requires, _ = questRequirementLists(687, questOwnLinks{prev: 653}, []questLinkRow{
		{Entry: 653, Title: "Myzraels Allies", NextQuestID: 687},
	}, map[uint32]string{653: "Myzraels Allies"})
	if len(requires) != 1 || requires[0].Entry != 653 {
		t.Fatalf("a requirement stored on both ends came out as %+v", requires)
	}
	if !requires[0].Finished {
		t.Errorf("the stricter reading wins: %+v", requires[0])
	}

	// Quests 7161 and 7162 both name 7163 with a negative NextQuestId: either of
	// them merely has to have been taken.
	requires, unlocks = questRequirementLists(7163, questOwnLinks{}, []questLinkRow{
		{Entry: 7161, Title: "Proving Grounds", NextQuestID: -7163},
		{Entry: 7162, Title: "Proving Grounds", NextQuestID: -7163},
	}, nil)
	if len(requires) != 2 {
		t.Fatalf("7163 has %d requirements, want 2: %+v", len(requires), requires)
	}
	for _, r := range requires {
		if r.Finished {
			t.Errorf("a negative link was read as \"must be finished\": %+v", r)
		}
	}
	if len(unlocks) != 0 {
		t.Errorf("7163 unlocks something it does not lead into: %+v", unlocks)
	}

	// The other direction: a quest that names the page's quest leads nowhere yet.
	requires, unlocks = questRequirementLists(324, questOwnLinks{prev: 321, next: 322}, nil,
		map[uint32]string{321: "Lightforge Iron", 322: "Blessed Arm"})
	if len(requires) != 1 || requires[0].Entry != 321 {
		t.Errorf("324 requires %+v, want 321", requires)
	}
	if len(unlocks) != 1 || unlocks[0].Entry != 322 || !unlocks[0].Finished {
		t.Errorf("324 unlocks %+v, want 322 as something it has to be finished for", unlocks)
	}
}

func entries(steps []QuestChainStep) []uint32 {
	out := make([]uint32, 0, len(steps))
	for _, step := range steps {
		out = append(out, step.Entry)
	}
	return out
}

func itoa(v uint32) string {
	if v == 0 {
		return "0"
	}
	var buf [12]byte
	i := len(buf)
	for v > 0 {
		i--
		buf[i] = byte('0' + v%10)
		v /= 10
	}
	return string(buf[i:])
}
