package web

import (
	"strings"
	"testing"

	"tortoiseweb/internal/i18n"
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
