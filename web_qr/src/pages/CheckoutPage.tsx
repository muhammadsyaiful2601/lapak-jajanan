import { useEffect, useMemo, useState, type FormEvent } from 'react'
import { useNavigate } from 'react-router-dom'
import { Icon, SectionCard } from '../components/customer-ui'
import { useToast } from '../components/useToast'
import { SetupNotice } from '../components/SetupNotice'
import { useCart } from '../context/useCart'
import { getLocationId } from '../lib/location'
import { calculatePb1 } from '../lib/pricing'
import { formatRupiah, supabase } from '../lib/supabase'
import type { ShippingRate } from '../types'
import '../customer.css'

type OrderType = 'DELIVERY' | 'PICKUP'
type PaymentMethod = 'CASH' | 'QRIS'
type LocationState = 'initial' | 'loading' | 'found' | 'shared' | 'failed'

const MAPS_QUERY = '-6.2241,106.8095'

const LOCATION_LABELS: Array<{ state: LocationState; label: string }> = [
  { state: 'initial', label: '1. Awal' },
  { state: 'loading', label: '2. Proses' },
  { state: 'found', label: '3. Ditemukan' },
  { state: 'shared', label: '4. Dari WA' },
  { state: 'failed', label: '5. Gagal' },
]

/** Preview QR 17×17 identik dengan `_QrPreviewPainter` di mobile. */
function QrPreview() {
  const cells = 17
  const finder = (row: number, col: number, top: number, left: number) => {
    const r = row - top
    const c = col - left
    if (r < 0 || c < 0 || r >= 7 || c >= 7) return false
    return r === 0 || r === 6 || c === 0 || c === 6 || (r >= 2 && r <= 4 && c >= 2 && c <= 4)
  }

  const rects: Array<{ x: number; y: number }> = []
  for (let row = 0; row < cells; row++) {
    for (let col = 0; col < cells; col++) {
      const inFinder =
        finder(row, col, 0, 0) || finder(row, col, 0, cells - 7) || finder(row, col, cells - 7, 0)
      const dark = inFinder || ((row * 7 + col * 11 + row * col) % 5 < 2)
      if (dark) rects.push({ x: col, y: row })
    }
  }

  return (
    <svg viewBox={`0 0 ${cells} ${cells}`} role="img" aria-label="Pratinjau QRIS">
      {rects.map((rect) => (
        <rect key={`${rect.x}-${rect.y}`} x={rect.x} y={rect.y} width={1} height={1} fill="#1c1c19" />
      ))}
    </svg>
  )
}

export function CheckoutPage() {
  const { items, subtotal, clear } = useCart()
  const navigate = useNavigate()
  const { node: toast } = useToast()

  const [rates, setRates] = useState<ShippingRate[]>([])
  const [orderType, setOrderType] = useState<OrderType>('DELIVERY')
  const [paymentMethod, setPaymentMethod] = useState<PaymentMethod>('QRIS')
  const [customerName, setCustomerName] = useState('')
  const [whatsapp, setWhatsapp] = useState('')
  const [locationState, setLocationState] = useState<LocationState>('initial')
  const [coordinates, setCoordinates] = useState(MAPS_QUERY)
  const [error, setError] = useState('')
  const [submitting, setSubmitting] = useState(false)

  // Kode tiket dibuat di awal agar bisa ditampilkan pada panel pickup.
  const [ticketCode] = useState(() => `TKT-${String(Date.now()).slice(-6)}`)

  useEffect(() => {
    if (!supabase) return
    void supabase
      .from('shipping_rates')
      .select('*')
      .eq('is_active', true)
      .order('fee')
      .then(({ data }) => setRates((data as ShippingRate[]) ?? []))
  }, [])

  const selectedRate = rates[0]
  const shippingFee = orderType === 'DELIVERY' ? Number(selectedRate?.fee ?? 0) : 0
  const pb1 = calculatePb1(subtotal)
  const total = subtotal + pb1 + shippingFee

  const mapsUrl = useMemo(
    () => `https://maps.google.com/?q=${encodeURIComponent(coordinates)}`,
    [coordinates],
  )

  function detectLocation() {
    setLocationState('loading')
    if (!('geolocation' in navigator)) {
      setLocationState('failed')
      return
    }
    navigator.geolocation.getCurrentPosition(
      (position) => {
        setCoordinates(`${position.coords.latitude.toFixed(4)}, ${position.coords.longitude.toFixed(4)}`)
        setLocationState('found')
      },
      () => setLocationState('failed'),
      { enableHighAccuracy: true, timeout: 8000, maximumAge: 60000 },
    )
  }

  function openWhatsAppLocation() {
    const digits = whatsapp.replace(/\D/g, '')
    const phone = digits.startsWith('0') ? `62${digits.slice(1)}` : digits || '6281388992345'
    const message = encodeURIComponent(`Halo Lapak Jajanan, ini lokasi pengantaran saya: ${mapsUrl}`)
    window.open(`https://wa.me/${phone}?text=${message}`, '_blank', 'noopener')
    setLocationState('shared')
  }

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
    if (!customerName.trim()) {
      setError('Nama penerima wajib diisi.')
      return
    }

    setSubmitting(true)
    try {
      const { data: order, error: orderError } = await supabase
        .from('orders')
        .insert({
          ticket_code: ticketCode,
          location_id: getLocationId(),
          order_source: 'WEB_QR',
          order_type: orderType,
          customer_name: customerName.trim(),
          customer_whatsapp: whatsapp.trim() || null,
          delivery_address: orderType === 'DELIVERY' ? `Titik lokasi: ${coordinates}` : null,
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

  const locationBody = () => {
    switch (locationState) {
      case 'initial':
        return (
          <>
            <div className="c-loc-intro">
              <span className="c-square-icon">
                <Icon name="add_location_alt" />
              </span>
              <div>
                <h3>Lokasi Pengantaran</h3>
                <p>Bagikan titik lokasi Anda agar pesanan dapat diantar oleh kurir kami.</p>
              </div>
            </div>
            <div className="c-info-box">
              <Icon name="info" />
              <span>Website akan meminta izin akses lokasi dari browser Anda.</span>
            </div>
            <button type="button" className="c-wide-button" onClick={detectLocation}>
              <Icon name="my_location" />
              Gunakan Lokasi Saya
            </button>
          </>
        )
      case 'loading':
        return (
          <>
            <div className="c-loc-intro">
              <span className="c-square-icon">
                <Icon name="location_searching" />
              </span>
              <div>
                <h3>Sedang mendeteksi lokasi...</h3>
                <p>Mohon tunggu sebentar.</p>
              </div>
            </div>
            <div className="c-spin" />
          </>
        )
      case 'found':
        return (
          <>
            <div className="c-found-head">
              <Icon name="check_circle" />
              <span>Lokasi berhasil ditemukan</span>
              <span className="c-gps">GPS ~8 m</span>
            </div>
            <div className="c-coord-tile">
              <span className="c-square-icon">
                <Icon name="location_on" />
              </span>
              <div className="c-coord-tile-main">
                <strong>Koordinat: {coordinates} (Senopati, Jaksel)</strong>
                <span>Pin lokasi siap dikirim ke driver via WA</span>
              </div>
              <button type="button" className="c-text-button" onClick={detectLocation}>
                <Icon name="refresh" />
                Perbarui
              </button>
            </div>
            <button type="button" className="c-wide-button wa" onClick={openWhatsAppLocation}>
              <Icon name="share_location" />
              Kirim Lokasi ke WhatsApp
            </button>
            <p className="c-center-hint">WhatsApp akan dibuka dengan tautan Google Maps lokasi Anda.</p>
          </>
        )
      case 'shared':
        return (
          <>
            <div className="c-found-head">
              <Icon name="bookmark_added" />
              <span>Lokasi tersimpan</span>
            </div>
            <a className="c-map-link" href={mapsUrl} target="_blank" rel="noreferrer">
              <Icon name="map" />
              <span>maps.google.com/?q={coordinates}</span>
              <Icon name="open_in_new" />
            </a>
            <button type="button" className="c-wide-button soft" onClick={openWhatsAppLocation}>
              <Icon name="refresh" />
              Kirim Ulang Lokasi ke WhatsApp
            </button>
          </>
        )
      case 'failed':
        return (
          <>
            <div className="c-error-box">
              <Icon name="location_off" />
              <span>Lokasi belum berhasil didapatkan. Aktifkan izin lokasi, lalu coba lagi.</span>
            </div>
            <button type="button" className="c-wide-button" onClick={detectLocation}>
              <Icon name="refresh" />
              Coba Lagi
            </button>
          </>
        )
    }
  }

  return (
    <form className="c-shell" onSubmit={handleSubmit}>
      <header className="c-appbar">
        <button type="button" className="c-icon-button" aria-label="Kembali" onClick={() => navigate(-1)}>
          <Icon name="arrow_back" />
        </button>
        <h1 className="c-appbar-title">Checkout</h1>
        <button
          type="button"
          className="c-icon-button accent"
          aria-label="Pesanan saya"
          onClick={() => navigate('/riwayat')}
        >
          <Icon name="receipt_long" />
        </button>
      </header>

      <div className="c-body">
        <SetupNotice />

        <div className="c-greeting">
          <div className="c-greeting-main">
            <span className="c-greeting-chip">☕&nbsp; Lapak Jajanan • Table &amp; Delivery</span>
            <p className="c-greeting-title">Selesaikan Pesanan</p>
          </div>
          <span className="c-eta-pill">
            <Icon name="timer" />
            Est. 15-20 mnt
          </span>
        </div>

        <div className="c-spacer-12" />

        <SectionCard title="Data Penerima" icon="person_pin_circle">
          <label className="c-field-label" style={{ marginTop: 12 }} htmlFor="cust-name">
            Nama Lengkap
          </label>
          <div className="c-field-wrap">
            <Icon name="badge" />
            <input
              id="cust-name"
              className="c-field"
              value={customerName}
              onChange={(event) => setCustomerName(event.target.value)}
              placeholder="Nama penerima"
              autoComplete="name"
            />
            <span className="c-field-suffix">
              <Icon name="check_circle" />
            </span>
          </div>

          <label className="c-field-label" style={{ marginTop: 12 }} htmlFor="cust-wa">
            Nomor WhatsApp Aktif
          </label>
          <div className="c-field-wrap">
            <Icon name="chat_bubble" />
            <input
              id="cust-wa"
              className="c-field"
              value={whatsapp}
              onChange={(event) => setWhatsapp(event.target.value)}
              placeholder="081234567890"
              inputMode="tel"
              autoComplete="tel"
            />
            <span className="c-field-suffix">
              <span className="c-field-badge">Aktif</span>
            </span>
          </div>

          <p className="c-note-row">
            <Icon name="notifications_active" />
            <span>Struk dan update pesanan dikirim via WhatsApp</span>
          </p>
        </SectionCard>

        <div className="c-spacer-12" />

        <SectionCard
          title="Metode Pemenuhan"
          icon="moped"
          trailing={<span className="c-card-trailing">Area Aktif</span>}
        >
          <div className="c-seg">
            <button
              type="button"
              className={`c-seg-button${orderType === 'DELIVERY' ? ' active' : ''}`}
              onClick={() => setOrderType('DELIVERY')}
            >
              <Icon name="two_wheeler" />
              Delivery (Antar)
            </button>
            <button
              type="button"
              className={`c-seg-button${orderType === 'PICKUP' ? ' active' : ''}`}
              onClick={() => setOrderType('PICKUP')}
            >
              <Icon name="storefront" />
              Pickup (Ambil Sendiri)
            </button>
          </div>

          {orderType === 'DELIVERY' ? (
            <div className="c-panel">
              <div className="c-loc-chips">
                {LOCATION_LABELS.map((entry) => (
                  <button
                    key={entry.state}
                    type="button"
                    className={`c-loc-chip${locationState === entry.state ? ' active' : ''}`}
                    onClick={() => setLocationState(entry.state)}
                  >
                    {entry.label}
                  </button>
                ))}
              </div>
              <div style={{ marginTop: 10 }}>{locationBody()}</div>
            </div>
          ) : (
            <div className="c-panel">
              <div className="c-pickup-head">
                <span className="c-square-icon">
                  <Icon name="storefront" />
                </span>
                <div>
                  <h3>Lapak Jajanan — Lokasi Utama</h3>
                  <p>Gerai aktif • Estimasi siap ~15–20 menit</p>
                </div>
              </div>
              <div className="c-detail-box">
                <p className="c-detail-line">
                  <Icon name="location_on" />
                  <span>Jl. Senopati No. 45, Kebayoran Baru, Jakarta Selatan</span>
                </p>
                <p className="c-detail-line">
                  <Icon name="schedule" />
                  <span>Jam Operasional&nbsp; 10:00–22:00 WIB</span>
                </p>
              </div>
              <p className="c-pickup-note">
                Tunjukkan nomor pesanan {ticketCode} kepada kasir saat mengambil pesanan.
              </p>
            </div>
          )}
        </SectionCard>

        <div className="c-spacer-12" />

        <SectionCard title="Metode Pembayaran" icon="payments">
          <button
            type="button"
            className={`c-pay-option${paymentMethod === 'QRIS' ? ' active' : ''}`}
            onClick={() => setPaymentMethod('QRIS')}
          >
            <span className="c-pay-radio" />
            <span className="c-pay-copy">
              <strong>QRIS Instant</strong>
              <span>Bayar dengan aplikasi pembayaran pilihan Anda</span>
            </span>
            <Icon name="qr_code_2" />
          </button>

          {paymentMethod === 'QRIS' && (
            <div className="c-qr-box">
              <span className="c-qr-frame">
                <QrPreview />
              </span>
              <div className="c-qr-copy">
                <span className="c-qr-badge">Auto-Verified &lt; 2s</span>
                <h4>Preview QRIS</h4>
                <p>Nominal pembayaran {formatRupiah(total)}</p>
                <small>GoPay • BCA Mobile • OVO • DANA</small>
              </div>
            </div>
          )}

          <button
            type="button"
            className={`c-pay-option${paymentMethod === 'CASH' ? ' active' : ''}`}
            onClick={() => setPaymentMethod('CASH')}
          >
            <span className="c-pay-radio" />
            <span className="c-pay-copy">
              <strong>Cash (Tunai di Tempat)</strong>
              <span>
                {orderType === 'DELIVERY'
                  ? 'Bayar saat pesanan sampai'
                  : 'Bayar saat mengambil pesanan di gerai'}
              </span>
            </span>
            <Icon name="payments" />
          </button>
        </SectionCard>

        <div className="c-spacer-12" />

        <SectionCard title="Rincian Pembayaran" icon="receipt_long">
          <div className="c-item-list">
            {items.length === 0 ? (
              <div className="c-item-row">
                <span>Keranjang masih kosong</span>
              </div>
            ) : (
              items.map((item) => (
                <div className="c-item-row" key={item.key}>
                  <span>
                    {item.quantity}x {item.name}
                  </span>
                  <strong>{formatRupiah(item.unitPrice * item.quantity)}</strong>
                </div>
              ))
            )}
          </div>

          <div className="c-price-row">
            <span>Subtotal Menu ({items.length} item)</span>
            <strong>{formatRupiah(subtotal)}</strong>
          </div>
          <div className="c-price-row">
            <span>
              {orderType === 'DELIVERY' ? 'Ongkos Kirim Delivery' : 'Biaya Layanan Pickup'}
            </span>
            <strong className={shippingFee === 0 ? 'free' : ''}>
              {shippingFee === 0 ? 'Gratis (Rp0)' : formatRupiah(shippingFee)}
            </strong>
          </div>
          <div className="c-price-row">
            <span>PB1 Resto (10%)</span>
            <strong>{formatRupiah(pb1)}</strong>
          </div>

          <div className="c-total-box">
            <div>
              <h4>Total Pembayaran</h4>
              <p>
                {orderType === 'DELIVERY'
                  ? 'Termasuk pajak & ongkir'
                  : 'Termasuk pajak • Bebas biaya pickup'}
              </p>
            </div>
            <span>{formatRupiah(total)}</span>
          </div>
        </SectionCard>

        <p className="c-fresh-note">
          <Icon name="coffee" />
          <span>Pesanan diramu segar setelah dikonfirmasi.</span>
        </p>
      </div>

      <div className="c-bottombar">
        <div className="c-bottombar-inner">
          {error && <p className="c-form-error">{error}</p>}
          <p className="c-secure-row">
            <Icon name="lock" />
            <span>Terenkripsi 256-Bit SSL • QRIS Bank Indonesia Terdaftar</span>
          </p>
          <button type="submit" className="c-pay-button" disabled={submitting}>
            <Icon name={paymentMethod === 'QRIS' ? 'qr_code_scanner' : 'payments'} />
            <span className="c-pay-label">
              {submitting
                ? 'Memproses...'
                : paymentMethod === 'QRIS'
                  ? 'Bayar Sekarang via QRIS'
                  : 'Konfirmasi Pesanan Tunai'}
            </span>
            <span className="c-pay-total">{formatRupiah(total)}</span>
            <Icon name="arrow_forward" />
          </button>
        </div>
      </div>

      {toast}
    </form>
  )
}
