-- ============================================================================
-- Lapak Jajanan — Row Level Security & Realtime
-- Jalankan SETELAH database_schema.sql.
-- Mode prototype PBL: pembaca anonymously diizinkan, penulisan dibatasi policy.
-- Untuk produksi, ganti policy dengan pengecekan auth.jwt() / role admin.
-- ============================================================================

ALTER TABLE locations      ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories     ENABLE ROW LEVEL SECURITY;
ALTER TABLE menus          ENABLE ROW LEVEL SECURITY;
ALTER TABLE menu_toppings  ENABLE ROW LEVEL SECURITY;
ALTER TABLE shipping_rates ENABLE ROW LEVEL SECURITY;
ALTER TABLE ojek_drivers   ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders         ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items    ENABLE ROW LEVEL SECURITY;

-- ---------- Policy umum: semua bisa membaca data master & pesanan ----------
DROP POLICY IF EXISTS "public_read_locations" ON locations;
CREATE POLICY "public_read_locations" ON locations FOR SELECT USING (true);

DROP POLICY IF EXISTS "public_read_categories" ON categories;
CREATE POLICY "public_read_categories" ON categories FOR SELECT USING (true);

DROP POLICY IF EXISTS "public_read_menus" ON menus;
CREATE POLICY "public_read_menus" ON menus FOR SELECT USING (true);

DROP POLICY IF EXISTS "public_read_toppings" ON menu_toppings;
CREATE POLICY "public_read_toppings" ON menu_toppings FOR SELECT USING (true);

DROP POLICY IF EXISTS "public_read_shipping_rates" ON shipping_rates;
CREATE POLICY "public_read_shipping_rates" ON shipping_rates FOR SELECT USING (true);

DROP POLICY IF EXISTS "public_read_ojek" ON ojek_drivers;
CREATE POLICY "public_read_ojek" ON ojek_drivers FOR SELECT USING (true);

DROP POLICY IF EXISTS "public_read_orders" ON orders;
CREATE POLICY "public_read_orders" ON orders FOR SELECT USING (true);

DROP POLICY IF EXISTS "public_read_order_items" ON order_items;
CREATE POLICY "public_read_order_items" ON order_items FOR SELECT USING (true);

-- ---------- Policy tulis: sementara dibuka untuk prototype ----------
-- TODO(minggu 3): ganti dengan policy berbasis role Admin (JWT claim).
DROP POLICY IF EXISTS "admin_write_locations" ON locations;
CREATE POLICY "admin_write_locations" ON locations FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "admin_write_categories" ON categories;
CREATE POLICY "admin_write_categories" ON categories FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "admin_write_menus" ON menus;
CREATE POLICY "admin_write_menus" ON menus FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "admin_write_toppings" ON menu_toppings;
CREATE POLICY "admin_write_toppings" ON menu_toppings FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "admin_write_shipping_rates" ON shipping_rates;
CREATE POLICY "admin_write_shipping_rates" ON shipping_rates FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "admin_write_ojek" ON ojek_drivers;
CREATE POLICY "admin_write_ojek" ON ojek_drivers FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "write_orders" ON orders;
CREATE POLICY "write_orders" ON orders FOR ALL USING (true) WITH CHECK (true);

DROP POLICY IF EXISTS "write_order_items" ON order_items;
CREATE POLICY "write_order_items" ON order_items FOR ALL USING (true) WITH CHECK (true);

-- ---------- Realtime: Web tracking & Flutter admin butuh update seketika ----------
DO $$
BEGIN
  ALTER PUBLICATION supabase_realtime ADD TABLE orders;
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$
BEGIN
  ALTER PUBLICATION supabase_realtime ADD TABLE order_items;
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$
BEGIN
  ALTER PUBLICATION supabase_realtime ADD TABLE menus;
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$
BEGIN
  ALTER PUBLICATION supabase_realtime ADD TABLE locations;
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;

DO $$
BEGIN
  ALTER PUBLICATION supabase_realtime ADD TABLE ojek_drivers;
EXCEPTION WHEN duplicate_object THEN NULL;
END $$;
