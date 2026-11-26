-- ============================================================================
-- Lapak Jajanan — Skema Database Supabase (PostgreSQL)
-- Sumber: PRD bagian 4. Jalankan file ini lebih dulu di SQL Editor Supabase.
-- ============================================================================

CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- 1. Lokasi Operasional (Lokasi Utama & Pasar Kuliner)
CREATE TABLE IF NOT EXISTS locations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(100) NOT NULL, -- 'Lokasi Utama' | 'Pasar Kuliner'
  address TEXT,
  open_time TIME NOT NULL,
  close_time TIME NOT NULL,
  is_open BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Kategori Menu
CREATE TABLE IF NOT EXISTS categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(100) NOT NULL,
  sort_order INT DEFAULT 0
);

-- 3. Katalog Menu
CREATE TABLE IF NOT EXISTS menus (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  category_id UUID REFERENCES categories(id) ON DELETE SET NULL,
  name VARCHAR(150) NOT NULL,
  description TEXT,
  price NUMERIC(12, 2) NOT NULL CHECK (price >= 0),
  image_url TEXT,
  is_available BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. Variasi & Topping Menu
CREATE TABLE IF NOT EXISTS menu_toppings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  menu_id UUID REFERENCES menus(id) ON DELETE CASCADE,
  topping_name VARCHAR(100) NOT NULL,
  extra_price NUMERIC(12, 2) DEFAULT 0 CHECK (extra_price >= 0),
  is_available BOOLEAN DEFAULT TRUE
);

-- 5. Pengaturan Tarif Ongkir (Diatur Admin)
CREATE TABLE IF NOT EXISTS shipping_rates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  zone_name VARCHAR(100) NOT NULL,
  fee NUMERIC(12, 2) NOT NULL CHECK (fee >= 0),
  is_active BOOLEAN DEFAULT TRUE
);

-- 6. Master Ojek Langganan Sekitar (Diatur Admin)
CREATE TABLE IF NOT EXISTS ojek_drivers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(100) NOT NULL,
  whatsapp_number VARCHAR(25) NOT NULL, -- Format: '6281234567890'
  vehicle_plate VARCHAR(30),
  is_online BOOLEAN DEFAULT FALSE,
  is_busy BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 7. Tabel Pesanan & Transaksi (Mendukung Monitoring Performa & Biaya Pengantaran)
CREATE TABLE IF NOT EXISTS orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  ticket_code VARCHAR(20) UNIQUE NOT NULL, -- Contoh: 'TKT-101'
  location_id UUID REFERENCES locations(id),
  ojek_id UUID REFERENCES ojek_drivers(id) ON DELETE SET NULL,
  order_source VARCHAR(20) NOT NULL CHECK (order_source IN ('WEB_QR', 'POS_WALKIN')),
  order_type VARCHAR(20) NOT NULL CHECK (order_type IN ('DELIVERY', 'PICKUP')),
  customer_name VARCHAR(100) NOT NULL,
  customer_whatsapp VARCHAR(25),
  delivery_address TEXT,
  delivery_lat DOUBLE PRECISION,
  delivery_lng DOUBLE PRECISION,
  shipping_fee NUMERIC(12, 2) DEFAULT 0 CHECK (shipping_fee >= 0),
  payment_method VARCHAR(20) NOT NULL CHECK (payment_method IN ('CASH', 'QRIS')),
  payment_status VARCHAR(20) DEFAULT 'PENDING' CHECK (payment_status IN ('PENDING', 'PAID')),
  order_status VARCHAR(30) DEFAULT 'MENUNGGU_KONFIRMASI'
    CHECK (order_status IN ('MENUNGGU_KONFIRMASI', 'DIPROSES', 'DIANTAR', 'SELESAI')),
  subtotal_amount NUMERIC(12, 2) NOT NULL CHECK (subtotal_amount >= 0), -- Pendapatan bersih produk & topping
  total_amount NUMERIC(12, 2) NOT NULL CHECK (total_amount >= 0),      -- subtotal_amount + shipping_fee
  cash_received NUMERIC(12, 2) DEFAULT 0,
  cash_change NUMERIC(12, 2) DEFAULT 0,
  wa_receipt_sent BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  confirmed_at TIMESTAMPTZ,
  processed_at TIMESTAMPTZ,
  delivered_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 8. Detail Item Pesanan & Topping
CREATE TABLE IF NOT EXISTS order_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
  menu_id UUID REFERENCES menus(id),
  menu_name VARCHAR(150) NOT NULL,
  selected_toppings JSONB DEFAULT '[]'::jsonb,
  quantity INT NOT NULL CHECK (quantity > 0),
  unit_price NUMERIC(12, 2) NOT NULL CHECK (unit_price >= 0),
  subtotal NUMERIC(12, 2) NOT NULL CHECK (subtotal >= 0),
  item_note TEXT
);

-- ============================================================================
-- Index untuk query laporan & tracking
-- ============================================================================
CREATE INDEX IF NOT EXISTS idx_menus_category ON menus(category_id);
CREATE INDEX IF NOT EXISTS idx_toppings_menu ON menu_toppings(menu_id);
CREATE INDEX IF NOT EXISTS idx_order_items_order ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_orders_status ON orders(order_status);
CREATE INDEX IF NOT EXISTS idx_orders_created_at ON orders(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_orders_whatsapp ON orders(customer_whatsapp);
CREATE INDEX IF NOT EXISTS idx_orders_location ON orders(location_id);
CREATE INDEX IF NOT EXISTS idx_orders_ojek ON orders(ojek_id);

-- ============================================================================
-- Trigger updated_at otomatis (dipakai untuk monitoring kecepatan layanan)
-- ============================================================================
CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS orders_set_updated_at ON orders;
CREATE TRIGGER orders_set_updated_at
  BEFORE UPDATE ON orders
  FOR EACH ROW EXECUTE FUNCTION set_updated_at();
