package web

import (
	"fmt"
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

	t.Run("negative ids clamp instead of wrapping", func(t *testing.T) {
		// min="0" in the form is a hint to the browser; a hand-made POST is not
		// bound by it, and uint32(-1) is 4294967295 - a real value to the core.
		values := map[string]string{}
		for k, v := range valid {
			values[k] = v
		}
		values["model_id"] = "-1"
		values["item_id"] = "-7"
		in, problems := parseShopItemForm(form(values))
		if len(problems) != 0 {
			t.Fatalf("problems = %v, want none", problems)
		}
		if in.ModelID != 0 || in.ItemDisplayID != 0 {
			t.Errorf("negative ids became model_id=%d item_id=%d, want 0 and 0",
				in.ModelID, in.ItemDisplayID)
		}
	})

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
			// The select has to carry the categories, or none can be chosen.
			`<select name="category">`,
			`value="5"`,
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
		if !strings.Contains(body, `value="1"`) {
			t.Error("new form's category select has no options")
		}
		// A new row has nothing to preserve, so it must not be warned about.
		if strings.Contains(body, tr.T("shop.item.categoryMissing")) {
			t.Error("new form warns about a category that does not exist yet")
		}
	})

	// A row whose category was removed from shop_categories must keep showing
	// that value; otherwise the select displays its first entry and saving
	// silently moves the row into it.
	t.Run("edit form keeps an unknown category", func(t *testing.T) {
		page := base()
		body := render("admin_shop_item", shopItemView{
			PageData: page,
			Item: store.ShopItem{ID: 12, Category: 99, Entry: 50071, Price: 50,
				Region: store.ShopRegionGlobal, Scale: 1},
			Categories: []store.ShopCategory{{ID: 5, Name: "Mounts", NameCN: "坐骑"}},
			Regions:    (&Server{}).shopRegions(),
		})
		if !strings.Contains(body, `value="99" selected`) {
			t.Error("the row's own category is not the selected option")
		}
		if !strings.Contains(body, tr.T("shop.item.categoryMissing")) {
			t.Error("a category that no longer exists is not flagged")
		}
	})

	// The pager used to print "%!s(int=1)" because the catalogue string had %s
	// for the two integers the partial passes. The shared partial is used by the
	// account, ban and character lists too, so this guards all four pages.
	t.Run("pagination", func(t *testing.T) {
		page := base()
		body := render("admin_shop", shopListView{
			PageData: page,
			Items: []store.ShopItem{{ID: 1, Category: 5, Entry: 50071, Price: 1,
				Region: store.ShopRegionGlobal, Scale: 1}},
			Total: 244, Page: 2, Pages: 10,
			QueryString: "category=5&",
			RealmRegion: store.ShopRegionEurope,
		})
		if strings.Contains(body, "%!") {
			t.Errorf("pager has a format error: %s",
				firstLineContaining(body, "%!"))
		}
		if want := "page 2 of 10"; !strings.Contains(body, want) {
			t.Errorf("pager does not read %q", want)
		}
		// The links have to carry the filters through. A plain string in href is
		// percent-encoded by html/template (= &), which collapses the whole
		// query into one parameter and makes every page link a no-op, so assert
		// the encoded forms are absent rather than merely looking for "page=3".
		for _, want := range []string{
			`href="?category=5&amp;page=1"`,
			`href="?category=5&amp;page=3"`,
		} {
			if !strings.Contains(body, want) {
				t.Errorf("pager is missing %s", want)
			}
		}
		for _, bad := range []string{"%3d", "%3D", "%26"} {
			if strings.Contains(body, bad) {
				t.Errorf("pager link is double-escaped (%s): %s",
					bad, firstLineContaining(body, bad))
			}
		}
	})
}

// firstLineContaining digs out the offending line so a failure shows the text.
func firstLineContaining(body, needle string) string {
	for _, line := range strings.Split(body, "\n") {
		if strings.Contains(line, needle) {
			return strings.TrimSpace(line)
		}
	}
	return "(not found)"
}

// TestShopFormViewKeepsCategories pins the bug that made a category impossible
// to choose: the form's view assembly used to overwrite view.Categories with
// nil after the handler had loaded them, so the select rendered empty.
func TestShopFormViewKeepsCategories(t *testing.T) {
	bundle, err := i18n.Load()
	if err != nil {
		t.Fatalf("load i18n: %v", err)
	}
	page := PageData{Year: 2026, Tr: bundle.Translator(i18n.ZH)}
	cats := []store.ShopCategory{
		{ID: 1, Name: "Miscellaneous", NameCN: "杂项"},
		{ID: 5, Name: "Mounts", NameCN: "坐骑"},
	}
	regions := (&Server{}).shopRegions()

	v := shopFormView(page, shopItemView{}, cats, regions, store.ShopRegionChina, true, true)
	if len(v.Categories) != 2 {
		t.Fatalf("categories = %d, want 2 - they did not reach the form", len(v.Categories))
	}
	if len(v.Regions) != 3 {
		t.Errorf("regions = %d, want 3", len(v.Regions))
	}
	if v.RealmRegion != store.ShopRegionChina || !v.RealmIsChinese {
		t.Errorf("realm flags not applied: region=%d chinese=%v", v.RealmRegion, v.RealmIsChinese)
	}
	if v.Title == "" || v.Active != "admin-shop" {
		t.Errorf("page not set up: title=%q active=%q", v.Title, v.Active)
	}

	// A new row with no category must start on a real one: 0 does not exist, and
	// the core drops a row whose category it cannot find.
	if v.Item.Category != 1 {
		t.Errorf("new row did not default to the first category, got %d", v.Item.Category)
	}
	// ...but an existing row keeps whatever it has, even if it is gone.
	existing := shopFormView(page, shopItemView{Item: store.ShopItem{Category: 99}},
		cats, regions, store.ShopRegionEurope, false, false)
	if existing.Item.Category != 99 {
		t.Errorf("existing row's category was rewritten to %d", existing.Item.Category)
	}
}

func TestShopCategoryNameAndKnown(t *testing.T) {
	cats := []store.ShopCategory{
		{ID: 5, Name: "Mounts", NameCN: "坐骑"},
		{ID: 9, Name: "Special", NameCN: ""},
	}

	zh := shopListView{Categories: cats, RealmIsChinese: true}
	if got := zh.CategoryName(5); got != "坐骑" {
		t.Errorf("zh CategoryName(5) = %q, want 坐骑", got)
	}
	if got := zh.CategoryName(9); got != "Special" {
		t.Errorf("CategoryName falls back to the English name, got %q", got)
	}
	if got := zh.CategoryName(42); got != "#42" {
		t.Errorf("CategoryName(unknown) = %q, want #42", got)
	}
	en := shopListView{Categories: cats}
	if got := en.CategoryName(5); got != "Mounts" {
		t.Errorf("en CategoryName(5) = %q, want Mounts", got)
	}

	if !(shopItemView{Categories: cats, Item: store.ShopItem{Category: 5}}).CategoryKnown() {
		t.Error("a category present in the list is reported as missing")
	}
	if (shopItemView{Categories: cats, Item: store.ShopItem{Category: 42}}).CategoryKnown() {
		t.Error("a category absent from the list is reported as known")
	}
	if (shopItemView{Categories: cats, Item: store.ShopItem{Category: 0}}).CategoryKnown() {
		t.Error("category 0 is reported as known")
	}
}

// TestParseShopCategoryForm covers the rules that keep a category from breaking
// the client. Two of them are refusals; the icon name is only a warning.
func TestParseShopCategoryForm(t *testing.T) {
	form := func(values map[string]string) *http.Request {
		v := url.Values{}
		for k, val := range values {
			v.Set(k, val)
		}
		r := httptest.NewRequest(http.MethodPost, "/admin/shop/categories/new", strings.NewReader(v.Encode()))
		r.Header.Set("Content-Type", "application/x-www-form-urlencoded")
		return r
	}
	valid := map[string]string{"name": "Mounts", "name_loc4": "坐骑", "icon": "mount"}

	t.Run("accepts a complete form", func(t *testing.T) {
		in, problems, warnings := parseShopCategoryForm(form(valid))
		if len(problems) != 0 || len(warnings) != 0 {
			t.Fatalf("problems = %v, warnings = %v, want none", problems, warnings)
		}
		if in.Name != "Mounts" || in.NameCN != "坐骑" || in.Icon != "mount" {
			t.Errorf("parsed wrong: %+v", in)
		}
		if in.ID != 0 {
			t.Errorf("id should stay 0 for the table to assign, got %d", in.ID)
		}
	})

	t.Run("id is optional but bounded", func(t *testing.T) {
		in, problems, _ := parseShopCategoryForm(form(withValues(valid, map[string]string{"id": "200"})))
		if len(problems) != 0 || in.ID != 200 {
			t.Errorf("id 200: problems = %v, id = %d", problems, in.ID)
		}
		// The core reads the column with GetUInt8; 256 would be truncated and
		// the tab would no longer match the rows pointing at it.
		for _, raw := range []string{"0", "256", "-1", "abc"} {
			_, problems, _ := parseShopCategoryForm(form(withValues(valid, map[string]string{"id": raw})))
			if !contains(problems, "id") {
				t.Errorf("id %q was accepted", raw)
			}
		}
	})

	// One of these characters in a name or an icon does not break one category,
	// it breaks every category the server sends after it.
	t.Run("refuses the addon string separators", func(t *testing.T) {
		cases := []map[string]string{
			{"name": "Mounts=mine"},
			{"name": "Mounts;mine"},
			{"name_loc4": "坐骑=我的"},
			{"name_loc4": "坐骑;我的"},
			{"icon": "mount;ticket"},
			{"icon": "mount=ticket"},
		}
		for _, patch := range cases {
			_, problems, _ := parseShopCategoryForm(form(withValues(valid, patch)))
			if !contains(problems, "separator") {
				t.Errorf("%v was accepted", patch)
			}
		}
	})

	t.Run("requires a name and an icon", func(t *testing.T) {
		for _, patch := range []map[string]string{
			{"name": "", "name_loc4": ""},
			{"icon": ""},
			{"icon": "   "},
		} {
			_, problems, _ := parseShopCategoryForm(form(withValues(valid, patch)))
			if len(problems) == 0 {
				t.Errorf("%v was accepted", patch)
			}
		}
		// One language is enough: the client falls back to whichever is set.
		if _, problems, _ := parseShopCategoryForm(form(
			withValues(valid, map[string]string{"name": "", "name_loc4": "坐骑"}))); len(problems) != 0 {
			t.Errorf("a Chinese-only name was refused: %v", problems)
		}
	})

	// An unknown icon is allowed - adding your own artwork is legitimate - but
	// it has to be visible that the tab will be blank until then.
	t.Run("unknown icon warns instead of refusing", func(t *testing.T) {
		_, problems, warnings := parseShopCategoryForm(form(
			withValues(valid, map[string]string{"icon": "wormhole"})))
		if len(problems) != 0 {
			t.Errorf("problems = %v, want none", problems)
		}
		if !contains(warnings, "iconUnknown") {
			t.Errorf("warnings = %v, want iconUnknown", warnings)
		}
		if !shopIconKnown("MOUNT") {
			t.Error("the known-icon check should ignore case")
		}
		for _, icon := range shopCategoryIcons {
			if !shopIconKnown(icon) {
				t.Errorf("%q is listed as a known icon but not recognised", icon)
			}
		}
	})
}

// withValues copies base and applies patch, so a case only states what it changes.
func withValues(base, patch map[string]string) map[string]string {
	out := map[string]string{}
	for k, v := range base {
		out[k] = v
	}
	for k, v := range patch {
		out[k] = v
	}
	return out
}

func contains(list []string, want string) bool {
	for _, s := range list {
		if s == want {
			return true
		}
	}
	return false
}

// TestShopCategoryTemplatesRender runs both category pages, including the
// branch that refuses to offer a delete.
func TestShopCategoryTemplatesRender(t *testing.T) {
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
		body := render("admin_shop_categories", shopCategoryListView{
			PageData: base(),
			Categories: []store.ShopCategory{
				{ID: 5, Name: "Mounts", NameCN: "坐骑", Icon: "mount", Items: 57},
				// No texture ships for this one, so the row has to say so.
				{ID: 34, Name: "Toys", NameCN: "", Icon: "wormhole", Items: 0},
			},
		})
		for _, want := range []string{
			"Mounts", "坐骑", "mount", "wormhole",
			`href="/admin/shop?category=5"`,     // item count links to the filtered list
			`href="/admin/shop/categories/34"`,  // per-row edit
			`href="/admin/shop/categories/new"`, // and the create button
			tr.T("shop.cat.iconUnknown"),        // the missing texture is flagged
			tr.T("shop.cat.aboutHint"),          // About is not a row in this table
		} {
			if !strings.Contains(body, want) {
				t.Errorf("category list is missing %q", want)
			}
		}
	})

	t.Run("edit form", func(t *testing.T) {
		body := render("admin_shop_category", shopCategoryFormView(base(), shopCategoryView{
			Category:  store.ShopCategory{ID: 5, Name: "Mounts", NameCN: "坐骑", Icon: "mount", Items: 57},
			ItemCount: 57,
		}, shopCategoryIcons, false, false))
		for _, want := range []string{
			`action="/admin/shop/categories/5"`,
			`name="name"`, `name="name_loc4"`, `name="icon"`,
			`value="Mounts"`, `value="mount"`,
			// The hint spells out the texture path the client builds; assert the
			// stable part, since <icon> is escaped by html/template.
			`Interface\ShopFrame\`,
			`.blp`,
			// 57 items point here, so the delete form must not be offered.
			fmt.Sprintf("<strong>%d</strong>", 57),
			tr.T("shop.cat.deleteBlocked"),
		} {
			if !strings.Contains(body, want) {
				t.Errorf("category form is missing %q", want)
			}
		}
		if strings.Contains(body, "/delete") {
			t.Error("the form offers a delete for a category that still has items")
		}
		// The id is not editable: changing it would orphan the items.
		if strings.Contains(body, `name="id"`) {
			t.Error("the edit form offers to change the id")
		}
	})

	t.Run("empty category can be deleted", func(t *testing.T) {
		body := render("admin_shop_category", shopCategoryFormView(base(), shopCategoryView{
			Category: store.ShopCategory{ID: 34, Name: "Toys", Icon: "toys"},
		}, shopCategoryIcons, false, false))
		if !strings.Contains(body, `action="/admin/shop/categories/34/delete"`) {
			t.Error("a category nothing points at should offer a delete")
		}
		if strings.Contains(body, tr.T("shop.cat.deleteBlocked")) {
			t.Error("an empty category is reported as in use")
		}
	})

	t.Run("new form", func(t *testing.T) {
		body := render("admin_shop_category", shopCategoryFormView(base(), shopCategoryView{
			Category: store.ShopCategory{Icon: "default"},
		}, shopCategoryIcons, false, true))
		for _, want := range []string{
			`action="/admin/shop/categories/new"`,
			`name="id"`, // assignable on create so the tab order can be chosen
			`value="default"`,
			tr.T("shop.cat.idHint"),
		} {
			if !strings.Contains(body, want) {
				t.Errorf("new category form is missing %q", want)
			}
		}
		if strings.Contains(body, "/delete") {
			t.Error("the new form offers a delete")
		}
		// Every known icon is offered, so a blank tab is a choice, not a guess.
		for _, icon := range shopCategoryIcons {
			if !strings.Contains(body, `value="`+icon+`"`) {
				t.Errorf("icon %q is not suggested", icon)
			}
		}
	})
}

// TestCategoryIDFromPath pins the narrowing: uint8(300) is 44, so the check has
// to happen before the conversion rather than after it.
func TestCategoryIDFromPath(t *testing.T) {
	cases := []struct {
		in    uint32
		want  uint8
		valid bool
	}{
		{0, 0, true}, // "create"
		{1, 1, true},
		{255, 255, true},
		{256, 0, false}, // truncates to 0 - would look like "create"
		{300, 0, false}, // truncates to 44 - a different category entirely
		{4294967295, 0, false},
	}
	for _, tc := range cases {
		got, ok := categoryIDFromPath(tc.in)
		if ok != tc.valid {
			t.Errorf("categoryIDFromPath(%d) valid = %v, want %v", tc.in, ok, tc.valid)
			continue
		}
		if ok && got != tc.want {
			t.Errorf("categoryIDFromPath(%d) = %d, want %d", tc.in, got, tc.want)
		}
	}
}
