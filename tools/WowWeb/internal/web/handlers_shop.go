package web

import (
	"errors"
	"fmt"
	"html/template"
	"net/http"
	"strconv"
	"strings"

	"tortoiseweb/internal/store"
)

// The donation shop is edited from the admin area. Two things shape this page
// more than anything else:
//
//  1. The core loads both tables into memory and answers the client from there.
//     Nothing here is live on its own, and it is not obvious how to make it so:
//     the world server does have `.reload shop`, which clears both maps and
//     reads them again. The page says that rather than leaving an administrator
//     to restart mangosd - or to wonder why nothing happened.
//
//  2. Most ways of getting a row wrong are silent - the core logs one line and
//     drops it, and the item simply is not in the shop. So the form refuses
//     those cases instead: a price of zero, a duplicate item entry, a category
//     that does not exist, an item_template entry that does not exist. The
//     region mismatch is the one that cannot be refused (the row is legitimate,
//     just invisible on this realm), so it is reported as a warning.

const shopPageSize = 25

// ---------------------------------------------------------------------------
// List
// ---------------------------------------------------------------------------

type shopListView struct {
	PageData
	Categories []store.ShopCategory
	Items      []store.ShopItem

	FilterCategory *uint8
	Search         string
	Total          int
	Page           int
	Pages          int
	QueryString    template.URL

	// RealmRegion is what the core believes this realm is, from its own config;
	// an item locked to another region never reaches the client.
	RealmRegion uint8
	// RealmIsChinese mirrors the core's `NiHao` key, which decides whether the
	// client is sent the _loc4 names.
	RealmIsChinese bool
}

func (s *Server) handleAdminShop(w http.ResponseWriter, r *http.Request, page *PageData) {
	ctx := r.Context()
	q := r.URL.Query()

	filter := store.ShopItemFilter{
		Search: strings.TrimSpace(q.Get("q")),
		Limit:  shopPageSize,
		Region: s.realmRegion(),
	}
	if catStr := q.Get("category"); catStr != "" {
		if cat, err := strconv.Atoi(catStr); err == nil && cat >= 0 && cat <= 255 {
			c := uint8(cat)
			filter.Category = &c
		}
	}
	pageNum := atoiDefault(q.Get("page"), 1)
	if pageNum < 1 {
		pageNum = 1
	}
	filter.Offset = (pageNum - 1) * shopPageSize

	categories, err := s.store.ShopCategories(ctx)
	if err != nil {
		s.serverError(w, r, "list shop categories", err)
		return
	}
	items, total, err := s.store.ShopItems(ctx, filter)
	if err != nil {
		s.serverError(w, r, "list shop items", err)
		return
	}

	page.Title = page.T("shop.title")
	page.Active = "admin-shop"
	s.rend.Render(w, http.StatusOK, "admin_shop", shopListView{
		PageData:       *page,
		Categories:     categories,
		Items:          items,
		FilterCategory: filter.Category,
		Search:         filter.Search,
		Total:          total,
		Page:           pageNum,
		Pages:          pages(total, shopPageSize),
		QueryString:    baseQuery(r),
		RealmRegion:    s.realmRegion(),
		RealmIsChinese: s.realmIsChinese(),
	})
}

// ---------------------------------------------------------------------------
// Form (new and edit share it)
// ---------------------------------------------------------------------------

type shopItemView struct {
	PageData
	IsNew      bool
	Item       store.ShopItem
	Input      store.ShopItemInput
	Categories []store.ShopCategory
	Regions    []shopRegionOption

	// Referenced is the item_template row the entry points at, when it is known.
	ItemName    string
	ItemMissing bool

	Error string
	// Warnings are conditions that will not stop the row from working, but that
	// an administrator should see now rather than in game.
	Warnings []string

	RealmRegion    uint8
	RealmIsChinese bool
}

// shopRegionOption is one entry of the region select. There is no per-option
// hint: a <select> cannot show one, and shop.item.regionHint already explains
// what the field does.
type shopRegionOption struct {
	Value uint8
	Key   string
}

// CategoryName resolves a row's category id to the name the realm would show.
// The list used to print the bare id, so "5" appeared where the client says
// 坐骑 - the one column that has a name worth reading.
func (v shopListView) CategoryName(id uint8) string {
	for _, c := range v.Categories {
		if c.ID == id {
			return c.LocalizedName(v.RealmIsChinese)
		}
	}
	return fmt.Sprintf("#%d", id)
}

// CategoryKnown reports whether this row's category exists in shop_categories.
// The core drops a row whose category does not, so the form has to keep such a
// value visible: without this the <select> would show its first entry as
// selected and saving would quietly move the row to that category. The template
// only renders the placeholder for an existing row; a new one has nothing to
// preserve and simply starts on a real category.
func (v shopItemView) CategoryKnown() bool {
	for _, c := range v.Categories {
		if c.ID == v.Item.Category {
			return true
		}
	}
	return false
}

func (s *Server) shopRegions() []shopRegionOption {
	return []shopRegionOption{
		{store.ShopRegionGlobal, "shop.region.global"},
		{store.ShopRegionEurope, "shop.region.europe"},
		{store.ShopRegionChina, "shop.region.china"},
	}
}

func (s *Server) realmRegion() uint8 {
	if strings.EqualFold(strings.TrimSpace(s.cfg.ShopRegion), "china") {
		return store.ShopRegionChina
	}
	return store.ShopRegionEurope
}

// realmIsChinese mirrors the core's NiHao key. It is a separate setting because
// a realm can be the Chinese region without the client being sent Chinese
// names, and the shop list shows both.
func (s *Server) realmIsChinese() bool {
	return s.realmRegion() == store.ShopRegionChina
}

func (s *Server) renderShopForm(w http.ResponseWriter, r *http.Request, page *PageData, view shopItemView, status int) {
	s.rend.Render(w, status, "admin_shop_item", view)
}

// shopFormView assembles everything the item form needs.
//
// It is separate from the handler, and takes the categories as an argument, for
// one reason: this is where the category list was once dropped, which left the
// <select> empty and made a category impossible to choose. A function that
// cannot silently lose its input, and that a test can call without a database,
// is the fix - the previous version took an already-built view and overwrote
// view.Categories with nil.
func shopFormView(page PageData, view shopItemView, categories []store.ShopCategory,
	regions []shopRegionOption, realmRegion uint8, realmIsChinese bool, isNew bool) shopItemView {
	page.Title = page.T("shop.item.title")
	page.Active = "admin-shop"

	view.PageData = page
	view.Categories = categories
	view.Regions = regions
	view.RealmRegion = realmRegion
	view.RealmIsChinese = realmIsChinese
	view.IsNew = isNew

	// A new row needs a real category selected: 0 is not one, and the loader
	// drops a row whose category does not exist. Only fall back when nothing
	// valid was asked for.
	if isNew && !view.CategoryKnown() && len(categories) > 0 {
		view.Item.Category = categories[0].ID
	}
	return view
}

func (s *Server) handleAdminShopNewForm(w http.ResponseWriter, r *http.Request, page *PageData) {
	categories, err := s.store.ShopCategories(r.Context())
	if err != nil {
		s.serverError(w, r, "list shop categories", err)
		return
	}
	view := shopItemView{
		Item: store.ShopItem{Region: store.ShopRegionGlobal, Scale: 1},
	}
	// A prefilled category when arriving from a filtered list.
	if catStr := r.URL.Query().Get("category"); catStr != "" {
		if cat, err := strconv.Atoi(catStr); err == nil && cat >= 0 && cat <= 255 {
			view.Item.Category = uint8(cat)
		}
	}
	view = shopFormView(*page, view, categories, s.shopRegions(), s.realmRegion(),
		s.realmIsChinese(), true)
	s.renderShopForm(w, r, page, view, http.StatusOK)
}

func (s *Server) handleAdminShopItemForm(w http.ResponseWriter, r *http.Request, page *PageData) {
	id, ok := s.parseUintPath(r, "id")
	if !ok {
		return
	}
	ctx := r.Context()
	item, err := s.store.ShopItem(ctx, id)
	if errors.Is(err, store.ErrNotFound) {
		s.notFound(w, r)
		return
	} else if err != nil {
		s.serverError(w, r, "load shop item", err)
		return
	}
	categories, err := s.store.ShopCategories(ctx)
	if err != nil {
		s.serverError(w, r, "list shop categories", err)
		return
	}

	view := shopItemView{Item: item}
	if tmpl, err := s.store.ItemTemplate(ctx, item.Entry); err == nil {
		view.ItemName = tmpl.DisplayName()
	} else if errors.Is(err, store.ErrNotFound) {
		view.ItemMissing = true
	}
	view = shopFormView(*page, view, categories, s.shopRegions(), s.realmRegion(),
		s.realmIsChinese(), false)
	s.renderShopForm(w, r, page, view, http.StatusOK)
}

// ---------------------------------------------------------------------------
// Save
// ---------------------------------------------------------------------------

func (s *Server) handleAdminShopNewSubmit(w http.ResponseWriter, r *http.Request, page *PageData) {
	if !s.checkCSRF(w, r) {
		return
	}
	s.saveShopItem(w, r, page, 0)
}

func (s *Server) handleAdminShopItemSubmit(w http.ResponseWriter, r *http.Request, page *PageData) {
	if !s.checkCSRF(w, r) {
		return
	}
	id, ok := s.parseUintPath(r, "id")
	if !ok {
		return
	}
	s.saveShopItem(w, r, page, id)
}

// saveShopItem validates and writes, for both the create and the edit path.
func (s *Server) saveShopItem(w http.ResponseWriter, r *http.Request, page *PageData, id uint32) {
	ctx := r.Context()
	actor := accountFrom(ctx)

	input, problems := parseShopItemForm(r)
	warnings := []string{}

	// Referential checks that only the database can answer. Each one mirrors a
	// condition the core silently drops a row for.
	if input.Category != 0 || len(problems) == 0 {
		if ok, err := s.store.ShopCategoryExists(ctx, input.Category); err != nil {
			s.serverError(w, r, "check shop category", err)
			return
		} else if !ok {
			problems = append(problems, page.T("shop.err.noCategory"))
		}
	}
	if input.Entry != 0 {
		if _, err := s.store.ItemTemplate(ctx, input.Entry); err != nil {
			if errors.Is(err, store.ErrNotFound) {
				problems = append(problems, page.T("shop.err.noItem"))
			} else {
				s.serverError(w, r, "check item template", err)
				return
			}
		}
		if owner, err := s.store.ShopEntryOwner(ctx, input.Entry, id); err != nil {
			s.serverError(w, r, "check duplicate shop entry", err)
			return
		} else if owner != 0 {
			problems = append(problems, fmt.Sprintf(page.T("shop.err.duplicateEntry"), owner))
		}
	}
	// A row locked to the other region never reaches this realm's client.
	if input.Region != store.ShopRegionGlobal && input.Region != s.realmRegion() {
		warnings = append(warnings, fmt.Sprintf(page.T("shop.warn.otherRegion"),
			page.T("shop.region."+store.ShopRegionName(input.Region)),
			page.T("shop.region."+store.ShopRegionName(s.realmRegion()))))
	}
	if input.Scale == 0 {
		warnings = append(warnings, page.T("shop.warn.scaleZero"))
	}

	if len(problems) > 0 {
		view := shopItemView{Input: input, Warnings: warnings, Error: strings.Join(problems, "；")}
		view.Item = store.ShopItem{ID: id, Category: input.Category, Entry: input.Entry,
			ModelID: input.ModelID, ItemDisplayID: input.ItemDisplayID,
			Description: input.Description, DescriptionCN: input.DescriptionCN,
			Price: input.Price, Region: input.Region,
			X: input.X, Y: input.Y, Z: input.Z, Rotation: input.Rotation, Scale: input.Scale}
		if tmpl, err := s.store.ItemTemplate(ctx, input.Entry); err == nil {
			view.ItemName = tmpl.DisplayName()
		}
		categories, err := s.store.ShopCategories(ctx)
		if err != nil {
			s.serverError(w, r, "list shop categories", err)
			return
		}
		view = shopFormView(*page, view, categories, s.shopRegions(), s.realmRegion(),
			s.realmIsChinese(), id == 0)
		s.renderShopForm(w, r, page, view, http.StatusBadRequest)
		return
	}

	if id == 0 {
		newID, err := s.store.CreateShopItem(ctx, input)
		if err != nil {
			s.serverError(w, r, "create shop item", err)
			return
		}
		_ = s.store.Audit(ctx, actor.ID, actor.Username, "shop-item-create", fmt.Sprintf("shop_items/%d", newID),
			fmt.Sprintf("entry=%d category=%d price=%d region=%s", input.Entry, input.Category, input.Price,
				store.ShopRegionName(input.Region)), s.clientIP(r))
		s.setFlash(w, "ok", fmt.Sprintf(page.T("shop.flash.created"), input.Entry))
	} else {
		if err := s.store.UpdateShopItem(ctx, id, input); err != nil {
			if errors.Is(err, store.ErrNotFound) {
				s.notFound(w, r)
				return
			}
			s.serverError(w, r, "update shop item", err)
			return
		}
		_ = s.store.Audit(ctx, actor.ID, actor.Username, "shop-item-update", fmt.Sprintf("shop_items/%d", id),
			fmt.Sprintf("entry=%d category=%d price=%d region=%s", input.Entry, input.Category, input.Price,
				store.ShopRegionName(input.Region)), s.clientIP(r))
		s.setFlash(w, "ok", fmt.Sprintf(page.T("shop.flash.updated"), input.Entry))
	}
	if len(warnings) > 0 {
		s.setFlash(w, "warn", strings.Join(warnings, "；"))
	}
	http.Redirect(w, r, "/admin/shop", http.StatusSeeOther)
}

func (s *Server) handleAdminShopItemDelete(w http.ResponseWriter, r *http.Request, page *PageData) {
	if !s.checkCSRF(w, r) {
		return
	}
	id, ok := s.parseUintPath(r, "id")
	if !ok {
		return
	}
	ctx := r.Context()
	actor := accountFrom(ctx)

	item, err := s.store.ShopItem(ctx, id)
	if errors.Is(err, store.ErrNotFound) {
		s.notFound(w, r)
		return
	} else if err != nil {
		s.serverError(w, r, "load shop item", err)
		return
	}
	if err := s.store.DeleteShopItem(ctx, id); err != nil {
		if errors.Is(err, store.ErrNotFound) {
			s.notFound(w, r)
			return
		}
		s.serverError(w, r, "delete shop item", err)
		return
	}
	_ = s.store.Audit(ctx, actor.ID, actor.Username, "shop-item-delete", fmt.Sprintf("shop_items/%d", id),
		fmt.Sprintf("entry=%d price=%d", item.Entry, item.Price), s.clientIP(r))
	s.setFlash(w, "ok", fmt.Sprintf(page.T("shop.flash.deleted"), item.Entry))
	http.Redirect(w, r, "/admin/shop", http.StatusSeeOther)
}

// ---------------------------------------------------------------------------
// Form parsing
// ---------------------------------------------------------------------------

// parseShopItemForm reads the form and applies every rule that does not need
// the database. It is deliberately free of HTTP side effects so it can be
// tested directly - these are the checks that keep the core from silently
// dropping a row.
func parseShopItemForm(r *http.Request) (store.ShopItemInput, []string) {
	var in store.ShopItemInput
	var problems []string

	cat, err := strconv.Atoi(strings.TrimSpace(r.PostFormValue("category")))
	if err != nil || cat < 0 || cat > 255 {
		problems = append(problems, "category")
	} else {
		in.Category = uint8(cat)
	}

	entry, err := strconv.Atoi(strings.TrimSpace(r.PostFormValue("entry")))
	if err != nil || entry <= 0 {
		problems = append(problems, "entry")
	} else {
		in.Entry = uint32(entry)
	}

	in.ModelID = uintFromForm(r.PostFormValue("model_id"))
	in.ItemDisplayID = uintFromForm(r.PostFormValue("item_id"))

	price, err := strconv.Atoi(strings.TrimSpace(r.PostFormValue("price")))
	if err != nil || price <= 0 {
		// The core skips a zero price with an error in its log, so a shop item
		// without a price is not a shop item.
		problems = append(problems, "price")
	} else {
		in.Price = uint32(price)
	}

	region, err := strconv.Atoi(strings.TrimSpace(r.PostFormValue("region")))
	if err != nil || region < 0 || region > 2 {
		problems = append(problems, "region")
	} else {
		in.Region = uint8(region)
	}

	in.Description = strings.TrimSpace(r.PostFormValue("description"))
	in.DescriptionCN = strings.TrimSpace(r.PostFormValue("description_loc4"))

	in.X = floatDefault(r.PostFormValue("position_x"), 0)
	in.Y = floatDefault(r.PostFormValue("position_y"), 0)
	in.Z = floatDefault(r.PostFormValue("position_z"), 0)
	in.Rotation = floatDefault(r.PostFormValue("rotation"), 0)
	in.Scale = floatDefault(r.PostFormValue("scale"), 1)

	// The entry string the core builds for the client is capped at 1024 bytes
	// and truncated silently, so keep the free text well inside that.
	if len(in.Description) > 500 || len(in.DescriptionCN) > 500 {
		problems = append(problems, "description")
	}
	return in, problems
}

// uintFromForm reads a non-negative integer field. Full atoiDefault is wrong
// here: it hands back -1 for "-1", and uint32(-1) is 4294967295, which would be
// written to the display-id column as a real value. The form's min="0" is a
// hint to the browser, not a guarantee about what arrives.
func uintFromForm(s string) uint32 {
	if n := atoiDefault(s, 0); n > 0 {
		return uint32(n)
	}
	return 0
}

func floatDefault(s string, def float64) float64 {
	s = strings.TrimSpace(s)
	if s == "" {
		return def
	}
	v, err := strconv.ParseFloat(s, 64)
	if err != nil {
		return def
	}
	return v
}

// ---------------------------------------------------------------------------
// Categories
// ---------------------------------------------------------------------------
//
// Three rules shape this form, all of them from the loader and the client:
//
//  1. The id has to fit in a byte. ObjectMgr reads it with GetUInt8() while the
//     column is int unsigned, so 300 is silently truncated and the tab no longer
//     matches the rows that point at it.
//
//  2. The whole category list reaches the client as one addon string built here:
//     "id=0=name=icon;" repeated. The client splits it on ';' and then on '=',
//     so an '=' or ';' inside a name or an icon does not break one category, it
//     breaks every category that follows.
//
//  3. The icon is a filename: the client calls
//     SetTexture("Interface\\ShopFrame\\" .. icon). A name with no file behind it
//     leaves the tab blank. The list below is every named .blp in that folder,
//     so the common case is a choice rather than a guess - but it stays a
//     warning, because adding artwork of your own is legitimate.
var shopCategoryIcons = []string{
	"about", "bag", "default", "free", "mount", "pet",
	"scroll", "service", "tabard", "ticket", "toys",
}

func shopIconKnown(icon string) bool {
	for _, known := range shopCategoryIcons {
		if strings.EqualFold(strings.TrimSpace(icon), known) {
			return true
		}
	}
	return false
}

// shopCategorySeparators are the two characters the addon string cannot carry.
const shopCategorySeparators = "=;"

func hasCategorySeparator(s string) bool { return strings.ContainsAny(s, shopCategorySeparators) }

type shopCategoryView struct {
	PageData
	IsNew          bool
	Category       store.ShopCategory
	Input          store.ShopCategoryInput
	Icons          []string
	RealmIsChinese bool

	Error    string
	Warnings []string
	// ItemCount is how many rows point at this category, for the delete hint.
	ItemCount int
}

type shopCategoryListView struct {
	PageData
	Categories     []store.ShopCategory
	RealmIsChinese bool
}

// categoryIDFromPath narrows an id from the URL to what the core can read.
//
// The conversion has to be checked first: uint8(300) is 44, so a hand-made URL
// would quietly edit a different category instead of failing.
func categoryIDFromPath(id uint32) (uint8, bool) {
	if id > 255 {
		return 0, false
	}
	return uint8(id), true
}

// IconKnown reports whether the icon is one of the names the client ships a
// texture for, so the list can flag the ones that would render blank.
func (v shopCategoryListView) IconKnown(icon string) bool { return shopIconKnown(icon) }

// parseShopCategoryForm validates what the form sent. The two separator checks
// and the id range are refusals; the icon is not, because the list of names in
// the client is not the only source of artwork.
func parseShopCategoryForm(r *http.Request) (store.ShopCategoryInput, []string, []string) {
	var in store.ShopCategoryInput
	var problems, warnings []string

	in.Name = strings.TrimSpace(r.PostFormValue("name"))
	in.NameCN = strings.TrimSpace(r.PostFormValue("name_loc4"))
	in.Icon = strings.TrimSpace(r.PostFormValue("icon"))

	if in.Name == "" && in.NameCN == "" {
		problems = append(problems, "name")
	}
	if hasCategorySeparator(in.Name) || hasCategorySeparator(in.NameCN) {
		problems = append(problems, "separator")
	}
	if in.Icon == "" {
		problems = append(problems, "icon")
	} else if hasCategorySeparator(in.Icon) {
		problems = append(problems, "separator")
	} else if !shopIconKnown(in.Icon) {
		warnings = append(warnings, "iconUnknown")
	}

	if raw := strings.TrimSpace(r.PostFormValue("id")); raw != "" {
		n, err := strconv.Atoi(raw)
		if err != nil || n < 1 || n > 255 {
			problems = append(problems, "id")
		} else {
			in.ID = uint8(n)
		}
	}
	return in, problems, warnings
}

func (s *Server) renderShopCategoryForm(w http.ResponseWriter, r *http.Request, page *PageData, view shopCategoryView, status int) {
	s.rend.Render(w, status, "admin_shop_category", view)
}

// shopCategoryFormView is the category form's assembly, deliberately shaped like
// shopFormView: the caller cannot lose what it loaded.
func shopCategoryFormView(page PageData, view shopCategoryView, icons []string, realmIsChinese bool, isNew bool) shopCategoryView {
	page.Title = page.T("shop.cat.title")
	page.Active = "admin-shop"

	view.PageData = page
	view.Icons = icons
	view.RealmIsChinese = realmIsChinese
	view.IsNew = isNew
	return view
}

func (s *Server) handleAdminShopCategories(w http.ResponseWriter, r *http.Request, page *PageData) {
	categories, err := s.store.ShopCategories(r.Context())
	if err != nil {
		s.serverError(w, r, "list shop categories", err)
		return
	}
	page.Title = page.T("shop.cat.title")
	page.Active = "admin-shop"
	s.rend.Render(w, http.StatusOK, "admin_shop_categories", shopCategoryListView{
		PageData:       *page,
		Categories:     categories,
		RealmIsChinese: s.realmIsChinese(),
	})
}

func (s *Server) handleAdminShopCategoryNewForm(w http.ResponseWriter, r *http.Request, page *PageData) {
	view := shopCategoryFormView(*page, shopCategoryView{Category: store.ShopCategory{Icon: "default"}},
		shopCategoryIcons, s.realmIsChinese(), true)
	s.renderShopCategoryForm(w, r, page, view, http.StatusOK)
}

func (s *Server) handleAdminShopCategoryForm(w http.ResponseWriter, r *http.Request, page *PageData) {
	rawID, ok := s.parseUintPath(r, "id")
	if !ok {
		return
	}
	id, ok := categoryIDFromPath(rawID)
	if !ok {
		// The column holds more, but the core does not read more.
		s.notFound(w, r)
		return
	}
	cat, err := s.store.ShopCategory(r.Context(), id)
	if errors.Is(err, store.ErrNotFound) {
		s.notFound(w, r)
		return
	} else if err != nil {
		s.serverError(w, r, "load shop category", err)
		return
	}
	view := shopCategoryFormView(*page, shopCategoryView{Category: cat, ItemCount: cat.Items},
		shopCategoryIcons, s.realmIsChinese(), false)
	s.renderShopCategoryForm(w, r, page, view, http.StatusOK)
}

func (s *Server) handleAdminShopCategoryNewSubmit(w http.ResponseWriter, r *http.Request, page *PageData) {
	if !s.checkCSRF(w, r) {
		return
	}
	s.saveShopCategory(w, r, page, 0)
}

func (s *Server) handleAdminShopCategorySubmit(w http.ResponseWriter, r *http.Request, page *PageData) {
	if !s.checkCSRF(w, r) {
		return
	}
	rawID, ok := s.parseUintPath(r, "id")
	if !ok {
		return
	}
	id, ok := categoryIDFromPath(rawID)
	if !ok {
		s.notFound(w, r)
		return
	}
	s.saveShopCategory(w, r, page, id)
}

// saveShopCategory creates (id 0) or updates one category.
func (s *Server) saveShopCategory(w http.ResponseWriter, r *http.Request, page *PageData, id uint8) {
	ctx := r.Context()
	actor := accountFrom(ctx)
	isNew := id == 0

	input, problems, warnings := parseShopCategoryForm(r)

	// The id is only read on create: changing it would orphan every row that
	// points at the old one, and the core orders the tabs by it.
	if isNew && input.ID != 0 {
		if exists, err := s.store.ShopCategoryExists(ctx, input.ID); err != nil {
			s.serverError(w, r, "check shop category", err)
			return
		} else if exists {
			problems = append(problems, "idTaken")
		}
	}
	// A name the client already has a tab for is not fatal, but two tabs with
	// the same label are impossible to tell apart.
	if len(problems) == 0 {
		cats, err := s.store.ShopCategories(ctx)
		if err != nil {
			s.serverError(w, r, "list shop categories", err)
			return
		}
		for _, c := range cats {
			if c.ID == id {
				continue
			}
			if strings.EqualFold(strings.TrimSpace(c.Name), input.Name) ||
				(input.NameCN != "" && strings.EqualFold(strings.TrimSpace(c.NameCN), input.NameCN)) {
				warnings = append(warnings, "duplicateName")
				break
			}
		}
	}

	if len(problems) > 0 {
		view := shopCategoryView{
			Category: store.ShopCategory{ID: id, Name: input.Name, NameCN: input.NameCN, Icon: input.Icon},
			Input:    input,
			Error:    categoryProblemsText(page, problems),
			Warnings: categoryWarningsText(page, warnings),
		}
		view = shopCategoryFormView(*page, view, shopCategoryIcons, s.realmIsChinese(), isNew)
		s.renderShopCategoryForm(w, r, page, view, http.StatusBadRequest)
		return
	}

	if isNew {
		newID, err := s.store.CreateShopCategory(ctx, input)
		if err != nil {
			s.serverError(w, r, "create shop category", err)
			return
		}
		_ = s.store.Audit(ctx, actor.ID, actor.Username, "shop-category-create",
			fmt.Sprintf("shop_categories/%d", newID),
			fmt.Sprintf("name=%s icon=%s", input.Name, input.Icon), s.clientIP(r))
		s.setFlash(w, "ok", fmt.Sprintf(page.T("shop.cat.flash.created"), newID))
		http.Redirect(w, r, "/admin/shop/categories", http.StatusSeeOther)
		return
	}

	if err := s.store.UpdateShopCategory(ctx, id, input); err != nil {
		if errors.Is(err, store.ErrNotFound) {
			s.notFound(w, r)
			return
		}
		s.serverError(w, r, "update shop category", err)
		return
	}
	_ = s.store.Audit(ctx, actor.ID, actor.Username, "shop-category-update",
		fmt.Sprintf("shop_categories/%d", id),
		fmt.Sprintf("name=%s icon=%s", input.Name, input.Icon), s.clientIP(r))
	s.setFlash(w, "ok", fmt.Sprintf(page.T("shop.cat.flash.updated"), id))
	http.Redirect(w, r, "/admin/shop/categories", http.StatusSeeOther)
}

// handleAdminShopCategoryDelete refuses while rows still point at the category:
// the core drops a shop_items row whose category is missing, so deleting one in
// use would empty part of the shop with nothing but a log line to show for it.
func (s *Server) handleAdminShopCategoryDelete(w http.ResponseWriter, r *http.Request, page *PageData) {
	if !s.checkCSRF(w, r) {
		return
	}
	rawID, ok := s.parseUintPath(r, "id")
	if !ok {
		return
	}
	id, ok := categoryIDFromPath(rawID)
	if !ok {
		s.notFound(w, r)
		return
	}
	ctx := r.Context()
	actor := accountFrom(ctx)

	cat, err := s.store.ShopCategory(ctx, id)
	if errors.Is(err, store.ErrNotFound) {
		s.notFound(w, r)
		return
	} else if err != nil {
		s.serverError(w, r, "load shop category", err)
		return
	}
	if cat.Items > 0 {
		s.setFlash(w, "error", fmt.Sprintf(page.T("shop.cat.err.inUse"), cat.Items))
		http.Redirect(w, r, "/admin/shop/categories", http.StatusSeeOther)
		return
	}
	if err := s.store.DeleteShopCategory(ctx, id); err != nil {
		if errors.Is(err, store.ErrNotFound) {
			s.notFound(w, r)
			return
		}
		s.serverError(w, r, "delete shop category", err)
		return
	}
	_ = s.store.Audit(ctx, actor.ID, actor.Username, "shop-category-delete",
		fmt.Sprintf("shop_categories/%d", id), "name="+cat.Name, s.clientIP(r))
	s.setFlash(w, "ok", fmt.Sprintf(page.T("shop.cat.flash.deleted"), id))
	http.Redirect(w, r, "/admin/shop/categories", http.StatusSeeOther)
}

// categoryProblemsText renders the refusal reasons for the form.
func categoryProblemsText(page *PageData, problems []string) string {
	keys := map[string]string{
		"name":      "shop.cat.err.nameRequired",
		"separator": "shop.cat.err.separators",
		"icon":      "shop.cat.err.iconRequired",
		"id":        "shop.cat.err.idRange",
		"idTaken":   "shop.cat.err.idTaken",
	}
	var out []string
	for _, p := range problems {
		if k, ok := keys[p]; ok {
			out = append(out, page.T(k))
		}
	}
	return strings.Join(out, "；")
}

func categoryWarningsText(page *PageData, warnings []string) []string {
	keys := map[string]string{
		"iconUnknown":   "shop.cat.warn.iconUnknown",
		"duplicateName": "shop.cat.warn.duplicateName",
	}
	var out []string
	for _, w := range warnings {
		if k, ok := keys[w]; ok {
			out = append(out, page.T(k))
		}
	}
	return out
}
