package web

import (
	"fmt"
	"strconv"
	"strings"

	"tortoiseweb/internal/store"
)

// Rendering the conditions that gate loot rows.
//
// The store hands back a small tree whose leaves name a kind and carry their
// operands as strings (see internal/store/conditions.go). Turning that into a
// sentence is a presentation job, so it happens here: the wording comes from the
// message catalogue - "cond.questRewarded" and friends - and the operands the
// operands that name something in the client's DBCs (an area, a skill, a team)
// are resolved with the same tables the rest of the pages use.
//
// A catalogue entry for a leaf is a format string with one verb per operand, so
// adding a language stays a data change rather than a code change.

// CondText renders a condition tree as one line. Nil and empty conditions render
// as "", which is what the templates test to decide whether to print anything.
func (p PageData) CondText(c *store.LootCondition) string {
	if c == nil || c.Empty() {
		return ""
	}
	return p.condNode(*c, 0)
}

// condMaxDepth mirrors the store's cap; a tree that deep is already truncated
// there, and this only has to stop the formatter from running away.
const condMaxDepth = 8

func (p PageData) condNode(c store.LootCondition, depth int) string {
	if depth >= condMaxDepth {
		return p.T("cond.unknown")
	}
	out := p.condBody(c, depth)
	// The flag flips whatever the row itself says. Flipping a NOT is a double
	// negation - "not satisfied by: not (Horde only)" is how the database says
	// "Horde only" - so that pair is dropped instead of printed, which is how a
	// reader would simplify it anyway.
	if c.Reverse {
		if c.Op == store.CondNot && len(c.Kids) == 1 {
			return p.condNode(c.Kids[0], depth+1)
		}
		return fmt.Sprintf(p.T("cond.negated"), out)
	}
	return out
}

// condBody renders the node itself, ignoring the reverse flag.
func (p PageData) condBody(c store.LootCondition, depth int) string {
	if c.Op != "" {
		parts := make([]string, 0, len(c.Kids))
		for _, kid := range c.Kids {
			parts = append(parts, p.condNode(kid, depth+1))
		}
		if len(parts) == 0 {
			return p.T("cond.unknown")
		}
		if len(parts) == 1 {
			// A "not" of one thing is that thing negated; an and/or with one leg
			// is that leg, not a one-element list.
			if c.Op == store.CondNot {
				return fmt.Sprintf(p.T("cond.not"), parts[0])
			}
			return parts[0]
		}
		// Folding rather than joining: the catalogue entry is a sentence with
		// two slots, and a translator can order them. Joining with the raw
		// format string would print the "%s" to the page.
		join := p.T("cond." + c.Op + "Join")
		acc := parts[0]
		for _, next := range parts[1:] {
			acc = sprintfCount(join, []string{acc, next})
		}
		return acc
	}
	return p.condLeaf(c)
}

// condLeaf renders one non-logical condition.
func (p PageData) condLeaf(c store.LootCondition) string {
	key := "cond." + c.Kind
	args := make([]string, 0, len(c.Args))
	for i, a := range c.Args {
		args = append(args, p.condArg(c.Kind, i, a))
	}

	// A type the core has and this page does not know still has to say
	// something: the raw type and the operands are what a GM would go and look
	// up, and dropping them would leave an empty condition line.
	if c.Kind == store.CondUnknown {
		return strings.TrimSpace(p.T("cond.unknown") + " " + strings.Join(args, " "))
	}

	format := p.T(key)
	if format == key {
		// The catalogue has no entry for this kind either. Printing the key
		// itself - "cond.area" - would be worse than the operands alone.
		return strings.TrimSpace(p.T("cond.unknown") + " " + strings.Join(args, " "))
	}
	return sprintfCount(format, args)
}

// condArg renders one operand.
//
// An operand that names something gets its name, and then the id in brackets:
// the name is what a reader recognises and the id is what a GM edits, and two
// rows can share a name - two quests with the same title are a real pair in this
// realm's data, and without the ids their "or" reads as a mistake.
func (p PageData) condArg(kind string, slot int, a store.CondArg) string {
	if a.Name != "" {
		return a.Name + fmt.Sprintf(p.T("cond.idSuffix"), a.Value)
	}
	switch {
	case kind == store.CondArea && slot == 0:
		return p.namedOr(a.Value, p.AreaName)
	case kind == store.CondSkill && slot == 0:
		return p.namedOr(a.Value, p.SkillName)
	case kind == store.CondTeam && slot == 0:
		return p.teamName(a.Value)
	case kind == store.CondQuestTaken && slot == 1:
		// value2 is the state the quest has to be in (Conditions.h): 0 any,
		// 1 incomplete, 2 complete. It is a word, not a number.
		return p.T("cond.questState." + a.Value)
	}
	return a.Value
}

// namedOr applies a name lookup to a decimal operand, keeping the number when
// the lookup has nothing.
func (p PageData) namedOr(raw string, lookup func(uint32) string) string {
	n, err := strconv.ParseUint(raw, 10, 32)
	if err != nil {
		return raw
	}
	if name := lookup(uint32(n)); name != "" {
		return name
	}
	return "#" + raw
}

// teamName renders the two team ids conditions use (SharedDefines.h: 469
// alliance, 67 horde).
func (p PageData) teamName(raw string) string {
	switch raw {
	case "469":
		return p.T("cond.team.alliance")
	case "67":
		return p.T("cond.team.horde")
	}
	return raw
}

// verbCount reports how many verbs a format string consumes.
//
// It is not the number of "%" characters: "%%" is a literal percent sign and
// takes no argument. Counting characters there would make a "100%%" suffix ask
// for an argument that does not exist, and Sprintf would print its
// "%!(EXTRA ...)" marker onto the page.
func verbCount(format string) int {
	n := 0
	for i := 0; i < len(format); i++ {
		if format[i] != '%' {
			continue
		}
		if i+1 < len(format) && format[i+1] == '%' {
			i++
			continue
		}
		n++
	}
	return n
}

// sprintfCount formats a catalogue entry that has one verb per operand.
//
// The verbs are filled in the order the entry writes them, so a translator can
// reorder or drop an operand - "装着 %2$s 的 %1$s" - without a code change. An
// entry with fewer verbs than operands drops the extras instead of printing
// "%!(EXTRA ...)" onto the page.
func sprintfCount(format string, args []string) string {
	n := verbCount(format)
	if n == 0 {
		return format
	}
	if len(args) > n {
		args = args[:n]
	}
	anyArgs := make([]any, 0, n)
	for _, a := range args {
		anyArgs = append(anyArgs, a)
	}
	for len(anyArgs) < n {
		anyArgs = append(anyArgs, "")
	}
	// %d is spelled for a number, but every operand arrives as a string; the
	// catalogue writes %s and this only catches a stray %d in an entry.
	return fmt.Sprintf(strings.ReplaceAll(format, "%d", "%s"), anyArgs...)
}

// ---------------------------------------------------------------------------
// Loot groups
// ---------------------------------------------------------------------------

// LootGroupView is one groupid of a loot list, with its rows.
//
// A group is the core's "at most one of these" set: the chances inside it are
// subtracted in order from a single roll, and the first row whose chance covers
// the roll wins. Printing the rows as a flat list of percents - which is what
// the page did before - leaves a GM unable to tell a 5% drop from a 5% share of a
// group that always produces something.
type LootGroupView struct {
	// Group is the groupid, or 0 for the rows rolled on their own.
	Group uint8
	// Items are the rows, in the order they are stored.
	Items []store.ContentLootItem
	// Chance is the group's total stored chance, when that number means
	// something: every row explicitly chanced, all from the same reference
	// entry. Zero means the page prints no total.
	Chance float64
	// Equal is how many rows are stored with chance 0 ("one of these").
	Equal int
}

// GroupLoot is the template's view of the package function below: a template
// can only call methods on the value it is handed.
func (p PageData) GroupLoot(items []store.ContentLootItem) []LootGroupView {
	return GroupLootItems(items)
}

// GroupLootItems splits a loot list into its groups, keeping the ungrouped rows
// together in the front group so the common case still reads as one list.
func GroupLootItems(items []store.ContentLootItem) []LootGroupView {
	if len(items) == 0 {
		return nil
	}
	var free []store.ContentLootItem
	var order []uint8
	byGroup := map[uint8][]store.ContentLootItem{}
	for _, it := range items {
		if it.Group == 0 {
			free = append(free, it)
			continue
		}
		if _, seen := byGroup[it.Group]; !seen {
			order = append(order, it.Group)
		}
		byGroup[it.Group] = append(byGroup[it.Group], it)
	}

	var out []LootGroupView
	if len(free) > 0 {
		out = append(out, LootGroupView{Items: free})
	}
	for _, g := range order {
		items := byGroup[g]
		out = append(out, LootGroupView{
			Group:  g,
			Items:  items,
			Chance: items[0].GroupChance,
			Equal:  items[0].GroupEqual,
		})
	}
	return out
}

// GroupEqualHint says what the equal-chance rows in a group mean.
func (p PageData) GroupEqualHint(n int) string {
	return fmt.Sprintf(p.T("db.lootGroupEqual"), n)
}

// GroupLabel renders the group header, e.g. "Loot group 3".
func (p PageData) GroupLabel(group uint8) string {
	return sprintfCount(p.T("db.lootGroup"), []string{strconv.Itoa(int(group))})
}

// GroupTotal renders a group's total chance. The marker is the catalogue's, so
// a language that puts the number first can.
func (p PageData) GroupTotal(chance float64) string {
	return sprintfCount(p.T("db.lootGroupTotal"), []string{strconv.FormatFloat(chance, 'f', 2, 64)})
}
