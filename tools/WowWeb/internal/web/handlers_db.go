package web

import (
	"fmt"
	"html/template"
	"net/http"
	"net/url"
	"strconv"
	"strings"

	"tortoiseweb/internal/i18n"
	"tortoiseweb/internal/store"
)

// The database browser: read-only pages over the core's own content tables.
//
// Three things shape this file:
//
//  1. It is public, like the database sites it is modelled on. Everything it
//     shows is already in the world database the client is served from.
//
//  2. The names come from the core's own headers - ItemPrototype.h for classes,
//     inventory types, stat and trigger constants, SharedDefines.h for quality,
//     creature type and rank, SpellDefines.h for schools - so a page and the
//     game cannot disagree about what a quality 4 or a school 2 is.
//
//  3. The locale is the request's language: a Chinese reader gets the *_loc4
//     columns, everyone else the base ones, and the store falls back inside the
//     query, so a row with no translation still reads.
//
// Numbers that are DBC indexes (casting time, duration, range, icons, spell
// effects) are shown as the numbers they are. Naming them needs the client's DBC
// files, which this service does not read; a made-up label would be worse than
// the index it replaced.

// dbLocale maps the request's language onto the translation columns to read.
func dbLocale(page *PageData) store.ContentLocale {
	if page.Lang() == i18n.ZH {
		return store.ContentLocaleZH
	}
	return store.ContentLocaleBase
}

// dbOption is one entry of a filter dropdown.
type dbOption struct {
	Value uint8
	Name  string
}

// optUint8 reads an optional 0..255 filter. An unparsable or out-of-range value
// counts as absent rather than being clamped: a hand-edited URL should show
// everything, not a silently different subset.
func optUint8(q url.Values, name string) *uint8 {
	raw := strings.TrimSpace(q.Get(name))
	if raw == "" {
		return nil
	}
	n, err := strconv.Atoi(raw)
	if err != nil || n < 0 || n > 255 {
		return nil
	}
	v := uint8(n)
	return &v
}

// dbPageNum reads the page number, defaulting to the first page.
func dbPageNum(q url.Values) int {
	n := atoiDefault(q.Get("page"), 1)
	if n < 1 {
		return 1
	}
	return n
}

// named renders "<key>.<n>" if the catalogue has it, and "#n" if it does not.
// A missing name has to stay visible: a wrong label would be worse.
func (p PageData) named(prefix string, n int) string {
	key := prefix + "." + itoa(n)
	if v := p.Tr.T(key); v != key {
		return v
	}
	return "#" + itoa(n)
}

// ---------------------------------------------------------------------------
// Display names for the core's enums
// ---------------------------------------------------------------------------

// QualityName renders ITEM_QUALITY_* (SharedDefines.h).
func (p PageData) QualityName(q uint8) string { return p.named("quality", int(q)) }

// QualityClass is the colour class for an item name, q0..q6.
func (p PageData) QualityClass(q uint8) string { return "q" + itoa(int(q)) }

// ItemClassName renders ITEM_CLASS_* (ItemPrototype.h).
func (p PageData) ItemClassName(c uint8) string { return p.named("itemclass", int(c)) }

// InvTypeName renders INVTYPE_* (ItemPrototype.h).
func (p PageData) InvTypeName(t uint8) string { return p.named("invtype", int(t)) }

// StatName renders ItemModType (ItemPrototype.h). The enum has gaps, so a value
// between the known ones falls back to the number.
func (p PageData) StatName(t uint8) string { return p.named("stat", int(t)) }

// TriggerName renders ItemSpelltriggerType (ItemPrototype.h).
func (p PageData) TriggerName(t uint8) string { return p.named("trigger", int(t)) }

// BondingName renders ItemBondingType (ItemPrototype.h).
func (p PageData) BondingName(b uint8) string { return p.named("bonding", int(b)) }

// CreatureTypeName renders CreatureType (SharedDefines.h), which starts at 1.
func (p PageData) CreatureTypeName(t uint8) string { return p.named("ctype", int(t)) }

// CreatureRankName renders CreatureEliteType (SharedDefines.h).
func (p PageData) CreatureRankName(r uint8) string { return p.named("crank", int(r)) }

// GameObjectTypeName renders GameobjectTypes (SharedDefines.h). The enum covers
// 0..30 and several values are placeholders the core never instantiates, so the
// names come from the enum itself rather than from what the data uses.
func (p PageData) GameObjectTypeName(t uint8) string { return p.named("gotype", int(t)) }

// SchoolName renders SpellSchools (SpellDefines.h). The column holds a single
// school index, not the mask the core derives from it.
func (p PageData) SchoolName(s uint32) string {
	if s > 6 {
		return "#" + itoa(int(s))
	}
	return p.named("school", int(s))
}

func dbOptions(p PageData, prefix string, from, to int) []dbOption {
	out := make([]dbOption, 0, to-from+1)
	for i := from; i <= to; i++ {
		out = append(out, dbOption{Value: uint8(i), Name: p.named(prefix, i)})
	}
	return out
}

// ResistanceName names one of an item's six resistance columns.
//
// The columns are holy/fire/nature/frost/shadow/arcane - they skip armor, which
// is what SpellSchools calls school 0 - so the column index is the school index
// minus one. Getting that wrong would label a fire resistance as holy.
func (p PageData) ResistanceName(column int) string {
	if column < 0 || column > 5 {
		return "#" + itoa(column)
	}
	return p.named("school", column+1)
}

// QualityOptions lists ITEM_QUALITY_POOR..ARTIFACT. 0 is a real choice, which is
// why the filter carries a pointer.
func (p PageData) QualityOptions() []dbOption { return dbOptions(p, "quality", 0, 6) }

// ItemClassOptions lists ITEM_CLASS_CONSUMABLE..JUNK.
func (p PageData) ItemClassOptions() []dbOption { return dbOptions(p, "itemclass", 0, 15) }

// CreatureTypeOptions lists CREATURE_TYPE_BEAST..TOTEM.
func (p PageData) CreatureTypeOptions() []dbOption { return dbOptions(p, "ctype", 1, 11) }

// GameObjectTypeOptions lists GAMEOBJECT_TYPE_DOOR..AURA_GENERATOR. 0 is a real
// type (a door), which is why the filter carries a pointer.
func (p PageData) GameObjectTypeOptions() []dbOption { return dbOptions(p, "gotype", 0, 30) }

// SpellSchoolOptions lists SPELL_SCHOOL_NORMAL..ARCANE.
func (p PageData) SpellSchoolOptions() []dbOption { return dbOptions(p, "school", 0, 6) }

// ---------------------------------------------------------------------------
// Number formatting
// ---------------------------------------------------------------------------

// DamageRange renders an item's weapon damage, or "" when it has none.
func (p PageData) DamageRange(it store.ContentItem) string {
	if it.DamageMax <= 0 {
		return ""
	}
	return fmt.Sprintf("%.0f - %.0f", it.DamageMin, it.DamageMax)
}

// Speed renders the swing time in seconds, or "" when the item has no delay.
func (p PageData) Speed(it store.ContentItem) string {
	if it.Delay == 0 {
		return ""
	}
	return fmt.Sprintf("%.2f", float64(it.Delay)/1000)
}

// DPS renders the damage per second, or "" when it cannot be worked out.
func (p PageData) DPS(it store.ContentItem) string {
	if it.Delay == 0 || it.DamageMax <= 0 {
		return ""
	}
	dps := (it.DamageMin + it.DamageMax) / 2 / (float64(it.Delay) / 1000)
	return fmt.Sprintf("%.1f", dps)
}

// MoneyRange renders a copper range such as a creature's coin drop.
func (p PageData) MoneyRange(min, max uint32) string {
	if min == 0 && max == 0 {
		return ""
	}
	if min == max {
		return store.CoinsFromCopper(min)
	}
	return store.CoinsFromCopper(min) + " - " + store.CoinsFromCopper(max)
}

// RespawnWindow renders how long a gameobject takes to come back, or "" when it
// never does. The two numbers are the min/max the placements were saved with -
// the seconds column the core picks a respawn delay out of - and they are equal
// in practice, so the common case reads as one number.
//
// A negative value is not a delay: the core flips the sign of the column for a
// placement it does not spawn by default, so those read as what they are.
func (p PageData) RespawnWindow(st store.GameObjectSpawnStats) string {
	switch {
	case st.Spawns == 0:
		return ""
	case st.RespawnMin < 0 || st.RespawnMax < 0:
		return p.T("db.notSpawnedByDefault")
	case st.RespawnMin == 0 && st.RespawnMax == 0:
		// No delay stored and no placement that waits: printing "0 s" would
		// read as "instantly", which is not what the row says.
		return ""
	case st.RespawnMin == st.RespawnMax:
		return fmt.Sprintf(p.T("db.respawnSeconds"), st.RespawnMin)
	default:
		return fmt.Sprintf(p.T("db.respawnRange"), st.RespawnMin, st.RespawnMax)
	}
}

// dbMoney is a labelled amount of coin.
type dbMoney struct {
	Label  string
	Amount string
}

// QuestMoney renders RewOrReqMoney, which is money the player receives when it is
// positive and money the player has to pay when it is negative - Player.cpp
// reads both meanings from the same column.
func (p PageData) QuestMoney(v int32) dbMoney {
	if v < 0 {
		return dbMoney{Label: p.T("db.moneyRequired"), Amount: store.CoinsFromCopper(uint32(-v))}
	}
	return dbMoney{Label: p.T("db.money"), Amount: store.CoinsFromCopper(uint32(v))}
}

// LevelRange renders a creature's level range.
func (p PageData) LevelRange(min, max uint8) string {
	if min == max {
		return itoa(int(min))
	}
	return itoa(int(min)) + " - " + itoa(int(max))
}

// SpellRange renders the effect range of a spell the way the tooltip does: the
// base points are a lower bound, so the value is base+1 .. base+dice.
func (p PageData) SpellRange(e store.ContentSpellEffect) string {
	if e.DieSides <= 1 {
		return itoa(int(e.BasePoints) + 1)
	}
	return fmt.Sprintf("%d - %d", e.BasePoints+1, e.BasePoints+int32(e.DieSides))
}

// ---------------------------------------------------------------------------
// Landing page
// ---------------------------------------------------------------------------

type dbHomeView struct {
	PageData
	Counts store.ContentCounts
	// Query is what the shared search box shows in its input.
	Query string
}

func (s *Server) handleDBHome(w http.ResponseWriter, r *http.Request, page *PageData) {
	page.Title = page.T("db.title")
	page.Active = "db"
	s.rend.Render(w, http.StatusOK, "db_home", dbHomeView{
		PageData: *page,
		Counts:   s.store.ContentCountsFor(r.Context()),
	})
}

// ---------------------------------------------------------------------------
// Unified search
// ---------------------------------------------------------------------------

type dbSearchView struct {
	PageData
	Query   string
	Results []store.ContentSearchResult
}

// dbKindPath maps a result kind to the path the page uses.
func dbKindPath(kind string) string {
	switch kind {
	case "item":
		return "/db/items"
	case "spell":
		return "/db/spells"
	case "quest":
		return "/db/quests"
	case "gameobject":
		return "/db/objects"
	default:
		return "/db/npcs"
	}
}

func (s *Server) handleDBSearch(w http.ResponseWriter, r *http.Request, page *PageData) {
	term := strings.TrimSpace(r.URL.Query().Get("q"))

	page.Title = page.T("db.search.title")
	page.Active = "db"
	s.rend.Render(w, http.StatusOK, "db_search", dbSearchView{
		PageData: *page,
		Query:    term,
		Results:  s.store.ContentSearch(r.Context(), dbLocale(page), term),
	})
}

// ---------------------------------------------------------------------------
// Items
// ---------------------------------------------------------------------------

type dbItemsView struct {
	PageData
	Items []store.ContentItem

	Search        string
	FilterQuality *uint8
	FilterClass   *uint8
	FilterMin     *uint8
	FilterMax     *uint8

	Total       int
	Page        int
	Pages       int
	QueryString template.URL
}

func (s *Server) handleDBItems(w http.ResponseWriter, r *http.Request, page *PageData) {
	q := r.URL.Query()
	filter := store.ContentItemFilter{
		Search:   strings.TrimSpace(q.Get("q")),
		Quality:  optUint8(q, "quality"),
		Class:    optUint8(q, "class"),
		MinLevel: optUint8(q, "minlevel"),
		MaxLevel: optUint8(q, "maxlevel"),
		Limit:    store.ContentPageSize,
	}
	pageNum := dbPageNum(q)
	filter.Offset = (pageNum - 1) * store.ContentPageSize

	items, total, err := s.store.ContentItems(r.Context(), dbLocale(page), filter)
	if err != nil {
		s.serverError(w, r, "list items", err)
		return
	}

	page.Title = page.T("db.items.title")
	page.Active = "db"
	s.rend.Render(w, http.StatusOK, "db_items", dbItemsView{
		PageData:      *page,
		Items:         items,
		Search:        filter.Search,
		FilterQuality: filter.Quality,
		FilterClass:   filter.Class,
		FilterMin:     filter.MinLevel,
		FilterMax:     filter.MaxLevel,
		Total:         total,
		Page:          pageNum,
		Pages:         pages(total, store.ContentPageSize),
		QueryString:   baseQuery(r),
	})
}

// dbItemSetView is the "this item is part of a set" block on the item page.
type dbItemSetView struct {
	Name    string
	Pieces  []dbItemSetPiece
	Bonuses []SetBonus
	// ClientListed is true when the pieces came from the client's own set list
	// rather than from the item templates, which happens when the server's data
	// does not use the set at all.
	ClientListed bool
}

// dbItemSetPiece is one item of a set, with the one being viewed marked.
type dbItemSetPiece struct {
	Entry     uint32
	Name      string
	Icon      string
	IsCurrent bool
}

type dbItemView struct {
	PageData
	Item store.ContentItem
	// Relations are the cross links (who drops it, who sells it, which quests
	// want it). A failure to read them is not a failure of the page: the item
	// itself is still worth showing, so the handler leaves this empty and the
	// template skips the sections.
	Relations *store.ItemRelations
	// Set is the item's set, when it is in one. Its pieces and bonuses only exist
	// in the client's ItemSet.dbc, which the server never loads.
	Set *dbItemSetView
	// Disenchant is what an enchanter gets for the item, when it can be broken
	// down at all.
	Disenchant []store.ContentLootItem
	Query      string
}

func (s *Server) handleDBItem(w http.ResponseWriter, r *http.Request, page *PageData) {
	entry, ok := s.parseUintPath(r, "entry")
	if !ok {
		s.notFound(w, r)
		return
	}

	loc := dbLocale(page)
	item, err := s.store.ContentItem(r.Context(), loc, entry)
	if err != nil {
		if err == store.ErrNotFound {
			s.notFound(w, r)
			return
		}
		s.serverError(w, r, "load item", err)
		return
	}

	relations, err := s.store.ItemRelations(r.Context(), loc, entry)
	if err != nil {
		s.serverError(w, r, "load item relations", err)
		return
	}

	itemSet, err := s.itemSet(r, page, loc, item)
	if err != nil {
		s.serverError(w, r, "load item set", err)
		return
	}

	disenchant, err := s.store.ItemDisenchant(r.Context(), loc, item.DisenchantID)
	if err != nil {
		s.serverError(w, r, "load disenchant", err)
		return
	}

	page.Title = item.Name
	page.Active = "db"
	s.rend.Render(w, http.StatusOK, "db_item", dbItemView{
		PageData: *page, Item: *item, Relations: relations, Set: itemSet,
		Disenchant: disenchant,
	})
}

// itemSet builds the set block for an item, or nil when the item is in no set.
//
// The pieces come from the server's own data - every item template stores the set
// it belongs to - and fall back to the client's list (ItemSet.dbc) when no item
// carries the set. The name and the bonuses only exist in that DBC, so those
// always come from it.
func (s *Server) itemSet(r *http.Request, page *PageData, loc store.ContentLocale, item *store.ContentItem) (*dbItemSetView, error) {
	if item.SetID == 0 {
		return nil, nil
	}
	view := &dbItemSetView{
		Name:    page.ItemSetName(item.SetID),
		Bonuses: page.SetBonuses(item.SetID),
	}

	pieces, err := s.store.ItemsInSet(r.Context(), loc, item.SetID)
	if err != nil {
		return nil, err
	}
	if len(pieces) == 0 {
		// The set is only in the client's data. Look its pieces up so the page can
		// still show them.
		ids := page.SetPieces(item.SetID)
		briefs, err := s.store.ItemBriefs(r.Context(), loc, ids)
		if err != nil {
			return nil, err
		}
		for _, id := range ids {
			pieces = append(pieces, store.ContentItemCount{
				Entry: id, Count: 1, Name: briefs[id].Name, DisplayID: briefs[id].DisplayID,
			})
		}
		view.ClientListed = true
	}

	for _, piece := range pieces {
		view.Pieces = append(view.Pieces, dbItemSetPiece{
			Entry:     piece.Entry,
			Name:      piece.Name,
			Icon:      page.ItemIcon(piece.DisplayID),
			IsCurrent: piece.Entry == item.Entry,
		})
	}

	// The bonus spells are stored as ids; a player reads names.
	if len(view.Bonuses) > 0 {
		ids := make([]uint32, 0, len(view.Bonuses))
		for _, bonus := range view.Bonuses {
			ids = append(ids, bonus.SpellID)
		}
		names, err := s.store.SpellNames(r.Context(), loc, ids)
		if err != nil {
			return nil, err
		}
		for i := range view.Bonuses {
			view.Bonuses[i].Name = names[view.Bonuses[i].SpellID]
		}
	}
	return view, nil
}

// questTargets splits the "kill or collect" ids a quest stores into creatures and
// gameobjects: the core writes a gameobject as the negative of its entry.
func questTargets(quest *store.ContentQuest) (creatures, objects []uint32) {
	for _, target := range quest.RequiredMobs {
		if target.IsGameObject {
			objects = append(objects, target.Entry)
			continue
		}
		creatures = append(creatures, target.Entry)
	}
	return creatures, objects
}

// dbTooltipView is the hover tooltip for one item.
//
// It is deliberately smaller than the item page: a tooltip that repeats every
// number the page already shows would be a worse tooltip. What it carries is
// what the game's own tooltip carries, in the same order, so a player reading it
// recognises it.
type dbTooltipView struct {
	PageData
	Item store.ContentItem
	// Spells are the "use" and "equip" lines, in slot order. The name is looked
	// up rather than the id, because a tooltip that says "#133" is not worth
	// hovering for.
	Spells []dbTooltipSpell
	// Unique is the game's own "unique" line: at most one of the item may be
	// carried, which the core stores as max_count = 1.
	Unique bool
}

// dbTooltipSpell is one line of an item's spell list in a tooltip.
type dbTooltipSpell struct {
	SpellID uint32
	Name    string
	Trigger uint8
}

func (s *Server) handleDBItemTooltip(w http.ResponseWriter, r *http.Request, page *PageData) {
	entry, ok := s.parseUintPath(r, "entry")
	if !ok {
		s.notFound(w, r)
		return
	}

	item, err := s.store.ContentItem(r.Context(), dbLocale(page), entry)
	if err != nil {
		if err == store.ErrNotFound {
			s.notFound(w, r)
			return
		}
		s.serverError(w, r, "load item tooltip", err)
		return
	}

	view := dbTooltipView{PageData: *page, Item: *item, Unique: item.MaxCount == 1}
	if len(item.Spells) > 0 {
		ids := make([]uint32, 0, len(item.Spells))
		for _, sp := range item.Spells {
			ids = append(ids, sp.SpellID)
		}
		names, err := s.store.SpellNames(r.Context(), dbLocale(page), ids)
		if err != nil {
			s.serverError(w, r, "load tooltip spell names", err)
			return
		}
		for _, sp := range item.Spells {
			view.Spells = append(view.Spells, dbTooltipSpell{
				SpellID: sp.SpellID,
				Name:    names[sp.SpellID],
				Trigger: sp.Trigger,
			})
		}
	}

	s.rend.RenderFragment(w, "db_item_tooltip", view)
}

// ---------------------------------------------------------------------------
// Spells
// ---------------------------------------------------------------------------

type dbSpellsView struct {
	PageData
	Spells []store.ContentSpell

	Search       string
	FilterSchool *uint8
	FilterMin    *uint8
	FilterMax    *uint8

	Total       int
	Page        int
	Pages       int
	QueryString template.URL
}

func (s *Server) handleDBSpells(w http.ResponseWriter, r *http.Request, page *PageData) {
	q := r.URL.Query()
	filter := store.ContentSpellFilter{
		Search:   strings.TrimSpace(q.Get("q")),
		School:   optUint8(q, "school"),
		MinLevel: optUint8(q, "minlevel"),
		MaxLevel: optUint8(q, "maxlevel"),
		Limit:    store.ContentPageSize,
	}
	pageNum := dbPageNum(q)
	filter.Offset = (pageNum - 1) * store.ContentPageSize

	spells, total, err := s.store.ContentSpells(r.Context(), dbLocale(page), filter)
	if err != nil {
		s.serverError(w, r, "list spells", err)
		return
	}

	page.Title = page.T("db.spells.title")
	page.Active = "db"
	s.rend.Render(w, http.StatusOK, "db_spells", dbSpellsView{
		PageData:     *page,
		Spells:       spells,
		Search:       filter.Search,
		FilterSchool: filter.School,
		FilterMin:    filter.MinLevel,
		FilterMax:    filter.MaxLevel,
		Total:        total,
		Page:         pageNum,
		Pages:        pages(total, store.ContentPageSize),
		QueryString:  baseQuery(r),
	})
}

type dbSpellView struct {
	PageData
	Spell store.ContentSpell
	Query string
}

func (s *Server) handleDBSpell(w http.ResponseWriter, r *http.Request, page *PageData) {
	entry, ok := s.parseUintPath(r, "entry")
	if !ok {
		s.notFound(w, r)
		return
	}

	spell, err := s.store.ContentSpell(r.Context(), dbLocale(page), entry)
	if err != nil {
		if err == store.ErrNotFound {
			s.notFound(w, r)
			return
		}
		s.serverError(w, r, "load spell", err)
		return
	}

	page.Title = spell.Name
	page.Active = "db"
	s.rend.Render(w, http.StatusOK, "db_spell", dbSpellView{PageData: *page, Spell: *spell})
}

// ---------------------------------------------------------------------------
// Quests
// ---------------------------------------------------------------------------

type dbQuestsView struct {
	PageData
	Quests []store.ContentQuest

	Search    string
	FilterMin *uint8
	FilterMax *uint8

	Total       int
	Page        int
	Pages       int
	QueryString template.URL
}

func (s *Server) handleDBQuests(w http.ResponseWriter, r *http.Request, page *PageData) {
	q := r.URL.Query()
	filter := store.ContentQuestFilter{
		Search:   strings.TrimSpace(q.Get("q")),
		MinLevel: optUint8(q, "minlevel"),
		MaxLevel: optUint8(q, "maxlevel"),
		Limit:    store.ContentPageSize,
	}
	pageNum := dbPageNum(q)
	filter.Offset = (pageNum - 1) * store.ContentPageSize

	quests, total, err := s.store.ContentQuests(r.Context(), dbLocale(page), filter)
	if err != nil {
		s.serverError(w, r, "list quests", err)
		return
	}

	page.Title = page.T("db.quests.title")
	page.Active = "db"
	s.rend.Render(w, http.StatusOK, "db_quests", dbQuestsView{
		PageData:    *page,
		Quests:      quests,
		Search:      filter.Search,
		FilterMin:   filter.MinLevel,
		FilterMax:   filter.MaxLevel,
		Total:       total,
		Page:        pageNum,
		Pages:       pages(total, store.ContentPageSize),
		QueryString: baseQuery(r),
	})
}

type dbQuestView struct {
	PageData
	Quest store.ContentQuest
	// Relations are who hands the quest out and who takes it back.
	Relations *store.QuestRelations
	// Chain is the storyline the quest belongs to, what it requires, what it
	// opens up and what it excludes.
	Chain *store.QuestChain
	// Point is the objective on a map, when the quest has one. On this realm no
	// quest sets those coordinates, so Targets is the block that usually shows.
	Point *MapView
	// Targets are the zones where the creatures and objects the quest asks for
	// live, one map per zone.
	Targets []MapView
	Query   string
	// HasText lists the prose blocks that are present, so the page can skip the
	// ones that are empty rather than printing empty headings.
	HasDetails    bool
	HasObjectives bool
	HasReward     bool
	HasRequest    bool
	HasEnd        bool
	ObjectiveText []string
}

func (s *Server) handleDBQuest(w http.ResponseWriter, r *http.Request, page *PageData) {
	entry, ok := s.parseUintPath(r, "entry")
	if !ok {
		s.notFound(w, r)
		return
	}

	loc := dbLocale(page)
	quest, err := s.store.ContentQuest(r.Context(), loc, entry)
	if err != nil {
		if err == store.ErrNotFound {
			s.notFound(w, r)
			return
		}
		s.serverError(w, r, "load quest", err)
		return
	}

	relations, err := s.store.QuestRelations(r.Context(), loc, entry)
	if err != nil {
		s.serverError(w, r, "load quest relations", err)
		return
	}

	chain, err := s.store.QuestChain(r.Context(), loc, entry)
	if err != nil {
		s.serverError(w, r, "load quest chain", err)
		return
	}

	var objectiveText []string
	for _, t := range quest.ObjectiveText {
		if strings.TrimSpace(t) != "" {
			objectiveText = append(objectiveText, t)
		}
	}

	var point *MapView
	if quest.PointMapID != 0 {
		if view, ok := page.MapPoint(quest.PointMapID, quest.PointX, quest.PointY); ok {
			point = &view
		}
	}

	// Where the things it asks for are. A quest's own objective coordinates are
	// the better answer when they exist, so this only runs when they do not.
	var targets []MapView
	if point == nil {
		creatures, objects := questTargets(quest)
		if len(creatures) > 0 || len(objects) > 0 {
			spawns, err := s.store.QuestTargetSpawns(r.Context(), loc, creatures, objects)
			if err != nil {
				s.serverError(w, r, "load quest targets", err)
				return
			}
			targets = page.TargetMaps(spawns)
		}
	}

	page.Title = quest.Title
	page.Active = "db"
	s.rend.Render(w, http.StatusOK, "db_quest", dbQuestView{
		PageData:      *page,
		Quest:         *quest,
		Relations:     relations,
		Chain:         chain,
		Point:         point,
		Targets:       targets,
		HasDetails:    strings.TrimSpace(quest.Details) != "",
		HasObjectives: strings.TrimSpace(quest.Objectives) != "",
		HasReward:     strings.TrimSpace(quest.OfferRewardText) != "",
		HasRequest:    strings.TrimSpace(quest.RequestItemsText) != "",
		HasEnd:        strings.TrimSpace(quest.EndText) != "",
		ObjectiveText: objectiveText,
	})
}

// ---------------------------------------------------------------------------
// Creatures
// ---------------------------------------------------------------------------

type dbCreaturesView struct {
	PageData
	Creatures []store.ContentCreature

	Search     string
	FilterType *uint8
	FilterMin  *uint8
	FilterMax  *uint8

	Total       int
	Page        int
	Pages       int
	QueryString template.URL
}

func (s *Server) handleDBCreatures(w http.ResponseWriter, r *http.Request, page *PageData) {
	q := r.URL.Query()
	filter := store.ContentCreatureFilter{
		Search:   strings.TrimSpace(q.Get("q")),
		Type:     optUint8(q, "type"),
		MinLevel: optUint8(q, "minlevel"),
		MaxLevel: optUint8(q, "maxlevel"),
		Limit:    store.ContentPageSize,
	}
	pageNum := dbPageNum(q)
	filter.Offset = (pageNum - 1) * store.ContentPageSize

	creatures, total, err := s.store.ContentCreatures(r.Context(), dbLocale(page), filter)
	if err != nil {
		s.serverError(w, r, "list creatures", err)
		return
	}

	page.Title = page.T("db.npcs.title")
	page.Active = "db"
	s.rend.Render(w, http.StatusOK, "db_npcs", dbCreaturesView{
		PageData:    *page,
		Creatures:   creatures,
		Search:      filter.Search,
		FilterType:  filter.Type,
		FilterMin:   filter.MinLevel,
		FilterMax:   filter.MaxLevel,
		Total:       total,
		Page:        pageNum,
		Pages:       pages(total, store.ContentPageSize),
		QueryString: baseQuery(r),
	})
}

type dbCreatureView struct {
	PageData
	Creature store.ContentCreature
	// Relations are the quests it starts and ends plus its loot tables.
	Relations *store.CreatureRelations
	// Spawns are the zone maps its spawn points fall on, one map per zone.
	Spawns             []MapView
	SpawnListTruncated bool
	Query              string
}

func (s *Server) handleDBCreature(w http.ResponseWriter, r *http.Request, page *PageData) {
	entry, ok := s.parseUintPath(r, "entry")
	if !ok {
		s.notFound(w, r)
		return
	}

	loc := dbLocale(page)
	creature, err := s.store.ContentCreature(r.Context(), loc, entry)
	if err != nil {
		if err == store.ErrNotFound {
			s.notFound(w, r)
			return
		}
		s.serverError(w, r, "load creature", err)
		return
	}

	relations, err := s.store.CreatureRelations(r.Context(), loc, entry)
	if err != nil {
		s.serverError(w, r, "load creature relations", err)
		return
	}

	// Where it stands. A creature with no spawn row at all - one that only exists
	// as a template, or is summoned by a script - simply has no map to draw.
	spawns, truncated, err := s.store.CreatureSpawns(r.Context(), entry)
	if err != nil {
		s.serverError(w, r, "load creature spawns", err)
		return
	}

	page.Title = creature.Name
	page.Active = "db"
	s.rend.Render(w, http.StatusOK, "db_npc", dbCreatureView{
		PageData:           *page,
		Creature:           *creature,
		Relations:          relations,
		Spawns:             page.SpawnMaps(spawns),
		SpawnListTruncated: truncated,
	})
}

// ---------------------------------------------------------------------------
// Gameobjects
// ---------------------------------------------------------------------------

type dbObjectsView struct {
	PageData
	Objects []store.ContentGameObject

	Search     string
	FilterType *uint8
	Spawned    bool

	Total       int
	Page        int
	Pages       int
	QueryString template.URL
}

func (s *Server) handleDBObjects(w http.ResponseWriter, r *http.Request, page *PageData) {
	q := r.URL.Query()
	filter := store.ContentGameObjectFilter{
		Search:  strings.TrimSpace(q.Get("q")),
		Type:    optUint8(q, "type"),
		Spawned: q.Get("spawned") != "",
		Limit:   store.ContentPageSize,
	}
	pageNum := dbPageNum(q)
	filter.Offset = (pageNum - 1) * store.ContentPageSize

	objects, total, err := s.store.ContentGameObjects(r.Context(), dbLocale(page), filter)
	if err != nil {
		s.serverError(w, r, "list gameobjects", err)
		return
	}

	page.Title = page.T("db.objects.title")
	page.Active = "db"
	s.rend.Render(w, http.StatusOK, "db_objects", dbObjectsView{
		PageData:    *page,
		Objects:     objects,
		Search:      filter.Search,
		FilterType:  filter.Type,
		Spawned:     filter.Spawned,
		Total:       total,
		Page:        pageNum,
		Pages:       pages(total, store.ContentPageSize),
		QueryString: baseQuery(r),
	})
}

type dbObjectView struct {
	PageData
	Object store.ContentGameObject
	// Relations are the quests it starts, ends and is a target of, plus its loot.
	Relations *store.GameObjectRelations
	// Spawns are the zone maps its placements fall on, one map per zone.
	Spawns             []MapView
	SpawnListTruncated bool
	Stats              store.GameObjectSpawnStats
	LootID             uint32
	// DataFields are the non-zero data0..data23 columns, in index order.
	DataFields []dbDataField
	Query      string
}

// dbDataField is one non-zero data column of a gameobject template.
type dbDataField struct {
	Index uint8
	Value uint32
}

// nonZeroDataFields are the data0..data23 columns worth printing. An object
// template has twenty-four of them and the ones left at zero say nothing, while
// the index has to stay visible: which data column a number came from is what
// makes it readable against the core's per-type struct.
func nonZeroDataFields(object store.ContentGameObject) []dbDataField {
	var out []dbDataField
	for i, v := range object.Data {
		if v != 0 {
			out = append(out, dbDataField{Index: uint8(i), Value: v})
		}
	}
	return out
}

func (s *Server) handleDBObject(w http.ResponseWriter, r *http.Request, page *PageData) {
	entry, ok := s.parseUintPath(r, "entry")
	if !ok {
		s.notFound(w, r)
		return
	}

	loc := dbLocale(page)
	object, err := s.store.ContentGameObject(r.Context(), loc, entry)
	if err != nil {
		if err == store.ErrNotFound {
			s.notFound(w, r)
			return
		}
		s.serverError(w, r, "load gameobject", err)
		return
	}

	lootID := object.LootID()
	relations, err := s.store.GameObjectRelations(r.Context(), loc, entry, lootID)
	if err != nil {
		s.serverError(w, r, "load gameobject relations", err)
		return
	}

	// Where it stands. An object that is only a template - spawned by a script,
	// or left behind by an old patch - has no map to draw.
	spawns, truncated, err := s.store.GameObjectSpawns(r.Context(), entry)
	if err != nil {
		s.serverError(w, r, "load gameobject spawns", err)
		return
	}

	stats, err := s.store.GameObjectSpawnSummary(r.Context(), entry)
	if err != nil {
		s.serverError(w, r, "load gameobject spawn summary", err)
		return
	}

	page.Title = object.Name
	page.Active = "db"
	s.rend.Render(w, http.StatusOK, "db_object", dbObjectView{
		PageData:           *page,
		Object:             *object,
		Relations:          relations,
		Spawns:             page.ObjectSpawnMaps(spawns),
		SpawnListTruncated: truncated,
		Stats:              stats,
		LootID:             lootID,
		DataFields:         nonZeroDataFields(*object),
	})
}
