package web

import (
	_ "embed"
	"fmt"
	"strconv"
	"strings"

	"tortoiseweb/internal/store"
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
	//
	// Area 0 is left out on purpose: both continent fallback rows carry it
	// (Azeroth on map 0, Kalimdor on map 1), so the pair is not a lookup and
	// whoever won it would depend on the map iteration order. Those two are
	// addressed by their directory instead - ZonePath writes it, and
	// ZoneDirFromSegment reads it back.
	for _, boxes := range boxesByDir {
		for dir, box := range boxes {
			if _, seen := areaOfDir[dir]; !seen {
				areaOfDir[dir] = box.area
			}
			if box.area == 0 {
				continue
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
// reports whether that zone has any content. Area 0 is not a zone: the two
// continent fallback rows share it, so they are addressed by directory.
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

// ZoneArea is the area id of a zone directory, so a page can name it. The
// continent fallback rows answer 0.
func ZoneArea(dir string) (uint32, bool) {
	area, ok := areaOfDir[dir]
	return area, ok
}

// ZoneDirFromSegment resolves the single path segment of /db/zones/<segment>:
// a real area id, or a directory for the two rows that have no area of their
// own. Anything else - an unknown area, an unknown directory, a non-numeric
// area - reports false so the caller can answer 404.
func ZoneDirFromSegment(segment string) (string, bool) {
	if segment == "" {
		return "", false
	}
	if area, err := strconv.ParseUint(segment, 10, 32); err == nil {
		if area == 0 {
			return "", false // two rows share it; only the directory is unique
		}
		return ZoneDirForArea(uint32(area))
	}
	if _, has := zoneContents[segment]; !has {
		return "", false
	}
	return segment, true
}

// ZoneBoxForDir is the map box a zone's directory was built from: its map id
// names the picture and, for the continent rows, the zone itself.
func ZoneBoxForDir(dir string) (zoneBox, bool) {
	for _, boxes := range boxesByDir {
		if box, ok := boxes[dir]; ok {
			return box, true
		}
	}
	return zoneBox{}, false
}

// ZonePath is the URL of a zone's page: by area id where it has one, by
// directory for the two continent rows that would otherwise share /db/zones/0.
func ZonePath(dir string) string {
	area, _ := ZoneArea(dir)
	if area == 0 {
		return "/db/zones/" + dir
	}
	return "/db/zones/" + strconv.FormatUint(uint64(area), 10)
}

// ZoneLabel is what a zone is called on a page. A zone is named by its area;
// the continent rows have no area name, so they go by the map they hold - the
// same name the picture's map carries, in the page's language.
func ZoneLabel(page *PageData, dir string) string {
	if area, ok := ZoneArea(dir); ok && area != 0 {
		return page.AreaName(area)
	}
	if box, ok := ZoneBoxForDir(dir); ok {
		return page.MapName(uint32(box.mapID))
	}
	return ""
}

// zoneSearchLimit caps the zone group of the unified search, the same way
// store.contentSearchLimit caps each table it asks.
const zoneSearchLimit = 10

// SearchZones is the zone group of the unified search: the zones whose name in
// the page's language contains term, busiest first - the order the zones list
// uses.
//
// It runs here rather than in the store because a zone is not a table: the set
// of zones with a page is the generated table above, and the names come from the
// client's AreaTable through PageData.AreaName. Filtering by that name is what
// keeps every hit linkable - an area the client knows but no spawn point lands on
// has no /db/zones page to send the reader to.
func SearchZones(page *PageData, term string) []store.ContentSearchResult {
	needle := strings.ToLower(strings.TrimSpace(term))
	if needle == "" {
		return nil
	}

	var out []store.ContentSearchResult
	for _, dir := range zoneOrder {
		area, ok := ZoneArea(dir)
		if !ok || area == 0 {
			// The two continent rows have no area id, so a hit could not carry
			// one: the result row shows the id and links by it. They keep their
			// own pages through the directory, reachable from the zones list.
			continue
		}
		name := ZoneLabel(page, dir)
		if name == "" || !strings.Contains(strings.ToLower(name), needle) {
			continue
		}
		content, _ := ZoneContent(dir)
		out = append(out, store.ContentSearchResult{
			Kind:  "zone",
			Entry: area,
			Name:  name,
			Subtitle: fmt.Sprintf("%d %s · %d %s",
				content.Creatures, page.T("db.zone.creatures"),
				content.Objects, page.T("db.zone.objects")),
		})
		if len(out) == zoneSearchLimit {
			break
		}
	}
	return out
}
