package store

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"strconv"
	"strings"
)

// World content browsing: items, spells, quests and creatures.
//
// This reads the core's own content tables directly instead of copying AoWoW's
// schema (and its importer) into this service. The names and numbers players see
// are already in item_template, creature_template, quest_template,
// spell_template and the locales_* tables, and nothing here can drift away from
// them, because there is no second copy to keep in step. Everything is read-only.
//
// # Locale
//
// This realm keeps its Chinese text in the *_loc4 columns - the slot the core
// maps zhCN to, and the one sql/wip_updates/locales_*.sql fills and the shop
// module already reads. So a visitor reading the site in Chinese gets
// COALESCE(<column>_loc4, <base column>) and everyone else the base column.
// The suffix comes only from the constants below and never from a request, so it
// cannot be used to reach a column that was not meant to be visible.

// ContentPageSize is how many rows a browser page lists.
const ContentPageSize = 25

// contentSearchLimit caps each group of the unified search.
const contentSearchLimit = 10

// ContentLocale selects which translation columns a query reads.
type ContentLocale string

const (
	// ContentLocaleBase reads the table's own column.
	ContentLocaleBase ContentLocale = ""
	// ContentLocaleZH reads the *_loc4 columns.
	ContentLocaleZH ContentLocale = "loc4"
)

// column returns base with the locale suffix applied: "name" -> "name_loc4".
func (l ContentLocale) column(base string) string {
	if l == ContentLocaleBase {
		return base
	}
	return base + "_" + string(l)
}

// localized builds the expression a query shows: the locale column when there is
// one, falling back to the base column so an untranslated row still reads.
// localeAlias may be empty, in which case there is no join to read from.
func (l ContentLocale) localized(localeAlias, baseAlias, base string) string {
	if l == ContentLocaleBase || localeAlias == "" {
		return "COALESCE(" + baseAlias + "." + base + ", '')"
	}
	return "COALESCE(" + localeAlias + "." + l.column(base) + ", " + baseAlias + "." + base + ", '')"
}

// join returns the LEFT JOIN that brings the locale table in, or "" when the
// base columns are all that is read.
func (l ContentLocale) join(alias, table, key, baseAlias string) string {
	if l == ContentLocaleBase {
		return ""
	}
	return " LEFT JOIN " + table + " " + alias + " ON " + alias + "." + key + " = " + baseAlias + "." + key
}

// contentSearch builds the "does this row match the search box" clause: a LIKE
// over the shown name, the same LIKE over the untranslated name, and an exact
// entry match when the term is a number (which is how players paste an id).
func contentSearch(loc ContentLocale, localeAlias, baseAlias, base, term string) (string, []any) {
	if term == "" {
		return "", nil
	}
	like := "%" + term + "%"
	parts := []string{baseAlias + "." + base + " LIKE ?"}
	args := []any{like}
	if loc != ContentLocaleBase && localeAlias != "" {
		parts = append(parts, localeAlias+"."+loc.column(base)+" LIKE ?")
		args = append(args, like)
	}
	if entry, err := strconv.ParseUint(term, 10, 32); err == nil {
		parts = append(parts, baseAlias+".entry = ?")
		args = append(args, entry)
	}
	return "(" + strings.Join(parts, " OR ") + ")", args
}

// contentLimit returns the LIMIT/OFFSET pair every list query ends with.
func contentLimit(limit, offset int) (string, []any) {
	if limit <= 0 || limit > 200 {
		limit = ContentPageSize
	}
	if offset < 0 {
		offset = 0
	}
	return " LIMIT ? OFFSET ?", []any{limit, offset}
}

// ---------------------------------------------------------------------------
// Shared row pieces
// ---------------------------------------------------------------------------

// ContentItemStat is one "of the ..." line: a stat type and its value.
type ContentItemStat struct {
	Type  uint8
	Value int16
}

// ContentItemResistance is one non-zero resistance on an item.
type ContentItemResistance struct {
	School int
	Value  int16
}

// ContentItemSpell is one of the "use / equip / chance on hit" spells an item
// carries. Slot is the column number (1..3), which is what a GM greps for;
// Trigger is the ITEM_SPELLTRIGGER_* constant, and Charges is the stored charge
// count (negative means the charges are consumed).
type ContentItemSpell struct {
	Slot    int
	SpellID uint32
	Trigger uint8
	Charges int16
}

// ContentItemCount is an item plus how many of it a quest wants or gives.
type ContentItemCount struct {
	Entry uint32
	Count uint16
	Name  string
}

// ---------------------------------------------------------------------------
// Items
// ---------------------------------------------------------------------------

// ContentItem is one item_template row with the name the visitor should read.
type ContentItem struct {
	Entry         uint32
	Name          string
	Description   string
	Quality       uint8
	Class         uint8
	SubClass      uint8
	DisplayID     uint32
	ItemLevel     uint8
	RequiredLevel uint8
	InventoryType uint8
	BuyPrice      uint32
	SellPrice     uint32
	MaxCount      uint16
	Stackable     uint16
	Armor         int16
	Block         uint32
	Delay         uint16
	DamageMin     float64
	DamageMax     float64
	Bonding       uint8
	PageText      uint32
	StartQuest    uint32
	SetID         uint32
	Duration      uint32
	Flags         uint32

	Resistances []ContentItemResistance
	Stats       []ContentItemStat
	Spells      []ContentItemSpell

	// Fixed-width scan buffers. The tables store these as numbered columns
	// (stat_type1..10, spellid_1..3), which sql.Rows cannot scan into a slice, so
	// they are collected into the slices above after the scan.
	holyRes      int16
	fireRes      int16
	natureRes    int16
	frostRes     int16
	shadowRes    int16
	arcaneRes    int16
	statType     [10]int16
	statValue    [10]int16
	spellID      [3]uint32
	spellTrigger [3]int16
	spellCharges [3]int16
}

// ContentItemFilter narrows a list. A nil pointer means "no filter".
type ContentItemFilter struct {
	Search   string
	Quality  *uint8
	Class    *uint8
	MinLevel *uint8
	MaxLevel *uint8
	Limit    int
	Offset   int
}

// itemWhere builds the WHERE clause and its arguments.
func itemWhere(loc ContentLocale, f ContentItemFilter) (string, []any) {
	var where []string
	var args []any

	if clause, a := contentSearch(loc, "cl", "i", "name", f.Search); clause != "" {
		where = append(where, clause)
		args = append(args, a...)
	}
	if f.Quality != nil {
		where = append(where, "i.quality = ?")
		args = append(args, *f.Quality)
	}
	if f.Class != nil {
		where = append(where, "i.class = ?")
		args = append(args, *f.Class)
	}
	if f.MinLevel != nil {
		where = append(where, "i.item_level >= ?")
		args = append(args, *f.MinLevel)
	}
	if f.MaxLevel != nil {
		where = append(where, "i.item_level <= ?")
		args = append(args, *f.MaxLevel)
	}
	return contentWhere(where), args
}

func contentWhere(parts []string) string {
	if len(parts) == 0 {
		return ""
	}
	return " WHERE " + strings.Join(parts, " AND ")
}

// itemColumns is the SELECT list shared by the item list and detail queries.
// Keep it in step with ContentItem.scanTargets, which the unit test checks.
func itemColumns(loc ContentLocale) string {
	return "i.entry, " + loc.localized("cl", "i", "name") + ", " + loc.localized("cl", "i", "description") + `,
		i.quality, i.class, i.subclass, i.display_id, i.item_level, i.required_level,
		i.inventory_type, i.buy_price, i.sell_price, i.max_count, i.stackable,
		i.armor, i.block, i.delay, i.dmg_min1, i.dmg_max1,
		i.bonding, i.page_text, i.start_quest, i.set_id, i.duration, i.flags,
		i.holy_res, i.fire_res, i.nature_res, i.frost_res, i.shadow_res, i.arcane_res,
		i.stat_type1, i.stat_value1, i.stat_type2, i.stat_value2, i.stat_type3, i.stat_value3,
		i.stat_type4, i.stat_value4, i.stat_type5, i.stat_value5, i.stat_type6, i.stat_value6,
		i.stat_type7, i.stat_value7, i.stat_type8, i.stat_value8, i.stat_type9, i.stat_value9,
		i.stat_type10, i.stat_value10,
		i.spellid_1, i.spelltrigger_1, i.spellcharges_1,
		i.spellid_2, i.spelltrigger_2, i.spellcharges_2,
		i.spellid_3, i.spelltrigger_3, i.spellcharges_3`
}

func itemListQuery(loc ContentLocale, f ContentItemFilter) (string, []any) {
	where, args := itemWhere(loc, f)
	order := loc.localized("cl", "i", "name")
	limit, limitArgs := contentLimit(f.Limit, f.Offset)
	q := "SELECT " + itemColumns(loc) +
		" FROM item_template i" + loc.join("cl", "locales_item", "entry", "i") +
		where + " ORDER BY " + order + ", i.entry" + limit
	return q, append(args, limitArgs...)
}

func itemCountQuery(loc ContentLocale, f ContentItemFilter) (string, []any) {
	where, args := itemWhere(loc, f)
	return "SELECT COUNT(*) FROM item_template i" +
		loc.join("cl", "locales_item", "entry", "i") + where, args
}

func itemDetailQuery(loc ContentLocale) string {
	return "SELECT " + itemColumns(loc) +
		" FROM item_template i" + loc.join("cl", "locales_item", "entry", "i") +
		" WHERE i.entry = ?"
}

// scanTargets lists the destinations of itemColumns in the same order, so the
// two can only be changed together.
func (it *ContentItem) scanTargets() []any {
	return []any{
		&it.Entry, &it.Name, &it.Description,
		&it.Quality, &it.Class, &it.SubClass, &it.DisplayID, &it.ItemLevel, &it.RequiredLevel,
		&it.InventoryType, &it.BuyPrice, &it.SellPrice, &it.MaxCount, &it.Stackable,
		&it.Armor, &it.Block, &it.Delay, &it.DamageMin, &it.DamageMax,
		&it.Bonding, &it.PageText, &it.StartQuest, &it.SetID, &it.Duration, &it.Flags,
		&it.holyRes, &it.fireRes, &it.natureRes, &it.frostRes, &it.shadowRes, &it.arcaneRes,
		&it.statType[0], &it.statValue[0], &it.statType[1], &it.statValue[1],
		&it.statType[2], &it.statValue[2], &it.statType[3], &it.statValue[3],
		&it.statType[4], &it.statValue[4], &it.statType[5], &it.statValue[5],
		&it.statType[6], &it.statValue[6], &it.statType[7], &it.statValue[7],
		&it.statType[8], &it.statValue[8], &it.statType[9], &it.statValue[9],
		&it.spellID[0], &it.spellTrigger[0], &it.spellCharges[0],
		&it.spellID[1], &it.spellTrigger[1], &it.spellCharges[1],
		&it.spellID[2], &it.spellTrigger[2], &it.spellCharges[2],
	}
}

// collect turns the fixed-width scan buffers into the slices a template ranges
// over, dropping the empty entries.
func (it *ContentItem) collect() {
	for i, res := range [6]int16{it.holyRes, it.fireRes, it.natureRes, it.frostRes, it.shadowRes, it.arcaneRes} {
		if res != 0 {
			it.Resistances = append(it.Resistances, ContentItemResistance{School: i, Value: res})
		}
	}
	for i := range it.statType {
		if it.statType[i] != 0 {
			it.Stats = append(it.Stats, ContentItemStat{Type: uint8(it.statType[i]), Value: it.statValue[i]})
		}
	}
	for i := range it.spellID {
		if it.spellID[i] != 0 {
			it.Spells = append(it.Spells, ContentItemSpell{
				Slot: i + 1, SpellID: it.spellID[i], Trigger: uint8(it.spellTrigger[i]), Charges: it.spellCharges[i],
			})
		}
	}
}

// ContentItems lists items matching the filter, with the total number of matches
// for paging.
func (s *Store) ContentItems(ctx context.Context, loc ContentLocale, f ContentItemFilter) ([]ContentItem, int, error) {
	countQ, countArgs := itemCountQuery(loc, f)
	var total int
	if err := s.World.QueryRowContext(ctx, countQ, countArgs...).Scan(&total); err != nil {
		return nil, 0, fmt.Errorf("count items: %w", err)
	}

	listQ, listArgs := itemListQuery(loc, f)
	rows, err := s.World.QueryContext(ctx, listQ, listArgs...)
	if err != nil {
		return nil, 0, fmt.Errorf("list items: %w", err)
	}
	defer rows.Close()

	var out []ContentItem
	for rows.Next() {
		var it ContentItem
		if err := rows.Scan(it.scanTargets()...); err != nil {
			return nil, 0, fmt.Errorf("scan item: %w", err)
		}
		it.collect()
		out = append(out, it)
	}
	return out, total, rows.Err()
}

// ContentItem loads one item.
func (s *Store) ContentItem(ctx context.Context, loc ContentLocale, entry uint32) (*ContentItem, error) {
	q := itemDetailQuery(loc)
	var it ContentItem
	if err := s.World.QueryRowContext(ctx, q, entry).Scan(it.scanTargets()...); err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, ErrNotFound
		}
		return nil, fmt.Errorf("item %d: %w", entry, err)
	}
	it.collect()
	return &it, nil
}

// ---------------------------------------------------------------------------
// Spells
// ---------------------------------------------------------------------------

// ContentSpell is one spell_template row.
type ContentSpell struct {
	Entry              uint32
	Name               string
	NameSubtext        string
	Description        string
	AuraDescription    string
	School             uint32
	SpellLevel         uint32
	BaseLevel          uint32
	MaxLevel           uint32
	ManaCost           uint32
	ManaCostPercentage uint32
	CastingTimeIndex   uint32
	DurationIndex      uint32
	RangeIndex         uint32
	PowerType          uint32
	ProcChance         uint32
	StackAmount        uint32
	SpellIconID        uint32
	SpellFamilyName    uint32
	CustomFlags        uint32

	Effects []ContentSpellEffect

	// Fixed-width scan buffers; see ContentItem.
	effect       [3]uint32
	basePoints   [3]int32
	dieSides     [3]uint32
	auraName     [3]uint32
	miscValue    [3]int32
	triggerSpell [3]uint32
}

// ContentSpellEffect is one of the three effect slots.
type ContentSpellEffect struct {
	Slot         int
	Effect       uint32
	BasePoints   int32
	DieSides     uint32
	AuraName     uint32
	MiscValue    int32
	TriggerSpell uint32
}

// ContentSpellFilter narrows a spell list.
type ContentSpellFilter struct {
	Search   string
	School   *uint8
	MinLevel *uint8
	MaxLevel *uint8
	Limit    int
	Offset   int
}

func spellWhere(loc ContentLocale, f ContentSpellFilter) (string, []any) {
	var where []string
	var args []any
	if clause, a := contentSearch(loc, "cl", "s", "name", f.Search); clause != "" {
		where = append(where, clause)
		args = append(args, a...)
	}
	if f.School != nil {
		where = append(where, "s.school = ?")
		args = append(args, *f.School)
	}
	if f.MinLevel != nil {
		where = append(where, "s.spellLevel >= ?")
		args = append(args, *f.MinLevel)
	}
	if f.MaxLevel != nil {
		where = append(where, "s.spellLevel <= ?")
		args = append(args, *f.MaxLevel)
	}
	return contentWhere(where), args
}

func spellColumns(loc ContentLocale) string {
	return "s.entry, " + loc.localized("cl", "s", "name") + ", " + loc.localized("cl", "s", "nameSubtext") + ", " +
		loc.localized("cl", "s", "description") + ", " + loc.localized("cl", "s", "auraDescription") + `,
		s.school, s.spellLevel, s.baseLevel, s.maxLevel, s.manaCost, s.manaCostPercentage,
		s.castingTimeIndex, s.durationIndex, s.rangeIndex, s.powerType,
		s.procChance, s.stackAmount, s.spellIconId, s.spellFamilyName, s.customFlags,
		s.effect1, s.effectBasePoints1, s.effectDieSides1, s.effectApplyAuraName1, s.effectMiscValue1, s.effectTriggerSpell1,
		s.effect2, s.effectBasePoints2, s.effectDieSides2, s.effectApplyAuraName2, s.effectMiscValue2, s.effectTriggerSpell2,
		s.effect3, s.effectBasePoints3, s.effectDieSides3, s.effectApplyAuraName3, s.effectMiscValue3, s.effectTriggerSpell3`
}

func spellListQuery(loc ContentLocale, f ContentSpellFilter) (string, []any) {
	where, args := spellWhere(loc, f)
	order := loc.localized("cl", "s", "name")
	limit, limitArgs := contentLimit(f.Limit, f.Offset)
	q := "SELECT " + spellColumns(loc) +
		" FROM spell_template s" + loc.join("cl", "locales_spell", "entry", "s") +
		where + " ORDER BY " + order + ", s.entry" + limit
	return q, append(args, limitArgs...)
}

func spellCountQuery(loc ContentLocale, f ContentSpellFilter) (string, []any) {
	where, args := spellWhere(loc, f)
	return "SELECT COUNT(*) FROM spell_template s" +
		loc.join("cl", "locales_spell", "entry", "s") + where, args
}

func spellDetailQuery(loc ContentLocale) string {
	return "SELECT " + spellColumns(loc) +
		" FROM spell_template s" + loc.join("cl", "locales_spell", "entry", "s") +
		" WHERE s.entry = ?"
}

func (sp *ContentSpell) scanTargets() []any {
	return []any{
		&sp.Entry, &sp.Name, &sp.NameSubtext, &sp.Description, &sp.AuraDescription,
		&sp.School, &sp.SpellLevel, &sp.BaseLevel, &sp.MaxLevel, &sp.ManaCost, &sp.ManaCostPercentage,
		&sp.CastingTimeIndex, &sp.DurationIndex, &sp.RangeIndex, &sp.PowerType,
		&sp.ProcChance, &sp.StackAmount, &sp.SpellIconID, &sp.SpellFamilyName, &sp.CustomFlags,
		&sp.effect[0], &sp.basePoints[0], &sp.dieSides[0], &sp.auraName[0], &sp.miscValue[0], &sp.triggerSpell[0],
		&sp.effect[1], &sp.basePoints[1], &sp.dieSides[1], &sp.auraName[1], &sp.miscValue[1], &sp.triggerSpell[1],
		&sp.effect[2], &sp.basePoints[2], &sp.dieSides[2], &sp.auraName[2], &sp.miscValue[2], &sp.triggerSpell[2],
	}
}

func (sp *ContentSpell) collect() {
	for i := range sp.effect {
		if sp.effect[i] == 0 {
			continue
		}
		sp.Effects = append(sp.Effects, ContentSpellEffect{
			Slot: i + 1, Effect: sp.effect[i], BasePoints: sp.basePoints[i], DieSides: sp.dieSides[i],
			AuraName: sp.auraName[i], MiscValue: sp.miscValue[i], TriggerSpell: sp.triggerSpell[i],
		})
	}
}

// ContentSpells lists spells matching the filter.
func (s *Store) ContentSpells(ctx context.Context, loc ContentLocale, f ContentSpellFilter) ([]ContentSpell, int, error) {
	countQ, countArgs := spellCountQuery(loc, f)
	var total int
	if err := s.World.QueryRowContext(ctx, countQ, countArgs...).Scan(&total); err != nil {
		return nil, 0, fmt.Errorf("count spells: %w", err)
	}

	listQ, listArgs := spellListQuery(loc, f)
	rows, err := s.World.QueryContext(ctx, listQ, listArgs...)
	if err != nil {
		return nil, 0, fmt.Errorf("list spells: %w", err)
	}
	defer rows.Close()

	var out []ContentSpell
	for rows.Next() {
		var sp ContentSpell
		if err := rows.Scan(sp.scanTargets()...); err != nil {
			return nil, 0, fmt.Errorf("scan spell: %w", err)
		}
		sp.collect()
		out = append(out, sp)
	}
	return out, total, rows.Err()
}

// ContentSpell loads one spell.
func (s *Store) ContentSpell(ctx context.Context, loc ContentLocale, entry uint32) (*ContentSpell, error) {
	q := spellDetailQuery(loc)
	var sp ContentSpell
	if err := s.World.QueryRowContext(ctx, q, entry).Scan(sp.scanTargets()...); err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, ErrNotFound
		}
		return nil, fmt.Errorf("spell %d: %w", entry, err)
	}
	sp.collect()
	return &sp, nil
}

// ---------------------------------------------------------------------------
// Quests
// ---------------------------------------------------------------------------

// ContentQuest is one quest_template row.
type ContentQuest struct {
	Entry            uint32
	Title            string
	Details          string
	Objectives       string
	OfferRewardText  string
	RequestItemsText string
	EndText          string
	ObjectiveText    []string

	MinLevel         uint8
	MaxLevel         uint8
	QuestLevel       uint8
	Type             uint16
	ZoneOrSort       int16
	SuggestedPlayers uint8
	QuestFlags       uint16
	SpecialFlags     uint16
	PrevQuestID      int32
	NextQuestID      int32

	RewXP            uint32
	RewOrReqMoney    int32
	RewMoneyMaxLevel uint32

	// Where the quest markers point on the map, when they do.
	PointMapID uint16
	PointX     float64
	PointY     float64

	RequiredItems   []ContentItemCount
	RewardItems     []ContentItemCount
	ChoiceItems     []ContentItemCount
	RequiredMobs    []ContentCreatureCount
	RequiredSources []ContentItemCount

	// Fixed-width scan buffers; see ContentItem.
	objectiveText  [4]string
	reqItemID      [4]uint32
	reqItemCount   [4]uint16
	reqSourceID    [4]uint32
	reqSourceCount [4]uint16
	reqMobID       [4]int32
	reqMobCount    [4]uint16
	rewItemID      [4]uint32
	rewItemCount   [4]uint16
	rewChoiceID    [6]uint32
	rewChoiceCount [6]uint16
}

// ContentCreatureCount is a creature or gameobject a quest asks for. Game
// objects are stored as the negative of their entry, which is how the core tells
// the two apart.
type ContentCreatureCount struct {
	Entry        uint32
	IsGameObject bool
	Count        uint16
}

// ContentQuestFilter narrows a quest list.
type ContentQuestFilter struct {
	Search   string
	MinLevel *uint8
	MaxLevel *uint8
	Limit    int
	Offset   int
}

func questWhere(loc ContentLocale, f ContentQuestFilter) (string, []any) {
	var where []string
	var args []any
	if clause, a := contentSearch(loc, "cl", "q", "Title", f.Search); clause != "" {
		where = append(where, clause)
		args = append(args, a...)
	}
	if f.MinLevel != nil {
		where = append(where, "q.QuestLevel >= ?")
		args = append(args, *f.MinLevel)
	}
	if f.MaxLevel != nil {
		where = append(where, "q.QuestLevel <= ?")
		args = append(args, *f.MaxLevel)
	}
	return contentWhere(where), args
}

func questColumns(loc ContentLocale) string {
	return "q.entry, " + loc.localized("cl", "q", "Title") + ", " +
		"COALESCE(q.Details, ''), COALESCE(q.Objectives, ''), COALESCE(q.OfferRewardText, ''), " +
		"COALESCE(q.RequestItemsText, ''), COALESCE(q.EndText, ''), " +
		"COALESCE(q.ObjectiveText1, ''), COALESCE(q.ObjectiveText2, ''), " +
		"COALESCE(q.ObjectiveText3, ''), COALESCE(q.ObjectiveText4, ''), " + `
		q.MinLevel, q.MaxLevel, q.QuestLevel, q.Type, q.ZoneOrSort, q.SuggestedPlayers,
		q.QuestFlags, q.SpecialFlags, q.PrevQuestId, q.NextQuestId,
		q.RewXP, q.RewOrReqMoney, q.RewMoneyMaxLevel,
		q.ReqItemId1, q.ReqItemCount1, q.ReqItemId2, q.ReqItemCount2,
		q.ReqItemId3, q.ReqItemCount3, q.ReqItemId4, q.ReqItemCount4,
		q.ReqSourceId1, q.ReqSourceCount1, q.ReqSourceId2, q.ReqSourceCount2,
		q.ReqSourceId3, q.ReqSourceCount3, q.ReqSourceId4, q.ReqSourceCount4,
		q.ReqCreatureOrGOId1, q.ReqCreatureOrGOCount1, q.ReqCreatureOrGOId2, q.ReqCreatureOrGOCount2,
		q.ReqCreatureOrGOId3, q.ReqCreatureOrGOCount3, q.ReqCreatureOrGOId4, q.ReqCreatureOrGOCount4,
		q.RewItemId1, q.RewItemCount1, q.RewItemId2, q.RewItemCount2,
		q.RewItemId3, q.RewItemCount3, q.RewItemId4, q.RewItemCount4,
		q.RewChoiceItemId1, q.RewChoiceItemCount1, q.RewChoiceItemId2, q.RewChoiceItemCount2,
		q.RewChoiceItemId3, q.RewChoiceItemCount3, q.RewChoiceItemId4, q.RewChoiceItemCount4,
		q.RewChoiceItemId5, q.RewChoiceItemCount5, q.RewChoiceItemId6, q.RewChoiceItemCount6,
		q.PointMapId, q.PointX, q.PointY`
}

func questListQuery(loc ContentLocale, f ContentQuestFilter) (string, []any) {
	where, args := questWhere(loc, f)
	order := loc.localized("cl", "q", "Title")
	limit, limitArgs := contentLimit(f.Limit, f.Offset)
	q := "SELECT " + questColumns(loc) +
		" FROM quest_template q" + loc.join("cl", "locales_quest", "entry", "q") +
		where + " ORDER BY " + order + ", q.entry" + limit
	return q, append(args, limitArgs...)
}

func questCountQuery(loc ContentLocale, f ContentQuestFilter) (string, []any) {
	where, args := questWhere(loc, f)
	return "SELECT COUNT(*) FROM quest_template q" +
		loc.join("cl", "locales_quest", "entry", "q") + where, args
}

func questDetailQuery(loc ContentLocale) string {
	return "SELECT " + questColumns(loc) +
		" FROM quest_template q" + loc.join("cl", "locales_quest", "entry", "q") +
		" WHERE q.entry = ?"
}

func (q *ContentQuest) scanTargets() []any {
	return []any{
		&q.Entry, &q.Title,
		&q.Details, &q.Objectives, &q.OfferRewardText, &q.RequestItemsText, &q.EndText,
		&q.objectiveText[0], &q.objectiveText[1], &q.objectiveText[2], &q.objectiveText[3],
		&q.MinLevel, &q.MaxLevel, &q.QuestLevel, &q.Type, &q.ZoneOrSort, &q.SuggestedPlayers,
		&q.QuestFlags, &q.SpecialFlags, &q.PrevQuestID, &q.NextQuestID,
		&q.RewXP, &q.RewOrReqMoney, &q.RewMoneyMaxLevel,
		&q.reqItemID[0], &q.reqItemCount[0], &q.reqItemID[1], &q.reqItemCount[1],
		&q.reqItemID[2], &q.reqItemCount[2], &q.reqItemID[3], &q.reqItemCount[3],
		&q.reqSourceID[0], &q.reqSourceCount[0], &q.reqSourceID[1], &q.reqSourceCount[1],
		&q.reqSourceID[2], &q.reqSourceCount[2], &q.reqSourceID[3], &q.reqSourceCount[3],
		&q.reqMobID[0], &q.reqMobCount[0], &q.reqMobID[1], &q.reqMobCount[1],
		&q.reqMobID[2], &q.reqMobCount[2], &q.reqMobID[3], &q.reqMobCount[3],
		&q.rewItemID[0], &q.rewItemCount[0], &q.rewItemID[1], &q.rewItemCount[1],
		&q.rewItemID[2], &q.rewItemCount[2], &q.rewItemID[3], &q.rewItemCount[3],
		&q.rewChoiceID[0], &q.rewChoiceCount[0], &q.rewChoiceID[1], &q.rewChoiceCount[1],
		&q.rewChoiceID[2], &q.rewChoiceCount[2], &q.rewChoiceID[3], &q.rewChoiceCount[3],
		&q.rewChoiceID[4], &q.rewChoiceCount[4], &q.rewChoiceID[5], &q.rewChoiceCount[5],
		&q.PointMapID, &q.PointX, &q.PointY,
	}
}

func (q *ContentQuest) collect() {
	for _, t := range q.objectiveText {
		q.ObjectiveText = append(q.ObjectiveText, t)
	}
	q.RequiredItems = itemCounts(q.reqItemID[:], q.reqItemCount[:])
	q.RequiredSources = itemCounts(q.reqSourceID[:], q.reqSourceCount[:])
	q.RewardItems = itemCounts(q.rewItemID[:], q.rewItemCount[:])
	q.ChoiceItems = itemCounts(q.rewChoiceID[:], q.rewChoiceCount[:])
	for i := range q.reqMobID {
		if q.reqMobID[i] == 0 || q.reqMobCount[i] == 0 {
			continue
		}
		mob := ContentCreatureCount{Count: q.reqMobCount[i]}
		if q.reqMobID[i] < 0 {
			// The core stores a required game object as the negative entry.
			mob.IsGameObject = true
			mob.Entry = uint32(-q.reqMobID[i])
		} else {
			mob.Entry = uint32(q.reqMobID[i])
		}
		q.RequiredMobs = append(q.RequiredMobs, mob)
	}
}

// itemCounts pairs entry columns with their counts, skipping empty slots.
func itemCounts(ids []uint32, counts []uint16) []ContentItemCount {
	var out []ContentItemCount
	for i := range ids {
		if ids[i] == 0 || counts[i] == 0 {
			continue
		}
		out = append(out, ContentItemCount{Entry: ids[i], Count: counts[i]})
	}
	return out
}

// ContentQuests lists quests matching the filter.
func (s *Store) ContentQuests(ctx context.Context, loc ContentLocale, f ContentQuestFilter) ([]ContentQuest, int, error) {
	countQ, countArgs := questCountQuery(loc, f)
	var total int
	if err := s.World.QueryRowContext(ctx, countQ, countArgs...).Scan(&total); err != nil {
		return nil, 0, fmt.Errorf("count quests: %w", err)
	}

	listQ, listArgs := questListQuery(loc, f)
	rows, err := s.World.QueryContext(ctx, listQ, listArgs...)
	if err != nil {
		return nil, 0, fmt.Errorf("list quests: %w", err)
	}
	defer rows.Close()

	var out []ContentQuest
	for rows.Next() {
		var q ContentQuest
		if err := rows.Scan(q.scanTargets()...); err != nil {
			return nil, 0, fmt.Errorf("scan quest: %w", err)
		}
		q.collect()
		out = append(out, q)
	}
	return out, total, rows.Err()
}

// ContentQuest loads one quest.
func (s *Store) ContentQuest(ctx context.Context, loc ContentLocale, entry uint32) (*ContentQuest, error) {
	q := questDetailQuery(loc)
	var quest ContentQuest
	if err := s.World.QueryRowContext(ctx, q, entry).Scan(quest.scanTargets()...); err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, ErrNotFound
		}
		return nil, fmt.Errorf("quest %d: %w", entry, err)
	}
	quest.collect()
	if err := s.fillItemNames(ctx, loc,
		quest.RequiredItems, quest.RequiredSources, quest.RewardItems, quest.ChoiceItems); err != nil {
		return nil, err
	}
	return &quest, nil
}

// itemNamesQuery loads the names of the given item entries in one round trip.
func itemNamesQuery(loc ContentLocale, ids []uint32) (string, []any) {
	placeholders := strings.TrimSuffix(strings.Repeat("?,", len(ids)), ",")
	args := make([]any, 0, len(ids))
	for _, id := range ids {
		args = append(args, id)
	}
	return "SELECT i.entry, " + loc.localized("cl", "i", "name") + " FROM item_template i" +
		loc.join("cl", "locales_item", "entry", "i") + " WHERE i.entry IN (" + placeholders + ")", args
}

// fillItemNames adds the name of each referenced item so a quest page can link
// them without a second round trip per row.
func (s *Store) fillItemNames(ctx context.Context, loc ContentLocale, groups ...[]ContentItemCount) error {
	entries := map[uint32]string{}
	var ids []uint32
	for _, group := range groups {
		for _, it := range group {
			if _, seen := entries[it.Entry]; !seen {
				entries[it.Entry] = ""
				ids = append(ids, it.Entry)
			}
		}
	}
	if len(ids) == 0 {
		return nil
	}

	q, args := itemNamesQuery(loc, ids)
	rows, err := s.World.QueryContext(ctx, q, args...)
	if err != nil {
		return fmt.Errorf("names for quest items: %w", err)
	}
	defer rows.Close()
	for rows.Next() {
		var entry uint32
		var name string
		if err := rows.Scan(&entry, &name); err != nil {
			return fmt.Errorf("scan quest item name: %w", err)
		}
		entries[entry] = name
	}
	if err := rows.Err(); err != nil {
		return err
	}

	for _, group := range groups {
		for i := range group {
			group[i].Name = entries[group[i].Entry]
		}
	}
	return nil
}

// ---------------------------------------------------------------------------
// Creatures
// ---------------------------------------------------------------------------

// ContentCreature is one creature_template row.
type ContentCreature struct {
	Entry        uint32
	Name         string
	SubName      string
	LevelMin     uint8
	LevelMax     uint8
	Rank         uint8
	Type         uint8
	Faction      uint16
	NPCFlags     uint32
	LootID       uint32
	GossipMenuID uint32
	VendorID     uint32
	TrainerType  int8
	Scale        float64
	GoldMin      uint32
	GoldMax      uint32
	Civilian     uint8
	RacialLeader uint8
	DynamicFlags uint32
	AIName       string
	ScriptName   string
}

// ContentCreatureFilter narrows a creature list.
type ContentCreatureFilter struct {
	Search   string
	Type     *uint8
	MinLevel *uint8
	MaxLevel *uint8
	Limit    int
	Offset   int
}

func creatureWhere(loc ContentLocale, f ContentCreatureFilter) (string, []any) {
	var where []string
	var args []any
	if clause, a := contentSearch(loc, "cl", "c", "name", f.Search); clause != "" {
		where = append(where, clause)
		args = append(args, a...)
	}
	if f.Type != nil {
		where = append(where, "c.type = ?")
		args = append(args, *f.Type)
	}
	if f.MinLevel != nil {
		where = append(where, "c.level_min >= ?")
		args = append(args, *f.MinLevel)
	}
	if f.MaxLevel != nil {
		where = append(where, "c.level_max <= ?")
		args = append(args, *f.MaxLevel)
	}
	return contentWhere(where), args
}

func creatureColumns(loc ContentLocale) string {
	return "c.entry, " + loc.localized("cl", "c", "name") + ", " + loc.localized("cl", "c", "subname") + `,
		c.level_min, c.level_max, c.rank, c.type, c.faction, c.npc_flags,
		c.loot_id, c.gossip_menu_id, c.vendor_id, c.trainer_type,
		c.scale, c.gold_min, c.gold_max, c.civilian, c.racial_leader, c.dynamic_flags,
		c.ai_name, c.script_name`
}

func creatureListQuery(loc ContentLocale, f ContentCreatureFilter) (string, []any) {
	where, args := creatureWhere(loc, f)
	order := loc.localized("cl", "c", "name")
	limit, limitArgs := contentLimit(f.Limit, f.Offset)
	q := "SELECT " + creatureColumns(loc) +
		" FROM creature_template c" + loc.join("cl", "locales_creature", "entry", "c") +
		where + " ORDER BY " + order + ", c.entry" + limit
	return q, append(args, limitArgs...)
}

func creatureCountQuery(loc ContentLocale, f ContentCreatureFilter) (string, []any) {
	where, args := creatureWhere(loc, f)
	return "SELECT COUNT(*) FROM creature_template c" +
		loc.join("cl", "locales_creature", "entry", "c") + where, args
}

func creatureDetailQuery(loc ContentLocale) string {
	return "SELECT " + creatureColumns(loc) +
		" FROM creature_template c" + loc.join("cl", "locales_creature", "entry", "c") +
		" WHERE c.entry = ?"
}

func (c *ContentCreature) scanTargets() []any {
	return []any{
		&c.Entry, &c.Name, &c.SubName,
		&c.LevelMin, &c.LevelMax, &c.Rank, &c.Type, &c.Faction, &c.NPCFlags,
		&c.LootID, &c.GossipMenuID, &c.VendorID, &c.TrainerType,
		&c.Scale, &c.GoldMin, &c.GoldMax, &c.Civilian, &c.RacialLeader, &c.DynamicFlags,
		&c.AIName, &c.ScriptName,
	}
}

// ContentCreatures lists creatures matching the filter.
func (s *Store) ContentCreatures(ctx context.Context, loc ContentLocale, f ContentCreatureFilter) ([]ContentCreature, int, error) {
	countQ, countArgs := creatureCountQuery(loc, f)
	var total int
	if err := s.World.QueryRowContext(ctx, countQ, countArgs...).Scan(&total); err != nil {
		return nil, 0, fmt.Errorf("count creatures: %w", err)
	}

	listQ, listArgs := creatureListQuery(loc, f)
	rows, err := s.World.QueryContext(ctx, listQ, listArgs...)
	if err != nil {
		return nil, 0, fmt.Errorf("list creatures: %w", err)
	}
	defer rows.Close()

	var out []ContentCreature
	for rows.Next() {
		var c ContentCreature
		if err := rows.Scan(c.scanTargets()...); err != nil {
			return nil, 0, fmt.Errorf("scan creature: %w", err)
		}
		out = append(out, c)
	}
	return out, total, rows.Err()
}

// ContentCreature loads one creature.
func (s *Store) ContentCreature(ctx context.Context, loc ContentLocale, entry uint32) (*ContentCreature, error) {
	q := creatureDetailQuery(loc)
	var c ContentCreature
	if err := s.World.QueryRowContext(ctx, q, entry).Scan(c.scanTargets()...); err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, ErrNotFound
		}
		return nil, fmt.Errorf("creature %d: %w", entry, err)
	}
	return &c, nil
}

// ---------------------------------------------------------------------------
// Counts and unified search
// ---------------------------------------------------------------------------

// ContentCounts is how much of each kind of content the database holds, shown on
// the browser's landing page.
type ContentCounts struct {
	Items     int
	Spells    int
	Quests    int
	Creatures int
}

// ContentCountsFor counts the four tables. A table that is missing (an older
// world database) reports zero rather than failing the page.
func (s *Store) ContentCountsFor(ctx context.Context) ContentCounts {
	var c ContentCounts
	for _, t := range []struct {
		table string
		into  *int
	}{
		{"item_template", &c.Items},
		{"spell_template", &c.Spells},
		{"quest_template", &c.Quests},
		{"creature_template", &c.Creatures},
	} {
		if err := s.World.QueryRowContext(ctx, "SELECT COUNT(*) FROM "+t.table).Scan(t.into); err != nil {
			*t.into = 0
		}
	}
	return c
}

// ContentSearchResult is one hit of the unified search.
type ContentSearchResult struct {
	Kind     string // "item" | "spell" | "quest" | "creature"
	Entry    uint32
	Name     string
	Subtitle string // level / quality, whatever the kind shows under the name
}

// The four searches behind the unified search box. Each returns the SQL and its
// arguments, so the same builders can be exercised by the tests without a
// database.

func itemSearchQuery(loc ContentLocale, term string) (string, []any) {
	where, args := itemWhere(loc, ContentItemFilter{Search: term})
	name := loc.localized("cl", "i", "name")
	return "SELECT i.entry, " + name + ", '' FROM item_template i" +
		loc.join("cl", "locales_item", "entry", "i") + where +
		" ORDER BY " + name + " LIMIT " + strconv.Itoa(contentSearchLimit), args
}

func spellSearchQuery(loc ContentLocale, term string) (string, []any) {
	where, args := spellWhere(loc, ContentSpellFilter{Search: term})
	name := loc.localized("cl", "s", "name")
	return "SELECT s.entry, " + name + ", " + loc.localized("cl", "s", "nameSubtext") +
		" FROM spell_template s" + loc.join("cl", "locales_spell", "entry", "s") + where +
		" ORDER BY " + name + " LIMIT " + strconv.Itoa(contentSearchLimit), args
}

func questSearchQuery(loc ContentLocale, term string) (string, []any) {
	where, args := questWhere(loc, ContentQuestFilter{Search: term})
	title := loc.localized("cl", "q", "Title")
	return "SELECT q.entry, " + title + ", CAST(q.QuestLevel AS CHAR)" +
		" FROM quest_template q" + loc.join("cl", "locales_quest", "entry", "q") + where +
		" ORDER BY " + title + " LIMIT " + strconv.Itoa(contentSearchLimit), args
}

func creatureSearchQuery(loc ContentLocale, term string) (string, []any) {
	where, args := creatureWhere(loc, ContentCreatureFilter{Search: term})
	name := loc.localized("cl", "c", "name")
	return "SELECT c.entry, " + name + ", " + loc.localized("cl", "c", "subname") +
		" FROM creature_template c" + loc.join("cl", "locales_creature", "entry", "c") + where +
		" ORDER BY " + name + " LIMIT " + strconv.Itoa(contentSearchLimit), args
}

// ContentSearch looks in all four tables and returns up to contentSearchLimit
// hits per kind. One kind failing to answer degrades the page to the other
// three rather than turning the search into an error - the individual queries
// are what the store's own tests exercise.
func (s *Store) ContentSearch(ctx context.Context, loc ContentLocale, term string) []ContentSearchResult {
	term = strings.TrimSpace(term)
	if term == "" {
		return nil
	}

	var out []ContentSearchResult
	run := func(kind, q string, args []any) {
		rows, err := s.World.QueryContext(ctx, q, args...)
		if err != nil {
			return
		}
		defer rows.Close()
		for rows.Next() {
			var r ContentSearchResult
			r.Kind = kind
			if err := rows.Scan(&r.Entry, &r.Name, &r.Subtitle); err != nil {
				return
			}
			out = append(out, r)
		}
	}

	// Each kind is asked separately, so a query that fails degrades the page to
	// the other three instead of failing the whole search.
	queries := []struct {
		kind  string
		build func(ContentLocale, string) (string, []any)
	}{
		{"item", itemSearchQuery},
		{"spell", spellSearchQuery},
		{"quest", questSearchQuery},
		{"creature", creatureSearchQuery},
	}
	for _, q := range queries {
		sql, args := q.build(loc, term)
		run(q.kind, sql, args)
	}
	return out
}
