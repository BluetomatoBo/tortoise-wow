package web

import (
	"bytes"
	"math"
	"strings"
	"testing"

	"tortoiseweb/internal/i18n"
	"tortoiseweb/internal/store"
)

// TestZoneBoxesLoad checks the table the map generator writes.
func TestZoneBoxesLoad(t *testing.T) {
	if n := MapZoneCount(); n < 100 {
		t.Fatalf("only %d zones loaded; the generator did not run or the file is truncated", n)
	}
	// Elwynn Forest: area 12 on map 0, box from the client's WorldMapArea.dbc.
	box, ok := zoneByArea[12]
	if !ok {
		t.Fatal("zone 12 (Elwynn) is missing")
	}
	if box.mapID != 0 || box.dir != "elwynn" {
		t.Errorf("zone 12 = %+v", box)
	}
	for _, c := range []struct {
		name string
		got  float64
		want float64
	}{
		{"xmin", box.xmin, -10254.17}, {"xmax", box.xmax, -7939.58},
		{"ymin", box.ymin, -1935.42}, {"ymax", box.ymax, 1535.42},
	} {
		if math.Abs(c.got-c.want) > 1 {
			t.Errorf("Elwynn %s = %.2f, want %.2f", c.name, c.got, c.want)
		}
	}
}

// TestMapPointMatchesTheGame is the check that matters: the conversion has to
// agree with the coordinates a player reads in the game, or every dot is a lie.
//
// The Goldshire innkeeper stands at world (-9466.4, 21.4) and the inn is at
// 42, 66 on the Elwynn map. The conversion is the one AoWoW used before this site
// replaced it, including the axis swap - without the swap the same point lands at
// 66.0, 43.6, which is the wrong part of the zone.
func TestMapPointMatchesTheGame(t *testing.T) {
	page := namePage(t, i18n.ZH)

	view, ok := page.MapPoint(0, -9466.4, 21.4)
	if !ok {
		t.Fatal("the Goldshire innkeeper's position did not land in any zone")
	}
	if view.Area != 12 {
		t.Errorf("zone = %d, want 12 (Elwynn)", view.Area)
	}
	if len(view.Markers) != 1 {
		t.Fatalf("markers = %d", len(view.Markers))
	}
	x, y := view.Markers[0].X, view.Markers[0].Y
	if math.Abs(x-42) > 2.5 || math.Abs(y-66) > 2.5 {
		t.Errorf("Goldshire landed at %.1f, %.1f; the game shows 42, 66", x, y)
	}
	// The swap is the part an implementation gets wrong, so pin it: the X axis
	// comes from the world Y.
	if math.Abs(x-66) < 1 {
		t.Errorf("x = %.1f looks like the axes were not swapped", x)
	}
	if !strings.HasPrefix(view.Image, "/assets/maps/") || !strings.HasSuffix(view.Image, ".png") {
		t.Errorf("image = %q", view.Image)
	}
	if view.Name == "" {
		t.Error("the map has no name")
	}
}

// TestZoneAtPicksTheSmallest pins the tie-break: the Elwynn box and the continent
// box both contain an Elwynn point, and the answer has to be Elwynn.
func TestZoneAtPicksTheSmallest(t *testing.T) {
	area, ok := ZoneAt(0, -9466.4, 21.4)
	if !ok || area != 12 {
		t.Errorf("ZoneAt(0, Goldshire) = %d, %v; want 12", area, ok)
	}

	// A Kalimdor point has to answer with a Kalimdor zone - the map id in the
	// lookup is what keeps the two continents apart. (The point used here is in
	// Orgrimmar, whose own box is smaller than Durotar's, so the city is the
	// expected answer; asserting the map is the part that matters.)
	if area, ok := ZoneAt(1, 1600, -4400); !ok || zoneByArea[area].mapID != 1 {
		t.Errorf("ZoneAt(1, Orgrimmar) = %d, %v (map %d); want a map-1 zone",
			area, ok, zoneByArea[area].mapID)
	}

	// Somewhere nothing covers: the middle of the ocean.
	if area, ok := ZoneAt(1, 20000, 20000); ok {
		t.Errorf("a point outside every box matched zone %d", area)
	}
}

// TestZoneAtPrefersTheZoneOverTheContinent is the same tie-break stated the other
// way round: the continent box is huge and must never win over the zone inside it.
func TestZoneAtPrefersTheZoneOverTheContinent(t *testing.T) {
	continent, ok := zoneByArea[0] // area 0 is the "Azeroth" row
	if !ok {
		t.Skip("no continent row")
	}
	zone, ok := zoneByArea[12]
	if !ok {
		t.Fatal("no Elwynn row")
	}
	if !continent.contains(-9466.4, 21.4) {
		t.Skip("the continent box does not cover Elwynn in this data")
	}
	if !zone.better(continent) {
		t.Error("the zone box is not smaller than the continent box")
	}
}

// TestSpawnMapsGroupsByZone covers the creature page's list: spawns in two zones
// become two maps, each with its own dots, and a point with no box is dropped
// rather than drawn somewhere invented.
func TestSpawnMapsGroupsByZone(t *testing.T) {
	page := namePage(t, i18n.ZH)
	views := page.SpawnMaps([]store.CreatureSpawn{
		{Map: 0, X: -9466.4, Y: 21.4}, // Elwynn
		{Map: 0, X: -9450, Y: 30},     // Elwynn again
		{Map: 0, X: -8830, Y: 640},    // Stormwind City
		{Map: 1, X: 20000, Y: 20000},  // nowhere
	})
	if len(views) != 2 {
		t.Fatalf("got %d maps, want 2:\n%+v", len(views), views)
	}
	for _, view := range views {
		if len(view.Markers) == 0 {
			t.Errorf("%s has no dots", view.Name)
		}
		for _, m := range view.Markers {
			if m.X < 0 || m.X > 100 || m.Y < 0 || m.Y > 100 {
				t.Errorf("%s has a dot outside the image: %.1f, %.1f", view.Name, m.X, m.Y)
			}
		}
	}
	// The two Elwynn spawns share one map.
	if views[0].Area == 12 && len(views[0].Markers) != 2 {
		t.Errorf("Elwynn got %d dots, want 2", len(views[0].Markers))
	}
}

// TestPagesDrawMaps checks the wiring end to end on the two pages that have a map.
func TestPagesDrawMaps(t *testing.T) {
	rend, err := newRenderer()
	if err != nil {
		t.Fatal(err)
	}
	page := namePage(t, i18n.ZH)

	render := func(name string, view any) string {
		var buf bytes.Buffer
		if err := rend.cache[name].ExecuteTemplate(&buf, "layout", view); err != nil {
			t.Fatalf("%s: %v", name, err)
		}
		return buf.String()
	}

	spawns := page.SpawnMaps([]store.CreatureSpawn{{Map: 0, X: -9466.4, Y: 21.4}})
	npc := render("db_npc", dbCreatureView{PageData: page,
		Creature: store.ContentCreature{Entry: 295, Name: "旅店老板法雷"}, Spawns: spawns})
	if !strings.Contains(npc, "/assets/maps/elwynn.png") {
		t.Errorf("the creature page draws no map:\n%s", first(npc, 1200))
	}
	if !strings.Contains(npc, "map-dot") {
		t.Errorf("the creature page draws no dot:\n%s", first(npc, 1200))
	}

	point, ok := page.MapPoint(0, -9466.4, 21.4)
	if !ok {
		t.Fatal("no map for the quest point")
	}
	quest := render("db_quest", dbQuestView{PageData: page,
		Quest: store.ContentQuest{Entry: 1, Title: "任务", PointMapID: 0, PointX: -9466.4, PointY: 21.4},
		Point: &point})
	if !strings.Contains(quest, "/assets/maps/elwynn.png") {
		t.Errorf("the quest page draws no map:\n%s", first(quest, 1200))
	}

	// A quest with no point has no map block at all.
	plain := render("db_quest", dbQuestView{PageData: page, Quest: store.ContentQuest{Entry: 2, Title: "无坐标"}})
	if strings.Contains(plain, "/assets/maps/") {
		t.Errorf("a quest without a point drew a map:\n%s", first(plain, 1200))
	}
}

// TestMapFilesExist walks every zone box and checks its image is embedded: the
// boxes and the images are generated separately, and a missing file is a broken
// image on a live page.
func TestMapFilesExist(t *testing.T) {
	for area, box := range zoneByArea {
		if _, err := templateFS.Open("assets/maps/" + box.dir + ".png"); err != nil {
			t.Errorf("zone %d (%s) has no image: %v", area, box.dir, err)
		}
	}
}
