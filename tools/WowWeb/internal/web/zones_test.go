package web

import (
	"strings"
	"testing"
)

// TestZoneContentTableParses checks the generated table against the zone list:
// every data line has to turn into a zone, the order has to be the busiest-first
// one the page shows, and every zone has to name an area so its page can be
// linked.
func TestZoneContentTableParses(t *testing.T) {
	if len(zoneContents) == 0 {
		t.Fatal("zonecontent.txt is empty or was not embedded")
	}
	lines, parsed := 0, 0
	for _, line := range strings.Split(zoneContentData, "\n") {
		if line == "" || strings.HasPrefix(line, "#") {
			continue
		}
		lines++
		if field := strings.Split(line, "\t"); len(field) == 8 {
			if _, ok := zoneContents[field[0]]; ok {
				parsed++
			}
		}
	}
	if lines != parsed {
		t.Errorf("zonecontent.txt has %d data lines but %d zones were parsed", lines, parsed)
	}
	if len(zoneOrder) != len(zoneContents) {
		t.Errorf("zoneOrder has %d entries for %d zones", len(zoneOrder), len(zoneContents))
	}
	for i, dir := range zoneOrder {
		z, ok := zoneContents[dir]
		if !ok {
			t.Fatalf("zoneOrder names %q, which is not in the table", dir)
		}
		if i > 0 {
			prev := zoneContents[zoneOrder[i-1]]
			if prev.Spawns() < z.Spawns() {
				t.Errorf("zoneOrder is not busiest first: %s (%d) before %s (%d)",
					prev.Dir, prev.Spawns(), z.Dir, z.Spawns())
			}
		}
		if _, ok := ZoneArea(dir); !ok {
			t.Errorf("zone %q has content but no area id, so it cannot be linked", dir)
		}
		for _, item := range append(append([]zoneEntry{}, z.TopCreatures...), z.TopObjects...) {
			if item.Entry == 0 || item.Dots <= 0 {
				t.Errorf("zone %q has a broken top entry %+v", dir, item)
			}
		}
	}
}

// TestZoneCountsMatchTheSpawns sums the table and compares it with the spawn
// counts the generator reported, so a plumbing mistake in the generator shows up
// here rather than as a quiet wrong number on a page.
func TestZoneCountsMatchTheSpawns(t *testing.T) {
	// 上一轮的实测值：生物 88,818 个刷出点里 362 个落在任何区域框之外，
	// 物件 66,117 个里 634 个；表里是落在区域里的那些。
	creatures, objects := 0, 0
	for _, z := range zoneContents {
		creatures += z.Creatures
		objects += z.Objects
	}
	if creatures != 88818-362 {
		t.Errorf("creature spawns in the table = %d, want %d", creatures, 88818-362)
	}
	if objects != 66117-634 {
		t.Errorf("object spawns in the table = %d, want %d", objects, 66117-634)
	}
}

// TestZoneKnownNumbers pins a few zones' counts: they are large enough that a
// broken join or a lost zone would show, and they are the zones a reader is most
// likely to open first.
func TestZoneKnownNumbers(t *testing.T) {
	cases := []struct {
		dir                string
		creatures, objects int
	}{
		{"barrens", 3716, 2903},
		{"stormwind", 777, 2335},
		{"thalassianhighlands", 1371, 435},
	}
	for _, tc := range cases {
		z, ok := ZoneContent(tc.dir)
		if !ok {
			t.Errorf("zone %q is missing from the table", tc.dir)
			continue
		}
		if z.Creatures != tc.creatures || z.Objects != tc.objects {
			t.Errorf("zone %q = %d creatures / %d objects, want %d / %d",
				tc.dir, z.Creatures, z.Objects, tc.creatures, tc.objects)
		}
		if tc.dir == "barrens" && len(z.TopCreatures) == 0 {
			t.Error("the busiest zone has no top creatures")
		}
	}
}
