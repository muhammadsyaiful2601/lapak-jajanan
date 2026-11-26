import { useEffect, useState, type FormEvent } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import { SetupNotice } from '../components/SetupNotice'
import { useCart } from '../context/useCart'
import { getLocationId } from '../lib/location'
import { calculatePb1 } from '../lib/pricing'
import { formatRupiah, supabase } from '../lib/supabase'
import type { ShippingRate } from '../types'

export function CheckoutPage() {
  const { items, subtotal, clear } = useCart()
  const navigate = useNavigate()
  const [rates, setRates] = useState<ShippingRate[]>([])
  const [orderType, setOrderType] = useState<'DELIVERY' | 'PICKUP'>('PICKUP')
  const [shippingRateId, setShippingRateId] = useState('')
  const [customerName, setCustomerName] = useState('')
  const [whatsapp, setWhatsapp] = useState('')
  const [address, setAddress] = useState('')
  const [paymentMethod, setPaymentMethod] = useState<'CASH' | 'QRIS'>('CASH')
  const [error, setError] = useState('')
  const [submitting, setSubmitting] = useState(false)

  useEffect(() => {
    if (!supabase) return
    void supabase
      .from('shipping_rates')
      .select('*')
      .eq('is_active', true)
      .order('fee')
      .then(({ data }) => setRates((data as ShippingRate[]) ?? []))
  }, [])

  const selectedRate = rates.find((rate) => rate.id === shippingRateId)
  const shippingFee = orderType === 'DELIVERY' ? Number(selectedRate?.fee ?? 0) : 0
  const pb1 = calculatePb1(subtotal)
  const total = subtotal + pb1 + shippingFee

  async function handleSubmit(event: FormEvent) {
    event.preventDefault()
    setError('')

    if (!supabase) {
      setError('Supabase belum dikonfigurasi. Isi file .env terlebih dahulu.')
      return
    }
    if (items.length === 0) {
      setError('Keranjang masih kosong.')
      return
    }
    if (orderType === 'DELIVERY' && !selectedRate) {
      setError('Pilih zona tarif ongkir terlebih dahulu.')
      return
    }

    setSubmitting(true)
    const ticketCode = `TKT-${String(Date.now()).slice(-6)}`

    try {
      const { data: order, error: orderError } = await supabase
        .from('orders')
        .insert({
          ticket_code: ticketCode,
          location_id: getLocationId(),
          order_source: 'WEB_QR',
          order_type: orderType,
          customer_name: customerName,
          customer_whatsapp: whatsapp,
          delivery_address: orderType === 'DELIVERY' ? address : null,
          shipping_fee: shippingFee,
          payment_method: paymentMethod,
          payment_status: 'PENDING',
          order_status: 'MENUNGGU_KONFIRMASI',
          subtotal_amount: subtotal,
          total_amount: total,
        })
        .select('id')
        .single()

      if (orderError || !order) throw orderError ?? new Error('Gagal membuat pesanan')

      const { error: itemsError } = await supabase.from('order_items').insert(
        items.map((item) => ({
          order_id: order.id,
          menu_id: item.menuId,
          menu_name: item.name,
          selected_toppings: item.toppingNames,
          quantity: item.quantity,
          unit_price: item.unitPrice,
          subtotal: item.unitPrice * item.quantity,
          item_note: item.note || null,
        })),
      )

      if (itemsError) throw itemsError
      clear()
      navigate(`/track/${ticketCode}`)
    } catch (caught) {
      setError(caught instanceof Error ? caught.message : 'Terjadi kesalahan saat checkout')
    } finally {
      setSubmitting(false)
    }
  }

  return (
    <div className="page">
      <SetupNotice />
      <h1>Checkout</h1>

      <form className="checkout-form" onSubmit={handleSubmit}>
        <fieldset>
          <legend>Jenis pesanan (FR-P06)</legend>
          <label className="radio-row">
            <input
              type="radio"
              checked={orderType === 'PICKUP'}
              onChange={() => setOrderType('PICKUP')}
            />
            Pickup — ambil di gerai
          </label>
          <label className="radio-row">
            <input
              type="radio"
              checked={orderType === 'DELIVERY'}
              onChange={() => setOrderType('DELIVERY')}
            />
            Delivery — dikirim ojek langganan
          </label>
        </fieldset>

        {orderType === 'DELIVERY' && (
          <>
            <label>Alamat / patokan
              <input value={address} onChange={(event) => setAddress(event.target.value)} required />
            </label>
            <label>Zona ongkir
              <select value={shippingRateId} onChange={(event) => setShippingRateId(event.target.value)} required>
                <option value="">Pilih zona...</option>
                {rates.map((rate) => (
                  <option key={rate.id} value={rate.id}>
                    {rate.zone_name} — {formatRupiah(Number(rate.fee))}
                  </option>
                ))}
              </select>
            </label>
            <p className="muted">Titik GPS otomatis (FR-P06) menyusul pada minggu 3.</p>
          </>
        )}

        <label>Nama pelanggan
          <input value={customerName} onChange={(event) => setCustomerName(event.target.value)} required />
        </label>
        <label>Nomor WhatsApp
          <input value={whatsapp} onChange={(event) => setWhatsapp(event.target.value)} placeholder="081234567890" required />
        </label>

        <fieldset>
          <legend>Metode pembayaran (FR-P07)</legend>
          <label className="radio-row">
            <input type="radio" checked={paymentMethod === 'CASH'} onChange={() => setPaymentMethod('CASH')} />
            Cash
          </label>
          <label className="radio-row">
            <input type="radio" checked={paymentMethod === 'QRIS'} onChange={() => setPaymentMethod('QRIS')} />
            QRIS
          </label>
        </fieldset>

        <div className="summary-card">
          <div className="summary-row"><span>Subtotal menu</span><span>{formatRupiah(subtotal)}</span></div>
          <div className="summary-row"><span>PB1 Resto (10%)</span><span>{formatRupiah(pb1)}</span></div>
          <div className="summary-row"><span>Ongkir</span><span>{formatRupiah(shippingFee)}</span></div>
          <div className="summary-row total"><span>Total</span><strong>{formatRupiah(total)}</strong></div>
        </div>

        {error && <p className="error-text">{error}</p>}

        <button type="submit" className="primary-button block" disabled={submitting}>
          {submitting ? 'Memproses...' : 'Buat pesanan'}
        </button>
        <Link to="/cart" className="text-button block">Kembali ke keranjang</Link>
      </form>
    </div>
  )
}
