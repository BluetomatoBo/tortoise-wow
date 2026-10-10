package web

import (
	_ "embed"
	"math"
	"strconv"
	"strings"

	"tortoiseweb/internal/store"
)

// Placing world coordinates on a zone map.
//
// The database gives a spawn as (map, x, y) in world coordinates; the map image
// the client draws covers a box of that same space, and the box is in the
// client's WorldMapArea.dbc (see gen_maps.py for how the four floats are read -
// they are rotated against the axes, which is why the conversion below swaps them).
//
// The percentages are of the picture the client draws, which is the whole zone and
// not one of its tiles: gen_maps.py assembles the twelve pieces the client keeps
// (a 4x3 grid, see WorldMapFrame.xml) into the 1002x668 frame before scaling it
// down. Drawing a percentage on a single corner tile - which this site did until
// the maps were checked against that XML - puts every dot in the wrong place.
//
// The conversion is the one the AoWoW this site replaces used:
//
//	x% = 100 - (y - yMin) / (yMax - yMin) * 100
//	y% = 100 - (x - xMin) / (xMax - xMin) * 100
//
// Checked against the game: the Goldshire innkeeper stands at world
// (-9466.4, 21.4) and the inn sits at 42, 66 on the Elwynn map. These boxes put it
// at 43.6, 66.0.

//go:embed mapzones.txt
var mapZonesData string

// zoneFixData is the overlap correction table from gen_zonefix.py: cells where
// the smallest box is known to be the wrong zone.
//
// The boxes are the extent of a zone's map *artwork*, which carries a margin of
// the neighbouring zones, so neighbours overlap and "the smallest box wins" is
// wrong wherever a small box only covers a neighbour's land as margin. The file
// holds the cells where that was checked and corrected by hand; everywhere else
// the box rule stands.
//
//go:embed zonefix.txt
var zoneFixData string

// mapImage is the URL of a zone's map.
//
// The version is the same one the stylesheet carries and it matters more here:
// map images live at paths that never change, they are served with an hour of
// cache, and they are seventeen megabytes of artwork - so after a regeneration a
// visitor would otherwise be shown the previous build's maps, which is a map at
// the wrong size with the dots in the wrong places.
func mapImage(dir string) string {
	return "/assets/maps/" + dir + ".png?v=" + assetVersion
}

// zoneBox is one zone's map and the world box it covers.
type zoneBox struct {
	area                   uint32
	dir                    string
	mapID                  uint16
	xmin, xmax, ymin, ymax float64
}

var (
	// boxesByMap holds every box of a map id. A map can carry its own fallback
	// row - area 0, "Azeroth" on map 0 and "Kalimdor" on map 1 - which is why the
	// table is keyed by the map and not by the area: the same area id names a
	// different box on each continent, and a lookup that ignored the map answered a
	// Kalimdor point with Azeroth's box and Azeroth's picture.
	boxesByMap = map[uint16][]zoneBox{}
	boxCount   int

	// zoneFix holds the corrected cells: a map + cell -> the area that cell
	// really belongs to. It is keyed by a struct so a lookup needs no string.
	zoneFix = map[zoneFixCell]uint32{}
)

// zoneFixCellSize is the side of a correction cell, in world yards. It has to
// match gen_zonefix.py.
const zoneFixCellSize = 128

// zoneFixCell names one cell of one map. The coordinates are floored division of
// the world coordinates, so they can be negative.
type zoneFixCell struct {
	mapID  uint16
	cx, cy int32
}

func zoneFixKey(mapID uint16, x, y float64) zoneFixCell {
	return zoneFixCell{
		mapID: mapID,
		cx:    int32(math.Floor(x / zoneFixCellSize)),
		cy:    int32(math.Floor(y / zoneFixCellSize)),
	}
}

func init() {
	for _, line := range strings.Split(mapZonesData, "\n") {
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}
		field := strings.Split(line, "\t")
		if len(field) != 7 {
			continue
		}
		area, err := strconv.ParseUint(field[0], 10, 32)
		if err != nil {
			continue
		}
		mapID, err := strconv.ParseUint(field[2], 10, 16)
		if err != nil {
			continue
		}
		box := zoneBox{area: uint32(area), dir: field[1], mapID: uint16(mapID)}
		if box.xmin, err = strconv.ParseFloat(field[3], 64); err != nil {
			continue
		}
		if box.xmax, err = strconv.ParseFloat(field[4], 64); err != nil {
			continue
		}
		if box.ymin, err = strconv.ParseFloat(field[5], 64); err != nil {
			continue
		}
		if box.ymax, err = strconv.ParseFloat(field[6], 64); err != nil {
			continue
		}
		boxesByMap[box.mapID] = append(boxesByMap[box.mapID], box)
		boxCount++
	}

	for _, line := range strings.Split(zoneFixData, "\n") {
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}
		field := strings.Split(line, "\t")
		if len(field) != 4 {
			continue
		}
		mapID, err := strconv.ParseUint(field[0], 10, 16)
		if err != nil {
			continue
		}
		cx, err := strconv.ParseInt(field[1], 10, 32)
		if err != nil {
			continue
		}
		cy, err := strconv.ParseInt(field[2], 10, 32)
		if err != nil {
			continue
		}
		area, err := strconv.ParseUint(field[3], 10, 32)
		if err != nil {
			continue
		}
		zoneFix[zoneFixCell{mapID: uint16(mapID), cx: int32(cx), cy: int32(cy)}] = uint32(area)
	}
}

// MapMarker is one point on a map, in percent of the image.
type MapMarker struct {
	X, Y  float64
	Label string
}

// MapView is a map image with the points that fall on it.
type MapView struct {
	Area    uint32
	Image   string
	Name    string
	Markers []MapMarker
}

// Contains reports whether a world point is inside the box.
func (b zoneBox) contains(x, y float64) bool {
	return x >= b.xmin && x <= b.xmax && y >= b.ymin && y <= b.ymax
}

// better reports whether b is a more specific box than best, so that a scan can
// keep the smallest one. (The name is extent, not area: `area` here is the zone's
// id.)
func (b zoneBox) better(best zoneBox) bool {
	return b.extent() < best.extent()
}

func (b zoneBox) extent() float64 {
	return (b.xmax - b.xmin) * (b.ymax - b.ymin)
}

// marker puts a world point on this box, in percent.
func (b zoneBox) marker(x, y float64) (float64, float64) {
	px := 100 - (y-b.ymin)/(b.ymax-b.ymin)*100
	py := 100 - (x-b.xmin)/(b.xmax-b.xmin)*100
	return px, py
}

// ZoneAt finds the zone a world point falls into on a map.
//
// Several boxes can contain it - a zone and the continent it sits on, or two
// neighbours that overlap at the edge - and the smallest is the one whose map the
// client would show for that point. The box is returned rather than its area,
// because an area id alone does not say which map it was matched on.
//
// The correction table is consulted first: a cell listed there has been checked
// by hand (see gen_zonefix.py), because the box rule reads a zone's map artwork
// extent and a small box can cover a neighbour's land as nothing but margin. A
// corrected area that does not actually contain the point falls through to the
// box rule, so a stale table can only lose an improvement, never invent a zone.
func ZoneAt(mapID uint16, x, y float64) (zoneBox, bool) {
	if area, ok := zoneFix[zoneFixKey(mapID, x, y)]; ok {
		for _, box := range boxesByMap[mapID] {
			if box.area == area && box.contains(x, y) {
				return box, true
			}
		}
	}
	return zoneBoxAt(mapID, x, y)
}

func zoneBoxAt(mapID uint16, x, y float64) (zoneBox, bool) {
	var (
		best  zoneBox
		found bool
	)
	for _, box := range boxesByMap[mapID] {
		if !box.contains(x, y) {
			continue
		}
		if !found || box.better(best) {
			best, found = box, true
		}
	}
	return best, found
}

// MapPoint is where a world point lands on the map of the zone it is in.
// The percentages are what a template puts in style="left:..%;top:..%".
func (p PageData) MapPoint(mapID uint16, x, y float64) (MapView, bool) {
	box, ok := ZoneAt(mapID, x, y)
	if !ok {
		return MapView{}, false
	}
	px, py := box.marker(x, y)
	view := MapView{
		Area:  box.area,
		Image: mapImage(box.dir),
		Name:  p.AreaName(box.area),
	}
	view.Markers = append(view.Markers, MapMarker{X: round2(px), Y: round2(py)})
	return view, true
}

// SpawnMaps groups a creature's spawn points by the zone they are in, so the page
// can draw one map per zone with a dot for each spawn.
//
// Points on a map with no zone box are dropped: a coordinate that cannot be
// placed would otherwise be drawn at a made-up position.
func (p PageData) SpawnMaps(spawns []store.CreatureSpawn) []MapView {
	points := make([]mapPoint, 0, len(spawns))
	for _, spawn := range spawns {
		points = append(points, mapPoint{
			Map: spawn.Map, X: spawn.X, Y: spawn.Y,
			Label: strconv.FormatFloat(spawn.X, 'f', 1, 64) + ", " +
				strconv.FormatFloat(spawn.Y, 'f', 1, 64),
		})
	}
	return p.mapViews(points)
}

// ObjectSpawnMaps groups a gameobject's placements by the zone they are in. It
// works the same way the creature list does, and for the same reason: a zone's
// points belong on that zone's artwork.
func (p PageData) ObjectSpawnMaps(spawns []store.GameObjectSpawn) []MapView {
	points := make([]mapPoint, 0, len(spawns))
	for _, spawn := range spawns {
		points = append(points, mapPoint{
			Map: spawn.Map, X: spawn.X, Y: spawn.Y,
			Label: strconv.FormatFloat(spawn.X, 'f', 1, 64) + ", " +
				strconv.FormatFloat(spawn.Y, 'f', 1, 64),
		})
	}
	return p.mapViews(points)
}

// TargetMaps groups where a quest's targets live, one map per zone, with each dot
// labelled by the creature or object it is.
func (p PageData) TargetMaps(targets []store.QuestTargetSpawn) []MapView {
	points := make([]mapPoint, 0, len(targets))
	for _, target := range targets {
		points = append(points, mapPoint{
			Map: target.Map, X: target.X, Y: target.Y, Label: target.Name,
		})
	}
	return p.mapViews(points)
}

// mapPoint is a world position with the label its dot carries.
type mapPoint struct {
	Map   uint16
	X, Y  float64
	Label string
}

// mapViews is the grouping both of the above share.
func (p PageData) mapViews(points []mapPoint) []MapView {
	var views []MapView
	byBox := map[zoneBox]int{}

	for _, point := range points {
		box, ok := ZoneAt(point.Map, point.X, point.Y)
		if !ok {
			continue
		}
		px, py := box.marker(point.X, point.Y)
		marker := MapMarker{X: round2(px), Y: round2(py), Label: point.Label}

		if at, seen := byBox[box]; seen {
			views[at].Markers = append(views[at].Markers, marker)
			continue
		}
		byBox[box] = len(views)
		views = append(views, MapView{
			Area:    box.area,
			Image:   mapImage(box.dir),
			Name:    p.AreaName(box.area),
			Markers: []MapMarker{marker},
		})
	}
	return views
}

// MapPointLabel is the caption for a single quest objective point.
func (p PageData) MapPointLabel(mapID uint16, x, y float64) string {
	box, ok := ZoneAt(mapID, x, y)
	if !ok {
		return ""
	}
	px, py := box.marker(x, y)
	return p.AreaName(box.area) + " " + strconv.FormatFloat(round2(px), 'f', 1, 64) +
		", " + strconv.FormatFloat(round2(py), 'f', 1, 64)
}

// round2 keeps the percentages at two decimals: a style attribute does not need
// more, and it keeps the rendered HTML stable in tests.
func round2(v float64) float64 {
	return math.Round(v*100) / 100
}

// MapZoneCount reports how many zones have a box, for the tests.
func MapZoneCount() int { return boxCount }
