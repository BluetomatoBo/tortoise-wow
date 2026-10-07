package store

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"math"
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
// What the walks deliberately do not interpret is groupid and condition_id. The
// page reports the chance the row stores - the number a GM compares against -
// not the probability a particular character sees at the mob.

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
}

// ContentLootItem is one item something can drop.
type ContentLootItem struct {
	Entry     uint32
	Name      string
	Chance    float64 // percent
	MinCount  uint32
	MaxCount  uint32
	QuestOnly bool
	Via       uint32 // non-zero: reached through this reference_loot_template entry
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
	from, localeJoin, name, _ := lootSource(loc, own.kind)
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
	// t.item is selected too: on a reference row it holds the entry being
	// pointed at, which is what the chance has to be resolved against.
	q := "SELECT t.entry, " + name + ", t.ChanceOrQuestChance, t.mincountOrRef, t.maxcount, t.item" +
		" FROM " + table + " t" +
		ownerJoin(from, own.key, "t") + localeJoin +
		" WHERE " + where + extra + " ORDER BY t.entry, t.item LIMIT ?"
	return q, append(args, relationLimit)
}

// lootItemsQuery lists one loot table's rows for a single owner. The owner is
// the leading column of every loot table's primary key, so this is an index read
// even on creature_loot_template.
func lootItemsQuery(table string, owner uint32) (string, []any) {
	return "SELECT item, ChanceOrQuestChance, mincountOrRef, maxcount FROM " + table +
		" WHERE entry = ? ORDER BY item LIMIT ?", []any{owner, relationLimit}
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
	return "SELECT item, ChanceOrQuestChance, mincountOrRef, maxcount FROM reference_loot_template" +
		" WHERE entry = ?", []any{entry}
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
		if err := rows.Scan(&r.item, &r.chance, &r.mincountOrRef, &r.maxcount); err != nil {
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
func (s *Store) collectReferenceItems(ctx context.Context, ref uint32, factor float64, depth int, seen map[uint32]bool, out *[]ContentLootItem) error {
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
			})
			continue
		}
		if err := s.collectReferenceItems(ctx, r.item, chance, depth+1, seen, out); err != nil {
			return err
		}
	}
	return nil
}

// ---------------------------------------------------------------------------
// Shared scanning
// ---------------------------------------------------------------------------

// scanLootItems reads one loot table's rows for one owner and expands whatever
// references it points at, so the caller gets items either way.
func (s *Store) scanLootItems(ctx context.Context, table string, owner uint32) ([]ContentLootItem, error) {
	q, args := lootItemsQuery(table, owner)
	rows, err := s.World.QueryContext(ctx, q, args...)
	if err != nil {
		return nil, fmt.Errorf("%s for %d: %w", table, owner, err)
	}
	defer rows.Close()

	var out []ContentLootItem
	var refs []uint32
	for rows.Next() {
		var item uint32
		var chance float64
		var mincountOrRef int32
		var maxcount uint32
		if err := rows.Scan(&item, &chance, &mincountOrRef, &maxcount); err != nil {
			return nil, fmt.Errorf("scan %s: %w", table, err)
		}
		if mincountOrRef < 0 {
			refs = append(refs, item)
			continue
		}
		out = append(out, ContentLootItem{
			Entry:     item,
			Chance:    math.Abs(chance),
			MinCount:  uint32(mincountOrRef),
			MaxCount:  maxcount,
			QuestOnly: chance < 0,
		})
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}

	// References are expanded after the direct rows so the page lists what the
	// owner drops itself first and the referenced tables below it.
	seen := map[uint32]bool{}
	for _, ref := range refs {
		if err := s.collectReferenceItems(ctx, ref, 100, 0, seen, &out); err != nil {
			return nil, err
		}
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

// fillLootNames fills in the names of the items a loot list holds.
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

	names, err := s.itemNames(ctx, loc, ids)
	if err != nil {
		return err
	}
	for _, list := range lists {
		for i := range list {
			list[i].Name = names[list[i].Entry]
		}
	}
	return nil
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
		if err := rows.Scan(&d.Entry, &d.Name, &chance, &mincountOrRef, &maxcount, &d.Via); err != nil {
			return nil, fmt.Errorf("scan %s: %w", table, err)
		}
		d.Chance = math.Abs(chance)
		d.QuestOnly = chance < 0
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
		return out, nil
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
	return out, nil
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
		list, err := s.scanLootItems(ctx, g.table, g.id)
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
