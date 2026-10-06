package web

import (
	"errors"
	"fmt"
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
	QueryString    string

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

type shopRegionOption struct {
	Value uint8
	Key   string
	Hint  string
}

func (s *Server) shopRegions() []shopRegionOption {
	return []shopRegionOption{
		{store.ShopRegionGlobal, "shop.region.global", "shop.region.globalHint"},
		{store.ShopRegionEurope, "shop.region.europe", "shop.region.europeHint"},
		{store.ShopRegionChina, "shop.region.china", "shop.region.chinaHint"},
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
	page.Title = page.T("shop.item.title")
	page.Active = "admin-shop"
	view.PageData = *page
	view.Categories = nil
	view.Regions = s.shopRegions()
	view.RealmRegion = s.realmRegion()
	view.RealmIsChinese = s.realmIsChinese()
	s.rend.Render(w, status, "admin_shop_item", view)
}

func (s *Server) handleAdminShopNewForm(w http.ResponseWriter, r *http.Request, page *PageData) {
	categories, err := s.store.ShopCategories(r.Context())
	if err != nil {
		s.serverError(w, r, "list shop categories", err)
		return
	}
	view := shopItemView{
		IsNew: true,
		Item: store.ShopItem{
			Region: store.ShopRegionGlobal,
			Scale:  1,
		},
	}
	view.Categories = categories
	// A prefilled category when arriving from a filtered list.
	if catStr := r.URL.Query().Get("category"); catStr != "" {
		if cat, err := strconv.Atoi(catStr); err == nil && cat >= 0 && cat <= 255 {
			view.Item.Category = uint8(cat)
		}
	}
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

	view := shopItemView{Item: item, Categories: categories}
	if tmpl, err := s.store.ItemTemplate(ctx, item.Entry); err == nil {
		view.ItemName = tmpl.DisplayName()
	} else if errors.Is(err, store.ErrNotFound) {
		view.ItemMissing = true
	}
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
		view := shopItemView{IsNew: id == 0, Input: input, Warnings: warnings, Error: strings.Join(problems, "；")}
		view.Item = store.ShopItem{ID: id, Category: input.Category, Entry: input.Entry,
			ModelID: input.ModelID, ItemDisplayID: input.ItemDisplayID,
			Description: input.Description, DescriptionCN: input.DescriptionCN,
			Price: input.Price, Region: input.Region,
			X: input.X, Y: input.Y, Z: input.Z, Rotation: input.Rotation, Scale: input.Scale}
		if cats, err := s.store.ShopCategories(ctx); err == nil {
			view.Categories = cats
		}
		if tmpl, err := s.store.ItemTemplate(ctx, input.Entry); err == nil {
			view.ItemName = tmpl.DisplayName()
		}
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

	in.ModelID = uint32(atoiDefault(r.PostFormValue("model_id"), 0))
	in.ItemDisplayID = uint32(atoiDefault(r.PostFormValue("item_id"), 0))

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
