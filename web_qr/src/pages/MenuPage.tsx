import { useCallback, useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import { MenuCard } from '../components/catalog/MenuCard'
import { MenuDetailSheet } from '../components/catalog/MenuDetailSheet'
import { useCart } from '../context/useCart'
import {
  mockCategories,
  mockMenus,
  mockToppings,
  toCatalogMenu,
  type CatalogMenu,
} from '../data/mockCatalog'
import { getLocationLabel } from '../lib/location'
import { formatRupiah, isSupabaseConfigured, supabase } from '../lib/supabase'
import type { CartItem, Category, Menu, Topping } from '../types'

type SortMode = 'populer' | 'murah' | 'nama'

function SearchIcon() {
  return (
    <svg
      className="search-icon"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="1.8"
      aria-hidden="true"
    >
      <circle cx="11" cy="11" r="6.5" />
      <path d="m16 16 4 4" strokeLinecap="round" />
    </svg>
  )
}

export function MenuPage() {
  const [menus, setMenus] = useState<CatalogMenu[]>(() =>
    isSupabaseConfigured ? [] : mockMenus,
  )
  const [categories, setCategories] = useState<Category[]>(() =>
    isSupabaseConfigured ? [] : mockCategories,
  )
  const [toppings, setToppings] = useState<Topping[]>(() =>
    isSupabaseConfigured ? [] : mockToppings,
  )
  const [search, setSearch] = useState('')
  const [categoryId, setCategoryId] = useState<string | null>(null)
  const [sortMode, setSortMode] = useState<SortMode>('populer')
  const [selected, setSelected] = useState<CatalogMenu | null>(null)
  const [loading, setLoading] = useState(isSupabaseConfigured)
  const { addItem, totalQuantity, subtotal } = useCart()

  useEffect(() => {
    if (!supabase) return
    let active = true

    void Promise.all([
      supabase.from('menus').select('*').order('name'),
      supabase.from('categories').select('*').order('sort_order'),
      supabase.from('menu_toppings').select('*'),
    ]).then(([menuResult, categoryResult, toppingResult]) => {
      if (!active) return
      if (menuResult.error || categoryResult.error || toppingResult.error) {
        setMenus(mockMenus)
        setCategories(mockCategories)
        setToppings(mockToppings)
      } else {
        setMenus(((menuResult.data ?? []) as Menu[]).map(toCatalogMenu))
        setCategories((categoryResult.data ?? []) as Category[])
        setToppings((toppingResult.data ?? []) as Topping[])
      }
      setLoading(false)
    })

    return () => {
      active = false
    }
  }, [])

  const closeDetail = useCallback(() => setSelected(null), [])

  const handleAdd = useCallback(
    (item: CartItem) => {
      addItem(item)
      setSelected(null)
    },
    [addItem],
  )

  const visibleMenus = menus
    .filter((menu) => {
      const matchSearch = menu.name.toLowerCase().includes(search.trim().toLowerCase())
      const matchCategory = !categoryId || menu.category_id === categoryId
      return matchSearch && matchCategory
    })
    .sort((a, b) => {
      if (sortMode === 'murah') return Number(a.price) - Number(b.price)
      if (sortMode === 'nama') return a.name.localeCompare(b.name)
      const aPopular = a.badge && a.badge !== 'Stok habis' ? 0 : 1
      const bPopular = b.badge && b.badge !== 'Stok habis' ? 0 : 1
      return aPopular - bPopular
    })

  return (
    <div className="catalog-page">
      <section className="store-banner">
        <div className="store-icon" aria-hidden="true">🏪</div>
        <div className="store-copy">
          <div className="store-title">
            <strong>Gerai Aktif Hari Ini: {getLocationLabel()}</strong>
            <span className="status-pill">Buka</span>
          </div>
          <p>10.00–22.00 WIB • Delivery & Pickup dibuka</p>
          <small>Ditetapkan otomatis oleh sistem kasir admin</small>
        </div>
        <span className="speed-pill"><span aria-hidden="true">⚡</span> Cepat</span>
      </section>

      <div className="catalog-toolbar">
        <div className="search-box">
          <SearchIcon />
          <input
            aria-label="Cari menu"
            placeholder="Cari pentol, bakmie, minuman..."
            value={search}
            onChange={(event) => setSearch(event.target.value)}
          />
          {search && (
            <button type="button" onClick={() => setSearch('')} aria-label="Hapus pencarian">
              ×
            </button>
          )}
        </div>

        <label className="sort-pill">
          <span aria-hidden="true">🔥</span>
          <select
            aria-label="Urutkan menu"
            value={sortMode}
            onChange={(event) => setSortMode(event.target.value as SortMode)}
          >
            <option value="populer">Terpopuler</option>
            <option value="murah">Termurah</option>
            <option value="nama">Nama A–Z</option>
          </select>
        </label>
      </div>

      <div className="category-tabs" role="tablist" aria-label="Kategori menu">
        <button
          type="button"
          role="tab"
          aria-selected={categoryId === null}
          className={categoryId === null ? 'category-tab active' : 'category-tab'}
          onClick={() => setCategoryId(null)}
        >
          Semua
        </button>
        {categories.map((category) => (
          <button
            key={category.id}
            type="button"
            role="tab"
            aria-selected={categoryId === category.id}
            className={categoryId === category.id ? 'category-tab active' : 'category-tab'}
            onClick={() => setCategoryId(category.id)}
          >
            {category.name}
          </button>
        ))}
      </div>

      {loading && (
        <div className="menu-list">
          {[0, 1, 2, 3].map((index) => (
            <div key={index} className="menu-row skeleton" aria-hidden="true" />
          ))}
        </div>
      )}

      {!loading && visibleMenus.length === 0 && (
        <div className="empty-state">
          <span aria-hidden="true">🥢</span>
          <strong>Menu tidak ditemukan</strong>
          <p>Coba kata kunci lain atau pilih kategori Semua.</p>
          <button
            type="button"
            className="text-button"
            onClick={() => {
              setSearch('')
              setCategoryId(null)
            }}
          >
            Reset filter
          </button>
        </div>
      )}

      {!loading && visibleMenus.length > 0 && (
        <div className="menu-list">
          {visibleMenus.map((menu) => (
            <MenuCard key={menu.id} menu={menu} onSelect={setSelected} />
          ))}
        </div>
      )}

      {selected && (
        <MenuDetailSheet
          menu={selected}
          toppings={toppings}
          onClose={closeDetail}
          onAdd={handleAdd}
        />
      )}

      {totalQuantity > 0 && (
        <div className="floating-cart">
          <div className="floating-cart-info">
            <small>{totalQuantity} Menu Terpilih</small>
            <strong>{formatRupiah(subtotal)}</strong>
          </div>
          <Link to="/cart" className="floating-cart-button">
            Lihat Keranjang <span aria-hidden="true">→</span>
          </Link>
        </div>
      )}
    </div>
  )
}
