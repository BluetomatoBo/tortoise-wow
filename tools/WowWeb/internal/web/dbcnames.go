package web

import (
	_ "embed"
	"fmt"
	"sort"
	"strconv"
	"strings"

	"tortoiseweb/internal/i18n"
	"tortoiseweb/internal/store"
)

// Names for the ids the database stores where a player expects a word: a quest's
// ZoneOrSort, a creature's faction, an item's class/subclass and its set.
//
// The names live in the client's DBC files, which the server never loads, so they
// ship with the site in dbcnames.txt - generated from the client's own files by
// gen_dbc_names.py, the same verified way the icons are. The client's DBCs carry
// every locale in one record, so the table holds both languages and the page
// picks by the visitor's language.
//
// A lookup that finds nothing returns "", and the templates fall back to printing
// the raw number, which is what every page did before this existed.

//go:embed dbcnames.txt
var dbcNamesData string

// dbcName is one row's name in both languages the site serves.
type dbcName struct {
	en, zh string
}

// pick returns the name in the visitor's language, falling back to the other one
// rather than to an empty string: a client that did not translate every row is
// still better than a page that shows nothing.
func (n dbcName) pick(lang i18n.Lang) string {
	if lang == i18n.ZH {
		if n.zh != "" {
			return n.zh
		}
		return n.en
	}
	if n.en != "" {
		return n.en
	}
	return n.zh
}

// subclassKey is an item's class and subclass, which is how ItemSubClass.dbc is
// keyed - its own id column is shared by several rows.
type subclassKey struct {
	class, subclass uint8
}

var (
	areaNames      = map[uint32]dbcName{}
	factionNames   = map[uint32]dbcName{}
	mapNames       = map[uint32]dbcName{}
	questSortNames = map[uint32]dbcName{}
	subclassNames  = map[subclassKey]dbcName{}
	itemSetNames   = map[uint32]dbcName{}
	skillNames     = map[uint32]dbcName{}
	setItems       = map[uint32][]uint32{}
	setBonuses     = map[uint32][]SetBonus{}
)

// maxID is the value a DBC pads unused key columns with (0xFFFFFFFF); it is not
// an id anything in the database refers to.
const maxID = 4294967295

func init() {
	for _, line := range strings.Split(dbcNamesData, "\n") {
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}
		field := strings.Split(line, "\t")
		if len(field) < 3 {
			continue
		}
		kind := field[0]
		switch kind {
		case "SETITEM":
			if len(field) != 3 {
				continue
			}
			set, err1 := strconv.ParseUint(field[1], 10, 32)
			item, err2 := strconv.ParseUint(field[2], 10, 32)
			if err1 == nil && err2 == nil {
				setItems[uint32(set)] = append(setItems[uint32(set)], uint32(item))
			}
			continue
		case "SETBONUS":
			if len(field) != 4 {
				continue
			}
			set, err1 := strconv.ParseUint(field[1], 10, 32)
			pieces, err2 := strconv.ParseUint(field[2], 10, 32)
			spell, err3 := strconv.ParseUint(field[3], 10, 32)
			if err1 == nil && err2 == nil && err3 == nil {
				setBonuses[uint32(set)] = append(setBonuses[uint32(set)], SetBonus{
					Pieces: int(pieces), SpellID: uint32(spell),
				})
			}
			continue
		}

		// Everything past here carries a name in two languages, last two fields.
		if len(field) < 4 {
			continue
		}
		name := dbcName{en: field[len(field)-2], zh: field[len(field)-1]}

		if kind == "SUBCLASS" {
			if len(field) != 5 {
				continue
			}
			class, err1 := strconv.ParseUint(field[1], 10, 8)
			sub, err2 := strconv.ParseUint(field[2], 10, 8)
			if err1 != nil || err2 != nil || class == maxID || sub == maxID {
				continue
			}
			subclassNames[subclassKey{uint8(class), uint8(sub)}] = name
			continue
		}
		if len(field) != 4 {
			continue
		}
		id, err := strconv.ParseUint(field[1], 10, 32)
		if err != nil || id == maxID {
			continue
		}
		switch kind {
		case "AREA":
			areaNames[uint32(id)] = name
		case "FACTION":
			factionNames[uint32(id)] = name
		case "MAP":
			mapNames[uint32(id)] = name
		case "QSORT":
			questSortNames[uint32(id)] = name
		case "ITEMSET":
			itemSetNames[uint32(id)] = name
		case "SKILL":
			skillNames[uint32(id)] = name
		}
	}
}

// AreaName is the zone name for an area id, or "".
func (p PageData) AreaName(id uint32) string {
	return areaNames[id].pick(p.Lang())
}

// ZoneOrSortName labels a quest's ZoneOrSort column, which the core reads as a
// zone id when it is positive and as the negated id of a quest sort when it is
// negative (ObjectMgr.cpp checks exactly that). Returns "" when the id is not in
// either table, including for 0, which means "no zone".
func (p PageData) ZoneOrSortName(zoneOrSort int16) string {
	switch {
	case zoneOrSort > 0:
		return areaNames[uint32(zoneOrSort)].pick(p.Lang())
	case zoneOrSort < 0:
		return questSortNames[uint32(-int32(zoneOrSort))].pick(p.Lang())
	default:
		return ""
	}
}

// FactionName is the faction name for a creature's faction id, or "".
func (p PageData) FactionName(id uint16) string {
	return factionNames[uint32(id)].pick(p.Lang())
}

// MapName is the map name for a map id, or "".
func (p PageData) MapName(id uint32) string {
	return mapNames[id].pick(p.Lang())
}

// SubClassName is the name of an item's class and subclass, or "".
func (p PageData) SubClassName(class, subclass uint8) string {
	return subclassNames[subclassKey{class, subclass}].pick(p.Lang())
}

// SkillName is the SkillLine name for a skill id, or "".
func (p PageData) SkillName(id uint32) string {
	return skillNames[id].pick(p.Lang())
}

// ItemSetName is the name of an item set, or "".
func (p PageData) ItemSetName(id uint32) string {
	return itemSetNames[id].pick(p.Lang())
}

// SetBonus is one of an item set's bonuses: the number of pieces that switches it
// on, and the spell it grants.
type SetBonus struct {
	Pieces  int
	SpellID uint32
	Name    string
}

// itemSetKnown reports whether the client's ItemSet.dbc knows this id, so a page
// can 404 an id that names nothing.
func itemSetKnown(id uint32) (string, bool) {
	if _, ok := itemSetNames[id]; ok {
		return "name", true
	}
	if _, ok := setItems[id]; ok {
		return "pieces", true
	}
	if _, ok := setBonuses[id]; ok {
		return "bonus", true
	}
	return "", false
}

// ItemSetIDs is every set the client's ItemSet.dbc carries, in id order: the
// named sets plus any set that only lists pieces or bonuses. It is the list the
// sets browser walks.
func ItemSetIDs() []uint32 {
	seen := make(map[uint32]bool, len(itemSetNames)+len(setItems)+len(setBonuses))
	for id := range itemSetNames {
		seen[id] = true
	}
	for id := range setItems {
		seen[id] = true
	}
	for id := range setBonuses {
		seen[id] = true
	}
	ids := make([]uint32, 0, len(seen))
	for id := range seen {
		ids = append(ids, id)
	}
	sort.Slice(ids, func(i, j int) bool { return ids[i] < ids[j] })
	return ids
}

// SearchSets is the set group of the unified search: sets whose name in the
// page's language contains term, plus an exact id hit, A-Z by the shown name -
// the order the set list uses.
//
// Like the zones it runs here rather than in the store: a set lives in the
// client's ItemSet.dbc, not in a table, and filtering by the name the page shows
// is what keeps every hit clickable.
func SearchSets(page *PageData, term string) []store.ContentSearchResult {
	needle := strings.ToLower(strings.TrimSpace(term))
	if needle == "" {
		return nil
	}
	var exact uint32
	if id, err := strconv.ParseUint(strings.TrimSpace(term), 10, 32); err == nil {
		exact = uint32(id)
	}

	type hit struct {
		id   uint32
		name string
	}
	var hits []hit
	for _, id := range ItemSetIDs() {
		name := page.ItemSetName(id)
		if name == "" {
			continue
		}
		if id != exact && !strings.Contains(strings.ToLower(name), needle) {
			continue
		}
		hits = append(hits, hit{id, name})
	}
	sort.Slice(hits, func(i, j int) bool { return hits[i].name < hits[j].name })

	limit := len(hits)
	if limit > setSearchLimit {
		limit = setSearchLimit
	}
	out := make([]store.ContentSearchResult, 0, limit)
	for _, h := range hits[:limit] {
		out = append(out, store.ContentSearchResult{Kind: "set", Entry: h.id, Name: h.name,
			Subtitle: fmt.Sprintf("%d %s", len(page.SetPieces(h.id)), page.T("db.set.pieces"))})
	}
	return out
}

// setSearchLimit caps the set group of the unified search, the way
// store.contentSearchLimit caps each table it asks.
const setSearchLimit = 10

// SetPieces is the client's own list of what is in a set, used when the server's
// item templates point at a set id but no item carries it.
func (p PageData) SetPieces(setID uint32) []uint32 {
	return setItems[setID]
}

// SetBonuses lists a set's bonuses in the order a player earns them.
func (p PageData) SetBonuses(setID uint32) []SetBonus {
	bonuses := setBonuses[setID]
	out := make([]SetBonus, 0, len(bonuses))
	for _, b := range bonuses {
		out = append(out, b)
	}
	sort.Slice(out, func(i, j int) bool {
		if out[i].Pieces != out[j].Pieces {
			return out[i].Pieces < out[j].Pieces
		}
		return out[i].SpellID < out[j].SpellID
	})
	return out
}

// DBCNameCounts reports how many rows each table holds, for the tests and for
// anyone wondering how much of the client's data is covered.
func DBCNameCounts() (areas, factions, maps, sorts, subclasses, sets, skills int) {
	return len(areaNames), len(factionNames), len(mapNames),
		len(questSortNames), len(subclassNames), len(itemSetNames), len(skillNames)
}

// SetDataCounts reports how many sets have members and bonuses loaded.
func SetDataCounts() (withItems, withBonuses int) {
	return len(setItems), len(setBonuses)
}
