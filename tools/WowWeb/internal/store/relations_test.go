package store

import (
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
		kind     DropKind
		baseWant string
		zhWant   string
		zhJoin   string
	}{
		{DropCreature, "COALESCE(c.name, '')", "COALESCE(lc.name_loc4, c.name, '')", "LEFT JOIN locales_creature lc ON lc.entry = c.entry"},
		{DropGameObject, "COALESCE(g.name, '')", "COALESCE(lg.name_loc4, g.name, '')", "LEFT JOIN locales_gameobject lg ON lg.entry = g.entry"},
		{DropItem, "COALESCE(i.name, '')", "COALESCE(li.name_loc4, i.name, '')", "LEFT JOIN locales_item li ON li.entry = i.entry"},
	}
	for _, tc := range cases {
		base, _ := lootSourceQuery(ContentLocaleBase, "creature_loot_template", tc.kind, 7, nil)
		if !strings.Contains(base, tc.baseWant) {
			t.Errorf("%s base: want %s in %s", tc.kind, tc.baseWant, base)
		}
		if strings.Contains(base, "_loc4") {
			t.Errorf("%s base: names a locale column: %s", tc.kind, base)
		}

		zh, _ := lootSourceQuery(ContentLocaleZH, "creature_loot_template", tc.kind, 7, nil)
		if !strings.Contains(zh, tc.zhWant) || !strings.Contains(zh, tc.zhJoin) {
			t.Errorf("%s zh: want %s and the join in %s", tc.kind, tc.zhWant, zh)
		}
	}
}

// TestLootSourceQueryReferences covers the two shapes one query has to match: the
// row that names the item, and the row that points at a reference holding it.
func TestLootSourceQueryReferences(t *testing.T) {
	without, args := lootSourceQuery(ContentLocaleBase, "creature_loot_template", DropCreature, 7, nil)
	if strings.Contains(without, " IN (") {
		t.Errorf("no references should mean no IN list: %s", without)
	}
	if len(args) != 2 { // the item and the limit
		t.Errorf("args = %v, want the item and the limit", args)
	}

	with, args := lootSourceQuery(ContentLocaleBase, "creature_loot_template", DropCreature, 7, []uint32{30016, 30017})
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
