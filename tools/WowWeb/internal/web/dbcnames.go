package web

import (
	_ "embed"
	"strconv"
	"strings"

	"tortoiseweb/internal/i18n"
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
		if len(field) < 4 {
			continue
		}
		kind := field[0]
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

// ItemSetName is the name of an item set, or "".
func (p PageData) ItemSetName(id uint32) string {
	return itemSetNames[id].pick(p.Lang())
}

// DBCNameCounts reports how many rows each table holds, for the tests and for
// anyone wondering how much of the client's data is covered.
func DBCNameCounts() (areas, factions, maps, sorts, subclasses, sets int) {
	return len(areaNames), len(factionNames), len(mapNames),
		len(questSortNames), len(subclassNames), len(itemSetNames)
}
