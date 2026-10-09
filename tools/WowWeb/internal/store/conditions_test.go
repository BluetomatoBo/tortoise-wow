package store

import (
	"strings"
	"testing"
)

// TestSummarizeGroups covers the group totals the page prints: the sum the core
// computes for explicitly chanced rows, the count of equal-chance rows, and the
// case where two references share a groupid by accident and the sum would be a
// number the core never arrives at.
func TestSummarizeGroups(t *testing.T) {
	items := []ContentLootItem{
		{Entry: 1, Chance: 5},
		{Entry: 2, Chance: 60, Group: 4, Via: 900},
		{Entry: 3, Chance: 40, Group: 4, Via: 900},
		{Entry: 4, Chance: 0, Group: 7, Via: 0},
		{Entry: 5, Chance: 25, Group: 7, Via: 0},
		{Entry: 6, Chance: 10, Group: 8, Via: 111},
		{Entry: 7, Chance: 10, Group: 8, Via: 222},
	}
	summarizeGroups(items)

	if items[0].GroupChance != 0 || items[0].GroupEqual != 0 {
		t.Errorf("an ungrouped row grew a group summary: %+v", items[0])
	}
	if items[1].GroupChance != 100 || items[2].GroupChance != 100 {
		t.Errorf("group 4 total is %v and %v, want 100", items[1].GroupChance, items[2].GroupChance)
	}
	if items[3].GroupEqual != 1 || items[4].GroupEqual != 1 {
		t.Errorf("group 7 equal-chance count is %d and %d, want 1",
			items[3].GroupEqual, items[4].GroupEqual)
	}
	if items[3].GroupChance != 25 {
		t.Errorf("group 7 total is %v, want 25 (the equal-chance row adds nothing)", items[3].GroupChance)
	}
	if items[5].GroupChance != 0 || items[6].GroupChance != 0 {
		t.Errorf("a group spanning two references printed a total: %v and %v",
			items[5].GroupChance, items[6].GroupChance)
	}
}

// TestCondOperandOrder guards the operand order against the column order of the
// conditions table: an item condition stores value1 = item and value2 = count,
// and swapping them would print the count where the name belongs.
func TestCondOperandOrder(t *testing.T) {
	rows := map[uint32]condRow{
		80: {entry: 80, typ: -1, values: [4]int32{1, 79, 0, 0}},
		1:  {entry: 1, typ: 2, values: [4]int32{11511, 1, 0, 0}},
		79: {entry: 79, typ: 4, values: [4]int32{361, 0, 0, 0}},
	}
	names := map[string]string{
		condNameKey(CondItem, 0, 11511): "塞纳里奥信标",
	}
	got := buildCond(rows[80], rows, names, map[uint32]bool{}, 0)
	if got.Op != CondAnd || len(got.Kids) != 2 {
		t.Fatalf("the AND node came out as %+v", got)
	}
	item := got.Kids[0]
	if len(item.Args) != 2 {
		t.Fatalf("the item condition has %d operands, want 2", len(item.Args))
	}
	if item.Args[0].Name != "塞纳里奥信标" || item.Args[0].Value != "11511" {
		t.Errorf("operand 0 is %+v, want the item name and its id", item.Args[0])
	}
	if item.Args[1].Value != "1" || item.Args[1].Name != "" {
		t.Errorf("operand 1 is %+v, want the bare count", item.Args[1])
	}
	area := got.Kids[1]
	if area.Kind != CondArea || len(area.Args) != 1 || area.Args[0].Value != "361" {
		t.Errorf("the area condition came out as %+v", area)
	}
}

// TestCondCycleStops covers the guard the table needs: conditions are data, and
// a chain that points back at itself has to stop rather than recurse forever.
func TestCondCycleStops(t *testing.T) {
	rows := map[uint32]condRow{
		1: {entry: 1, typ: -1, values: [4]int32{2, 0, 0, 0}},
		2: {entry: 2, typ: -1, values: [4]int32{1, 0, 0, 0}},
	}
	got := buildCond(rows[1], rows, nil, map[uint32]bool{}, 0)
	// One level of nesting, then the cycle is cut: the walk does not hang.
	if got.Op != CondAnd || len(got.Kids) != 1 {
		t.Fatalf("the cycle was not cut at one level: %+v", got)
	}
}

// TestCondReverseFlagIsRead guards the flag bit: a reversed condition reads the
// opposite way, and dropping the bit would print the wrong requirement.
func TestCondReverseFlagIsRead(t *testing.T) {
	rows := map[uint32]condRow{
		5: {entry: 5, typ: 6, values: [4]int32{67, 0, 0, 0}, flags: 0x1},
		6: {entry: 6, typ: 6, values: [4]int32{67, 0, 0, 0}},
	}
	if got := buildCond(rows[5], rows, nil, map[uint32]bool{}, 0); !got.Reverse {
		t.Error("the reverse flag was dropped")
	}
	if got := buildCond(rows[6], rows, nil, map[uint32]bool{}, 0); got.Reverse {
		t.Error("a row with no flags came out reversed")
	}
}

// TestConditionColumnsExist checks the columns the condition queries read against
// the game's own CREATE TABLE statements, the same guard the loot queries have.
func TestConditionColumnsExist(t *testing.T) {
	schema := loadSchema(t)
	if schema == nil {
		t.Skipf("no game schema below %s", ddlDir)
	}
	for _, col := range []string{"condition_entry", "type", "value1", "value2", "value3", "value4", "flags"} {
		if !schema["conditions"][col] {
			t.Errorf("conditions has no %q column", col)
		}
	}
	for _, col := range []string{"groupid", "condition_id", "ChanceOrQuestChance", "mincountOrRef"} {
		if !schema["creature_loot_template"][strings.ToLower(col)] {
			t.Errorf("creature_loot_template has no %q column", col)
		}
	}
}
