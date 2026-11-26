import { Link } from 'react-router-dom'
import { useCart } from '../context/useCart'
import { formatRupiah } from '../lib/supabase'

export function CartPage() {
  const { items, subtotal, changeQuantity, removeItem, setNote } = useCart()

  return (
    <div className="page">
      <h1>Keranjang</h1>
      {items.length === 0 && (
        <div className="empty-card">
          <p>Keranjang masih kosong.</p>
          <Link to="/" className="primary-link">Lihat menu</Link>
        </div>
      )}

      {items.map((item) => (
        <article key={item.key} className="cart-item">
          <div className="cart-item-head">
            <strong>{item.name}</strong>
            <button type="button" className="text-button danger" onClick={() => removeItem(item.key)}>
              Hapus
            </button>
          </div>
          {item.toppingNames.length > 0 && (
            <p className="muted">Topping: {item.toppingNames.join(', ')}</p>
          )}
          <input
            className="note-input"
            placeholder="Catatan khusus (opsional)"
            value={item.note}
            onChange={(event) => setNote(item.key, event.target.value)}
          />
          <div className="cart-item-foot">
            <div className="quantity-row compact">
              <button type="button" onClick={() => changeQuantity(item.key, -1)}>−</button>
              <span>{item.quantity}</span>
              <button type="button" onClick={() => changeQuantity(item.key, 1)}>+</button>
            </div>
            <strong>{formatRupiah(item.unitPrice * item.quantity)}</strong>
          </div>
        </article>
      ))}

      {items.length > 0 && (
        <div className="summary-card">
          <div className="summary-row">
            <span>Subtotal</span>
            <strong>{formatRupiah(subtotal)}</strong>
          </div>
          <p className="muted">Ongkir dihitung setelah memilih zona pengantaran.</p>
          <Link to="/checkout" className="primary-button block">Lanjut checkout</Link>
        </div>
      )}
    </div>
  )
}
