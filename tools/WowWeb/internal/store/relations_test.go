package store

import (
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
