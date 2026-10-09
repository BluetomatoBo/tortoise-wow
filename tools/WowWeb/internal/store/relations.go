package store

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"math"
	"sort"
	"strings"
)

// Cross links between the browsable content: which creature gives a quest,
// whose loot an item comes out of, who sells it.
//
// The core keeps these in small relation tables (creature_questrelation) and in
// the loot tables (creature_loot_template and friends). A loot row is one of two
// things, told apart by the sign of mincountOrRef:
//
//	mincountOrRef > 0   the row yields `item`, that many times at minimum
//	mincountOrRef < 0   the row yields reference_loot_template entry `item`
//
// so a reference is read from the item column, not from a column of its own. A
// negative ChanceOrQuestChance means the drop only happens for that quest, and
// its magnitude is still the chance.
//
// References nest, and reference_loot_template is small enough (under ten
// thousand rows here) to walk row by row instead of writing recursive SQL, which
// keeps the queries readable and the MySQL version requirement low. Every walk
// is bounded twice: the depth is capped, and an entry already on the current
// path is not entered again, because these tables are data and data can contain
// a cycle.
//
// What the walks report is the chance the row stores - the number a GM compares
// against - not the probability a particular character sees at the mob. The two
// columns that explain why a row may not drop at all are carried alongside it:
// groupid says the row is one of a set that yields at most one item, and
// condition_id names a condition the player has to meet. Both are resolved by
// the page; the raw values are kept here because they are what the GM edits.

// relationLimit caps every relation list. An item can drop from hundreds of
// creatures; the page shows the first rows by entry and says which lists were
// cut rather than rendering a wall of them.
const relationLimit = 200

// refMaxDepth bounds a reference walk. The deepest chain in this realm's data is
// a few hops, so this only has to be a number that exists.
const refMaxDepth = 8

// DropKind says what the entry on the far side of a relation is. It decides
// which table the name comes from and which heading the page prints.
type DropKind string

const (
	DropCreature   DropKind = "creature"
	DropGameObject DropKind = "gameobject"
	DropItem       DropKind = "item"
)

// ContentDrop is one source of an item: the creature, gameobject or container
// whose loot can produce it.
type ContentDrop struct {
	Entry     uint32
	Name      string
	Kind      DropKind
	Chance    float64 // percent
	MinCount  uint32
	MaxCount  uint32
	QuestOnly bool   // the stored chance was negative: it only drops for a quest
	Via       uint32 // non-zero: the item sits inside this reference_loot_template entry
	// Group and Condition work as they do on ContentLootItem.
	Group     uint8
	Condition *LootCondition

	// condID is the raw condition_id, replaced by Condition once loaded.
	condID uint32
}

// ContentLootItem is one item something can drop.
type ContentLootItem struct {
	Entry uint32
	Name  string
	// DisplayID is the client display id the icon is looked up by.
	DisplayID uint32
	Chance    float64 // percent
	MinCount  uint32
	MaxCount  uint32
	QuestOnly bool
	Via       uint32 // non-zero: reached through this reference_loot_template entry
	// Group is the loot group the row belongs to. A group above zero yields at
	// most one of its rows: the chances inside it are weights, and the core
	// subtracts them from one roll in row order (LootMgr.cpp, LootGroup::Roll).
	// Zero means the row is rolled on its own.
	Group uint8
	// GroupChance is the group's total chance for the simple case where every
	// row in it is explicitly chanced: the sum the core compares against 100 to
	// warn about an over-weighted group. Zero when the group is empty or holds
	// equal-chance rows, where the sum does not describe the outcome.
	GroupChance float64
	// GroupEqual is the number of rows in the group stored with chance 0, which
	// the core treats as "one of these at random".
	GroupEqual int
	// Condition is the condition the player has to meet for the row to be
	// rolled at all. Nil when the row is unconditional.
	Condition *LootCondition

	// condID is the raw condition_id, kept until the conditions are loaded and
	// then replaced by Condition. Unexported: the number is an editing detail,
	// the page shows the resolved condition.
	condID uint32
}

// ContentQuestRef is a quest in a relation list ("gives this quest", "rewards
// this item").
type ContentQuestRef struct {
	Entry  uint32
	Title  string
	Count  uint16
	Choice bool // one of several rewards to pick from
}

// ContentSourceRef is a creature or gameobject in a relation list.
type ContentSourceRef struct {
	Entry uint32
	Name  string
	Kind  DropKind
}

// ItemRelations is everything the item page says about where an item comes from
// and what asks for it.
type ItemRelations struct {
	DroppedBy        []ContentDrop // creatures
	FoundIn          []ContentDrop // gameobjects: chests, herb nodes, ore veins
	ContainedIn      []ContentDrop // items that contain it
	SkinnedFrom      []ContentDrop // creatures
	PickpocketedFrom []ContentDrop // creatures
	SoldBy           []ContentDrop // creatures
	RequiredBy       []ContentQuestRef
	RewardedBy       []ContentQuestRef

	// Truncated holds the i18n keys of the lists that hit relationLimit.
	Truncated []string
}

// CreatureRelations is the other direction: what this creature starts, ends and
// hands out.
type CreatureRelations struct {
	StartsQuests []ContentQuestRef
	EndsQuests   []ContentQuestRef
	Drops        []ContentLootItem
	Skins        []ContentLootItem
	Pickpockets  []ContentLootItem
	Sells        []ContentLootItem

	Truncated []string
}

// QuestRelations is who hands a quest out and who takes it back.
type QuestRelations struct {
	Starts []ContentSourceRef
	Ends   []ContentSourceRef
}

// ---------------------------------------------------------------------------
// Query builders
// ---------------------------------------------------------------------------

// placeholders spells an IN list.
func placeholders(n int) string {
	return strings.TrimSuffix(strings.Repeat("?,", n), ",")
}

// lootOwner says how a loot table hangs off the thing that owns its rows.
//
// Key is the owner's column that names the loot entry, and it is not the owner's
// own entry: the core reads creature_template.loot_id for
// creature_loot_template, skinning_loot_id for skinning_loot_template and
// pickpocket_loot_id for pickpocketing_loot_template. The two values coincide by
// habit rather than by rule - 5231 of this realm's 5404 loot-bearing creatures
// happen to have loot_id == entry - so joining on entry looks right on most rows
// and is wrong on the rest.
//
// Extra is a predicate the core also applies while resolving the loot id:
// gameobjects expose one only for chests and fishing holes (GameObject.h,
// GetLootId), where data1 is that id. For any other type data1 means something
// else, so matching on it alone would invent drops.
type lootOwner struct {
	kind  DropKind
	key   string
	extra string
}

var lootOwners = map[string]lootOwner{
	"creature_loot_template":      {DropCreature, "loot_id", ""},
	"skinning_loot_template":      {DropCreature, "skinning_loot_id", ""},
	"pickpocketing_loot_template": {DropCreature, "pickpocket_loot_id", ""},
	"gameobject_loot_template":    {DropGameObject, "data1", "g.type IN (3, 25)"},
	"item_loot_template":          {DropItem, "entry", ""},
}

// lootSource names the table that owns a loot table's entries, with the join and
// the expression that read that name in the visitor's language.
func lootSource(loc ContentLocale, kind DropKind) (from, join, name, owner string) {
	switch kind {
	case DropGameObject:
		return "gameobject_template g", loc.join("lg", "locales_gameobject", "entry", "g"),
			loc.localized("lg", "g", "name"), "g"
	case DropItem:
		return "item_template i", loc.join("li", "locales_item", "entry", "i"),
			loc.localized("li", "i", "name"), "i"
	default:
		return "creature_template c", loc.join("lc", "locales_creature", "entry", "c"),
			loc.localized("lc", "c", "name"), "c"
	}
}

// ownerJoin is the clause that binds a loot table to the table that owns its
// rows. It is what makes the owner's name in the SELECT list mean anything:
// without it the query names an alias that is not in the FROM clause, and the
// server rejects the whole statement with "Unknown column 'c.name' in 'field
// list'".
func ownerJoin(owner, key, lootAlias string) string {
	return " JOIN " + owner + " ON " + strings.Fields(owner)[1] + "." + key + " = " + lootAlias + ".entry"
}

// lootSourceQuery lists the rows of one loot table that can produce the item:
// the rows that name it, plus the rows pointing at a reference entry that
// contains it. refs may be empty, in which case only direct rows match.
func lootSourceQuery(loc ContentLocale, table string, item uint32, refs []uint32) (string, []any) {
	own := lootOwners[table]
	from, localeJoin, name, owner := lootSource(loc, own.kind)
	where := "(t.mincountOrRef > 0 AND t.item = ?)"
	args := []any{item}
	if len(refs) > 0 {
		where += " OR (t.mincountOrRef < 0 AND t.item IN (" + placeholders(len(refs)) + "))"
		for _, r := range refs {
			args = append(args, r)
		}
	}
	// The extra predicate has to be ANDed onto the whole match, not onto the
	// last branch of it: "a OR b AND c" parses as "a OR (b AND c)" in SQL, which
	// would let the direct rows through without the type check.
	extra := ""
	if own.extra != "" {
		extra = " AND (" + own.extra + ")"
		where = "(" + where + ")"
	}
	// The entry selected is the *owner's*, not the loot table's: the loot table is
	// keyed by a loot id, and the page turns this column into a link. Selecting
	// t.entry links to the loot id, which is a creature only by coincidence - this
	// realm has loot ids that belong to nothing (2000213, whose loot data exists)
	// and loot ids that are another creature's entry, so the link either 404s or
	// opens the wrong creature.
	//
	// t.item is selected as well: on a reference row it holds the entry being
	// pointed at, which is what the chance has to be resolved against.
	q := "SELECT " + owner + ".entry, " + name + ", t.ChanceOrQuestChance, t.mincountOrRef, t.maxcount, t.item," +
		" t.groupid, t.condition_id" +
		" FROM " + table + " t" +
		ownerJoin(from, own.key, "t") + localeJoin +
		" WHERE " + where + extra + " ORDER BY " + owner + ".entry, t.item LIMIT ?"
	return q, append(args, relationLimit)
}

// lootItemsQuery lists one loot table's rows for a single owner. The owner is
// the leading column of every loot table's primary key, so this is an index read
// even on creature_loot_template.
func lootItemsQuery(table string, owner uint32) (string, []any) {
	return "SELECT item, ChanceOrQuestChance, mincountOrRef, maxcount, groupid, condition_id FROM " + table +
		" WHERE entry = ? ORDER BY groupid, item LIMIT ?", []any{owner, relationLimit}
}

// referenceParentsQuery lists the reference entries that name any of ids.
//
// One query covers both kinds of row on purpose: a direct row names the item and
// a hop names the reference it leads to, and in both cases the id being looked
// for sits in the item column.
func referenceParentsQuery(ids []uint32) (string, []any) {
	args := make([]any, 0, len(ids))
	for _, id := range ids {
		args = append(args, id)
	}
	return "SELECT DISTINCT entry FROM reference_loot_template WHERE item IN (" +
		placeholders(len(ids)) + ")", args
}

// referenceItemsQuery lists one reference entry's rows.
func referenceItemsQuery(entry uint32) (string, []any) {
	return "SELECT item, ChanceOrQuestChance, mincountOrRef, maxcount, groupid, condition_id" +
		" FROM reference_loot_template WHERE entry = ? ORDER BY groupid, item", []any{entry}
}

// vendorSellersQuery lists the creatures selling the item.
func vendorSellersQuery(loc ContentLocale, item uint32) (string, []any) {
	_, join, name, _ := lootSource(loc, DropCreature)
	return "SELECT v.entry, " + name + " FROM npc_vendor v" +
		" JOIN creature_template c ON c.entry = v.entry" + join +
		" WHERE v.item = ? ORDER BY v.entry LIMIT ?", []any{item, relationLimit}
}

// vendorItemsQuery lists what one creature sells. Only the item ids come out of
// it; their names are filled by the same lookup the loot lists use.
func vendorItemsQuery(entry uint32) (string, []any) {
	return "SELECT item FROM npc_vendor WHERE entry = ? ORDER BY item LIMIT ?",
		[]any{entry, relationLimit}
}

// questItemPrefixes names the (id, count) column prefixes a quest template uses
// to ask for items or hand them out.
func questItemPrefixes(kind string) []string {
	switch kind {
	case "required":
		return []string{"ReqItemId"}
	case "choice":
		return []string{"RewChoiceItemId"}
	default:
		return []string{"RewItemId"}
	}
}

// questItemQuery finds the quests that name the item in any of the given column
// prefixes.
//
// The slots are selected rather than aggregated in SQL so the caller can tell
// which one matched - a required item and a choice reward both need saying - and
// because a CASE chain over ten pairs is harder to read than the loop building
// this one.
func questItemQuery(loc ContentLocale, prefixes []string, slots int, item uint32) (string, []any) {
	var cols, where []string
	args := []any{}
	for _, prefix := range prefixes {
		// The id column is "<prefix>IdN" and its count is "<prefix>CountN": for
		// ReqItemId that is ReqItemCount1, so the trailing "Id" belongs to the
		// slot number, not to the count column.
		count := strings.TrimSuffix(prefix, "Id")
		for i := 1; i <= slots; i++ {
			id := fmt.Sprintf("q.%s%d", prefix, i)
			cols = append(cols, id, fmt.Sprintf("q.%sCount%d", count, i))
			where = append(where, id+" = ?")
			args = append(args, item)
		}
	}
	q := "SELECT q.entry, " + loc.localized("cl", "q", "Title") + ", " + strings.Join(cols, ", ") +
		" FROM quest_template q" + loc.join("cl", "locales_quest", "entry", "q") +
		" WHERE (" + strings.Join(where, " OR ") + ") ORDER BY q.entry LIMIT ?"
	return q, append(args, relationLimit)
}

// questActorQuery lists the creatures or gameobjects on one side of a quest: the
// ones that hand it out (relation) or take it back (involved).
func questActorQuery(loc ContentLocale, table string, kind DropKind, quest uint32) (string, []any) {
	from, join, name, owner := lootSource(loc, kind)
	return "SELECT " + owner + ".entry, " + name +
		" FROM " + table + " r" +
		" JOIN " + from + " ON " + owner + ".entry = r.id" + join +
		" WHERE r.quest = ? ORDER BY " + owner + ".entry LIMIT ?", []any{quest, relationLimit}
}

// questsOfActorQuery lists the quests one creature relates to. It only selects
// quest ids and titles, so it shares the scan with the reward queries.
func questsOfActorQuery(loc ContentLocale, table string, actor uint32) (string, []any) {
	return "SELECT r.quest, " + loc.localized("cl", "q", "Title") +
		" FROM " + table + " r" +
		" JOIN quest_template q ON q.entry = r.quest" +
		loc.join("cl", "locales_quest", "entry", "q") +
		" WHERE r.id = ? ORDER BY r.quest LIMIT ?", []any{actor, relationLimit}
}

// ---------------------------------------------------------------------------
// Reference walking
// ---------------------------------------------------------------------------

// referenceRow is one reference_loot_template row.
type referenceRow struct {
	item          uint32
	chance        float64
	mincountOrRef int32
	maxcount      uint32
	group         uint8
	cond          uint32
}

// referenceRows reads one reference entry.
func (s *Store) referenceRows(ctx context.Context, entry uint32) ([]referenceRow, error) {
	q, args := referenceItemsQuery(entry)
	rows, err := s.World.QueryContext(ctx, q, args...)
	if err != nil {
		return nil, fmt.Errorf("reference loot %d: %w", entry, err)
	}
	defer rows.Close()

	var out []referenceRow
	for rows.Next() {
		var r referenceRow
		if err := rows.Scan(&r.item, &r.chance, &r.mincountOrRef, &r.maxcount, &r.group, &r.cond); err != nil {
			return nil, fmt.Errorf("scan reference loot %d: %w", entry, err)
		}
		out = append(out, r)
	}
	return out, rows.Err()
}

// refsContaining lists the reference entries that reach the item, directly or
// through other references. This is the upward direction - "who could drop it" -
// and it is what lets a loot table query recognise a row that points at a
// reference instead of naming the item.
func (s *Store) refsContaining(ctx context.Context, item uint32) ([]uint32, error) {
	seen := map[uint32]bool{item: true}
	level := []uint32{item}
	var found []uint32

	for depth := 0; depth < refMaxDepth && len(level) > 0; depth++ {
		q, args := referenceParentsQuery(level)
		rows, err := s.World.QueryContext(ctx, q, args...)
		if err != nil {
			return nil, fmt.Errorf("reference parents: %w", err)
		}
		var next []uint32
		for rows.Next() {
			var entry uint32
			if err := rows.Scan(&entry); err != nil {
				rows.Close()
				return nil, fmt.Errorf("scan reference parent: %w", err)
			}
			if !seen[entry] {
				seen[entry] = true
				next = append(next, entry)
			}
		}
		err = rows.Err()
		rows.Close()
		if err != nil {
			return nil, err
		}
		found = append(found, next...)
		level = next
	}
	return found, nil
}

// refHit is what one reference entry holds for an item.
type refHit struct {
	chance   float64 // percent of reaching the item from this entry
	min, max uint32
}

// refChainHits walks downwards and reports, per starting reference entry, the
// chance of the item coming out of it.
//
// The chance of reaching the item through a reference is the item's own row
// there, plus for every hop the hop's chance times what that reference holds -
// the same product the core builds when it loads loot. Each stored percentage is
// divided by 100 as it is folded in, so the result is a percentage again.
func (s *Store) refChainHits(ctx context.Context, item uint32, roots []uint32) (map[uint32]refHit, error) {
	memo := map[uint32]refHit{}
	busy := map[uint32]bool{}

	var walk func(entry uint32, depth int) (refHit, error)
	walk = func(entry uint32, depth int) (refHit, error) {
		if hit, ok := memo[entry]; ok {
			return hit, nil
		}
		if busy[entry] || depth > refMaxDepth {
			return refHit{}, nil
		}
		busy[entry] = true
		defer delete(busy, entry)

		rows, err := s.referenceRows(ctx, entry)
		if err != nil {
			return refHit{}, err
		}
		var out refHit
		for _, r := range rows {
			factor := math.Abs(r.chance) / 100
			if factor == 0 {
				continue
			}
			if r.mincountOrRef > 0 {
				if r.item != item {
					continue
				}
				out.chance += factor
				if out.min == 0 {
					out.min, out.max = uint32(r.mincountOrRef), r.maxcount
				}
				continue
			}
			sub, err := walk(r.item, depth+1)
			if err != nil {
				return refHit{}, err
			}
			if sub.chance == 0 {
				continue
			}
			out.chance += factor * sub.chance / 100
			if out.min == 0 {
				out.min, out.max = sub.min, sub.max
			}
		}
		if out.chance > 100 {
			out.chance = 100
		}
		memo[entry] = out
		return out, nil
	}

	hits := make(map[uint32]refHit, len(roots))
	for _, root := range roots {
		hit, err := walk(root, 0)
		if err != nil {
			return nil, err
		}
		hits[root] = hit
	}
	return hits, nil
}

// collectReferenceItems appends every item a reference entry can yield, scaling
// each stored chance by the hops that led here. factor is a percentage: 100 when
// the reference was picked outright, less when it was reached through another.
func (s *Store) collectReferenceItems(ctx context.Context, ref uint32, factor float64, depth int, seen map[uint32]bool, out *[]ContentLootItem, group uint8, cond uint32) error {
	if depth > refMaxDepth || seen[ref] {
		return nil
	}
	seen[ref] = true

	rows, err := s.referenceRows(ctx, ref)
	if err != nil {
		return err
	}
	for _, r := range rows {
		chance := factor * math.Abs(r.chance) / 100
		if chance == 0 {
			continue
		}
		if r.mincountOrRef > 0 {
			*out = append(*out, ContentLootItem{
				Entry:     r.item,
				Chance:    chance,
				MinCount:  uint32(r.mincountOrRef),
				MaxCount:  r.maxcount,
				QuestOnly: r.chance < 0,
				Via:       ref,
				Group:     r.group,
				condID:    r.cond,
			})
			continue
		}
		if err := s.collectReferenceItems(ctx, r.item, chance, depth+1, seen, out, r.group, r.cond); err != nil {
			return err
		}
	}
	return nil
}

// summarizeGroups fills in the group totals the page prints on a group header.
//
// The number is the one the core itself computes (LootGroup::RawTotalChance):
// the sum of the rows stored with a chance above zero. Rows stored with chance
// zero are the group's "one of these at random" part, and the sum does not
// describe them, so they are counted instead. A group whose rows all come from
// different reference entries is not one group in the core either - each
// reference is rolled on its own - but the ids are the same number and the page
// says so rather than inventing a total.
func summarizeGroups(items []ContentLootItem) {
	type acc struct {
		sum   float64
		equal int
		vias  map[uint32]bool
	}
	groups := map[uint8]*acc{}
	for _, it := range items {
		if it.Group == 0 {
			continue
		}
		a := groups[it.Group]
		if a == nil {
			a = &acc{vias: map[uint32]bool{}}
			groups[it.Group] = a
		}
		a.vias[it.Via] = true
		if it.Chance == 0 {
			a.equal++
			continue
		}
		a.sum += it.Chance
	}
	for i := range items {
		if items[i].Group == 0 {
			continue
		}
		a := groups[items[i].Group]
		if a == nil {
			continue
		}
		items[i].GroupEqual = a.equal
		// One reference entry means one group in the core; several mean the
		// total says nothing, so it is left at zero and the page prints no
		// number.
		if len(a.vias) == 1 {
			items[i].GroupChance = a.sum
		}
	}
}

// attachConditions loads the conditions the rows name and hangs each one on its
// row. One query per table, not one per row: a boss can carry a hundred rows.
func (s *Store) attachConditions(ctx context.Context, loc ContentLocale, items []ContentLootItem) error {
	var ids []uint32
	for _, it := range items {
		if it.condID != 0 {
			ids = append(ids, it.condID)
		}
	}
	if len(ids) == 0 {
		return nil
	}
	conds, err := s.LootConditions(ctx, loc, dedup(ids))
	if err != nil {
		return err
	}
	for i := range items {
		if items[i].condID == 0 {
			continue
		}
		if c, ok := conds[items[i].condID]; ok {
			items[i].Condition = c
		}
	}
	return nil
}

// attachDropConditions is attachConditions for the item page's direction, where
// the rows are ContentDrop.
func (s *Store) attachDropConditions(ctx context.Context, loc ContentLocale, drops []ContentDrop) error {
	var ids []uint32
	for _, d := range drops {
		if d.condID != 0 {
			ids = append(ids, d.condID)
		}
	}
	if len(ids) == 0 {
		return nil
	}
	conds, err := s.LootConditions(ctx, loc, dedup(ids))
	if err != nil {
		return err
	}
	for i := range drops {
		if drops[i].condID == 0 {
			continue
		}
		if c, ok := conds[drops[i].condID]; ok {
			drops[i].Condition = c
		}
	}
	return nil
}

// ---------------------------------------------------------------------------
// Shared scanning
// ---------------------------------------------------------------------------

// scanLootItems reads one loot table's rows for one owner and expands whatever
// references it points at, so the caller gets items either way.
func (s *Store) scanLootItems(ctx context.Context, loc ContentLocale, table string, owner uint32) ([]ContentLootItem, error) {
	q, args := lootItemsQuery(table, owner)
	rows, err := s.World.QueryContext(ctx, q, args...)
	if err != nil {
		return nil, fmt.Errorf("%s for %d: %w", table, owner, err)
	}
	defer rows.Close()

	var out []ContentLootItem
	var refs []uint32
	var refGroups []uint8
	var refConds []uint32
	for rows.Next() {
		var item uint32
		var chance float64
		var mincountOrRef int32
		var maxcount uint32
		var group uint8
		var cond uint32
		if err := rows.Scan(&item, &chance, &mincountOrRef, &maxcount, &group, &cond); err != nil {
			return nil, fmt.Errorf("scan %s: %w", table, err)
		}
		if mincountOrRef < 0 {
			refs = append(refs, item)
			refGroups = append(refGroups, group)
			refConds = append(refConds, cond)
			continue
		}
		out = append(out, ContentLootItem{
			Entry:     item,
			Chance:    math.Abs(chance),
			MinCount:  uint32(mincountOrRef),
			MaxCount:  maxcount,
			QuestOnly: chance < 0,
			Group:     group,
			condID:    cond,
		})
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}

	// References are expanded after the direct rows so the page lists what the
	// owner drops itself first and the referenced tables below it.
	seen := map[uint32]bool{}
	for i, ref := range refs {
		if err := s.collectReferenceItems(ctx, ref, 100, 0, seen, &out, refGroups[i], refConds[i]); err != nil {
			return nil, err
		}
	}
	summarizeGroups(out)
	if err := s.attachConditions(ctx, loc, out); err != nil {
		return nil, err
	}
	return out, nil
}

// scanQuestRefs reads the quests a query returned together with the (id, count)
// slot pairs it selected, and keeps the pair that matched the item.
func scanQuestRefs(rows *sql.Rows, prefixes []string, slots int, item uint32) ([]ContentQuestRef, error) {
	const perPrefix = 2 // the id column and its count
	buf := make([]sql.NullInt64, len(prefixes)*slots*perPrefix)
	targets := make([]any, 0, len(buf)+2)
	for i := range buf {
		targets = append(targets, &buf[i])
	}

	var out []ContentQuestRef
	for rows.Next() {
		var ref ContentQuestRef
		row := append([]any{&ref.Entry, &ref.Title}, targets...)
		if err := rows.Scan(row...); err != nil {
			return nil, err
		}
		at := 0
		for _, prefix := range prefixes {
			choice := strings.HasPrefix(prefix, "RewChoice")
			for i := 0; i < slots; i++ {
				id, count := buf[at], buf[at+1]
				at += perPrefix
				if id.Valid && uint32(id.Int64) == item {
					ref.Choice = choice
					if count.Valid {
						ref.Count = uint16(count.Int64)
					}
				}
			}
		}
		out = append(out, ref)
	}
	return out, rows.Err()
}

// fillLootNames fills in the name and display id of the items a loot list holds.
func (s *Store) fillLootNames(ctx context.Context, loc ContentLocale, lists ...[]ContentLootItem) error {
	seen := map[uint32]bool{}
	var ids []uint32
	for _, list := range lists {
		for _, it := range list {
			if !seen[it.Entry] {
				seen[it.Entry] = true
				ids = append(ids, it.Entry)
			}
		}
	}
	if len(ids) == 0 {
		return nil
	}

	briefs, err := s.itemBriefs(ctx, loc, ids)
	if err != nil {
		return err
	}
	for _, list := range lists {
		for i := range list {
			list[i].Name = briefs[list[i].Entry].Name
			list[i].DisplayID = briefs[list[i].Entry].DisplayID
		}
	}
	return nil
}

// ---------------------------------------------------------------------------
// Disenchanting
// ---------------------------------------------------------------------------

// ItemDisenchant lists what an item breaks into for an enchanter.
//
// The items come from disenchant_loot_template, keyed by the item's own
// disenchant_id - the table's comment recommends item_level*100+quality, but the
// data and the core both use the column (LootTemplates_Disenchant is filled with
// proto->DisenchantID). The table has the same shape as the other loot tables, so
// it goes through the same reader, references and all.
func (s *Store) ItemDisenchant(ctx context.Context, loc ContentLocale, disenchantID uint32) ([]ContentLootItem, error) {
	if disenchantID == 0 {
		return nil, nil
	}
	items, err := s.scanLootItems(ctx, loc, "disenchant_loot_template", disenchantID)
	if err != nil {
		return nil, err
	}
	if err := s.fillLootNames(ctx, loc, items); err != nil {
		return nil, err
	}
	return items, nil
}

// QuestTargetSpawn is one place a creature or object a quest asks for stands.
type QuestTargetSpawn struct {
	Entry        uint32
	Name         string
	IsGameObject bool
	Map          uint16
	X, Y, Z      float64
}

// targetSpawnLimit caps how many points a quest page plots. A quest that asks for
// a mob living all over a continent would otherwise return thousands.
const targetSpawnLimit = 200

// QuestTargetSpawns finds where the creatures and objects a quest asks for live.
//
// It is what makes a quest page show a map on a realm whose quests have no
// objective coordinates at all - this one has PointMapId = 0 on every quest - by
// answering the question a player actually has: where do I find these?
func (s *Store) QuestTargetSpawns(ctx context.Context, loc ContentLocale, creatures, objects []uint32) ([]QuestTargetSpawn, error) {
	var out []QuestTargetSpawn

	if len(creatures) > 0 {
		rows, err := s.World.QueryContext(ctx, targetSpawnQuery(loc, DropCreature, len(creatures)),
			append(spawnArgs(creatures), targetSpawnLimit)...)
		if err != nil {
			return nil, fmt.Errorf("quest target spawns: %w", err)
		}
		list, err := scanTargetSpawns(rows)
		rows.Close()
		if err != nil {
			return nil, err
		}
		out = append(out, list...)
	}

	if len(objects) > 0 {
		rows, err := s.World.QueryContext(ctx, targetSpawnQuery(loc, DropGameObject, len(objects)),
			append(spawnArgs(objects), targetSpawnLimit)...)
		if err != nil {
			return nil, fmt.Errorf("quest target object spawns: %w", err)
		}
		list, err := scanTargetSpawns(rows)
		rows.Close()
		if err != nil {
			return nil, err
		}
		for i := range list {
			list[i].IsGameObject = true
		}
		out = append(out, list...)
	}

	return out, nil
}

// targetSpawnQuery reads the spawn points of a set of creatures or gameobjects.
//
// The entry is selected from the *template's* own key column. The spawn table
// carries the template id in a column called `id` while the template tables are
// keyed by `entry`, so "c.id" asks a table for a column it does not have - which
// MySQL answers with "Unknown column 'c.id' in 'field list'" on the page.
func targetSpawnQuery(loc ContentLocale, kind DropKind, n int) string {
	if kind == DropGameObject {
		return "SELECT g.entry, " + loc.localized("lg", "g", "name") +
			", t.map, t.position_x, t.position_y, t.position_z" +
			" FROM gameobject t JOIN gameobject_template g ON g.entry = t.id" +
			loc.join("lg", "locales_gameobject", "entry", "g") +
			" WHERE t.id IN (" + placeholders(n) + ") ORDER BY t.id, t.guid LIMIT ?"
	}
	return "SELECT c.entry, " + loc.localized("lc", "c", "name") +
		", t.map, t.position_x, t.position_y, t.position_z" +
		" FROM creature t JOIN creature_template c ON c.entry = t.id" +
		loc.join("lc", "locales_creature", "entry", "c") +
		" WHERE t.id IN (" + placeholders(n) + ") ORDER BY t.id, t.guid LIMIT ?"
}

func spawnArgs(entries []uint32) []any {
	args := make([]any, 0, len(entries)+1)
	for _, entry := range entries {
		args = append(args, entry)
	}
	return args
}

// scanTargetSpawns reads the (id, name, map, x, y, z) shape the two queries share.
func scanTargetSpawns(rows *sql.Rows) ([]QuestTargetSpawn, error) {
	var out []QuestTargetSpawn
	for rows.Next() {
		var spawn QuestTargetSpawn
		if err := rows.Scan(&spawn.Entry, &spawn.Name, &spawn.Map,
			&spawn.X, &spawn.Y, &spawn.Z); err != nil {
			return nil, fmt.Errorf("scan target spawn: %w", err)
		}
		out = append(out, spawn)
	}
	return out, rows.Err()
}

// ---------------------------------------------------------------------------
// Item sets
// ---------------------------------------------------------------------------

// setLimit caps the pieces a set page lists. The largest set in this realm has 17.
const setLimit = 32

// ItemsInSet lists the items that carry a set id.
//
// This is the server's own view of a set: every item template stores the set it
// belongs to. The client also has a list of its own in ItemSet.dbc, and where the
// two disagree - this realm has eleven sets like that, where a custom item reuses
// an old set id - the server's is the one that matches what the item pages say.
func (s *Store) ItemsInSet(ctx context.Context, loc ContentLocale, setID uint32) ([]ContentItemCount, error) {
	rows, err := s.World.QueryContext(ctx,
		"SELECT entry FROM item_template WHERE set_id = ? ORDER BY entry LIMIT ?", setID, setLimit)
	if err != nil {
		return nil, fmt.Errorf("items in set %d: %w", setID, err)
	}
	defer rows.Close()

	var out []ContentItemCount
	for rows.Next() {
		piece := ContentItemCount{Count: 1}
		if err := rows.Scan(&piece.Entry); err != nil {
			return nil, fmt.Errorf("scan set piece: %w", err)
		}
		out = append(out, piece)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}

	// The names and display ids come from the same lookup the quest rewards use.
	groups := []*[]ContentItemCount{&out}
	for _, group := range groups {
		if err := s.fillItemNames(ctx, loc, *group); err != nil {
			return nil, err
		}
	}
	return out, nil
}

// ItemBriefs reads the name and display id of the given items. It is exported for
// the page that shows a set's pieces, which only has their ids.
func (s *Store) ItemBriefs(ctx context.Context, loc ContentLocale, ids []uint32) (map[uint32]ItemBrief, error) {
	return s.itemBriefs(ctx, loc, ids)
}

// ItemBrief is the name and display id of one item.
type ItemBrief = itemBrief

// ---------------------------------------------------------------------------
// Spawn points
// ---------------------------------------------------------------------------

// CreatureSpawn is one place a creature stands. The three coordinates are world
// coordinates on Map, which is what the client's zone boxes are in too.
type CreatureSpawn struct {
	Map     uint16
	X, Y, Z float64
}

// spawnLimit caps what a page draws. The busiest creature in this realm has 785
// spawns and a map with 785 dots says nothing, so the page draws the first ones
// and says how many it left out.
const spawnLimit = 200

// CreatureSpawns lists where a creature stands, and whether the list was cut.
//
// The lookup is an index read: the spawns table has a key on the creature id.
func (s *Store) CreatureSpawns(ctx context.Context, entry uint32) ([]CreatureSpawn, bool, error) {
	rows, err := s.World.QueryContext(ctx,
		"SELECT map, position_x, position_y, position_z FROM creature"+
			" WHERE id = ? ORDER BY guid LIMIT ?", entry, spawnLimit)
	if err != nil {
		return nil, false, fmt.Errorf("spawns of creature %d: %w", entry, err)
	}
	defer rows.Close()

	var out []CreatureSpawn
	for rows.Next() {
		var spawn CreatureSpawn
		if err := rows.Scan(&spawn.Map, &spawn.X, &spawn.Y, &spawn.Z); err != nil {
			return nil, false, fmt.Errorf("scan spawn: %w", err)
		}
		out = append(out, spawn)
	}
	if err := rows.Err(); err != nil {
		return nil, false, err
	}
	return out, len(out) >= spawnLimit, nil
}

// ---------------------------------------------------------------------------
// Loaders the pages call
// ---------------------------------------------------------------------------

// ItemRelations gathers every cross link the item page shows.
//
// The loot tables are the slow part by design: none of them is indexed by item
// - each primary key starts at the loot's owner - so each of these queries scans
// its table once. creature_loot_template is the only large one, at about 313k
// rows; the others are under twenty thousand.
func (s *Store) ItemRelations(ctx context.Context, loc ContentLocale, item uint32) (*ItemRelations, error) {
	refs, err := s.refsContaining(ctx, item)
	if err != nil {
		return nil, err
	}

	out := &ItemRelations{}
	for _, g := range []struct {
		table string
		into  *[]ContentDrop
		key   string
	}{
		{"creature_loot_template", &out.DroppedBy, "db.droppedBy"},
		{"gameobject_loot_template", &out.FoundIn, "db.foundIn"},
		{"item_loot_template", &out.ContainedIn, "db.containedIn"},
		{"skinning_loot_template", &out.SkinnedFrom, "db.skinnedFrom"},
		{"pickpocketing_loot_template", &out.PickpocketedFrom, "db.pickpocketedFrom"},
	} {
		list, err := s.loadLootSources(ctx, loc, g.table, item, refs)
		if err != nil {
			return nil, err
		}
		if len(list) >= relationLimit {
			out.Truncated = append(out.Truncated, g.key)
		}
		*g.into = list
	}

	for _, g := range []struct {
		prefixes []string
		slots    int
		into     *[]ContentQuestRef
	}{
		{questItemPrefixes("required"), 4, &out.RequiredBy},
		{questItemPrefixes("rewarded"), 4, &out.RewardedBy},
		{questItemPrefixes("choice"), 6, &out.RewardedBy},
	} {
		q, args := questItemQuery(loc, g.prefixes, g.slots, item)
		rows, err := s.World.QueryContext(ctx, q, args...)
		if err != nil {
			return nil, fmt.Errorf("quests for item %d: %w", item, err)
		}
		list, err := scanQuestRefs(rows, g.prefixes, g.slots, item)
		rows.Close()
		if err != nil {
			return nil, err
		}
		*g.into = append(*g.into, list...)
	}

	vq, vargs := vendorSellersQuery(loc, item)
	rows, err := s.World.QueryContext(ctx, vq, vargs...)
	if err != nil {
		return nil, fmt.Errorf("vendors for item %d: %w", item, err)
	}
	defer rows.Close()
	for rows.Next() {
		d := ContentDrop{Kind: DropCreature}
		if err := rows.Scan(&d.Entry, &d.Name); err != nil {
			return nil, fmt.Errorf("scan vendor: %w", err)
		}
		out.SoldBy = append(out.SoldBy, d)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	if len(out.SoldBy) >= relationLimit {
		out.Truncated = append(out.Truncated, "db.soldBy")
	}
	return out, nil
}

// loadLootSources reads one loot table for the item page and resolves whatever
// came through a reference into a chance for the item itself.
func (s *Store) loadLootSources(ctx context.Context, loc ContentLocale, table string, item uint32, refs []uint32) ([]ContentDrop, error) {
	q, args := lootSourceQuery(loc, table, item, refs)
	rows, err := s.World.QueryContext(ctx, q, args...)
	if err != nil {
		return nil, fmt.Errorf("%s for item %d: %w", table, item, err)
	}
	defer rows.Close()

	var out []ContentDrop
	var roots []uint32
	for rows.Next() {
		d := ContentDrop{Kind: lootOwners[table].kind}
		var chance float64
		var mincountOrRef int32
		var maxcount uint32
		var group uint8
		var cond uint32
		if err := rows.Scan(&d.Entry, &d.Name, &chance, &mincountOrRef, &maxcount, &d.Via, &group, &cond); err != nil {
			return nil, fmt.Errorf("scan %s: %w", table, err)
		}
		d.Chance = math.Abs(chance)
		d.QuestOnly = chance < 0
		d.Group, d.condID = group, cond
		if mincountOrRef > 0 {
			d.MinCount, d.MaxCount = uint32(mincountOrRef), maxcount
		} else {
			// d.Via already holds the reference entry. The counts and the real
			// chance belong to the item's own row inside it, resolved below.
			roots = append(roots, d.Via)
		}
		out = append(out, d)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	if len(roots) == 0 {
		return out, s.attachDropConditions(ctx, loc, out)
	}

	hits, err := s.refChainHits(ctx, item, roots)
	if err != nil {
		return nil, err
	}
	for i := range out {
		if out[i].Via == 0 {
			continue
		}
		hit, ok := hits[out[i].Via]
		if !ok || hit.chance == 0 {
			// The reference does not hold the item after all. Keeping the row
			// with the chance of the reference row is closer to the truth than
			// dropping it, and the page says where it came from.
			continue
		}
		out[i].Chance = out[i].Chance * hit.chance / 100
		out[i].MinCount, out[i].MaxCount = hit.min, hit.max
	}
	return out, s.attachDropConditions(ctx, loc, out)
}

// CreatureRelations gathers what one creature starts, ends, drops and sells.
func (s *Store) CreatureRelations(ctx context.Context, loc ContentLocale, creature uint32) (*CreatureRelations, error) {
	out := &CreatureRelations{}

	for _, g := range []struct {
		table string
		into  *[]ContentQuestRef
		key   string
	}{
		{"creature_questrelation", &out.StartsQuests, "db.startsQuests"},
		{"creature_involvedrelation", &out.EndsQuests, "db.endsQuests"},
	} {
		q, args := questsOfActorQuery(loc, g.table, creature)
		rows, err := s.World.QueryContext(ctx, q, args...)
		if err != nil {
			return nil, fmt.Errorf("%s for %d: %w", g.table, creature, err)
		}
		list, err := scanQuestRefs(rows, nil, 0, 0)
		rows.Close()
		if err != nil {
			return nil, err
		}
		if len(list) >= relationLimit {
			out.Truncated = append(out.Truncated, g.key)
		}
		*g.into = list
	}

	// The loot tables are keyed by the creature's loot ids, which are separate
	// columns and are not the creature's own entry, so they have to be read
	// first. A zero means the creature has no loot of that kind.
	ids, err := s.creatureLootIDs(ctx, creature)
	if err != nil {
		return nil, err
	}
	for _, g := range []struct {
		table string
		id    uint32
		into  *[]ContentLootItem
	}{
		{"creature_loot_template", ids.loot, &out.Drops},
		{"skinning_loot_template", ids.skinning, &out.Skins},
		{"pickpocketing_loot_template", ids.pickpocket, &out.Pickpockets},
	} {
		if g.id == 0 {
			continue
		}
		list, err := s.scanLootItems(ctx, loc, g.table, g.id)
		if err != nil {
			return nil, err
		}
		*g.into = list
	}

	vq, vargs := vendorItemsQuery(creature)
	rows, err := s.World.QueryContext(ctx, vq, vargs...)
	if err != nil {
		return nil, fmt.Errorf("vendor %d: %w", creature, err)
	}
	var sold []ContentLootItem
	for rows.Next() {
		it := ContentLootItem{Chance: 100}
		if err := rows.Scan(&it.Entry); err != nil {
			rows.Close()
			return nil, fmt.Errorf("scan vendor %d: %w", creature, err)
		}
		sold = append(sold, it)
	}
	err = rows.Err()
	rows.Close()
	if err != nil {
		return nil, err
	}
	if len(sold) >= relationLimit {
		out.Truncated = append(out.Truncated, "db.sells")
	}
	out.Sells = sold

	if err := s.fillLootNames(ctx, loc, out.Drops, out.Skins, out.Pickpockets, out.Sells); err != nil {
		return nil, err
	}
	return out, nil
}

// creatureLootIDs are the three columns a creature points at its loot tables
// with. Each is independent: a creature can have corpse loot and no skinning
// loot, or the other way round.
type creatureLootIDs struct {
	loot       uint32
	skinning   uint32
	pickpocket uint32
}

// creatureLootIDs reads the loot ids of one creature. It is a separate query
// because ContentCreature does not carry them: they are only needed on the page
// that shows the loot.
func (s *Store) creatureLootIDs(ctx context.Context, creature uint32) (creatureLootIDs, error) {
	var ids creatureLootIDs
	err := s.World.QueryRowContext(ctx,
		"SELECT loot_id, skinning_loot_id, pickpocket_loot_id FROM creature_template WHERE entry = ?",
		creature).Scan(&ids.loot, &ids.skinning, &ids.pickpocket)
	if errors.Is(err, sql.ErrNoRows) {
		return creatureLootIDs{}, nil
	}
	if err != nil {
		return creatureLootIDs{}, fmt.Errorf("loot ids of creature %d: %w", creature, err)
	}
	return ids, nil
}

// QuestRelations gathers who hands a quest out and who takes it back.
func (s *Store) QuestRelations(ctx context.Context, loc ContentLocale, quest uint32) (*QuestRelations, error) {
	out := &QuestRelations{}
	for _, g := range []struct {
		table string
		kind  DropKind
		into  *[]ContentSourceRef
	}{
		{"creature_questrelation", DropCreature, &out.Starts},
		{"gameobject_questrelation", DropGameObject, &out.Starts},
		{"creature_involvedrelation", DropCreature, &out.Ends},
		{"gameobject_involvedrelation", DropGameObject, &out.Ends},
	} {
		q, args := questActorQuery(loc, g.table, g.kind, quest)
		rows, err := s.World.QueryContext(ctx, q, args...)
		if err != nil {
			return nil, fmt.Errorf("%s for quest %d: %w", g.table, quest, err)
		}
		for rows.Next() {
			ref := ContentSourceRef{Kind: g.kind}
			if err := rows.Scan(&ref.Entry, &ref.Name); err != nil {
				rows.Close()
				return nil, fmt.Errorf("scan %s: %w", g.table, err)
			}
			*g.into = append(*g.into, ref)
		}
		err = rows.Err()
		rows.Close()
		if err != nil {
			return nil, err
		}
	}
	return out, nil
}

// ---------------------------------------------------------------------------
// Quest chains
//
// A quest page answers two different "what comes before and after" questions, and
// the core keeps the answers in two different sets of columns. They never hold the
// same value: of the 990 quests here that set both, not one sets them to the same
// quest, because they mean different things.
//
//	NextQuestInChain  the storyline. A quest names the next one, and the core also
//	                  reads the link backwards - ObjectMgr.cpp pushes a quest into
//	                  its successor's `prevChainQuests` - and refuses to hand out a
//	                  step while its successor is already in the log
//	                  (Player::SatisfyQuestNextChain / SatisfyQuestPrevChain). This
//	                  is the chain a player means by "the quest line".
//
//	PrevQuestId       a hard requirement, and it is stored on either end. A quest's
//	NextQuestId       own PrevQuestId names what it needs; a quest's NextQuestId
//	                  makes *it* something the named quest needs (ObjectMgr.cpp
//	                  pushes it into that quest's `prevQuests`). The sign says
//	                  which: positive means the named quest has to be rewarded,
//	                  negative means it only has to be in the log, not finished
//	                  (Player::SatisfyQuestPreviousQuest). Reading only this quest's
//	                  own column loses every requirement stored on the other end.
//
//	ExclusiveGroup    quests one character cannot all do: a group id of 0 is "no
//	                  group", a positive one is "pick one of them", a negative one
//	                  is "all of them" (the same function as above).

// questChainLimit bounds a walk. The longest chain in this realm is 15 steps;
// this only has to be a number that cannot be reached by data with a loop in it.
const questChainLimit = 40

// QuestChainStep is one quest of a storyline, in reading order.
type QuestChainStep struct {
	Entry uint32
	Title string
	// Current marks the quest the page is about.
	Current bool
	// Alternate marks a step that is one of several ways into the quest after it:
	// two quests can both chain into the same next one, and the line follows the
	// one that has steps of its own in front of it.
	Alternate bool
}

// QuestRequirement is a quest on one side of this one, with what the sign of the
// link means: Finished says the quest has to be rewarded rather than merely
// started.
type QuestRequirement struct {
	Entry    uint32
	Title    string
	Finished bool
}

// QuestChain is everything the quest page shows about the quests around this one.
type QuestChain struct {
	Steps    []QuestChainStep
	Requires []QuestRequirement
	Unlocks  []QuestRequirement
	Group    []QuestChainStep
	// GroupAll is true for a negative group id: every quest in the group is needed
	// rather than one of them.
	GroupAll bool
}

// questChainNextQuery reads the storyline link of one quest.
func questChainNextQuery() string {
	return "SELECT NextQuestInChain FROM quest_template WHERE entry = ?"
}

// questChainPrevQuery reads the quests that chain into one, which can be more
// than one.
func questChainPrevQuery(loc ContentLocale) string {
	return "SELECT q.entry, " + loc.localized("cl", "q", "Title") +
		" FROM quest_template q" + loc.join("cl", "locales_quest", "entry", "q") +
		" WHERE q.NextQuestInChain = ? ORDER BY q.entry"
}

// questOwnLinksQuery reads this quest's own chain columns.
func questOwnLinksQuery() string {
	return "SELECT PrevQuestId, NextQuestId, ExclusiveGroup FROM quest_template WHERE entry = ?"
}

// questLinkQuery reads every quest joined to this one by a hard requirement, from
// either end and in either direction: the sign of each link says which way round
// it is.
func questLinkQuery(loc ContentLocale) string {
	return "SELECT q.entry, " + loc.localized("cl", "q", "Title") + ", q.PrevQuestId, q.NextQuestId" +
		" FROM quest_template q" + loc.join("cl", "locales_quest", "entry", "q") +
		" WHERE q.PrevQuestId IN (?, ?) OR q.NextQuestId IN (?, ?) ORDER BY q.entry"
}

// questGroupQuery reads the other quests of this one's exclusive group, and the
// group id itself so the page can say which kind of group it is.
func questGroupQuery(loc ContentLocale) string {
	return "SELECT o.entry, " + loc.localized("cl", "o", "Title") + ", g.ExclusiveGroup" +
		" FROM quest_template q" +
		" JOIN quest_template o ON o.ExclusiveGroup = q.ExclusiveGroup" +
		" JOIN quest_template g ON g.entry = q.entry" +
		loc.join("cl", "locales_quest", "entry", "o") +
		" WHERE q.entry = ? AND o.entry <> ? AND q.ExclusiveGroup <> 0 ORDER BY o.entry"
}

// questTitlesQuery reads several quest titles at once.
func questTitlesQuery(loc ContentLocale, n int) string {
	return "SELECT q.entry, " + loc.localized("cl", "q", "Title") +
		" FROM quest_template q" + loc.join("cl", "locales_quest", "entry", "q") +
		" WHERE q.entry IN (" + strings.TrimSuffix(strings.Repeat("?,", n), ",") + ")"
}

// questOwnLinks is this quest's own chain columns.
type questOwnLinks struct {
	prev  int32
	next  int32
	group int32
}

// questLinkRow is one row of questLinkQuery.
type questLinkRow struct {
	Entry       uint32
	Title       string
	PrevQuestID int32
	NextQuestID int32
}

// questWalker reads the two directions of the storyline. It is a pair of
// functions rather than a store method so the walk below can be tested on a
// fixed set of links, which is where the ordering rules live.
type questWalker struct {
	next   func(uint32) (uint32, error)
	prevs  func(uint32) ([]QuestChainStep, error)
	titles func([]uint32) (map[uint32]string, error)
}

// QuestChain gathers the storyline a quest belongs to, what it needs, what it
// opens up, and the quests it excludes.
func (s *Store) QuestChain(ctx context.Context, loc ContentLocale, quest uint32) (*QuestChain, error) {
	out := &QuestChain{}

	var own questOwnLinks
	err := s.World.QueryRowContext(ctx, questOwnLinksQuery(), quest).
		Scan(&own.prev, &own.next, &own.group)
	if errors.Is(err, sql.ErrNoRows) {
		return out, nil
	}
	if err != nil {
		return nil, fmt.Errorf("quest %d links: %w", quest, err)
	}

	links, err := s.questLinkRows(ctx, loc, quest)
	if err != nil {
		return nil, err
	}

	// Titles for the two quests this one names itself. The data stores a link on
	// one end only, so the other end is not necessarily in the rows above and has
	// to be looked up.
	titles, err := s.questTitles(ctx, loc, ownNames(own))
	if err != nil {
		return nil, err
	}

	out.Requires, out.Unlocks = questRequirementLists(quest, own, links, titles)

	if own.group != 0 {
		out.Group, err = s.questGroup(ctx, loc, quest)
		if err != nil {
			return nil, err
		}
		out.GroupAll = own.group < 0
	}

	out.Steps, err = chainSteps(quest, questWalker{
		next: func(entry uint32) (uint32, error) {
			var next uint32
			err := s.World.QueryRowContext(ctx, questChainNextQuery(), entry).Scan(&next)
			if errors.Is(err, sql.ErrNoRows) {
				return 0, nil
			}
			if err != nil {
				return 0, fmt.Errorf("quest %d next in chain: %w", entry, err)
			}
			return next, nil
		},
		prevs: func(entry uint32) ([]QuestChainStep, error) {
			return s.questChainPredecessors(ctx, loc, entry)
		},
		titles: func(entries []uint32) (map[uint32]string, error) {
			return s.questTitles(ctx, loc, entries)
		},
	})
	if err != nil {
		return nil, err
	}
	return out, nil
}

// questRequirementLists sorts the hard requirement links into the two lists the
// page prints, reading the sign the way the core does: a positive link means the
// named quest has to be finished, a negative one that it only has to be in the
// log (Player::SatisfyQuestPreviousQuest).
func questRequirementLists(quest uint32, own questOwnLinks, links []questLinkRow, titles map[uint32]string) (requires, unlocks []QuestRequirement) {
	entry := int32(quest)
	if own.prev != 0 {
		id := uint32(absInt32(own.prev))
		requires = append(requires, QuestRequirement{Entry: id, Title: titles[id], Finished: own.prev > 0})
	}
	if own.next != 0 {
		id := uint32(absInt32(own.next))
		unlocks = append(unlocks, QuestRequirement{Entry: id, Title: titles[id], Finished: own.next > 0})
	}

	for _, l := range links {
		// This quest's PrevQuestId names what it needs; another quest's NextQuestId
		// is that quest naming this one as what *it* needs, which is stored on the
		// other end and reads the same way.
		switch l.PrevQuestID {
		case entry:
			unlocks = append(unlocks, QuestRequirement{Entry: l.Entry, Title: l.Title, Finished: true})
		case -entry:
			unlocks = append(unlocks, QuestRequirement{Entry: l.Entry, Title: l.Title})
		}
		switch l.NextQuestID {
		case entry:
			requires = append(requires, QuestRequirement{Entry: l.Entry, Title: l.Title, Finished: true})
		case -entry:
			requires = append(requires, QuestRequirement{Entry: l.Entry, Title: l.Title})
		}
	}
	return dedupeRequirements(requires), dedupeRequirements(unlocks)
}

// ownNames lists the quests this one names itself, for the title lookup.
func ownNames(own questOwnLinks) []uint32 {
	var out []uint32
	for _, id := range []int32{own.prev, own.next} {
		if id != 0 {
			out = append(out, uint32(absInt32(id)))
		}
	}
	return out
}

// chainSteps walks the storyline both ways from the quest.
//
// Forward is straight: NextQuestInChain names one quest. Backward a quest can
// have several predecessors, and then the line follows the one that has steps of
// its own in front of it - the others are ways into the same quest rather than
// the trunk - and those are kept in the list, marked as alternates, instead of
// being dropped.
func chainSteps(quest uint32, walk questWalker) ([]QuestChainStep, error) {
	// Forward first, collecting entries only: the titles of the whole line are
	// then one query instead of one per step.
	var forward []uint32
	cur := quest
	for i := 0; i < questChainLimit; i++ {
		next, err := walk.next(cur)
		if err != nil {
			return nil, err
		}
		if next == 0 {
			break
		}
		forward = append(forward, next)
		cur = next
	}

	names, err := walk.titles(append([]uint32{quest}, forward...))
	if err != nil {
		return nil, err
	}
	steps := make([]QuestChainStep, 0, len(forward))
	for _, entry := range forward {
		steps = append(steps, QuestChainStep{Entry: entry, Title: names[entry]})
	}

	back := []QuestChainStep{{Entry: quest, Title: names[quest]}}
	cur = quest
	for i := 0; i < questChainLimit; i++ {
		prevs, err := walk.prevs(cur)
		if err != nil {
			return nil, err
		}
		if len(prevs) == 0 {
			break
		}
		main, rest := prevs[0], prevs[1:]
		if len(prevs) > 1 {
			main, rest = pickChainTrunk(walk, prevs)
		}
		// An alternate leads into the same quest as the trunk step that follows
		// it, so it is collected between the trunk step and that quest.
		for _, alt := range rest {
			back = append(back, QuestChainStep{Entry: alt.Entry, Title: alt.Title, Alternate: true})
		}
		back = append(back, QuestChainStep{Entry: main.Entry, Title: main.Title})
		cur = main.Entry
	}

	// back was collected outwards from the quest, so it reads the other way round
	// once reversed - and there the alternate sits just before the trunk step it
	// leads into, which is where it was collected.
	prefix := make([]QuestChainStep, 0, len(back))
	for i := len(back) - 1; i >= 0; i-- {
		step := back[i]
		step.Current = step.Entry == quest
		prefix = append(prefix, step)
	}
	return append(prefix, steps...), nil
}

// pickChainTrunk chooses which of several predecessors continues the line: the
// lowest entry that has a predecessor of its own, and the lowest entry when none
// of them does.
func pickChainTrunk(walk questWalker, prevs []QuestChainStep) (QuestChainStep, []QuestChainStep) {
	rest := func(chosen uint32) []QuestChainStep {
		out := make([]QuestChainStep, 0, len(prevs)-1)
		for _, other := range prevs {
			if other.Entry != chosen {
				out = append(out, other)
			}
		}
		return out
	}
	for _, cand := range prevs {
		earlier, err := walk.prevs(cand.Entry)
		if err == nil && len(earlier) > 0 {
			return cand, rest(cand.Entry)
		}
	}
	return prevs[0], rest(prevs[0].Entry)
}

// questLinkRows reads every quest joined to this one by a hard requirement, from
// either end and in either direction.
func (s *Store) questLinkRows(ctx context.Context, loc ContentLocale, quest uint32) ([]questLinkRow, error) {
	id := int64(quest)
	rows, err := s.World.QueryContext(ctx, questLinkQuery(loc), id, -id, id, -id)
	if err != nil {
		return nil, fmt.Errorf("quest %d requirement links: %w", quest, err)
	}
	defer rows.Close()
	var out []questLinkRow
	for rows.Next() {
		var r questLinkRow
		if err := rows.Scan(&r.Entry, &r.Title, &r.PrevQuestID, &r.NextQuestID); err != nil {
			return nil, fmt.Errorf("scan quest requirement links: %w", err)
		}
		out = append(out, r)
	}
	return out, rows.Err()
}

func (s *Store) questGroup(ctx context.Context, loc ContentLocale, quest uint32) ([]QuestChainStep, error) {
	rows, err := s.World.QueryContext(ctx, questGroupQuery(loc), quest, quest)
	if err != nil {
		return nil, fmt.Errorf("quest %d exclusive group: %w", quest, err)
	}
	defer rows.Close()
	var out []QuestChainStep
	for rows.Next() {
		var step QuestChainStep
		var group int32
		if err := rows.Scan(&step.Entry, &step.Title, &group); err != nil {
			return nil, fmt.Errorf("scan quest group: %w", err)
		}
		out = append(out, step)
	}
	return out, rows.Err()
}

func (s *Store) questChainPredecessors(ctx context.Context, loc ContentLocale, quest uint32) ([]QuestChainStep, error) {
	rows, err := s.World.QueryContext(ctx, questChainPrevQuery(loc), quest)
	if err != nil {
		return nil, fmt.Errorf("quest %d previous in chain: %w", quest, err)
	}
	defer rows.Close()
	var out []QuestChainStep
	for rows.Next() {
		var step QuestChainStep
		if err := rows.Scan(&step.Entry, &step.Title); err != nil {
			return nil, fmt.Errorf("scan chain step: %w", err)
		}
		out = append(out, step)
	}
	return out, rows.Err()
}

// questTitles reads the titles of several quests at once.
func (s *Store) questTitles(ctx context.Context, loc ContentLocale, entries []uint32) (map[uint32]string, error) {
	out := map[uint32]string{}
	if len(entries) == 0 {
		return out, nil
	}
	args := make([]any, 0, len(entries))
	for _, entry := range entries {
		args = append(args, entry)
	}
	rows, err := s.World.QueryContext(ctx, questTitlesQuery(loc, len(entries)), args...)
	if err != nil {
		return nil, fmt.Errorf("quest titles %v: %w", entries, err)
	}
	defer rows.Close()
	for rows.Next() {
		var entry uint32
		var title string
		if err := rows.Scan(&entry, &title); err != nil {
			return nil, fmt.Errorf("scan quest title: %w", err)
		}
		out[entry] = title
	}
	return out, rows.Err()
}

// dedupeRequirements removes duplicates and orders by entry. A quest can be
// linked from both of its columns, in which case the stricter reading wins: a
// requirement to have finished it beats a requirement to have started it.
func dedupeRequirements(in []QuestRequirement) []QuestRequirement {
	out := in[:0]
	at := map[uint32]int{}
	for _, r := range in {
		if i, ok := at[r.Entry]; ok {
			if r.Finished {
				out[i].Finished = true
			}
			if out[i].Title == "" {
				out[i].Title = r.Title
			}
			continue
		}
		at[r.Entry] = len(out)
		out = append(out, r)
	}
	sort.Slice(out, func(i, j int) bool { return out[i].Entry < out[j].Entry })
	return out
}

func absInt32(v int32) int32 {
	if v < 0 {
		return -v
	}
	return v
}
