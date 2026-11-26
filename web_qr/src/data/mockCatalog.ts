import type { Category, Menu, MenuTone, Topping } from '../types'

/** Data contoh untuk preview UI saat Supabase belum terhubung. */
export interface CatalogMenu extends Menu {
  emoji: string
  tone: MenuTone
  badge?: string
  tag?: string
}

export const mockCategories: Category[] = [
  { id: 'cat-makanan', name: 'Makanan Berat', sort_order: 1 },
  { id: 'cat-camilan', name: 'Camilan', sort_order: 2 },
  { id: 'cat-minuman', name: 'Minuman', sort_order: 3 },
]

export const mockMenus: CatalogMenu[] = [
  {
    id: 'menu-pentol',
    category_id: 'cat-makanan',
    name: 'Pentol Kuah Pedas',
    description: 'Pentol kuah dengan sambal pedas khas lapak. Cocok untuk perut lapar.',
    price: 15000,
    image_url: null,
    is_available: true,
    emoji: '🍲',
    tone: 'red',
    badge: 'Paling laris',
    tag: 'Paling Diminati',
  },
  {
    id: 'menu-mie-ayam',
    category_id: 'cat-makanan',
    name: 'Mie Ayam Bakso',
    description: 'Mie ayam dengan bakso homemade dan kuah kaldu hangat.',
    price: 18000,
    image_url: null,
    is_available: true,
    emoji: '🍜',
    tone: 'orange',
    tag: 'Favorit Warga',
  },
  {
    id: 'menu-keripik',
    category_id: 'cat-camilan',
    name: 'Keripik Pisang',
    description: 'Keripik pisang renyah original, pas untuk teman ngobrol.',
    price: 10000,
    image_url: null,
    is_available: true,
    emoji: '🍌',
    tone: 'yellow',
    tag: 'Camilan Renyah',
  },
  {
    id: 'menu-pisang',
    category_id: 'cat-camilan',
    name: 'Pisang Madu Goreng',
    description: 'Pisang goreng renyah dengan siraman madu hangat.',
    price: 12000,
    image_url: null,
    is_available: true,
    emoji: '🍯',
    tone: 'yellow',
    tag: 'Manis Hangat',
  },
  {
    id: 'menu-es-teh',
    category_id: 'cat-minuman',
    name: 'Es Teh Manis',
    description: 'Teh manis dingin dalam gelas besar.',
    price: 5000,
    image_url: null,
    is_available: true,
    emoji: '🧋',
    tone: 'brown',
    tag: 'Penyegar Dahaga',
  },
  {
    id: 'menu-es-jeruk',
    category_id: 'cat-minuman',
    name: 'Es Jeruk',
    description: 'Jeruk peras segar, tanpa gula berlebih.',
    price: 7000,
    image_url: null,
    is_available: false,
    emoji: '🍊',
    tone: 'orange',
    badge: 'Stok habis',
  },
]

export const mockToppings: Topping[] = [
  { id: 'top-tetelan', menu_id: 'menu-pentol', topping_name: 'Tetelan', extra_price: 5000, is_available: true },
  { id: 'top-extra-pentol', menu_id: 'menu-pentol', topping_name: 'Extra Pentol', extra_price: 4000, is_available: true },
  { id: 'top-extra-bakso', menu_id: 'menu-mie-ayam', topping_name: 'Extra Bakso', extra_price: 5000, is_available: true },
  { id: 'top-pangsit', menu_id: 'menu-mie-ayam', topping_name: 'Extra Pangsit Goreng', extra_price: 5000, is_available: true },
  { id: 'top-keju', menu_id: 'menu-pisang', topping_name: 'Keju Susu', extra_price: 3000, is_available: true },
  { id: 'top-cokelat', menu_id: 'menu-pisang', topping_name: 'Cokelat Lumer', extra_price: 3000, is_available: true },
  { id: 'top-extra-gula', menu_id: 'menu-es-teh', topping_name: 'Extra Gula', extra_price: 0, is_available: true },
]

const TONE_BY_NAME: Record<string, CatalogMenu['tone']> = {
  pentol: 'red',
  mie: 'orange',
  keripik: 'yellow',
  pisang: 'yellow',
  es: 'brown',
}

/** Menambahkan dekorasi visual untuk menu yang berasal dari Supabase. */
export function toCatalogMenu(menu: Menu): CatalogMenu {
  const firstWord = menu.name.toLowerCase().split(' ')[0] ?? ''
  return {
    ...menu,
    emoji: '🍢',
    tone: TONE_BY_NAME[firstWord] ?? 'orange',
    badge: menu.is_available ? undefined : 'Stok habis',
  }
}
