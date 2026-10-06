package store

import (
	"context"
	"database/sql"
	"fmt"
	"strings"
)

// The donation shop lives entirely in the world database and is read by the
// core once at startup (ObjectMgr::LoadShopCategories / LoadShopEntries), which
// then answers the client's TW_SHOP addon messages from memory. So the web side
// only edits these two tables - and every edit needs a mangosd restart to show
// up in game.
//
// Two of the columns mean more than they look like, both learned from the
// loader:
//
//   - Price 0 makes the core log an error and skip the row ("price is 0"), and
//     the same entry listed twice is skipped as well ("already has an entry in
//     the shop for entry %u"). Both are enforced in the handler, not here.
//   - RegionLocked is the core's ShopRegion enum: Global, Europe, China. The
//     core computes the realm's own region from its `NiHao` config key (false =
//     Europe) and keeps a row only when it is Global or matches. A row that does
//     not match is silently absent from the shop on that realm.
//
// The name and the description the client shows are NOT the ones in this table:
// the loader sends item_template's name and description, taking the name from
// locales_item when the realm is Chinese (NiHao). shop_items.description and
// description_loc4 are still read into the struct but never used again, so the
// admin page labels them as unused rather than pretending they are the display
// text.

// ShopRegion values, mirroring enum class ShopRegion in the core.
const (
	ShopRegionGlobal uint8 = 0
	ShopRegionEurope uint8 = 1
	ShopRegionChina  uint8 = 2
)

// ShopCategory is one row of shop_categories.
type ShopCategory struct {
	ID     uint8
	Name   string // English, sent when the realm is not the Chinese one
	NameCN string // Name_loc4, sent when it is
	Icon   string

	// Items is how many shop_items rows point at this category. The core skips
	// a row whose category does not exist, so this is worth showing.
	Items int
}

// LocalizedName picks what the client would receive on a realm of this region.
func (c ShopCategory) LocalizedName(chinese bool) string {
	if chinese && strings.TrimSpace(c.NameCN) != "" {
		return c.NameCN
	}
	return c.Name
}

// ShopItem is one row of shop_items joined with the item it grants.
type ShopItem struct {
	ID       uint32
	Category uint8
	Entry    uint32 // shop_items.item, a row in item_template
	ModelID  uint32
	// ItemDisplayID overrides the model's skin; 0 means the item's own look.
	ItemDisplayID uint32

	// Description / DescriptionCN are loaded by the core and then ignored: the
	// client is sent item_template's description instead. Kept so the form can
	// show and edit them, labelled as unused.
	Description   string
	DescriptionCN string

	Price  uint32
	Region uint8 // ShopRegion

	// Placement of the model in the shop pane.
	X, Y, Z  float64
	Rotation float64
	Scale    float64

	// Joined from item_template / locales_item, for the admin list only.
	ItemName    string
	ItemNameCN  string
	ItemQuality uint32
	ItemLevel   uint32
}

// ShopItemFilter narrows the list.
type ShopItemFilter struct {
	Category *uint8
	Search   string // matched against the item name and the entry number
	Region   uint8  // the realm's own region, used to flag hidden rows
	Limit    int
	Offset   int
}

// ShopItemInput is what a form submits, already parsed.
type ShopItemInput struct {
	Category      uint8
	Entry         uint32
	ModelID       uint32
	ItemDisplayID uint32

	Description   string
	DescriptionCN string

	Price  uint32
	Region uint8

	X, Y, Z  float64
	Rotation float64
	Scale    float64
}

// ItemTemplate is the slice of item_template the picker needs.
type ItemTemplate struct {
	Entry     uint32
	Name      string
	NameCN    string
	Quality   uint32
	ItemLevel uint32
}

// DisplayName is what to show an administrator: the Chinese name when there is
// one, because that is what the players on a Chinese realm see.
func (t ItemTemplate) DisplayName() string {
	if strings.TrimSpace(t.NameCN) != "" {
		return t.NameCN
	}
	return t.Name
}

const shopItemColumns = `
	SELECT s.id, s.category, s.item, s.model_id, s.item_id,
	       COALESCE(s.description, ''), COALESCE(s.description_loc4, ''),
	       s.price, s.region_locked,
	       s.position_x, s.position_y, s.position_z, s.rotation, s.scale,
	       COALESCE(i.name, ''), COALESCE(l.name_loc4, ''),
	       COALESCE(i.quality, 0), COALESCE(i.item_level, 0)
	  FROM shop_items s
	  LEFT JOIN item_template i ON i.entry = s.item
	  LEFT JOIN locales_item l ON l.entry = s.item`

func scanShopItem(rows interface{ Scan(...any) error }) (ShopItem, error) {
	var it ShopItem
	err := rows.Scan(&it.ID, &it.Category, &it.Entry, &it.ModelID, &it.ItemDisplayID, &it.Description,
		&it.DescriptionCN, &it.Price, &it.Region,
		&it.X, &it.Y, &it.Z, &it.Rotation, &it.Scale,
		&it.ItemName, &it.ItemNameCN, &it.ItemQuality, &it.ItemLevel)
	return it, err
}

// ShopCategories lists the categories with how many items each holds.
func (s *Store) ShopCategories(ctx context.Context) ([]ShopCategory, error) {
	rows, err := s.World.QueryContext(ctx, `
		SELECT c.ID, COALESCE(c.Name, ''), COALESCE(c.Name_loc4, ''),
		       COALESCE(c.icon, ''), COUNT(i.id)
		  FROM shop_categories c
		  LEFT JOIN shop_items i ON i.category = c.ID
		 GROUP BY c.ID, c.Name, c.Name_loc4, c.icon
		 ORDER BY c.ID`)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var out []ShopCategory
	for rows.Next() {
		var c ShopCategory
		if err := rows.Scan(&c.ID, &c.Name, &c.NameCN, &c.Icon, &c.Items); err != nil {
			return nil, err
		}
		out = append(out, c)
	}
	return out, rows.Err()
}

// ShopCategoryExists reports whether the core would accept this category id -
// it skips any item whose category is not in the list.
func (s *Store) ShopCategoryExists(ctx context.Context, id uint8) (bool, error) {
	var n int
	err := s.World.QueryRowContext(ctx,
		`SELECT COUNT(*) FROM shop_categories WHERE ID = ?`, id).Scan(&n)
	return n > 0, err
}

// ShopItems lists items, newest first, with the total for pagination.
func (s *Store) ShopItems(ctx context.Context, f ShopItemFilter) ([]ShopItem, int, error) {
	where := []string{"1=1"}
	args := []any{}
	if f.Category != nil {
		where = append(where, "s.category = ?")
		args = append(args, *f.Category)
	}
	if q := strings.TrimSpace(f.Search); q != "" {
		where = append(where, "(i.name LIKE ? OR l.name_loc4 LIKE ? OR s.item = ?)")
		like := "%" + q + "%"
		args = append(args, like, like, atoiOrZero(q))
	}
	cond := " WHERE " + strings.Join(where, " AND ")

	var total int
	if err := s.World.QueryRowContext(ctx,
		`SELECT COUNT(*) FROM shop_items s
		   LEFT JOIN item_template i ON i.entry = s.item
		   LEFT JOIN locales_item l ON l.entry = s.item`+cond, args...).Scan(&total); err != nil {
		return nil, 0, err
	}

	limit := f.Limit
	if limit <= 0 || limit > 200 {
		limit = 25
	}
	rows, err := s.World.QueryContext(ctx,
		shopItemColumns+cond+` ORDER BY s.id DESC LIMIT ? OFFSET ?`,
		append(args, limit, f.Offset)...)
	if err != nil {
		return nil, 0, err
	}
	defer rows.Close()

	var out []ShopItem
	for rows.Next() {
		it, err := scanShopItem(rows)
		if err != nil {
			return nil, 0, err
		}
		out = append(out, it)
	}
	return out, total, rows.Err()
}

// ShopItem reads one row.
func (s *Store) ShopItem(ctx context.Context, id uint32) (ShopItem, error) {
	row := s.World.QueryRowContext(ctx, shopItemColumns+` WHERE s.id = ?`, id)
	it, err := scanShopItem(row)
	if err == sql.ErrNoRows {
		return ShopItem{}, ErrNotFound
	}
	return it, err
}

// ShopEntryOwner returns the id of the row already selling this item entry, or
// 0 when none does. The core skips a duplicate ("already has an entry in the
// shop for entry %u"), so the form has to refuse it.
func (s *Store) ShopEntryOwner(ctx context.Context, entry uint32, exceptID uint32) (uint32, error) {
	var id uint32
	err := s.World.QueryRowContext(ctx,
		`SELECT id FROM shop_items WHERE item = ? AND id <> ? LIMIT 1`, entry, exceptID).Scan(&id)
	if err == sql.ErrNoRows {
		return 0, nil
	}
	return id, err
}

// ItemTemplate reads the fields the picker shows. Returns ErrNotFound when the
// world database has no such entry - and the core would drop the shop row for
// the same reason ("item_template missed info").
func (s *Store) ItemTemplate(ctx context.Context, entry uint32) (ItemTemplate, error) {
	var t ItemTemplate
	err := s.World.QueryRowContext(ctx, `
		SELECT i.entry, i.name, COALESCE(l.name_loc4, ''), i.quality, i.item_level
		  FROM item_template i
		  LEFT JOIN locales_item l ON l.entry = i.entry
		 WHERE i.entry = ?`, entry).
		Scan(&t.Entry, &t.Name, &t.NameCN, &t.Quality, &t.ItemLevel)
	if err == sql.ErrNoRows {
		return ItemTemplate{}, ErrNotFound
	}
	return t, err
}

// SearchItemTemplates finds items by name or entry, for the picker.
func (s *Store) SearchItemTemplates(ctx context.Context, q string, limit int) ([]ItemTemplate, error) {
	q = strings.TrimSpace(q)
	if q == "" {
		return nil, nil
	}
	if limit <= 0 || limit > 50 {
		limit = 25
	}
	rows, err := s.World.QueryContext(ctx, `
		SELECT i.entry, i.name, COALESCE(l.name_loc4, ''), i.quality, i.item_level
		  FROM item_template i
		  LEFT JOIN locales_item l ON l.entry = i.entry
		 WHERE i.name LIKE ? OR l.name_loc4 LIKE ? OR i.entry = ?
		 ORDER BY i.entry
		 LIMIT ?`, "%"+q+"%", "%"+q+"%", atoiOrZero(q), limit)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var out []ItemTemplate
	for rows.Next() {
		var t ItemTemplate
		if err := rows.Scan(&t.Entry, &t.Name, &t.NameCN, &t.Quality, &t.ItemLevel); err != nil {
			return nil, err
		}
		out = append(out, t)
	}
	return out, rows.Err()
}

// CreateShopItem inserts a row and returns its id.
func (s *Store) CreateShopItem(ctx context.Context, in ShopItemInput) (uint32, error) {
	res, err := s.World.ExecContext(ctx, `
		INSERT INTO shop_items
			(category, item, model_id, item_id, description, description_loc4, price,
			 region_locked, position_x, position_y, position_z, rotation, scale)
		VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
		in.Category, in.Entry, in.ModelID, in.ItemDisplayID,
		truncate(in.Description, 500), truncate(in.DescriptionCN, 500),
		in.Price, in.Region, in.X, in.Y, in.Z, in.Rotation, in.Scale)
	if err != nil {
		return 0, err
	}
	id, err := res.LastInsertId()
	return uint32(id), err
}

// UpdateShopItem rewrites a row. The id never changes, and neither does the
// column set the core reads.
func (s *Store) UpdateShopItem(ctx context.Context, id uint32, in ShopItemInput) error {
	res, err := s.World.ExecContext(ctx, `
		UPDATE shop_items
		   SET category = ?, item = ?, model_id = ?, item_id = ?,
		       description = ?, description_loc4 = ?, price = ?, region_locked = ?,
		       position_x = ?, position_y = ?, position_z = ?, rotation = ?, scale = ?
		 WHERE id = ?`,
		in.Category, in.Entry, in.ModelID, in.ItemDisplayID,
		truncate(in.Description, 500), truncate(in.DescriptionCN, 500),
		in.Price, in.Region, in.X, in.Y, in.Z, in.Rotation, in.Scale, id)
	if err != nil {
		return err
	}
	if n, err := res.RowsAffected(); err == nil && n == 0 {
		// MySQL reports 0 for an update that changed nothing, so confirm the row
		// exists before calling it missing.
		if _, err := s.ShopItem(ctx, id); err != nil {
			return err
		}
	}
	return nil
}

// DeleteShopItem removes a row.
func (s *Store) DeleteShopItem(ctx context.Context, id uint32) error {
	res, err := s.World.ExecContext(ctx, `DELETE FROM shop_items WHERE id = ?`, id)
	if err != nil {
		return err
	}
	if n, err := res.RowsAffected(); err == nil && n == 0 {
		return ErrNotFound
	}
	return nil
}

// atoiOrZero lets a numeric search term match an entry number: "50000" should
// find that item even though the name columns will not match it.
func atoiOrZero(s string) uint32 {
	n := 0
	for _, c := range s {
		if c < '0' || c > '9' {
			return 0
		}
		n = n*10 + int(c-'0')
		if n > 1<<30 {
			return 0
		}
	}
	if n == 0 {
		return 0
	}
	return uint32(n)
}

// ShopRegionName renders the enum for the admin pages.
func ShopRegionName(r uint8) string {
	switch r {
	case ShopRegionGlobal:
		return "global"
	case ShopRegionEurope:
		return "europe"
	case ShopRegionChina:
		return "china"
	default:
		return fmt.Sprintf("unknown(%d)", r)
	}
}
