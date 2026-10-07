package web

import (
	_ "embed"
	"strconv"
	"strings"
)

// Item and spell icons.
//
// The columns the database keeps are ids, not artwork: an item has a display id
// (item_template.display_id) and a spell a spell icon id
// (spell_template.spellIconId). The names behind those ids live in the client's
// ItemDisplayInfo.dbc and SpellIcon.dbc, which the server never loads - so the
// mapping ships with the site instead, in icondata.txt, generated from the same
// dump the artwork came from (see gen_icons.py).
//
// An id with no entry draws nothing: the pages check for an empty URL rather
// than emitting an <img> that 404s. That is also what a Turtle-only id looks
// like, since the dump's DBCs predate it - the pages stay correct, they just
// show no icon for those.

//go:embed icondata.txt
var iconData string

// iconExt is the file extension the artwork is stored under.
const iconExt = ".png"

var (
	itemIconByDisplay  = map[uint32]string{}
	spellIconBySpellID = map[uint32]string{}
)

func init() {
	for _, line := range strings.Split(iconData, "\n") {
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}
		// <marker><TAB><id><TAB><name>
		marker, rest, ok := strings.Cut(line, "\t")
		if !ok {
			continue
		}
		idText, name, ok := strings.Cut(rest, "\t")
		if !ok || name == "" {
			continue
		}
		id, err := strconv.ParseUint(idText, 10, 32)
		if err != nil {
			continue
		}
		switch marker {
		case "D":
			itemIconByDisplay[uint32(id)] = name
		case "S":
			spellIconBySpellID[uint32(id)] = name
		}
	}
}

// iconURL builds the address of an icon file, or "" when there is none.
func iconURL(name string) string {
	if name == "" {
		return ""
	}
	return "/assets/icons/" + name + iconExt
}

// ItemIcon is the address of the icon for an item display id, or "" when the id
// has no artwork on this site.
func (p PageData) ItemIcon(displayID uint32) string {
	return iconURL(itemIconByDisplay[displayID])
}

// SpellIcon is the address of the icon for a spell icon id, or "".
func (p PageData) SpellIcon(spellIconID uint32) string {
	return iconURL(spellIconBySpellID[spellIconID])
}

// IconCounts reports how many ids each table maps, for the tests and for anyone
// wondering how much of the data is covered.
func IconCounts() (items, spells int) {
	return len(itemIconByDisplay), len(spellIconBySpellID)
}
