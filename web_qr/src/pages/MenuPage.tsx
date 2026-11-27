import { useEffect, useMemo, useState } from 'react'
import { SetupNotice } from '../components/SetupNotice'
import { useCart } from '../context/useCart'
import { formatRupiah, isSupabaseConfigured, supabase } from '../lib/supabase'
import type { Category, Menu, Topping } from '../types'

export function MenuPage() {
  const [menus, setMenus] = useState<Menu[]>([])
  const [categories, setCategories] = useState<Category[]>([])
  const [toppings, setToppings] = useState<Topping[]>([])
  const [search, setSearch] = useState('')
  const [categoryId, setCategoryId] = useState<string | null>(null)
  const [selected, setSelected] = useState<Menu | null>(null)
  const [selectedToppings, setSelectedToppings] = useState<string[]>([])
  const [quantity, setQuantity] = useState(1)
  const [loading, setLoading] = useState(isSupabaseConfigured)
  const { addItem } = useCart()

  useEffect(() => {
    if (!supabase) return
    let active = true

    void Promise.all([
      supabase.from('menus').select('*').order('name'),
      supabase.from('categories').select('*').order('sort_order'),
      supabase.from('menu_toppings').select('*'),
    ]).then(([menuResult, categoryResult, toppingResult]) => {
      if (!active) return
      setMenus((menuResult.data as Menu[]) ?? [])
      setCategories((categoryResult.data as Category[]) ?? [])
      setToppings((toppingResult.data as Topping[]) ?? [])
      setLoading(false)
    })

    return () => {
      active = false
    }
  }, [])

  const visibleMenus = useMemo(() => {
    return menus.filter((menu) => {
      const matchSearch = menu.name.toLowerCase().includes(search.toLowerCase())
      const matchCategory = !categoryId || menu.category_id === categoryId
      return matchSearch && matchCategory
    })
  }, [menus, search, categoryId])

  const selectedExtras = toppings.filter(
    (topping) =>
      selectedToppings.includes(topping.id) &&
      topping.menu_id === selected?.id &&
      topping.is_available,
  )

  function openDetail(menu: Menu) {
    setSelected(menu)
    setSelectedToppings([])
    setQuantity(1)
  }

  function addToCart() {
    if (!selected) return
    const availableExtraIds = selectedExtras.map((item) => item.id).sort()
    addItem({
      key: `${selected.id}|${availableExtraIds.join(',')}`,
      menuId: selected.id,
      name: selected.name,
      unitPrice:
        selected.price + selectedExtras.reduce((sum, item) => sum + item.extra_price, 0),
      toppingNames: selectedExtras.map((item) => item.topping_name),
      quantity,
      note: '',
    })
    setSelected(null)
  }

  return (
    <div className="page">
      <SetupNotice />

      <section className="hero-card">
        <h1>Pesan jajanan favoritmu</h1>
        <p>Pilih menu, tambahkan topping, lalu pesan via Delivery atau Pickup.</p>
      </section>

      <input
        className="search-input"
        placeholder="🔍 Cari menu..."
        value={search}
        onChange={(event) => setSearch(event.target.value)}
      />

      <div className="chips">
        <button
          type="button"
          className={categoryId === null ? 'chip active' : 'chip'}
          onClick={() => setCategoryId(null)}
        >
          Semua
        </button>
        {categories.map((category) => (
          <button
            key={category.id}
            type="button"
            className={categoryId === category.id ? 'chip active' : 'chip'}
            onClick={() => setCategoryId(category.id)}
          >
            {category.name}
          </button>
        ))}
      </div>

      {loading && <p className="muted">Memuat menu...</p>}
      {!loading && visibleMenus.length === 0 && (
        <p className="muted">Belum ada menu. Jalankan database/seed.sql di Supabase.</p>
      )}

      <div className="menu-grid">
        {visibleMenus.map((menu) => (
          <button
            key={menu.id}
            type="button"
            className="menu-card"
            onClick={() => openDetail(menu)}
            disabled={!menu.is_available}
          >
            <div className="menu-emoji">🍲</div>
            <div className="menu-info">
              <strong>{menu.name}</strong>
              <p>{menu.description}</p>
              <span className={menu.is_available ? 'price' : 'price sold-out'}>
                {menu.is_available ? formatRupiah(Number(menu.price)) : 'Habis'}
              </span>
            </div>
          </button>
        ))}
      </div>

      {selected && (
        <div className="modal-backdrop" onClick={() => setSelected(null)}>
          <div className="modal" onClick={(event) => event.stopPropagation()}>
            <h2>{selected.name}</h2>
            <p className="muted">{selected.description}</p>
            <p className="price">{formatRupiah(Number(selected.price))}</p>

            <h3>Topping (FR-P04)</h3>
            {toppings
              .filter((topping) => topping.menu_id === selected.id)
              .map((topping) => {
                const available = topping.is_available
                return (
                <label
                  key={topping.id}
                  className={available ? 'checkbox-row' : 'checkbox-row unavailable'}
                >
                  <input
                    type="checkbox"
                    checked={selectedToppings.includes(topping.id)}
                    disabled={!available}
                    onChange={(event) =>
                      setSelectedToppings((current) =>
                        event.target.checked && available
                          ? [...current, topping.id]
                          : current.filter((id) => id !== topping.id),
                      )
                    }
                  />
                  <span>
                    {topping.topping_name}{' '}
                    {available ? (
                      <small>+{formatRupiah(Number(topping.extra_price))}</small>
                    ) : (
                      <small className="sold-out">Habis</small>
                    )}
                  </span>
                </label>
                )
              })}

            <div className="quantity-row">
              <button type="button" onClick={() => setQuantity(Math.max(1, quantity - 1))}>−</button>
              <span>{quantity}</span>
              <button type="button" onClick={() => setQuantity(quantity + 1)}>+</button>
            </div>

            <button type="button" className="primary-button" onClick={addToCart}>
              Tambah ke keranjang
            </button>
            <button type="button" className="text-button" onClick={() => setSelected(null)}>
              Batal
            </button>
          </div>
        </div>
      )}
    </div>
  )
}
