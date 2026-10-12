package web

import (
	"strings"
	"testing"

	"tortoiseweb/internal/i18n"
	"tortoiseweb/internal/store"
)

// TestSearchZonesFindsByLocalizedName pins the zone group of the unified search:
// a zone is found by the name the page shows, in the page's language only, and
// the hit is the kind/entry pair the template turns into a link.
func TestSearchZonesFindsByLocalizedName(t *testing.T) {
	zh := namePage(t, i18n.ZH)
	en := namePage(t, i18n.EN)

	hits := SearchZones(&zh, "贫瘠之地")
	if len(hits) != 1 {
		t.Fatalf("SearchZones(zh, 贫瘠之地) = %d hits, want 1", len(hits))
	}
	if got := hits[0]; got.Kind != "zone" || got.Entry != 17 || got.Name != "贫瘠之地" {
		t.Errorf("hit = %+v, want kind zone / area 17 / 贫瘠之地", got)
	}
	// The subtitle carries the two counts under the words the zones list uses,
	// so a search row and the list agree on what a number means.
	if sub := hits[0].Subtitle; !strings.Contains(sub, zh.T("db.zone.creatures")) ||
		!strings.Contains(sub, zh.T("db.zone.objects")) {
		t.Errorf("subtitle %q does not name both counts", sub)
	}

	if hits := SearchZones(&en, "Stranglethorn"); len(hits) != 1 || hits[0].Entry != 33 {
		t.Errorf("SearchZones(en, Stranglethorn) = %+v, want area 33", hits)
	}

	// The other language's name is not a match, the way every other kind in the
	// unified search reads only the active locale's columns.
	if hits := SearchZones(&zh, "Stranglethorn"); len(hits) != 0 {
		t.Errorf("zh page matched the English name: %+v", hits)
	}
}

// TestSearchZonesIgnoresBlankAndCaps pins the two guards: a blank term adds
// nothing, and a term matching many zones stops at the same per-kind cap the
// store's queries use.
func TestSearchZonesIgnoresBlankAndCaps(t *testing.T) {
	zh := namePage(t, i18n.ZH)

	for _, term := range []string{"", "   ", "\t"} {
		if hits := SearchZones(&zh, term); hits != nil {
			t.Errorf("SearchZones(%q) = %+v, want nothing", term, hits)
		}
	}

	// 之 is in 16 of the 130 zone names (贫瘠之地, 幽魂之地 … and ten more), so a
	// one-character term exercises the cap rather than just the matcher: the
	// group comes back full and stops there.
	if got := len(SearchZones(&zh, "之")); got != zoneSearchLimit {
		t.Errorf("SearchZones(zh, 之) = %d hits, want the cap %d", got, zoneSearchLimit)
	}
}

// TestSearchZonesRoundTripsEveryZone is the invariant that matters: every zone
// with a page can be found by its own name, and every hit has a page to link to
// - the search must never send a reader to a zone that has no map.
//
// The two continent buckets are the exception, and they are named here so a real
// zone losing its name still fails this test: `kalimdor` and `azeroth` hold the
// spawns no sub-zone box covers, both sit on area 0, have no name to search for,
// and share the page /db/zones/0.
func TestSearchZonesRoundTripsEveryZone(t *testing.T) {
	zh := namePage(t, i18n.ZH)

	unnamed := 0
	for _, dir := range ZoneDirs() {
		area, ok := ZoneArea(dir)
		if !ok {
			t.Fatalf("zone %q has no area", dir)
		}
		name := zh.AreaName(area)
		if name == "" {
			unnamed++
			if area != 0 {
				t.Fatalf("zone %q (area %d) lost its name", dir, area)
			}
			continue
		}
		if _, has := ZoneDirForArea(area); !has {
			t.Fatalf("area %d has no page", area)
		}

		found := false
		for _, hit := range SearchZones(&zh, name) {
			if hit.Entry == area {
				found = true
				break
			}
		}
		if !found {
			t.Fatalf("searching %q does not find area %d", name, area)
		}
	}
	if unnamed != 2 {
		t.Errorf("unnamed zones = %d, want the 2 continent buckets", unnamed)
	}
}

// TestDBKindPathHasAZoneList pins the list path a zone hit falls back to: the
// detail link is built as kindPath + "/" + entry, so /db/zones + the area gives
// the page the zones table itself links to.
func TestDBKindPathHasAZoneList(t *testing.T) {
	if got := dbKindPath("zone"); got != "/db/zones" {
		t.Errorf("dbKindPath(zone) = %q, want /db/zones", got)
	}
}

// TestContinentRowsHaveTheirOwnPages pins the fix for the two rows that share
// area 0 (Azeroth on map 0, Kalimdor on map 1): each is addressed by its
// directory, named after its map, and the area still answers nothing - a
// lookup that took area 0 would hand both rows the same page, and which one it
// named would depend on the map iteration order.
func TestContinentRowsHaveTheirOwnPages(t *testing.T) {
	zh := namePage(t, i18n.ZH)

	if dir, ok := ZoneDirForArea(0); ok {
		t.Errorf("ZoneDirForArea(0) = %q, want no answer: two rows share it", dir)
	}
	if _, ok := ZoneDirFromSegment("0"); ok {
		t.Error(`ZoneDirFromSegment("0") found a zone, want none`)
	}

	rows := map[string]struct {
		label string
		path  string
	}{}
	for _, dir := range []string{"kalimdor", "azeroth"} {
		resolved, ok := ZoneDirFromSegment(dir)
		if !ok || resolved != dir {
			t.Fatalf("ZoneDirFromSegment(%q) = %q/%v", dir, resolved, ok)
		}
		label := ZoneLabel(&zh, dir)
		if label == "" {
			t.Fatalf("zone %q has no label", dir)
		}
		rows[dir] = struct {
			label string
			path  string
		}{label, ZonePath(dir)}
	}
	if rows["kalimdor"].path == rows["azeroth"].path {
		t.Errorf("the two continent rows share the page %s", rows["kalimdor"].path)
	}
	if rows["kalimdor"].path != "/db/zones/kalimdor" {
		t.Errorf("kalimdor path = %q", rows["kalimdor"].path)
	}
	// The label is the map's name in the page's language, not the directory.
	if rows["kalimdor"].label == rows["azeroth"].label {
		t.Errorf("both continent rows read %q", rows["kalimdor"].label)
	}
	if got := rows["kalimdor"].label; got != zh.MapName(1) {
		t.Errorf("kalimdor label = %q, want the map name %q", got, zh.MapName(1))
	}

	// A real zone still works the old way: area id in, area URL out.
	dir, ok := ZoneDirFromSegment("17")
	if !ok {
		t.Fatal(`ZoneDirFromSegment("17") found nothing`)
	}
	if got := ZonePath(dir); got != "/db/zones/17" {
		t.Errorf("zone 17 path = %q, want /db/zones/17", got)
	}
	if got := ZoneLabel(&zh, dir); got != zh.AreaName(17) {
		t.Errorf("zone 17 label = %q, want %q", got, zh.AreaName(17))
	}
}

// TestZoneNeighboursAreTheOnesNextDoor pins the adjacency rule on a zone whose
// neighbours are known: the Barrens borders Durotar, Mulgore and Dustwallow
// Marsh, so those must be present, the zone must not list itself, and the two
// continent rows must be left out (they span a whole map and would otherwise
// rank first by overlap).
func TestZoneNeighboursAreTheOnesNextDoor(t *testing.T) {
	zh := namePage(t, i18n.ZH)
	dir, ok := ZoneDirForArea(17) // the Barrens
	if !ok {
		t.Fatal("area 17 has no zone page")
	}

	neighbours := ZoneNeighbours(dir, zoneNeighbourLimit)
	if len(neighbours) == 0 || len(neighbours) > zoneNeighbourLimit {
		t.Fatalf("neighbours = %d entries", len(neighbours))
	}

	want := map[uint32]string{14: "杜隆塔尔", 215: "莫高雷", 15: "尘泥沼泽"}
	got := map[uint32]bool{}
	for _, n := range neighbours {
		got[n.Area] = true
		if n.Dir == dir {
			t.Errorf("the zone lists itself as a neighbour")
		}
		if n.Area == 0 {
			t.Errorf("a continent row is listed as a neighbour: %q", n.Dir)
		}
		if n.Share <= 0 || n.Share > 1.0001 {
			t.Errorf("share out of range for %q: %f", n.Dir, n.Share)
		}
		if name := zh.AreaName(n.Area); name == "" {
			t.Errorf("neighbour %q has no name", n.Dir)
		}
	}
	for area, name := range want {
		if !got[area] {
			t.Errorf("neighbour %s (area %d) is missing: %+v", name, area, neighbours)
		}
	}

	// The share ranks the list, so the first entry must be the most covered one.
	if neighbours[0].Share < neighbours[len(neighbours)-1].Share {
		t.Errorf("shares are not in descending order: %+v", neighbours)
	}

	// The continent rows have no neighbours of their own to offer, but a real
	// zone must always border something.
	if again := ZoneNeighbours(dir, 3); len(again) != 3 {
		t.Errorf("limit 3 gave %d entries", len(again))
	}
}

// TestZoneSpawnsGroupByTerrainGrid pins the grouping a faction page uses: spawn
// points are judged by the same ZoneAt chain the zone pages use, counted per
// zone with their distinct creature count, busiest first, and a point no zone
// claims is left out rather than guessed into one.
func TestZoneSpawnsGroupByTerrainGrid(t *testing.T) {
	zh := namePage(t, i18n.ZH)

	// Two real zones, taken from their own boxes so the test does not depend on
	// hand-copied coordinates.
	sw, ok := ZoneBoxForDir("stormwind")
	if !ok {
		t.Fatal("no stormwind box")
	}
	elwynn, ok := ZoneBoxForDir("elwynn")
	if !ok {
		t.Fatal("no elwynn box")
	}
	centre := func(b zoneBox) (uint16, float64, float64) {
		return b.mapID, (b.xmin + b.xmax) / 2, (b.ymin + b.ymax) / 2
	}
	swMap, swX, swY := centre(sw)
	elMap, elX, elY := centre(elwynn)

	spawns := []store.FactionSpawn{
		{Entry: 68, Map: swMap, X: swX, Y: swY},
		{Entry: 68, Map: swMap, X: swX + 1, Y: swY},
		{Entry: 1423, Map: swMap, X: swX + 2, Y: swY},
		{Entry: 900, Map: elMap, X: elX, Y: elY},
		// Nowhere: no map box contains it, so it must not be counted anywhere.
		{Entry: 1, Map: 900, X: 999999, Y: 999999},
	}

	got := zh.ZoneSpawns(spawns)
	if len(got) != 2 {
		t.Fatalf("zones = %+v, want the two the points stand in", got)
	}
	if got[0].Dir != "stormwind" || got[0].Spawns != 3 || got[0].Kinds != 2 {
		t.Errorf("first zone = %+v, want stormwind 3 spawns / 2 kinds", got[0])
	}
	if got[1].Dir != "elwynn" || got[1].Spawns != 1 || got[1].Kinds != 1 {
		t.Errorf("second zone = %+v, want elwynn 1/1", got[1])
	}
	for _, z := range got {
		if z.Area == 0 {
			t.Errorf("zone %q has no area id", z.Dir)
		}
		if _, ok := ZonePath(z.Dir), true; !ok {
			t.Errorf("zone %q has no page", z.Dir)
		}
	}

	// Busiest first, and the count must not depend on the input order.
	reversed := append([]store.FactionSpawn(nil), spawns...)
	for i, j := 0, len(reversed)-1; i < j; i, j = i+1, j-1 {
		reversed[i], reversed[j] = reversed[j], reversed[i]
	}
	if again := zh.ZoneSpawns(reversed); again[0].Dir != got[0].Dir || again[1].Dir != got[1].Dir {
		t.Errorf("input order changed the result: %+v", again)
	}
}
