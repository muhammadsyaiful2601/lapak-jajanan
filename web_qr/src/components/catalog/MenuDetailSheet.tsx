import { useEffect, useState } from 'react'
import type { CatalogMenu } from '../../data/mockCatalog'
import { formatRupiah } from '../../lib/supabase'
import type { CartItem, Topping } from '../../types'

const VARIANTS = [
  { id: 'reguler', label: 'Reguler', extra: 0 },
  { id: 'jumbo', label: 'Jumbo', extra: 5000 },
] as const

type VariantId = (typeof VARIANTS)[number]['id']

interface MenuDetailSheetProps {
  menu: CatalogMenu
  toppings: Topping[]
  /** Diisi saat pelanggan mengubah kustomisasi dari halaman keranjang. */
  initialItem?: CartItem
  onClose: () => void
  onAdd: (item: CartItem) => void
}

export function MenuDetailSheet({
  menu,
  toppings,
  initialItem,
  onClose,
  onAdd,
}: MenuDetailSheetProps) {
  const [variantId, setVariantId] = useState<VariantId>(initialItem?.variantId ?? 'reguler')
  const [selectedToppings, setSelectedToppings] = useState<string[]>(
    () => initialItem?.toppings?.map((topping) => topping.id) ?? [],
  )
  const [quantity, setQuantity] = useState(initialItem?.quantity ?? 1)
  const [note, setNote] = useState(initialItem?.note ?? '')

  useEffect(() => {
    const handleKey = (event: KeyboardEvent) => {
      if (event.key === 'Escape') onClose()
    }
    const previousOverflow = document.body.style.overflow
    document.body.style.overflow = 'hidden'
    document.addEventListener('keydown', handleKey)

    return () => {
      document.body.style.overflow = previousOverflow
      document.removeEventListener('keydown', handleKey)
    }
  }, [onClose])

  // Semua topping menu ikut tampil; yang habis ditandai disabled (FR-P04).
  const menuToppings = toppings.filter((topping) => topping.menu_id === menu.id)
  const availableToppings = menuToppings.filter((topping) => topping.is_available)
  const variant = VARIANTS.find((item) => item.id === variantId) ?? VARIANTS[0]
  const activeToppings = selectedToppings.filter((id) =>
    availableToppings.some((topping) => topping.id === id),
  )
  const chosenToppings = availableToppings.filter((topping) =>
    activeToppings.includes(topping.id),
  )
  const unitPrice =
    Number(menu.price) +
    variant.extra +
    chosenToppings.reduce((sum, topping) => sum + Number(topping.extra_price), 0)

  function toggleTopping(topping: Topping) {
    // Topping habis tidak bisa dipilih.
    if (!topping.is_available) return
    const id = topping.id
    setSelectedToppings((current) =>
      current.includes(id) ? current.filter((item) => item !== id) : [...current, id],
    )
  }

  function handleAdd() {
    onAdd({
      key: `${menu.id}|${variantId}|${[...activeToppings].sort().join(',')}`,
      menuId: menu.id,
      name: variant.extra > 0 ? `${menu.name} (Jumbo)` : menu.name,
      unitPrice,
      toppingNames: chosenToppings.map((topping) => topping.topping_name),
      quantity,
      note: note.trim(),
      menu: {
        id: menu.id,
        name: menu.name,
        description: menu.description,
        price: Number(menu.price),
        image_url: menu.image_url,
        emoji: menu.emoji,
        tone: menu.tone,
        badge: menu.badge,
        tag: menu.tag,
      },
      variantId,
      variantLabel: variant.label,
      variantExtra: variant.extra,
      toppings: chosenToppings.map((topping) => ({
        id: topping.id,
        name: topping.topping_name,
        price: Number(topping.extra_price),
      })),
    })
  }

  return (
    <div className="sheet-backdrop" onClick={onClose}>
      <section
        className="detail-sheet"
        role="dialog"
        aria-modal="true"
        aria-label={`Detail ${menu.name}`}
        onClick={(event) => event.stopPropagation()}
      >
        <div className="sheet-handle" aria-hidden="true" />

        <div className={`detail-hero tone-${menu.tone}`}>
          <button type="button" className="sheet-close" onClick={onClose} aria-label="Tutup">
            ×
          </button>
          {menu.image_url ? (
            <img className="detail-hero-img" src={menu.image_url} alt={menu.name} />
          ) : (
            <span className="detail-hero-emoji" aria-hidden="true">{menu.emoji}</span>
          )}
          {menu.badge && <span className="menu-badge hero-badge">{menu.badge}</span>}
        </div>

        <div className="detail-content">
          <h2>{menu.name}</h2>
          <p className="detail-desc">{menu.description}</p>
          <p className="detail-price">{formatRupiah(Number(menu.price))}</p>

          <div className="detail-section">
            <h3>Pilih ukuran</h3>
            <div className="variant-grid">
              {VARIANTS.map((item) => (
                <button
                  key={item.id}
                  type="button"
                  className={variantId === item.id ? 'variant-chip selected' : 'variant-chip'}
                  onClick={() => setVariantId(item.id)}
                >
                  <strong>{item.label}</strong>
                  <small>{item.extra > 0 ? `+${formatRupiah(item.extra)}` : 'Gratis'}</small>
                </button>
              ))}
            </div>
            <p className="hint">Pilih porsi yang paling pas untukmu.</p>
          </div>

          <div className="detail-section">
            <div className="section-heading">
              <h3>Tambah topping</h3>
              <span className="muted">Bisa pilih lebih dari satu</span>
            </div>

            {menuToppings.length === 0 && (
              <p className="muted">Menu ini belum punya topping.</p>
            )}

            <div className="topping-list">
              {menuToppings.map((topping) => {
                const checked = activeToppings.includes(topping.id)
                const available = topping.is_available
                return (
                  <label
                    key={topping.id}
                    className={[
                      'topping-row',
                      checked ? 'checked' : '',
                      available ? '' : 'unavailable',
                    ]
                      .filter(Boolean)
                      .join(' ')}
                  >
                    <input
                      type="checkbox"
                      checked={checked}
                      disabled={!available}
                      onChange={() => toggleTopping(topping)}
                    />
                    <span className="topping-check" aria-hidden="true">
                      {checked ? '✓' : ''}
                    </span>
                    <span className="topping-name">{topping.topping_name}</span>
                    <span className="topping-price">
                      {!available ? (
                        <small className="sold-out">Habis</small>
                      ) : Number(topping.extra_price) > 0 ? (
                        `+${formatRupiah(Number(topping.extra_price))}`
                      ) : (
                        'Gratis'
                      )}
                    </span>
                  </label>
                )
              })}
            </div>
          </div>

          <div className="detail-section">
            <h3>Catatan</h3>
            <textarea
              className="detail-note"
              rows={2}
              maxLength={140}
              placeholder="Contoh: kuah dipisah ya mas"
              value={note}
              onChange={(event) => setNote(event.target.value)}
            />
          </div>
        </div>

        <div className="sheet-footer">
          <div className="quantity-row compact">
            <button type="button" onClick={() => setQuantity(Math.max(1, quantity - 1))} aria-label="Kurangi jumlah">
              −
            </button>
            <span>{quantity}</span>
            <button type="button" onClick={() => setQuantity(quantity + 1)} aria-label="Tambah jumlah">
              +
            </button>
          </div>
          <button type="button" className="primary-button add-to-cart" onClick={handleAdd}>
            {initialItem ? 'Simpan perubahan' : 'Tambah ke keranjang'} ·{' '}
            {formatRupiah(unitPrice * quantity)}
          </button>
        </div>
      </section>
    </div>
  )
}
