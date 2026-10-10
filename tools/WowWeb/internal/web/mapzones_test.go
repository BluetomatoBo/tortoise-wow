package web

import (
	"bytes"
	"image"
	"image/color"
	"image/png"
	"math"
	"strings"
	"testing"

	"tortoiseweb/internal/i18n"
	"tortoiseweb/internal/store"
)

// boxIn finds one zone's box, the way a test asks for a known one.
func boxIn(t *testing.T, mapID uint16, area uint32) zoneBox {
	t.Helper()
	for _, box := range boxesByMap[mapID] {
		if box.area == area {
			return box
		}
	}
	t.Fatalf("map %d has no box for area %d", mapID, area)
	return zoneBox{}
}

// TestZoneBoxesLoad checks the table the map generator writes.
func TestZoneBoxesLoad(t *testing.T) {
	if n := MapZoneCount(); n < 100 {
		t.Fatalf("only %d zones loaded; the generator did not run or the file is truncated", n)
	}
	// Elwynn Forest: area 12 on map 0, box from the client's WorldMapArea.dbc.
	box := boxIn(t, 0, 12)
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
	if !strings.HasPrefix(view.Image, "/assets/maps/elwynn.png") ||
		!strings.Contains(view.Image, ".png?v=") {
		t.Errorf("image = %q; it needs a version, the maps are cached for an hour", view.Image)
	}
	if view.Name == "" {
		t.Error("the map has no name")
	}
}

// TestZoneAtPicksTheSmallest pins the tie-break: the Elwynn box and the continent
// box both contain an Elwynn point, and the answer has to be Elwynn.
func TestZoneAtPicksTheSmallest(t *testing.T) {
	box, ok := ZoneAt(0, -9466.4, 21.4)
	if !ok || box.area != 12 {
		t.Errorf("ZoneAt(0, Goldshire) = %d, %v; want 12", box.area, ok)
	}

	// A Kalimdor point has to answer with a Kalimdor zone - the map id in the
	// lookup is what keeps the two continents apart. (The point used here is in
	// Orgrimmar, whose own box is smaller than Durotar's, so the city is the
	// expected answer; asserting the map is the part that matters.)
	if box, ok := ZoneAt(1, 1600, -4400); !ok || box.mapID != 1 {
		t.Errorf("ZoneAt(1, Orgrimmar) = %+v, %v; want a map-1 zone", box, ok)
	}

	// Somewhere nothing covers: the middle of the ocean.
	if box, ok := ZoneAt(1, 20000, 20000); ok {
		t.Errorf("a point outside every box matched zone %d", box.area)
	}
}

// TestContinentFallbackUsesItsOwnMap covers the row that catches everything a zone
// box does not. Area 0 exists on both continents - "Azeroth" on map 0 and
// "Kalimdor" on map 1 - and a table keyed by area alone keeps only one of them:
// Kalimdor's row was overwritten by Azeroth's, so the page drew Azeroth's map for a
// Kalimdor point that no zone box claimed.
func TestContinentFallbackUsesItsOwnMap(t *testing.T) {
	kalimdor := boxIn(t, 1, 0)
	if kalimdor.dir != "kalimdor" {
		t.Fatalf("map 1's area-0 row is %q, want the Kalimdor row", kalimdor.dir)
	}
	// The ocean south-west of Kalimdor: inside both continent boxes, and inside no
	// zone box of map 1, so only the continent row can answer for it.
	const x, y = -11733.0, -19199.0
	if _, found := ZoneAt(0, x, y); !found {
		t.Fatal("the point is not in any map-0 box: it does not exercise the fallback")
	}
	view, ok := namePage(t, i18n.ZH).MapPoint(1, x, y)
	if !ok {
		t.Fatalf("no map for the Kalimdor point %.0f, %.0f", x, y)
	}
	if !strings.HasPrefix(view.Image, "/assets/maps/kalimdor.png") {
		t.Errorf("a Kalimdor point fell back to %q", view.Image)
	}
}

// TestZoneAtPrefersTheZoneOverTheContinent is the same tie-break stated the other
// way round: the continent box is huge and must never win over the zone inside it.
func TestZoneAtPrefersTheZoneOverTheContinent(t *testing.T) {
	continent := boxIn(t, 0, 0) // area 0 on map 0 is the "Azeroth" row
	zone := boxIn(t, 0, 12)
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
	checkDotsShareTheImage(t, "the creature page", npc)

	object := render("db_object", dbObjectView{PageData: page,
		Object: store.ContentGameObject{Entry: 1731, Name: "铜矿脉", Type: 3},
		Spawns: page.ObjectSpawnMaps([]store.GameObjectSpawn{{Map: 0, X: -9466.4, Y: 21.4}})})
	if !strings.Contains(object, "/assets/maps/elwynn.png") {
		t.Errorf("the gameobject page draws no map:\n%s", first(object, 1200))
	}
	if !strings.Contains(object, "map-dot") {
		t.Errorf("the gameobject page draws no dot:\n%s", first(object, 1200))
	}
	checkDotsShareTheImage(t, "the gameobject page", object)

	// An object that is only a template has no map block at all.
	unplaced := render("db_object", dbObjectView{PageData: page,
		Object: store.ContentGameObject{Entry: 2, Name: "没有放置的物件"}})
	if strings.Contains(unplaced, "/assets/maps/") {
		t.Errorf("an unplaced gameobject drew a map:\n%s", first(unplaced, 1200))
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

// checkDotsShareTheImage asserts a page's dots are positioned against a box that
// holds nothing but the map image.
//
// The percentage a dot carries is of the artwork, so the element it is absolutely
// positioned in has to be the image and not the figure around it: the figure also
// holds the caption below the picture, which makes it taller, and a dot then lands
// lower than the world coordinate it came from - far enough down that a spawn on a
// zone's southern edge is drawn below the map. The check is the order of the pieces
// in the markup - image, dots, caption - because that is what decides the box the
// browser resolves the percentage against.
func checkDotsShareTheImage(t *testing.T, what, page string) {
	t.Helper()
	frame := strings.Index(page, `class="map-frame"`)
	img := strings.Index(page, "<img src=\"/assets/maps/")
	dot := strings.Index(page, `class="map-dot"`)
	caption := strings.Index(page, "<figcaption>")
	if frame < 0 || img < 0 || dot < 0 {
		t.Errorf("%s: map, image or dot missing (frame %d, img %d, dot %d)", what, frame, img, dot)
		return
	}
	if !(frame < img && img < dot) {
		t.Errorf("%s: the dot is not inside the map frame (frame %d, img %d, dot %d):\n%s",
			what, frame, img, dot, first(page[frame:], 400))
	}
	if caption >= 0 && dot > caption {
		t.Errorf("%s: the dot comes after the caption, so it is a percentage of the figure:\n%s",
			what, first(page[dot:], 300))
	}
}

// TestMapImagesAreTheWholeZone is the check that the maps are the zone and not one
// tile of it.
//
// The client keeps a zone map as twelve 256x256 tiles that it lays out in a 4x3
// grid inside a 1002x668 frame (WorldMapFrame.xml). This site drew tile 1 alone
// for a while, so an NPC page showed the north-west corner of the zone blown up to
// the full width, and every dot - which the server places in percent of the whole
// zone - landed somewhere that corner does not show.
//
// A single tile is square; the frame is not, and is bigger than a tile. Both
// differences are asserted, so a generator that goes back to serving one tile
// fails here.
func TestMapImagesAreTheWholeZone(t *testing.T) {
	checked := 0
	seen := map[string]bool{}
	for _, boxes := range boxesByMap {
		for _, box := range boxes {
			if seen[box.dir] {
				continue
			}
			seen[box.dir] = true
			checkZoneImage(t, box)
			checked++
		}
	}
	if checked < 100 {
		t.Fatalf("only %d maps were checked", checked)
	}
}

// checkZoneImage asserts one map is the whole zone: bigger than a tile, shaped
// like the client's frame, and not blank.
func checkZoneImage(t *testing.T, box zoneBox) {
	t.Helper()
	const frameRatio = 1002.0 / 668.0
	f, err := templateFS.Open("assets/maps/" + box.dir + ".png")
	if err != nil {
		t.Errorf("zone %d (%s) has no image: %v", box.area, box.dir, err)
		return
	}
	img, err := png.Decode(f)
	f.Close()
	if err != nil {
		t.Errorf("zone %d (%s): %v", box.area, box.dir, err)
		return
	}
	bounds := img.Bounds()
	w, h := bounds.Dx(), bounds.Dy()
	if w <= 256 || h <= 256 {
		t.Errorf("zone %d (%s) is %dx%d: that is a tile, not a zone map",
			box.area, box.dir, w, h)
		return
	}
	if ratio := float64(w) / float64(h); math.Abs(ratio-frameRatio) > 0.02 {
		t.Errorf("zone %d (%s) is %dx%d (ratio %.3f, the frame is %.3f)",
			box.area, box.dir, w, h, ratio, frameRatio)
	}
	if colors, spread := imageColours(img); colors < 32 || spread < 8 {
		t.Errorf("zone %d (%s) is nearly blank: %d colours, spread %.1f",
			box.area, box.dir, colors, spread)
	}
}

// imageColours counts the distinct colours of a map and the spread of its
// luminance, which is how a blank or single-colour image is caught.
func imageColours(img image.Image) (int, float64) {
	seen := map[color.RGBA]struct{}{}
	bounds := img.Bounds()
	var sum, sumSq float64
	for y := bounds.Min.Y; y < bounds.Max.Y; y++ {
		for x := bounds.Min.X; x < bounds.Max.X; x++ {
			c := color.RGBAModel.Convert(img.At(x, y)).(color.RGBA)
			seen[c] = struct{}{}
			l := 0.299*float64(c.R) + 0.587*float64(c.G) + 0.114*float64(c.B)
			sum += l
			sumSq += l * l
		}
	}
	n := float64(bounds.Dx() * bounds.Dy())
	mean := sum / n
	variance := sumSq/n - mean*mean
	if variance < 0 {
		variance = 0
	}
	return len(seen), math.Sqrt(variance)
}

// TestTargetMapsLabelsDots covers the quest page's block: the dots have to be
// labelled by the creature or object they belong to, not by a raw coordinate, or
// a map with four dots says nothing about which is which.
func TestTargetMapsLabelsDots(t *testing.T) {
	page := namePage(t, i18n.ZH)
	views := page.TargetMaps([]store.QuestTargetSpawn{
		{Entry: 1561, Name: "血帆劫掠者", Map: 0, X: -9466.4, Y: 21.4},
		{Entry: 1562, Name: "血帆法师", Map: 0, X: -9450, Y: 40},
		{Entry: 4001, Name: "通缉告示", IsGameObject: true, Map: 0, X: -9450, Y: 40},
	})
	if len(views) != 1 {
		t.Fatalf("got %d maps, want 1 (all three points are in Elwynn)", len(views))
	}
	if len(views[0].Markers) != 3 {
		t.Fatalf("got %d dots, want 3", len(views[0].Markers))
	}
	for _, marker := range views[0].Markers {
		if marker.Label == "" {
			t.Errorf("a dot has no label: %+v", marker)
		}
		if strings.Contains(marker.Label, "46") {
			t.Errorf("the dot is labelled with coordinates, not a name: %q", marker.Label)
		}
	}
}

// TestQuestTargetsSplit covers the helper that reads a quest's "kill or collect"
// ids: the core writes a gameobject as the negative of its entry, and a page that
// looks those up as creatures finds nothing.
func TestQuestTargetsSplit(t *testing.T) {
	quest := &store.ContentQuest{
		RequiredMobs: []store.ContentCreatureCount{
			{Entry: 1561, Count: 5},
			{Entry: 4001, IsGameObject: true, Count: 1},
			{Entry: 2546, Count: 2},
		},
	}
	creatures, objects := questTargets(quest)
	if len(creatures) != 2 || creatures[0] != 1561 || creatures[1] != 2546 {
		t.Errorf("creatures = %v", creatures)
	}
	if len(objects) != 1 || objects[0] != 4001 {
		t.Errorf("objects = %v", objects)
	}
}

// TestZoneFixCorrectsAMarginBox pins the reported bug and the two cases that must
// not change.
//
// The boxes come from WorldMapArea.dbc, which is the extent of a zone's map
// *artwork* - it carries a margin of the neighbours - so a small box can cover a
// neighbour's land as nothing but margin. Scarlet Enclave (a custom zone) does
// exactly that to Eastern Plaguelands, and the smallest box used to win: a
// Gibbering Ghoul at Tyr's Hand was drawn on the Scarlet Enclave map.
func TestZoneFixCorrectsAMarginBox(t *testing.T) {
	cases := []struct {
		what  string
		mapID uint16
		x, y  float64
		want  string
	}{
		{"呢喃食尸鬼（提尔之手，东瘟疫之地）", 0, 2020.03, -4481.07, "easternplaguelands"},
		{"提尔之手一带", 0, 2300, -4300, "easternplaguelands"},
		{"迷失船员（血色领地自己的内容）", 0, 2269.49, -6149.63, "scarletenclave"},
		{"暴风城守卫（城市套在艾尔文森林里，不动）", 0, -8800, 600, "stormwind"},
		{"奥格瑞玛（套在杜隆塔尔里，不动）", 1, 1700, -4400, "orgrimmar"},
		{"幽暗城（套在提瑞斯法林地里，不动）", 0, 1600, 240, "undercity"},
	}
	for _, tc := range cases {
		box, ok := ZoneAt(tc.mapID, tc.x, tc.y)
		if !ok {
			t.Errorf("%s: no zone for (%.0f, %.0f) on map %d", tc.what, tc.x, tc.y, tc.mapID)
			continue
		}
		if box.dir != tc.want {
			t.Errorf("%s: (%.0f, %.0f) on map %d is %s, want %s",
				tc.what, tc.x, tc.y, tc.mapID, box.dir, tc.want)
		}
	}
}

// TestZoneFixTableIsUsable checks the embedded correction table against the box
// table: every entry has to name a zone that exists on that map, or a lookup
// would fall through and the file would be dead weight nobody noticed.
func TestZoneFixTableIsUsable(t *testing.T) {
	if len(zoneFix) == 0 {
		t.Fatal("zonefix.txt is empty or was not embedded")
	}
	// A row the parser skips is a correction that silently does nothing, so the
	// table has to hold every data line the file carries.
	want := 0
	for _, line := range strings.Split(zoneFixData, "\n") {
		if line != "" && !strings.HasPrefix(line, "#") {
			want++
		}
	}
	if len(zoneFix) != want {
		t.Errorf("zonefix.txt has %d data lines but %d entries were parsed", want, len(zoneFix))
	}
	for cell, area := range zoneFix {
		found := false
		for _, box := range boxesByMap[cell.mapID] {
			if box.area == area {
				found = true
				break
			}
		}
		if !found {
			t.Errorf("cell %+v corrects to area %d, which has no box on map %d",
				cell, area, cell.mapID)
		}
	}
}

// TestZoneGridPicksTheClientsOwnZone covers the area grid: the game itself reads
// the MCNK areaid out of the map files (GridMap::getArea), and the page now asks
// the same grid first, so a globally spread object - a small thorium vein is the
// one that was reported - stops landing on whichever neighbour's box is smallest.
func TestZoneGridPicksTheClientsOwnZone(t *testing.T) {
	cases := []struct {
		what  string
		mapID uint16
		x, y  float64
		want  string
	}{
		{"闪金镇旅店", 0, -9466.4, 21.4, "elwynn"},
		{"暴风城", 0, -8800, 600, "stormwind"},
		{"奥格瑞玛", 1, 1700, -4400, "orgrimmar"},
		{"呢喃食尸鬼（提尔之手）", 0, 2020.03, -4481.07, "easternplaguelands"},
		{"瑟银矿·塔纳利斯", 1, -8311, -2296, "tanaris"},
		// 这一格在拉皮迪斯岛的框里，旁边就是乌龟服自定义的哈祖里食人妖：自定义区域的内容
		// 站在老区域的地形上（地形网格会说荆棘谷），修正表把它判回岛上。
		{"瑟银矿·拉皮迪斯岛一带", 0, -12164.3, 3604.4, "lapidis"},
		{"瑟银矿·燃烧平原", 0, -8078, -2229, "burningsteppes"},
		{"瑟银矿·安戈洛环形山", 1, -6279, -1266, "ungorocrater"},
	}
	for _, tc := range cases {
		box, ok := ZoneAt(tc.mapID, tc.x, tc.y)
		if !ok {
			t.Errorf("%s: no zone for (%.0f, %.0f) on map %d", tc.what, tc.x, tc.y, tc.mapID)
			continue
		}
		if box.dir != tc.want {
			t.Errorf("%s: (%.0f, %.0f) on map %d is %s, want %s",
				tc.what, tc.x, tc.y, tc.mapID, box.dir, tc.want)
		}
	}
}

// TestZoneGridTableIsUsable checks the embedded grid against the boxes: every
// directory it names has to be a zone with a map, the runs have to be sorted and
// non-empty, and every data line has to have been parsed - a row silently dropped
// is a part of the world that quietly goes back to the box rule.
func TestZoneGridTableIsUsable(t *testing.T) {
	if len(zoneGrid) == 0 {
		t.Fatal("zonegrid.txt is empty or was not embedded")
	}
	rows := 0
	for _, line := range strings.Split(zoneGridData, "\n") {
		if line != "" && !strings.HasPrefix(line, "#") {
			rows++
		}
	}
	if len(zoneGrid) != rows {
		t.Errorf("zonegrid.txt has %d rows but %d were parsed", rows, len(zoneGrid))
	}
	for key, runs := range zoneGrid {
		if len(runs) == 0 {
			t.Errorf("grid row %+v has no runs", key)
		}
		for i, run := range runs {
			if _, ok := boxesByDir[key.mapID][run.dir]; !ok {
				t.Errorf("grid row %+v names zone %q, which has no map on map %d",
					key, run.dir, key.mapID)
			}
			if run.end <= run.start {
				t.Errorf("grid row %+v has an empty run %+v", key, run)
			}
			if i > 0 && run.start < runs[i-1].end {
				t.Errorf("grid row %+v has overlapping or unsorted runs: %+v then %+v",
					key, runs[i-1], run)
			}
		}
	}
}

// TestZoneFixFollowsTheBoxMargins pins the second round of corrections: a zone's
// box is its map artwork, so its *edges* lie over the neighbour's land. The cells
// a city's or a dungeon's box covers at its margin are the neighbour's ground -
// Defias diggers outside the Deadmines, Gnarlpine furbolgs outside Darnassus -
// and the ones a custom zone's box covers are its own content.
func TestZoneFixFollowsTheBoxMargins(t *testing.T) {
	cases := []struct {
		what  string
		mapID uint16
		x, y  float64
		want  string
	}{
		{"死亡矿井门口的地表（迪菲亚工人）", 0, -11350, 1517, "westfall"},
		{"暴风城南门外（迪菲亚盗贼、野兔）", 0, -9150, 50, "elwynn"},
		{"幽暗城外的提瑞斯法地表", 0, 1483, -50, "tirisfal"},
		{"达纳苏斯城外的泰达希尔地表（Gnarlpine 熊怪）", 1, 9550, 1883, "teldrassil"},
		{"黑石山塔边的采石场", 0, -7783, -1417, "burningsteppes"},
		{"卡兹莫丹机场（铁炉堡一侧）", 0, -5017, 1317, "dunmorogh"},
		{"黑石岛海面（乌龟服自定义）", 1, -683, -6917, "blackstoneisland"},
		{"吉尔尼斯半岛（乌龟服自定义）", 0, -1661.41, 1100.33, "gilneas"},
	}
	for _, tc := range cases {
		box, ok := ZoneAt(tc.mapID, tc.x, tc.y)
		if !ok {
			t.Errorf("%s: no zone for (%.0f, %.0f) on map %d", tc.what, tc.x, tc.y, tc.mapID)
			continue
		}
		if box.dir != tc.want {
			t.Errorf("%s: (%.0f, %.0f) on map %d is %s, want %s",
				tc.what, tc.x, tc.y, tc.mapID, box.dir, tc.want)
		}
	}
}

// TestZoneFixCoversCustomZonesTerrainDoesNotKnow pins the two zone pairs the
// operator checked on the site: content of a custom zone standing on terrain the
// vanilla tiles still describe as its neighbour.
//
// Eastern Plaguelands' box and the terrain grid both still call the ground north
// of Tyr's Hand "Eastern Plaguelands", but what stands there is Thalassian
// Highland content (Thalassian Sentinel, Silver Covenant Recruit, mana wyrms).
// The same for the Blacksand operation (a Venture Co. mine) the terrain places in
// Ashenvale while the content is Stonetalon's.
func TestZoneFixCoversCustomZonesTerrainDoesNotKnow(t *testing.T) {
	cases := []struct {
		what  string
		mapID uint16
		x, y  float64
		want  string
	}{
		{"萨拉斯高地的萨拉斯哨兵一带", 0, 2916.7, -3950.0, "thalassianhighlands"},
		{"萨拉斯高地北部", 0, 2916.7, -3716.7, "thalassianhighlands"},
		{"石爪山的黑沙矿点一带", 1, 2150.0, 2183.3, "stonetalonmountains"},
		{"石爪山黑沙矿点（南）", 1, 2150.0, 2283.3, "stonetalonmountains"},
	}
	for _, tc := range cases {
		box, ok := ZoneAt(tc.mapID, tc.x, tc.y)
		if !ok {
			t.Errorf("%s: no zone for (%.0f, %.0f) on map %d", tc.what, tc.x, tc.y, tc.mapID)
			continue
		}
		if box.dir != tc.want {
			t.Errorf("%s: (%.0f, %.0f) on map %d is %s, want %s",
				tc.what, tc.x, tc.y, tc.mapID, box.dir, tc.want)
		}
	}
}

// TestZoneFixSplitsACityFromItsWild covers Alah'Thalas, a custom blood elf city whose
// box lies entirely inside Thalassian Highlands: the terrain grid does not know the
// city at all, so the nested-box rule used to hand it every spawn in the box - the
// treants, boars and Thalassian Sentinels patrolling outside were drawn on the city
// map. The rule now keeps a cell on the city map only when at least half of what
// stands in it is the city's own (citizens, bankers, blood elf furniture); the rest
// goes to the highlands, which is what the client shows out there.
func TestZoneFixSplitsACityFromItsWild(t *testing.T) {
	cases := []struct {
		what  string
		mapID uint16
		x, y  float64
		want  string
	}{
		{"萨拉斯哨兵（城外的巡逻）", 0, 4007, -2677, "thalassianhighlands"},
		{"萨拉斯树人（城西的林子）", 0, 3900, -2400, "thalassianhighlands"},
		{"拍卖师瑞琳（城里）", 0, 4265, -2848, "alahthalas"},
		{"银行家莎兰娜（城里）", 0, 4262, -2842, "alahthalas"},
		{"城区中心", 0, 4300, -2800, "alahthalas"},
	}
	for _, tc := range cases {
		box, ok := ZoneAt(tc.mapID, tc.x, tc.y)
		if !ok {
			t.Errorf("%s: no zone for (%.0f, %.0f) on map %d", tc.what, tc.x, tc.y, tc.mapID)
			continue
		}
		if box.dir != tc.want {
			t.Errorf("%s: (%.0f, %.0f) on map %d is %s, want %s",
				tc.what, tc.x, tc.y, tc.mapID, box.dir, tc.want)
		}
	}
}
