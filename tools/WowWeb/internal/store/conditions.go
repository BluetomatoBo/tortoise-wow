package store

import (
	"context"
	"fmt"
	"sort"
	"strings"
)

// The conditions that gate loot rows.
//
// A loot row may carry a condition_id; the core checks it while rolling the row
// (Conditions.cpp), so a row whose condition is false never drops for that
// player. A page that prints only "5% chance" is telling a GM half of what the
// row says - the half that does not explain "why is this not dropping".
//
// The conditions table holds a small tree. Types -1/-2/-3 are AND/OR/NOT and
// their four value columns name other conditions; every other type is a leaf
// whose values are operands - a quest id, an item id, a number.
//
// The walk carries the same two guards the reference walk uses: a depth cap, and
// a visited set, because the table is data and data can contain a cycle.
//
// What the store resolves is the operand names that live in the database (a
// quest title, an item name, a spell name, an event description). The ones that
// live in the client's DBCs - area, skill, faction - are left as numbers and
// named by the web layer, which already loads those tables for the rest of the
// pages.

// Condition kinds. These are stable tokens: the web layer turns them into words
// through the message catalogue, so adding a language stays a data change.
const (
	CondAnd          = "and"
	CondOr           = "or"
	CondNot          = "not"
	CondAura         = "aura"
	CondItem         = "item"
	CondArea         = "area"
	CondTeam         = "team"
	CondSkill        = "skill"
	CondQuestDone    = "questRewarded"
	CondQuestTaken   = "questTaken"
	CondADCommission = "adCommission"
	CondGameEvent    = "gameEvent"
	CondSourceEntry  = "sourceEntry"
	CondDBGuid       = "dbGuid"
	CondLunatic      = "lunatic"
	CondUnknown      = "unknown"
)

// CondArg is one operand of a leaf condition.
//
// Value is the number the row stores; Name is the name the database has for it,
// empty when there is none. Both travel to the page: the name is what a reader
// recognises, and the id is what a GM edits - and two quests can share a title,
// which then reads as the same condition twice.
type CondArg struct {
	Value string
	Name  string
}

// LootCondition is one conditions row with its AND/OR/NOT chain dereferenced.
type LootCondition struct {
	// Kind names a leaf's condition type. Empty on a logical node.
	Kind string
	// Op is "and" / "or" / "not" on a logical node. Empty on a leaf.
	Op string
	// Args are a leaf's operands, in the order the type documents them.
	Args []CondArg
	// Kids are a logical node's operands.
	Kids []LootCondition
	// Reverse is the row's "the opposite of this condition" flag. The core
	// supports it on every type, so a page that drops it would lie.
	Reverse bool
	// Swap is the row's "swap source and target" flag.
	Swap bool
}

// Empty reports whether the condition says nothing worth printing.
func (c LootCondition) Empty() bool {
	return c.Kind == "" && c.Op == "" && len(c.Kids) == 0 && len(c.Args) == 0
}

// condRow is one raw conditions row.
type condRow struct {
	entry  uint32
	typ    int8
	values [4]int32
	flags  uint8
}

// condDepth bounds a condition chain. The deepest chain in this realm's data is
// a handful of hops.
const condDepth = 8

// lootConditionTypes maps a condition type to the kind token, and says how many
// of the four value columns the page shows.
//
// The numbers are the core's ConditionType (Conditions.h). Types the loot tables
// do not use are still listed where the meaning is unambiguous, so a GM who
// writes a new condition sees words rather than "条件类型 19".
var lootConditionTypes = map[int8]struct {
	kind string
	args int
}{
	1:  {CondAura, 1},         // having this spell's aura
	2:  {CondItem, 2},         // carrying this item, this many
	3:  {CondItem, 1},         // the same item, equipped
	4:  {CondArea, 1},         // standing in this area
	6:  {CondTeam, 1},         // alliance or horde
	7:  {CondSkill, 2},        // this skill, at least this value
	8:  {CondQuestDone, 1},    // quest already rewarded
	9:  {CondQuestTaken, 2},   // quest taken, in this state
	10: {CondADCommission, 0}, // wears the Argent Dawn commission
	12: {CondGameEvent, 1},    // this game event is running
	16: {CondSourceEntry, 1},  // the source is this exact entry
	52: {CondDBGuid, 2},       // the source's guid
	61: {CondLunatic, 0},      // level-one lunatic challenge
}

// LootConditions loads the conditions named by ids, keyed by condition id.
//
// The returned map holds one entry per id that exists, with its chain resolved.
func (s *Store) LootConditions(ctx context.Context, loc ContentLocale, ids []uint32) (map[uint32]*LootCondition, error) {
	wanted := map[uint32]bool{}
	for _, id := range ids {
		if id != 0 {
			wanted[id] = true
		}
	}
	if len(wanted) == 0 {
		return nil, nil
	}

	// The children a logical node names are conditions of their own, so the rows
	// are fetched in rounds until the frontier is empty. The rounds are bounded
	// by condDepth, and a row once read is not read again, which is also what
	// stops a cycle: a condition that names itself is simply not expanded
	// further.
	rows := map[uint32]condRow{}
	frontier := keysOf(wanted)
	for depth := 0; depth <= condDepth && len(frontier) > 0; depth++ {
		fetched, err := s.fetchCondRows(ctx, frontier)
		if err != nil {
			return nil, err
		}
		var next []uint32
		for id, row := range fetched {
			if _, seen := rows[id]; seen {
				continue
			}
			rows[id] = row
			if row.isLogical() {
				for _, child := range row.operands() {
					if child != 0 {
						if _, seen := rows[child]; !seen {
							next = append(next, child)
						}
					}
				}
			}
		}
		frontier = dedup(next)
	}

	// Names for the operands that have one. They are collected by kind first so
	// each table is read in one query rather than one per condition.
	names, err := s.condOperandNames(ctx, loc, rows)
	if err != nil {
		return nil, err
	}

	out := make(map[uint32]*LootCondition, len(wanted))
	for id := range wanted {
		if row, ok := rows[id]; ok {
			out[id] = buildCond(row, rows, names, map[uint32]bool{}, 0)
		}
	}
	return out, nil
}

// isLogical reports whether the row is an AND/OR/NOT node rather than a leaf.
func (r condRow) isLogical() bool { return r.typ < 0 }

// operands lists the condition ids a logical node points at.
func (r condRow) operands() []uint32 {
	out := make([]uint32, 0, 4)
	for _, v := range r.values {
		if v > 0 {
			out = append(out, uint32(v))
		}
	}
	return out
}

// fetchCondRows reads one round of condition rows.
func (s *Store) fetchCondRows(ctx context.Context, ids []uint32) (map[uint32]condRow, error) {
	q := "SELECT condition_entry, type, value1, value2, value3, value4, flags FROM conditions" +
		" WHERE condition_entry IN (" + placeholders(len(ids)) + ")"
	args := make([]any, 0, len(ids))
	for _, id := range ids {
		args = append(args, id)
	}
	rows, err := s.World.QueryContext(ctx, q, args...)
	if err != nil {
		return nil, fmt.Errorf("conditions %v: %w", ids, err)
	}
	defer rows.Close()

	out := map[uint32]condRow{}
	for rows.Next() {
		var r condRow
		if err := rows.Scan(&r.entry, &r.typ, &r.values[0], &r.values[1], &r.values[2], &r.values[3], &r.flags); err != nil {
			return nil, fmt.Errorf("scan conditions: %w", err)
		}
		out[r.entry] = r
	}
	return out, rows.Err()
}

// buildCond turns one row into a printable tree. visited holds the ids on the
// current path, so a chain that loops back on itself stops instead of recursing.
func buildCond(row condRow, rows map[uint32]condRow, names map[string]string, visited map[uint32]bool, depth int) *LootCondition {
	out := &LootCondition{
		Reverse: row.flags&0x1 != 0,
		Swap:    row.flags&0x2 != 0,
	}
	if row.isLogical() {
		switch row.typ {
		case -1:
			out.Op = CondAnd
		case -2:
			out.Op = CondOr
		default:
			out.Op = CondNot
		}
		if depth >= condDepth || visited[row.entry] {
			return out
		}
		visited[row.entry] = true
		defer delete(visited, row.entry)
		for _, child := range row.operands() {
			if c, ok := rows[child]; ok {
				out.Kids = append(out.Kids, *buildCond(c, rows, names, visited, depth+1))
			}
		}
		return out
	}

	spec, ok := lootConditionTypes[row.typ]
	if !ok {
		out.Kind = CondUnknown
		out.Args = []CondArg{{Value: fmt.Sprint(row.typ)}}
		for _, v := range row.values {
			if v != 0 {
				out.Args = append(out.Args, CondArg{Value: fmt.Sprint(v)})
			}
		}
		return out
	}
	out.Kind = spec.kind
	for i := 0; i < spec.args && i < 4; i++ {
		v := row.values[i]
		out.Args = append(out.Args, CondArg{
			Value: fmt.Sprint(v),
			Name:  names[condNameKey(spec.kind, i, v)],
		})
	}
	return out
}

// condNameKey keys one operand that has a name in the database.
func condNameKey(kind string, slot int, value int32) string {
	return fmt.Sprintf("%s|%d|%d", kind, slot, value)
}

// condOperandNames resolves the operand names that live in the database.
//
// Slot matters: for a taken-quest condition value1 is the quest and value2 is the
// state, and naming both would put a quest title where a "0/1/2" belongs.
func (s *Store) condOperandNames(ctx context.Context, loc ContentLocale, rows map[uint32]condRow) (map[string]string, error) {
	// Gather the ids per source table.
	quests := map[uint32]bool{}
	items := map[uint32]bool{}
	spells := map[uint32]bool{}
	events := map[uint32]bool{}
	creatures := map[uint32]bool{}
	for _, row := range rows {
		if row.isLogical() {
			continue
		}
		spec, ok := lootConditionTypes[row.typ]
		if !ok {
			continue
		}
		switch spec.kind {
		case CondQuestDone, CondQuestTaken:
			if row.values[0] > 0 {
				quests[uint32(row.values[0])] = true
			}
		case CondItem:
			if row.values[0] > 0 {
				items[uint32(row.values[0])] = true
			}
		case CondAura:
			if row.values[0] > 0 {
				spells[uint32(row.values[0])] = true
			}
		case CondGameEvent:
			if row.values[0] > 0 {
				events[uint32(row.values[0])] = true
			}
		case CondSourceEntry:
			if row.values[0] > 0 {
				creatures[uint32(row.values[0])] = true
			}
		}
	}

	out := map[string]string{}
	type lookup struct {
		kind  string
		slot  int
		ids   map[uint32]bool
		table string
		name  string
		joinA string
		locTb string
	}
	for _, lk := range []lookup{
		{CondQuestDone, 0, quests, "quest_template", "Title", "lq", "locales_quest"},
		{CondQuestTaken, 0, quests, "quest_template", "Title", "lq", "locales_quest"},
		{CondItem, 0, items, "item_template", "name", "li", "locales_item"},
		{CondAura, 0, spells, "spell_template", "name", "ls", "locales_spell"},
		{CondGameEvent, 0, events, "game_event", "description", "", ""},
		{CondSourceEntry, 0, creatures, "creature_template", "name", "lc", "locales_creature"},
	} {
		if len(lk.ids) == 0 {
			continue
		}
		names, err := s.condNames(ctx, loc, lk.ids, lk.table, lk.name, lk.joinA, lk.locTb)
		if err != nil {
			return nil, err
		}
		for id, name := range names {
			out[condNameKey(lk.kind, lk.slot, int32(id))] = name
		}
	}
	return out, nil
}

// condNames reads one table's names in the visitor's language.
func (s *Store) condNames(ctx context.Context, loc ContentLocale, ids map[uint32]bool, table, name, joinAlias, localeTable string) (map[uint32]string, error) {
	list := keysOf(ids)
	q := "SELECT t.entry, "
	if joinAlias != "" && loc != ContentLocaleBase {
		q += loc.localized(joinAlias, "t", name)
	} else {
		q += "COALESCE(t." + name + ", '')"
	}
	q += " FROM " + table + " t"
	if joinAlias != "" && loc != ContentLocaleBase {
		q += loc.join(joinAlias, localeTable, "entry", "t")
	}
	q += " WHERE t.entry IN (" + placeholders(len(list)) + ")"

	args := make([]any, 0, len(list))
	for _, id := range list {
		args = append(args, id)
	}
	rows, err := s.World.QueryContext(ctx, q, args...)
	if err != nil {
		return nil, fmt.Errorf("%s names: %w", table, err)
	}
	defer rows.Close()

	out := map[uint32]string{}
	for rows.Next() {
		var id uint32
		var got string
		if err := rows.Scan(&id, &got); err != nil {
			return nil, fmt.Errorf("scan %s name: %w", table, err)
		}
		out[id] = strings.TrimSpace(got)
	}
	return out, rows.Err()
}

func keysOf(m map[uint32]bool) []uint32 {
	out := make([]uint32, 0, len(m))
	for id := range m {
		out = append(out, id)
	}
	sort.Slice(out, func(i, j int) bool { return out[i] < out[j] })
	return out
}

func dedup(ids []uint32) []uint32 {
	if len(ids) == 0 {
		return nil
	}
	m := make(map[uint32]bool, len(ids))
	for _, id := range ids {
		m[id] = true
	}
	return keysOf(m)
}
