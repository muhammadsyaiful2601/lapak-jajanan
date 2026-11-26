import { useEffect, useMemo, useState } from 'react'
import { Link } from 'react-router-dom'
import { MenuDetailSheet } from '../components/catalog/MenuDetailSheet'
import { useCart } from '../context/useCart'
import {
  mockMenus,
  mockToppings,
  toCatalogMenu,
  type CatalogMenu,
} from '../data/mockCatalog'
import { getLocationLabel } from '../lib/location'
import { calculatePb1 } from '../lib/pricing'
import { formatRupiah, isSupabaseConfigured, supabase } from '../lib/supabase'
import type { CartItem, CartMenuSnapshot, Menu, Topping } from '../types'

function snapshotOf(menu: CatalogMenu): CartMenuSnapshot {
  return {
    id: menu.id,
    name: menu.name,
    description: menu.description,
    price: Number(menu.price),
    image_url: menu.image_url,
    emoji: menu.emoji,
    tone: menu.tone,
    badge: menu.badge,
    tag: menu.tag,
  }
}

function menuFromItem(item: CartItem): CatalogMenu {
  const toppingTotal = (item.toppings ?? []).reduce((sum, topping) => sum + topping.price, 0)
  const variantExtra =
    item.variantExtra ?? (item.name.endsWith(' (Jumbo)') ? 5000 : 0)

  return {
    id: item.menuId,
    category_id: null,
    name: item.menu?.name ?? item.name.replace(/ \(Jumbo\)$/, ''),
    description: item.menu?.description ?? null,
    price: item.menu?.price ?? Math.max(0, item.unitPrice - toppingTotal - variantExtra),
    image_url: item.menu?.image_url ?? null,
    is_available: true,
    emoji: item.menu?.emoji ?? '🍢',
    tone: item.menu?.tone ?? 'orange',
    badge: item.menu?.badge,
    tag: item.menu?.tag,
  }
}

function StoreIcon() {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.7" aria-hidden="true">
      <path d="M4 9.5 5.4 4h13.2L20 9.5" strokeLinecap="round" strokeLinejoin="round" />
      <path d="M4 9.5h16V20H4V9.5Z" strokeLinejoin="round" />
      <path d="M9.5 20v-5.5h5V20" strokeLinejoin="round" />
    </svg>
  )
}

function TrashIcon() {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" aria-hidden="true">
      <path d="M4.5 7h15M9.5 7V4.5h5V7M6.5 7l.8 12.5h9.4L17.5 7" strokeLinecap="round" strokeLinejoin="round" />
      <path d="M10.5 11v5M13.5 11v5" strokeLinecap="round" />
    </svg>
  )
}

function PencilIcon() {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" aria-hidden="true">
      <path d="M15.5 4.5 19.5 8.5 9 19H5v-4L15.5 4.5Z" strokeLinejoin="round" />
      <path d="m13.5 6.5 4 4" strokeLinecap="round" />
    </svg>
  )
}

function ListIcon() {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" aria-hidden="true">
      <path d="M8 7h11M8 12h11M8 17h11" strokeLinecap="round" />
      <circle cx="4.5" cy="7" r="1" fill="currentColor" stroke="none" />
      <circle cx="4.5" cy="12" r="1" fill="currentColor" stroke="none" />
      <circle cx="4.5" cy="17" r="1" fill="currentColor" stroke="none" />
    </svg>
  )
}

function PlusCircleIcon() {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" aria-hidden="true">
      <circle cx="12" cy="12" r="7.5" />
      <path d="M12 8.5v7M8.5 12h7" strokeLinecap="round" />
    </svg>
  )
}

function NoteIcon() {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" aria-hidden="true">
      <path d="M4 17c3-6 5 2 8-3s4-5 8-7" strokeLinecap="round" />
    </svg>
  )
}

function BoltIcon() {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" aria-hidden="true">
      <path d="M13 3 5.5 13.5H11L10 21l8-11h-5.5L13 3Z" strokeLinejoin="round" />
    </svg>
  )
}

function BowlIcon() {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" aria-hidden="true">
      <path d="M4 11h16a8 8 0 0 1-8 8 8 8 0 0 1-8-8Z" strokeLinejoin="round" />
      <path d="M9 7c0-1.2 1.4-1.8 1.4-3M13.5 7c0-1.2 1.4-1.8 1.4-3" strokeLinecap="round" />
    </svg>
  )
}

function InfoIcon() {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.6" aria-hidden="true">
      <circle cx="12" cy="12" r="8" />
      <path d="M12 11v5" strokeLinecap="round" />
      <circle cx="12" cy="8.2" r="0.9" fill="currentColor" stroke="none" />
    </svg>
  )
}

function ArrowIcon() {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" aria-hidden="true">
      <path d="M5 12h14M13 6l6 6-6 6" strokeLinecap="round" strokeLinejoin="round" />
    </svg>
  )
}

export function CartPage() {
  const { items, subtotal, totalQuantity, addItem, removeItem, changeQuantity, clear } = useCart()
  const [editing, setEditing] = useState<CartItem | null>(null)
  const [toppings, setToppings] = useState<Topping[]>(() =>
    isSupabaseConfigured ? [] : mockToppings,
  )
  const [catalog, setCatalog] = useState<CatalogMenu[]>(() =>
    isSupabaseConfigured ? [] : mockMenus,
  )

  useEffect(() => {
    if (!supabase) return
    let active = true

    void Promise.all([
      supabase.from('menu_toppings').select('*'),
      supabase.from('menus').select('*').eq('is_available', true).order('price'),
    ]).then(([toppingResult, menuResult]) => {
      if (!active) return
      if (!toppingResult.error) setToppings((toppingResult.data ?? []) as Topping[])
      if (!menuResult.error) {
        setCatalog(((menuResult.data ?? []) as Menu[]).map(toCatalogMenu))
      }
    })

    return () => {
      active = false
    }
  }, [])

  const pb1 = calculatePb1(subtotal)
  const estimateTotal = subtotal + pb1

  const suggestion = useMemo(() => {
    const cartMenuIds = new Set(items.map((item) => item.menuId))
    const available = catalog
      .filter((menu) => menu.is_available && !cartMenuIds.has(menu.id))
      .sort((a, b) => Number(a.price) - Number(b.price))
    return available.find((menu) => menu.id === 'menu-pisang') ?? available[0] ?? null
  }, [catalog, items])

  const editInitial = editing
    ? {
        ...editing,
        variantId:
          editing.variantId ?? (editing.name.endsWith(' (Jumbo)') ? 'jumbo' : 'reguler'),
        toppings: editing.toppings ?? [],
      }
    : undefined

  function addSuggestion(menu: CatalogMenu) {
    addItem({
      key: `${menu.id}|reguler|`,
      menuId: menu.id,
      name: menu.name,
      unitPrice: Number(menu.price),
      toppingNames: [],
      quantity: 1,
      note: '',
      menu: snapshotOf(menu),
      variantId: 'reguler',
      variantLabel: 'Reguler',
      variantExtra: 0,
      toppings: [],
    })
  }

  return (
    <div className="page cart-page">
      <section className="cart-source">
        <span className="cart-source-icon" aria-hidden="true">
          <StoreIcon />
        </span>
        <div className="cart-source-copy">
          <span className="cart-source-label">Diproses dari</span>
          <strong className="cart-source-name">{getLocationLabel()}</strong>
        </div>
        <span className="cart-source-eta">Cepat • ~15 mnt</span>
      </section>

      <div className="cart-head">
        <h1>Keranjang Pesanan</h1>
        <span className="cart-count">{totalQuantity} Menu</span>
        {items.length > 0 && (
          <button type="button" className="cart-clear" onClick={clear}>
            <TrashIcon /> Kosongkan
          </button>
        )}
      </div>

      {items.length === 0 && (
        <div className="cart-empty">
          <span className="cart-empty-icon" aria-hidden="true">🧺</span>
          <strong>Keranjang masih kosong</strong>
          <p>Yuk pilih jajanan favoritmu dulu. Menu bisa ditambah kapan saja.</p>
          <Link to="/" className="primary-link">Jelajahi Menu</Link>
        </div>
      )}

      {items.length > 0 && (
        <div className="cart-list">
          {items.map((item) => {
            const variantLabel =
              item.variantLabel ?? (item.name.endsWith(' (Jumbo)') ? 'Jumbo' : null)
            const itemToppings = item.toppings ?? []
            const tag = item.menu?.tag ?? item.menu?.badge

            return (
              <article key={item.key} className="cart-card">
                <div className="cart-card-top">
                  <div className={`cart-thumb tone-${item.menu?.tone ?? 'orange'}`}>
                    {item.menu?.image_url ? (
                      <img src={item.menu.image_url} alt={item.menu.name} />
                    ) : (
                      <span className="cart-thumb-emoji" aria-hidden="true">
                        {item.menu?.emoji ?? '🍢'}
                      </span>
                    )}
                  </div>

                  <div className="cart-info">
                    <h3>{item.name}</h3>
                    <p className="cart-item-price">
                      {formatRupiah(item.unitPrice)}
                      {item.quantity > 1 && <small> × {item.quantity}</small>}
                    </p>

                    {variantLabel && (
                      <p className="cart-option">
                        <ListIcon />
                        {variantLabel}
                      </p>
                    )}

                    {itemToppings.map((topping) => (
                      <p key={topping.id} className="cart-option">
                        <PlusCircleIcon />
                        {topping.name}
                        {topping.price > 0 && (
                          <span className="cart-option-extra">
                            (+{formatRupiah(topping.price)})
                          </span>
                        )}
                      </p>
                    ))}
                  </div>

                  <button
                    type="button"
                    className="cart-remove"
                    onClick={() => removeItem(item.key)}
                    aria-label={`Hapus ${item.name}`}
                  >
                    <TrashIcon />
                  </button>
                </div>

                {item.note && (
                  <div className="cart-note">
                    <NoteIcon />
                    <div>
                      <span>Catatan Pesanan:</span>
                      <em>“{item.note}”</em>
                    </div>
                  </div>
                )}

                {tag && (
                  <p className="cart-tag">
                    <BoltIcon />
                    {tag}
                  </p>
                )}

                <div className="cart-card-foot">
                  <button
                    type="button"
                    className="cart-edit"
                    onClick={() => setEditing(item)}
                  >
                    <PencilIcon /> Ubah Kustomisasi
                  </button>

                  <div className="qty-stepper">
                    <button
                      type="button"
                      onClick={() => changeQuantity(item.key, -1)}
                      aria-label={`Kurangi jumlah ${item.name}`}
                    >
                      −
                    </button>
                    <span>{item.quantity}</span>
                    <button
                      type="button"
                      className="plus"
                      onClick={() => changeQuantity(item.key, 1)}
                      aria-label={`Tambah jumlah ${item.name}`}
                    >
                      +
                    </button>
                  </div>
                </div>
              </article>
            )
          })}
        </div>
      )}

      {items.length > 0 && (
        <Link to="/" className="cart-add-more">
          <span aria-hidden="true">+</span> Tambah Menu Lain
        </Link>
      )}

      {items.length > 0 && (
        <section className="cart-summary">
          <div className="cart-summary-head">
            <h2>Ringkasan Pesanan</h2>
            <span className="cart-summary-badge">{totalQuantity} Menu Terpilih</span>
          </div>

          <div className="cart-summary-row">
            <span>Subtotal Menu ({totalQuantity} item)</span>
            <span>{formatRupiah(subtotal)}</span>
          </div>

          <div className="cart-summary-row">
            <span className="cart-summary-label">
              Estimasi Ongkir Delivery
              <InfoIcon />
            </span>
            <em>Dihitung di checkout</em>
          </div>

          <div className="cart-summary-row">
            <span>PB1 Resto (10%)</span>
            <span>{formatRupiah(pb1)}</span>
          </div>

          <div className="cart-total-box">
            <div>
              <strong>Estimasi Total</strong>
              <small>Termasuk pajak resto</small>
            </div>
            <span>{formatRupiah(estimateTotal)}</span>
          </div>
        </section>
      )}

      {items.length > 0 && suggestion && (
        <div className="cart-upsell">
          <span className="cart-upsell-icon" aria-hidden="true">
            <BowlIcon />
          </span>
          <div className="cart-upsell-copy">
            <strong>Mau tambah {suggestion.name}?</strong>
            <span>
              Teman setia santai senja cuma +{formatRupiah(Number(suggestion.price))}
            </span>
          </div>
          <button type="button" onClick={() => addSuggestion(suggestion)}>
            + Tambah
          </button>
        </div>
      )}

      {items.length > 0 && (
        <div className="checkout-bar">
          <div>
            <small>Total Pembayaran</small>
            <strong>{formatRupiah(estimateTotal)}</strong>
          </div>
          <Link to="/checkout" className="primary-button checkout-bar-button">
            Lanjut ke Checkout <ArrowIcon />
          </Link>
        </div>
      )}

      {editing && (
        <MenuDetailSheet
          menu={menuFromItem(editing)}
          toppings={toppings}
          initialItem={editInitial}
          onClose={() => setEditing(null)}
          onAdd={(updated) => {
            removeItem(editing.key)
            addItem(updated)
            setEditing(null)
          }}
        />
      )}
    </div>
  )
}
