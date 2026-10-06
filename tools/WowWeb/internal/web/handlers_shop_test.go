package web

import (
	"net/http"
	"net/http/httptest"
	"net/url"
	"strings"
	"testing"

	"tortoiseweb/internal/i18n"
	"tortoiseweb/internal/store"
)

// TestParseShopItemForm covers the checks that keep the world server from
// silently dropping a row.
//
// Every one of these mirrors a condition in ObjectMgr's loader that logs a line
// and skips the entry, with nothing shown in game: a price of 0, a missing
// category, a missing item_template row, a duplicate item. The form has to
// refuse them, because the failure is invisible otherwise.
func TestParseShopItemForm(t *testing.T) {
	form := func(values map[string]string) *http.Request {
		v := url.Values{}
		for k, val := range values {
			v.Set(k, val)
		}
		r := httptest.NewRequest(http.MethodPost, "/admin/shop/new", strings.NewReader(v.Encode()))
		r.Header.Set("Content-Type", "application/x-www-form-urlencoded")
		return r
	}
	valid := map[string]string{
		"category": "5", "entry": "50071", "price": "50", "region": "0",
		"model_id": "0", "item_id": "0", "scale": "1",
	}

	t.Run("accepts a complete form", func(t *testing.T) {
		in, problems := parseShopItemForm(form(valid))
		if len(problems) != 0 {
			t.Fatalf("problems = %v, want none", problems)
		}
		if in.Category != 5 || in.Entry != 50071 || in.Price != 50 || in.Region != 0 {
			t.Errorf("parsed wrong: %+v", in)
		}
	})

	cases := []struct {
		name  string
		patch map[string]string
		want  string
	}{
		// price 0 is skipped by the loader with "price is 0, skipping".
		{"price zero", map[string]string{"price": "0"}, "price"},
		{"price empty", map[string]string{"price": ""}, "price"},
		{"price negative", map[string]string{"price": "-5"}, "price"},
		{"entry zero", map[string]string{"entry": "0"}, "entry"},
		{"entry empty", map[string]string{"entry": ""}, "entry"},
		{"category empty", map[string]string{"category": ""}, "category"},
		{"category out of range", map[string]string{"category": "300"}, "category"},
		{"region unknown", map[string]string{"region": "9"}, "region"},
		{"region empty", map[string]string{"region": ""}, "region"},
		{"description too long", map[string]string{"description": strings.Repeat("x", 501)}, "description"},
		{"chinese description too long", map[string]string{"description_loc4": strings.Repeat("字", 501)}, "description"},
	}
	for _, tc := range cases {
		t.Run(tc.name, func(t *testing.T) {
			values := map[string]string{}
			for k, v := range valid {
				values[k] = v
			}
			for k, v := range tc.patch {
				values[k] = v
			}
			_, problems := parseShopItemForm(form(values))
			if !strings.Contains(strings.Join(problems, ","), tc.want) {
				t.Errorf("problems = %v, want one mentioning %q", problems, tc.want)
			}
		})
	}

	t.Run("floats default instead of failing", func(t *testing.T) {
		values := map[string]string{}
		for k, v := range valid {
			values[k] = v
		}
		delete(values, "scale")
		values["position_x"] = "not a number"
		in, problems := parseShopItemForm(form(values))
		if len(problems) != 0 {
			t.Fatalf("problems = %v, want none", problems)
		}
		if in.Scale != 1 {
			t.Errorf("scale = %v, want the default 1", in.Scale)
		}
		if in.X != 0 {
			t.Errorf("position_x = %v, want 0", in.X)
		}
	})
}

// TestShopTemplatesRender executes both pages. Parsing is covered by the
// renderer's own tests; running the templates is what catches a bad function
// call or a nil dereference inside them.
func TestShopTemplatesRender(t *testing.T) {
	rend, err := newRenderer()
	if err != nil {
		t.Fatalf("parse templates: %v", err)
	}
	bundle, err := i18n.Load()
	if err != nil {
		t.Fatalf("load i18n: %v", err)
	}
	tr := bundle.Translator(i18n.EN)
	base := func() PageData {
		return PageData{Year: 2026, Tr: tr, Config: PageConfig{SiteName: "Test Realm"}}
	}
	render := func(name string, data any) string {
		t.Helper()
		rec := httptest.NewRecorder()
		rend.Render(rec, http.StatusOK, name, data)
		if rec.Code != http.StatusOK {
			t.Fatalf("render %s: status %d", name, rec.Code)
		}
		return rec.Body.String()
	}

	t.Run("list", func(t *testing.T) {
		cat := uint8(5)
		page := base()
		page.Title = tr.T("shop.title")
		body := render("admin_shop", shopListView{
			PageData: page,
			Categories: []store.ShopCategory{
				{ID: 5, Name: "Mounts", NameCN: "坐骑", Icon: "mount", Items: 57},
			},
			Items: []store.ShopItem{
				{ID: 12, Category: 5, Entry: 50071, Price: 50, Region: store.ShopRegionGlobal,
					ItemName: "Ivory Raptor", ItemNameCN: "象牙陆行鸟", Scale: 1},
				{ID: 13, Category: 5, Entry: 50072, Price: 60, Region: store.ShopRegionChina,
					ItemName: "Hidden One", Scale: 1},
				{ID: 14, Category: 5, Entry: 99999, Price: 70, Region: store.ShopRegionEurope, Scale: 1},
			},
			FilterCategory: &cat, Total: 3, Page: 1, Pages: 1,
			RealmRegion: store.ShopRegionEurope,
		})
		for _, want := range []string{
			"象牙陆行鸟",               // the Chinese name is what a Chinese realm shows
			"Ivory Raptor",        // and the English one stays visible next to it
			"shop.notOnThisRealm", // placeholder check below is the real assertion
		} {
			if want == "shop.notOnThisRealm" {
				continue
			}
			if !strings.Contains(body, want) {
				t.Errorf("list page is missing %q", want)
			}
		}
		// The China-locked and Europe-locked rows must be flagged, the Global one
		// must not: a mismatched region means the client never sees the item.
		if n := strings.Count(body, tr.T("shop.notOnThisRealm")); n != 1 {
			t.Errorf("rows flagged as hidden from this realm = %d, want 1", n)
		}
		// An entry with no item_template row has to be visible as broken.
		if !strings.Contains(body, tr.T("shop.itemMissing")) {
			t.Error("a row without an item_template entry is not flagged")
		}
	})

	t.Run("edit form", func(t *testing.T) {
		page := base()
		body := render("admin_shop_item", shopItemView{
			PageData: page,
			Item: store.ShopItem{ID: 12, Category: 5, Entry: 50071, Price: 50,
				Region: store.ShopRegionGlobal, Scale: 1},
			Categories: []store.ShopCategory{{ID: 5, Name: "Mounts", NameCN: "坐骑"}},
			Regions:    (&Server{}).shopRegions(),
			ItemName:   "Ivory Raptor",
			Warnings:   []string{"⚠ test warning"},
		})
		for _, want := range []string{
			"Ivory Raptor",
			`name="entry"`, `name="price"`, `name="region"`, `name="scale"`,
			tr.T("shop.item.textHint"),
			"⚠ test warning",
			"/admin/shop/items/12/delete",
		} {
			if !strings.Contains(body, want) {
				t.Errorf("edit form is missing %q", want)
			}
		}
	})

	t.Run("new form", func(t *testing.T) {
		page := base()
		body := render("admin_shop_item", shopItemView{
			PageData:   page,
			IsNew:      true,
			Item:       store.ShopItem{Region: store.ShopRegionGlobal, Scale: 1},
			Categories: []store.ShopCategory{{ID: 1, Name: "Miscellaneous", NameCN: "杂项"}},
			Regions:    (&Server{}).shopRegions(),
		})
		if !strings.Contains(body, `action="/admin/shop/new"`) {
			t.Error("new form does not post to /admin/shop/new")
		}
		if strings.Contains(body, "/delete") {
			t.Error("new form offers a delete action for a row that does not exist yet")
		}
	})
}
