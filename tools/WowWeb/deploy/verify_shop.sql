-- verify_shop.sql - check the donation shop schema, queries and grants.
--
-- Run this once against the WORLD database, as the account the web service
-- uses, before trusting /admin/shop. It does two things:
--
--   1. runs every query internal/store/shop.go issues, so a column that moved
--      or a join that does not resolve shows up here instead of as a 500;
--   2. exercises INSERT / UPDATE / DELETE inside a transaction that is ROLLED
--      BACK at the end, so it also proves the grant from the README is enough
--      and leaves no data behind.
--
-- Usage:
--   mysql -u wowweb -p tw_world < verify_shop.sql
--
-- Every result line reads PASS or FAIL; the last section is the only one that
-- writes, and it rolls itself back.

SELECT DATABASE() AS world_database, CURRENT_USER() AS db_user;


-- ---------------------------------------------------------------------------
-- 1. Schema: the exact columns the store reads.
-- ---------------------------------------------------------------------------
SELECT 'shop_items columns' AS check_name,
       CASE WHEN COUNT(*) = 14 THEN 'PASS'
            ELSE CONCAT('FAIL - only ', COUNT(*), ' of 14') END AS result
  FROM information_schema.COLUMNS
 WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'shop_items'
   AND COLUMN_NAME IN ('id','category','item','model_id','item_id','description',
                       'description_loc4','price','region_locked','position_x',
                       'position_y','position_z','rotation','scale');

SELECT 'shop_categories columns' AS check_name,
       CASE WHEN COUNT(*) = 4 THEN 'PASS'
            ELSE CONCAT('FAIL - only ', COUNT(*), ' of 4') END AS result
  FROM information_schema.COLUMNS
 WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'shop_categories'
   AND COLUMN_NAME IN ('id','name','name_loc4','icon');

-- Referenced by the joins, not owned by the shop.
SELECT 'item_template columns' AS check_name,
       CASE WHEN COUNT(*) = 4 THEN 'PASS'
            ELSE CONCAT('FAIL - only ', COUNT(*), ' of 4') END AS result
  FROM information_schema.COLUMNS
 WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'item_template'
   AND COLUMN_NAME IN ('entry','name','quality','item_level');

SELECT 'locales_item columns' AS check_name,
       CASE WHEN COUNT(*) = 2 THEN 'PASS'
            ELSE CONCAT('FAIL - only ', COUNT(*), ' of 2') END AS result
  FROM information_schema.COLUMNS
 WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'locales_item'
   AND COLUMN_NAME IN ('entry','name_loc4');

-- Section 5 rolls its writes back, which only works on a transactional engine.
-- MyISAM would leave the row behind; the cleanup check at the end says so.
SELECT 'shop_items engine' AS check_name,
       CASE WHEN ENGINE = 'InnoDB' THEN 'PASS'
            ELSE CONCAT('FAIL - ', ENGINE, ', so section 5 cannot roll back') END AS result
  FROM information_schema.TABLES
 WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'shop_items';


-- ---------------------------------------------------------------------------
-- 2. The category list (store.ShopCategories), aliased c.
--    A category with no items must still appear, hence the LEFT JOIN.
-- ---------------------------------------------------------------------------
SELECT c.ID, COALESCE(c.Name, '') AS name, COALESCE(c.Name_loc4, '') AS name_cn,
       COALESCE(c.icon, '') AS icon, COUNT(i.id) AS items
  FROM shop_categories c
  LEFT JOIN shop_items i ON i.category = c.ID
 GROUP BY c.ID, c.Name, c.Name_loc4, c.icon
 ORDER BY c.ID;


-- ---------------------------------------------------------------------------
-- 3. The item list (store.ShopItems): the column list verbatim, then the page.
--    Row 3 is the COUNT for pagination.
-- ---------------------------------------------------------------------------
SELECT s.id, s.category, s.item, s.model_id, s.item_id,
       COALESCE(s.description, '') AS description,
       COALESCE(s.description_loc4, '') AS description_loc4,
       s.price, s.region_locked,
       s.position_x, s.position_y, s.position_z, s.rotation, s.scale,
       COALESCE(i.name, '') AS item_name, COALESCE(l.name_loc4, '') AS item_name_cn,
       COALESCE(i.quality, 0) AS quality, COALESCE(i.item_level, 0) AS item_level
  FROM shop_items s
  LEFT JOIN item_template i ON i.entry = s.item
  LEFT JOIN locales_item l ON l.entry = s.item
 ORDER BY s.id DESC
 LIMIT 5 OFFSET 0;

SELECT COUNT(*) AS total_items
  FROM shop_items s
  LEFT JOIN item_template i ON i.entry = s.item
  LEFT JOIN locales_item l ON l.entry = s.item;

-- The rows the form would refuse, which the world server also skips at startup.
-- Both counts must be 0 for the shop to show everything that is configured.
SELECT
  (SELECT COUNT(*) FROM shop_items WHERE price = 0) AS skipped_price_zero,
  (SELECT COUNT(*) FROM shop_items s
     LEFT JOIN shop_categories c ON c.ID = s.category
    WHERE c.ID IS NULL)                                  AS skipped_no_category,
  (SELECT COUNT(*) FROM shop_items s
     LEFT JOIN item_template i ON i.entry = s.item
    WHERE i.entry IS NULL)                               AS skipped_no_item,
  (SELECT COUNT(*) FROM (SELECT item FROM shop_items GROUP BY item HAVING COUNT(*) > 1) d)
                                                         AS skipped_duplicate;

-- Every shop_items.category must resolve, or those rows never reach a client.
SELECT s.category, COUNT(*) AS rows_in_category, MIN(c.ID) AS category_exists
  FROM shop_items s
  LEFT JOIN shop_categories c ON c.ID = s.category
 GROUP BY s.category
 ORDER BY s.category;


-- ---------------------------------------------------------------------------
-- 4. Reads that take a parameter: one row, the duplicate check, the item
--    template lookup, the search. Values are picked from live data so this
--    works on any realm.
-- ---------------------------------------------------------------------------
SET @some_id    = (SELECT id FROM shop_items ORDER BY id LIMIT 1);
SET @some_entry = (SELECT item FROM shop_items WHERE id = @some_id);

-- store.ShopItem  (must return exactly 1 row)
SELECT s.id, s.category, s.item, s.model_id, s.item_id,
       COALESCE(s.description, ''), COALESCE(s.description_loc4, ''),
       s.price, s.region_locked,
       s.position_x, s.position_y, s.position_z, s.rotation, s.scale,
       COALESCE(i.name, ''), COALESCE(l.name_loc4, ''),
       COALESCE(i.quality, 0), COALESCE(i.item_level, 0)
  FROM shop_items s
  LEFT JOIN item_template i ON i.entry = s.item
  LEFT JOIN locales_item l ON l.entry = s.item
 WHERE s.id = @some_id;

-- store.ShopEntryOwner  (must be empty: an entry may only be listed once)
SELECT id AS other_row_already_selling_entry
  FROM shop_items
 WHERE item = @some_entry AND id <> @some_id
 LIMIT 1;

-- store.ItemTemplate  (must return exactly 1 row)
SELECT i.entry, i.name, COALESCE(l.name_loc4, ''), i.quality, i.item_level
  FROM item_template i
  LEFT JOIN locales_item l ON l.entry = i.entry
 WHERE i.entry = @some_entry;

-- store.SearchItemTemplates, with 'a' as the search term.
SELECT i.entry, i.name, COALESCE(l.name_loc4, ''), i.quality, i.item_level
  FROM item_template i
  LEFT JOIN locales_item l ON l.entry = i.entry
 WHERE i.name LIKE '%a%' OR l.name_loc4 LIKE '%a%' OR i.entry = 0
 ORDER BY i.entry
 LIMIT 5;


-- ---------------------------------------------------------------------------
-- 5. Writes, and the grant behind them. Rolled back: nothing is left behind,
--    and the transaction only succeeds if the account may write.
--    Replace 1 with a category id that exists if the shop has no items yet.
-- ---------------------------------------------------------------------------
START TRANSACTION;

SET @new_cat   = COALESCE((SELECT category FROM shop_items ORDER BY id LIMIT 1),
                          (SELECT ID FROM shop_categories ORDER BY ID LIMIT 1));
SET @new_entry = COALESCE((SELECT item FROM shop_items ORDER BY id LIMIT 1),
                          (SELECT entry FROM item_template ORDER BY entry LIMIT 1));

INSERT INTO shop_items
  (category, item, model_id, item_id, description, description_loc4, price,
   region_locked, position_x, position_y, position_z, rotation, scale)
VALUES
  (@new_cat, @new_entry + 1000000, 0, 0, 'verify_shop.sql', 'verify_shop.sql', 1,
   0, 0, 0, 0, 0, 1);

SET @new_id = LAST_INSERT_ID();
-- Not ROW_COUNT(): the SET above sits between the INSERT and this SELECT, and
-- what that leaves in ROW_COUNT() is not worth relying on. Reading the row back
-- is the same assertion and does not depend on statement semantics.
SELECT @new_id AS inserted_id, 'INSERT' AS step,
       IF((SELECT COUNT(*) FROM shop_items WHERE id = @new_id) = 1, 'PASS', 'FAIL') AS result;

UPDATE shop_items
   SET category = @new_cat, item = @new_entry + 1000000, model_id = 0, item_id = 0,
       description = 'verify_shop.sql', description_loc4 = 'verify_shop.sql',
       price = 2, region_locked = 0,
       position_x = 0, position_y = 0, position_z = 0, rotation = 0, scale = 1
 WHERE id = @new_id;
SELECT price AS updated_price, 'UPDATE' AS step,
       IF(price = 2, 'PASS', 'FAIL') AS result
  FROM shop_items WHERE id = @new_id;

DELETE FROM shop_items WHERE id = @new_id;
-- ROW_COUNT() straight after the DELETE, with nothing in between: that is the
-- documented way to read it.
SELECT 'DELETE' AS step,
       IF(ROW_COUNT() = 1, 'PASS', 'FAIL') AS result;

ROLLBACK;

SELECT IF((SELECT COUNT(*) FROM shop_items WHERE id = @new_id) = 0,
          'PASS',
          CONCAT('FAIL - the test row ', @new_id, ' survived the rollback, delete it')) AS result,
       'cleanup' AS step;
