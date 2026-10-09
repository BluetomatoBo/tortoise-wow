package web

import (
	"strings"
	"testing"

	"tortoiseweb/internal/store"
)

// TestCondTextRendering covers the shape of a rendered condition: the operands in
// the order the conditions table stores them, the logical nodes folded rather
// than joined, and the ids that tell two same-named quests apart.
func TestCondTextRendering(t *testing.T) {
	zh := namePage(t, "zh")
	en := namePage(t, "en")

	cases := []struct {
		name string
		cond store.LootCondition
		zh   string
		en   string
	}{
		{
			name: "a single named operand keeps its id",
			cond: store.LootCondition{Kind: store.CondQuestDone,
				Args: []store.CondArg{{Value: "4242", Name: "被遗弃的希望"}}},
			zh: "需已完成任务「被遗弃的希望（#4242）」",
			en: `requires "被遗弃的希望 (#4242)" completed`,
		},
		{
			name: "an item condition puts the name before the count",
			cond: store.LootCondition{Kind: store.CondItem,
				Args: []store.CondArg{{Value: "11511", Name: "塞纳里奥信标"}, {Value: "1"}}},
			zh: "携带「塞纳里奥信标（#11511）」× 1",
			en: `carries "塞纳里奥信标 (#11511)" x 1`,
		},
		{
			name: "a skill operand is named from the client's table",
			cond: store.LootCondition{Kind: store.CondSkill,
				Args: []store.CondArg{{Value: "164"}, {Value: "1"}}},
			zh: "技能「锻造」达到 1",
			en: `skill "Blacksmithing" at 1`,
		},
		{
			name: "a team operand is a word, not the id",
			cond: store.LootCondition{Kind: store.CondTeam, Args: []store.CondArg{{Value: "67"}}},
			zh:   "仅限部落",
			en:   "Horde only",
		},
		{
			name: "a taken-quest state is a word",
			cond: store.LootCondition{Kind: store.CondQuestTaken,
				Args: []store.CondArg{{Value: "1846", Name: "龙喉胫骨"}, {Value: "2"}}},
			zh: "需已接任务「龙喉胫骨（#1846）」（已完成）",
			en: `requires quest "龙喉胫骨 (#1846)" taken (complete)`,
		},
		{
			name: "two operands are folded with the join entry",
			cond: store.LootCondition{Op: store.CondAnd, Kids: []store.LootCondition{
				{Kind: store.CondItem, Args: []store.CondArg{{Value: "11511", Name: "塞纳里奥信标"}, {Value: "1"}}},
				{Kind: store.CondArea, Args: []store.CondArg{{Value: "361"}}},
			}},
			zh: "携带「塞纳里奥信标（#11511）」× 1 且 身处「费伍德森林」",
			en: `carries "塞纳里奥信标 (#11511)" x 1 and in "Felwood"`,
		},
		{
			name: "the reverse flag is spelled out",
			cond: store.LootCondition{Kind: store.CondGameEvent, Reverse: true,
				Args: []store.CondArg{{Value: "12", Name: "Hallow's End"}}},
			zh: "不满足：节日/事件期间：Hallow's End（#12）",
			en: "not satisfied when: while the event is running: Hallow's End (#12)",
		},
		{
			// The database expresses "Horde only" as "not (Horde only)" plus the
			// reverse flag. Printing both halves is technically true and reads
			// like a mistake, so the pair cancels.
			name: "a reversed NOT is the condition it negates",
			cond: store.LootCondition{Op: store.CondNot, Reverse: true, Kids: []store.LootCondition{
				{Kind: store.CondTeam, Args: []store.CondArg{{Value: "67"}}},
			}},
			zh: "仅限部落",
			en: "Horde only",
		},
		{
			name: "an unknown type still prints its operands",
			cond: store.LootCondition{Kind: store.CondUnknown, Args: []store.CondArg{{Value: "99"}, {Value: "7"}}},
			zh:   "未知条件 99 7",
			en:   "unknown condition 99 7",
		},
		{
			name: "an area with no name falls back to the id",
			cond: store.LootCondition{Kind: store.CondArea, Args: []store.CondArg{{Value: "999999"}}},
			zh:   "身处「#999999」",
			en:   `in "#999999"`,
		},
	}

	for _, c := range cases {
		cond := c.cond
		if got := zh.CondText(&cond); got != c.zh {
			t.Errorf("%s [zh]:\n got %q\nwant %q", c.name, got, c.zh)
		}
		if got := en.CondText(&cond); got != c.en {
			t.Errorf("%s [en]:\n got %q\nwant %q", c.name, got, c.en)
		}
	}
}

// TestCondTextEmpty covers the values the templates test to decide whether to
// print a condition line at all.
func TestCondTextEmpty(t *testing.T) {
	page := namePage(t, "zh")
	if got := page.CondText(nil); got != "" {
		t.Errorf("a nil condition rendered as %q", got)
	}
	empty := store.LootCondition{}
	if got := page.CondText(&empty); got != "" {
		t.Errorf("an empty condition rendered as %q", got)
	}
}

// TestGroupLoot covers how the groupid column turns into a page: rows without a
// group stay in one list at the front, and a group carries the total the core
// itself computes.
func TestGroupLoot(t *testing.T) {
	items := []store.ContentLootItem{
		{Entry: 1, Chance: 5},
		{Entry: 2, Chance: 60, Group: 4, GroupChance: 100, Via: 900},
		{Entry: 3, Chance: 40, Group: 4, GroupChance: 100, Via: 900},
		{Entry: 4, Chance: 7},
		{Entry: 5, Chance: 0, Group: 9, GroupChance: 30, GroupEqual: 2, Via: 0},
		{Entry: 6, Chance: 30, Group: 9, GroupChance: 30, GroupEqual: 2, Via: 0},
	}
	groups := GroupLootItems(items)
	if len(groups) != 3 {
		t.Fatalf("grouped into %d lists, want 3", len(groups))
	}
	if groups[0].Group != 0 || len(groups[0].Items) != 2 {
		t.Errorf("the ungrouped rows are not the front list: group=%d items=%d",
			groups[0].Group, len(groups[0].Items))
	}
	if groups[0].Chance != 0 {
		t.Errorf("the ungrouped list printed a total (%v); there is none", groups[0].Chance)
	}
	if groups[1].Group != 4 || len(groups[1].Items) != 2 || groups[1].Chance != 100 {
		t.Errorf("group 4 came out as group=%d items=%d total=%v",
			groups[1].Group, len(groups[1].Items), groups[1].Chance)
	}
	if groups[2].Group != 9 || groups[2].Equal != 2 {
		t.Errorf("group 9 lost its equal-chance count: group=%d equal=%d",
			groups[2].Group, groups[2].Equal)
	}
	// The order inside a group is the order the rows were stored in, which is the
	// order the core rolls them in.
	if groups[1].Items[0].Entry != 2 || groups[1].Items[1].Entry != 3 {
		t.Errorf("group 4 reordered its rows: %d then %d", groups[1].Items[0].Entry, groups[1].Items[1].Entry)
	}
}

// TestGroupTotalNeedsOneReference covers the rule that a total is only printed
// when the rows came through one reference entry. Two references share a groupid
// by accident, and their sum would be a number the core never computes.
func TestGroupTotalNeedsOneReference(t *testing.T) {
	page := namePage(t, "zh")
	view := page.GroupLoot([]store.ContentLootItem{
		{Entry: 1, Chance: 10, Group: 3, Via: 111},
		{Entry: 2, Chance: 20, Group: 3, Via: 222},
	})
	if len(view) != 1 {
		t.Fatalf("got %d lists, want 1", len(view))
	}
	if view[0].Chance != 0 {
		t.Errorf("a group spanning two references printed a total (%v)", view[0].Chance)
	}
}

// TestGroupTotalRenders guards the suffix the group header prints: the catalogue
// entry ends in a literal percent sign, which must not be mistaken for a verb.
func TestGroupTotalRenders(t *testing.T) {
	page := namePage(t, "zh")
	got := page.GroupTotal(100)
	if strings.Contains(got, "EXTRA") || strings.Contains(got, "%!") {
		t.Fatalf("the total printed a format marker: %q", got)
	}
	if !strings.Contains(got, "100.00%") {
		t.Errorf("the total is missing its number: %q", got)
	}
}

// TestVerbCount guards the placeholder count a catalogue entry asks for. The
// entries end in a literal "%%", and counting "%" characters rather than verbs
// would make Sprintf print its "%!(EXTRA ...)" marker onto the page.
func TestVerbCount(t *testing.T) {
	cases := []struct {
		in   string
		want int
	}{
		{"组内总概率 %s%%", 1},
		{"%s 且 %s", 2},
		{"无占位符", 0},
		{"100%%", 0},
		{"%s 或 %s（#%s）", 3},
	}
	for _, c := range cases {
		if got := verbCount(c.in); got != c.want {
			t.Errorf("verbCount(%q) = %d, want %d", c.in, got, c.want)
		}
	}
}
