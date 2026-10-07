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

// dbKindNames maps a result kind to the label and path the page uses.
func dbKindPath(kind string) string {
	switch kind {
	case "item":
		return "/db/items"
	case "spell":
		return "/db/spells"
	case "quest":
		return "/db/quests"
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

type dbItemView struct {
	PageData
	Item  store.ContentItem
	Query string
}

func (s *Server) handleDBItem(w http.ResponseWriter, r *http.Request, page *PageData) {
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
		s.serverError(w, r, "load item", err)
		return
	}

	page.Title = item.Name
	page.Active = "db"
	s.rend.Render(w, http.StatusOK, "db_item", dbItemView{PageData: *page, Item: *item})
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
	Query string
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

	quest, err := s.store.ContentQuest(r.Context(), dbLocale(page), entry)
	if err != nil {
		if err == store.ErrNotFound {
			s.notFound(w, r)
			return
		}
		s.serverError(w, r, "load quest", err)
		return
	}

	var objectiveText []string
	for _, t := range quest.ObjectiveText {
		if strings.TrimSpace(t) != "" {
			objectiveText = append(objectiveText, t)
		}
	}

	page.Title = quest.Title
	page.Active = "db"
	s.rend.Render(w, http.StatusOK, "db_quest", dbQuestView{
		PageData:      *page,
		Quest:         *quest,
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
	Query    string
}

func (s *Server) handleDBCreature(w http.ResponseWriter, r *http.Request, page *PageData) {
	entry, ok := s.parseUintPath(r, "entry")
	if !ok {
		s.notFound(w, r)
		return
	}

	creature, err := s.store.ContentCreature(r.Context(), dbLocale(page), entry)
	if err != nil {
		if err == store.ErrNotFound {
			s.notFound(w, r)
			return
		}
		s.serverError(w, r, "load creature", err)
		return
	}

	page.Title = creature.Name
	page.Active = "db"
	s.rend.Render(w, http.StatusOK, "db_npc", dbCreatureView{PageData: *page, Creature: *creature})
}
