-- ============================================================================
-- Lapak Jajanan — Data contoh untuk development (opsional)
-- Jalankan setelah database_schema.sql & rls_policies.sql.
-- ============================================================================

INSERT INTO locations (name, address, open_time, close_time, is_open) VALUES
  ('Lokasi Utama', 'Jl. Merdeka No. 12', '09:00', '21:00', TRUE),
  ('Pasar Kuliner', 'Pasar Kuliner Blok B No. 5', '10:00', '22:00', TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO categories (name, sort_order) VALUES
  ('Makanan Berat', 1),
  ('Camilan', 2),
  ('Minuman', 3)
ON CONFLICT DO NOTHING;

INSERT INTO menus (category_id, name, description, price, is_available)
SELECT c.id, m.name, m.description, m.price, TRUE
FROM categories c
JOIN (
  VALUES
    ('Makanan Berat', 'Pentol Kuah Pedas', 'Pentol kuah dengan sambal pedas khas lapak', 15000),
    ('Makanan Berat', 'Mie Ayam Bakso', 'Mie ayam dengan bakso homemade', 18000),
    ('Camilan', 'Keripik Pisang', 'Keripik pisang renyah original', 10000),
    ('Minuman', 'Es Teh Manis', 'Teh manis dingin', 5000),
    ('Minuman', 'Es Jeruk', 'Jeruk peras segar', 7000)
) AS m(category, name, description, price) ON m.category = c.name
WHERE NOT EXISTS (SELECT 1 FROM menus existing WHERE existing.name = m.name);

INSERT INTO menu_toppings (menu_id, topping_name, extra_price, is_available)
SELECT mn.id, t.topping_name, t.extra_price, TRUE
FROM menus mn
JOIN (
  VALUES
    ('Pentol Kuah Pedas', 'Tetelan', 5000),
    ('Pentol Kuah Pedas', 'Extra Pentol', 4000),
    ('Mie Ayam Bakso', 'Extra Bakso', 5000),
    ('Es Teh Manis', 'Extra Gula', 0)
) AS t(menu, topping_name, extra_price) ON t.menu = mn.name
WHERE NOT EXISTS (
  SELECT 1 FROM menu_toppings mt
  WHERE mt.menu_id = mn.id AND mt.topping_name = t.topping_name
);

INSERT INTO shipping_rates (zone_name, fee, is_active) VALUES
  ('Zona 1 — Sekitar Lapak (0–1 km)', 5000, TRUE),
  ('Zona 2 — Within Kelurahan (1–3 km)', 7000, TRUE),
  ('Zona 3 — Luar Kelurahan (3–5 km)', 10000, TRUE)
ON CONFLICT DO NOTHING;

INSERT INTO ojek_drivers (name, whatsapp_number, vehicle_plate, is_online, is_busy) VALUES
  ('Pak Budi', '6281234567890', 'AB 1234 CD', TRUE, FALSE),
  ('Mas Rian', '6289876543210', 'AB 5678 EF', FALSE, FALSE)
WHERE NOT EXISTS (SELECT 1 FROM ojek_drivers WHERE whatsapp_number = '6281234567890');
