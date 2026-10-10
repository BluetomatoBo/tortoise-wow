package web

import (
	_ "embed"
	"strconv"
	"strings"
)

// The zones browser: the regions the maps describe, and what stands in each.
//
// The counts and the top lists come from zonecontent.txt, which
// gen_zonecontent.py computes at generation time - answering "what is in this
// zone" means running ZoneAt over all 155,000 spawn points, which is fine once
// and far too slow per request. Everything here is therefore a lookup.

//go:embed zonecontent.txt
var zoneContentData string

// zoneEntry is one entry of a zone's "most of what stands here" list.
type zoneEntry struct {
	Entry uint32
	Dots  int
}

// zoneContent is what one zone holds, as counted by the generator.
type zoneContent struct {
	Dir           string
	Creatures     int // spawn points
	CreatureKinds int // distinct entries
	Objects       int
	ObjectKinds   int
	Quests        int
	TopCreatures  []zoneEntry
	TopObjects    []zoneEntry
}

// Spawns is the two kinds added up, which is what the list sorts and shows.
func (z zoneContent) Spawns() int { return z.Creatures + z.Objects }

var (
	// zoneContents is the generator's table, keyed by the directory the zone's
	// map is stored under.
	zoneContents = map[string]zoneContent{}
	// zoneOrder is every zone with content, busiest first: the list page's order,
	// and the fallback when a page is asked for past the end.
	zoneOrder []string
	// dirOfArea and areaOfDir translate between the area id a URL uses and the
	// directory the generator and the maps use. An area can be listed on two maps
	// (the continent rows), so the first map wins - those rows have no spawns of
	// their own anyway.
	dirOfArea = map[uint32]string{}
	areaOfDir = map[string]uint32{}
)

func init() {
	for _, line := range strings.Split(zoneContentData, "\n") {
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}
		field := strings.Split(line, "\t")
		if len(field) != 8 {
			continue
		}
		z := zoneContent{Dir: field[0]}
		numbers := []*int{&z.Creatures, &z.CreatureKinds, &z.Objects, &z.ObjectKinds, &z.Quests}
		ok := true
		for i, target := range numbers {
			value, err := strconv.Atoi(field[i+1])
			if err != nil {
				ok = false
				break
			}
			*target = value
		}
		if !ok {
			continue
		}
		z.TopCreatures = parseZoneEntries(field[6])
		z.TopObjects = parseZoneEntries(field[7])
		zoneContents[z.Dir] = z
	}

	// The busiest zone first: the list is browsed, and the zones a visitor looks
	// for are the ones with something in them.
	zoneOrder = make([]string, 0, len(zoneContents))
	for dir := range zoneContents {
		zoneOrder = append(zoneOrder, dir)
	}
	sortZoneOrder(zoneOrder)

	// area -> directory, for the URLs, and back again for the pages.
	for _, boxes := range boxesByDir {
		for dir, box := range boxes {
			if _, seen := areaOfDir[dir]; !seen {
				areaOfDir[dir] = box.area
			}
			if _, seen := dirOfArea[box.area]; !seen {
				dirOfArea[box.area] = dir
			}
		}
	}
}

// sortZoneOrder orders the list by how much stands in each zone, then by name so
// the order is stable between builds.
func sortZoneOrder(dirs []string) {
	// A plain insertion sort: the list is a few hundred long and this runs once.
	for i := 1; i < len(dirs); i++ {
		for j := i; j > 0; j-- {
			a, b := zoneContents[dirs[j-1]], zoneContents[dirs[j]]
			if a.Spawns() > b.Spawns() || (a.Spawns() == b.Spawns() && a.Dir <= b.Dir) {
				break
			}
			dirs[j-1], dirs[j] = dirs[j], dirs[j-1]
		}
	}
}

// parseZoneEntries reads "entry:dots,entry:dots" into a slice.
func parseZoneEntries(field string) []zoneEntry {
	if field == "" {
		return nil
	}
	out := make([]zoneEntry, 0, 25)
	for _, part := range strings.Split(field, ",") {
		entry, dots, ok := strings.Cut(part, ":")
		if !ok {
			continue
		}
		e, err := strconv.ParseUint(entry, 10, 32)
		if err != nil {
			continue
		}
		n, err := strconv.Atoi(dots)
		if err != nil {
			continue
		}
		out = append(out, zoneEntry{Entry: uint32(e), Dots: n})
	}
	return out
}

// ZoneContent is the generated table for one zone, or zero when the zone holds
// nothing the generator counted.
func ZoneContent(dir string) (zoneContent, bool) {
	z, ok := zoneContents[dir]
	return z, ok
}

// ZoneDirs is every zone with content, busiest first.
func ZoneDirs() []string { return zoneOrder }

// ZoneDirForArea maps an area id to the directory its map is stored under, and
// reports whether that zone has any content.
func ZoneDirForArea(area uint32) (string, bool) {
	dir, ok := dirOfArea[area]
	if !ok {
		return "", false
	}
	if _, has := zoneContents[dir]; !has {
		return dir, false
	}
	return dir, true
}

// ZoneArea is the area id of a zone directory, so a page can name it.
func ZoneArea(dir string) (uint32, bool) {
	area, ok := areaOfDir[dir]
	return area, ok
}
