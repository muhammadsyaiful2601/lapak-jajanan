import { useEffect, useState } from 'react'
import { useNavigate, useParams } from 'react-router-dom'
import { Icon } from '../components/customer-ui'
import { useToast } from '../components/useToast'
import { SetupNotice } from '../components/SetupNotice'
import { formatRupiah, supabase } from '../lib/supabase'
import type { Order, OrderStatus } from '../types'
import '../customer.css'

const STATUS_FLOW: OrderStatus[] = ['MENUNGGU_KONFIRMASI', 'DIPROSES', 'DIANTAR', 'SELESAI']

const STEP_META: Record<
  OrderStatus,
  { title: string; description: string; time: string; icon: string }
> = {
  MENUNGGU_KONFIRMASI: {
    title: 'Menunggu Konfirmasi',
    description: 'Pesanan telah diterima kasir Lapak Jajan.',
    time: '12:35 WIB',
    icon: 'check',
  },
  DIPROSES: {
    title: 'Diproses di Dapur',
    description: 'Pesanan sedang disiapkan di dapur.',
    time: '12:37 WIB',
    icon: 'check',
  },
  DIANTAR: {
    title: 'Diantar Kurir',
    description: 'Kurir: Budi Santoso • Honda Beat B 4120 SNF (1.2 km lagi)',
    time: '12:45 WIB',
    icon: 'two_wheeler',
  },
  SELESAI: {
    title: 'Selesai',
    description: 'Pesanan diserahterimakan kepada pemesan.',
    time: 'Estimasi 12:55 WIB',
    icon: 'flag',
  },
}

const WA_NUMBER = '+62 813-8899-2345'
const WA_DIGITS = '6281388992345'

interface OrderItemRow {
  menu_name: string
  quantity: number
  subtotal: number
}

const DEMO_ITEMS: OrderItemRow[] = [
  { menu_name: 'Bakmi Spesial Komplit', quantity: 1, subtotal: 28000 },
  { menu_name: 'Dimsum Mentai', quantity: 1, subtotal: 20000 },
  { menu_name: 'Es Teh Manis', quantity: 1, subtotal: 5000 },
]

export function TrackingPage() {
  const { ticketCode = '' } = useParams()
  const navigate = useNavigate()
  const { show, node: toast } = useToast()
  const [order, setOrder] = useState<Order | null>(null)
  const [orderItems, setOrderItems] = useState<OrderItemRow[]>([])

  useEffect(() => {
    if (!supabase || !ticketCode) return
    void supabase
      .from('orders')
      .select('*')
      .eq('ticket_code', ticketCode)
      .maybeSingle()
      .then(({ data }) => {
        const found = (data as Order) ?? null
        setOrder(found)
        if (!found || !supabase) return
        void supabase
          .from('order_items')
          .select('menu_name, quantity, subtotal')
          .eq('order_id', found.id)
          .then(({ data: rows }) => setOrderItems((rows as OrderItemRow[]) ?? []))
      })
  }, [ticketCode])

  const currentIndex = order ? Math.max(0, STATUS_FLOW.indexOf(order.order_status)) : 0
  const displayTicket = ticketCode || '#KD-5082'
  const isPaid = order?.payment_status === 'PAID'

  function copyTicket() {
    void navigator.clipboard
      ?.writeText(displayTicket)
      .then(() => show('ID pesanan berhasil disalin.'))
      .catch(() => show('ID pesanan tidak dapat disalin.'))
  }

  function openWhatsApp() {
    window.open(`https://wa.me/${WA_DIGITS}`, '_blank', 'noopener')
  }

  const total = order ? Number(order.total_amount) : 68300
  const subtotal = order ? Number(order.subtotal_amount) : 53000
  const shipping = order ? Number(order.shipping_fee) : 10000
  const pb1 = Math.max(0, total - subtotal - shipping)

  return (
    <div className="c-shell">
      <header className="c-appbar">
        <button type="button" className="c-icon-button" aria-label="Kembali" onClick={() => navigate(-1)}>
          <Icon name="arrow_back" />
        </button>
        <h1 className="c-appbar-title">Konfirmasi &amp; Tracking</h1>
        <button
          type="button"
          className="c-icon-button accent"
          aria-label="Pesanan saya"
          onClick={() => navigate('/riwayat')}
        >
          <Icon name="receipt_long" />
        </button>
      </header>

      <main className="c-body">
        <SetupNotice />

        <div className="c-banner-success">
          <span className="c-circle-icon">
            <Icon name="check" />
          </span>
          <div>
            <strong>
              {isPaid || !order ? 'Pembayaran QRIS Berhasil & Lunas' : 'Menunggu Pembayaran'}
            </strong>
            <span>
              {isPaid || !order
                ? 'via Payment Gateway (TRX-GW-882194)'
                : 'Bayar tunai saat pesanan diterima.'}
            </span>
          </div>
          <Icon name="verified" />
        </div>

        <section className="c-track-card">
          <div className="c-greeting" style={{ alignItems: 'flex-start' }}>
            <div className="c-greeting-main">
              <span className="c-id-label">ID PESANAN</span>
              <div className="c-id-row">
                <span className="c-id-code">{displayTicket}</span>
                <button type="button" className="c-copy-button" aria-label="Salin ID Pesanan" onClick={copyTicket}>
                  <Icon name="content_copy" />
                </button>
              </div>
            </div>
            <span className="c-badge">
              <Icon name="two_wheeler" />
              {order?.order_type === 'PICKUP' ? 'Pickup' : 'Delivery'}
            </span>
          </div>

          <div className="c-info-tiles">
            <div className="c-info-tile">
              <small>Pemesan</small>
              <strong>{order?.customer_name || 'Rizky Ramadhan'}</strong>
            </div>
            <div className="c-info-tile">
              <small>Waktu</small>
              <strong>
                {order
                  ? new Date(order.created_at).toLocaleString('id-ID', {
                      day: 'numeric',
                      month: 'short',
                      hour: '2-digit',
                      minute: '2-digit',
                    })
                  : 'Hari ini, 12:35 WIB'}
              </strong>
            </div>
          </div>

          <div className="c-eta-box">
            <Icon name="schedule" />
            <div>
              <small>Estimasi Tiba</small>
              <strong>~20-25 Menit (12:55 WIB)</strong>
            </div>
            <span className="c-dot" />
          </div>
        </section>

        <section className="c-wa-card">
          <span className="c-circle-icon lg" style={{ background: '#2e7d32' }}>
            <Icon name="chat" />
          </span>
          <div className="c-wa-card-main">
            <span className="c-wa-tag">TERKIRIM OTOMATIS</span>
            <h3>Struk Resmi Digital via WhatsApp</h3>
            <p>Struk rincian biaya dan nomor pesanan telah dikirim ke {WA_NUMBER}.</p>
            <button type="button" className="c-wa-button" onClick={openWhatsApp}>
              <Icon name="forum" />
              Buka Obrolan WhatsApp Gerai
            </button>
          </div>
        </section>

        <section className="c-track-card">
          <h3>
            <Icon name="timeline" />
            <span>Pelacakan Pesanan</span>
            <span className="c-badge green tiny">Live Update</span>
          </h3>

          {STATUS_FLOW.map((status, index) => {
            const state = index < currentIndex ? 'done' : index === currentIndex ? 'active' : 'pending'
            const meta = STEP_META[status]
            return (
              <div key={status} className={`c-timeline-step ${state}`}>
                <div className="c-timeline-rail">
                  <span className={`c-timeline-dot ${state}`}>
                    <Icon name={meta.icon} />
                  </span>
                  {index < STATUS_FLOW.length - 1 && (
                    <span className={`c-timeline-line${index < currentIndex ? ' done' : ''}`} />
                  )}
                </div>
                <div className="c-timeline-body">
                  <div className="c-timeline-head">
                    <strong>{meta.title}</strong>
                    <time>{meta.time}</time>
                  </div>
                  <p>{meta.description}</p>
                </div>
              </div>
            )
          })}
        </section>

        <section className="c-track-card">
          <div className="c-menu-head">
            <h3>Rincian Menu</h3>
            <span>{orderItems.length > 0 ? `${orderItems.length} Produk` : '3 Produk'}</span>
          </div>

          {(orderItems.length > 0 ? orderItems : DEMO_ITEMS).map((item) => (
            <div className="c-menu-row" key={item.menu_name}>
              <span className="c-qty">{item.quantity}x</span>
              <span className="c-name">{item.menu_name}</span>
              <span className="c-price">{formatRupiah(Number(item.subtotal))}</span>
            </div>
          ))}

          <div className="c-cost-box">
            <div className="c-cost-row">
              <span>Subtotal</span>
              <strong>{formatRupiah(subtotal)}</strong>
            </div>
            <div className="c-cost-row">
              <span>{order?.order_type === 'PICKUP' ? 'Biaya Layanan Pickup' : 'Ongkos Kirim Delivery'}</span>
              <strong>{shipping === 0 ? 'Gratis' : formatRupiah(shipping)}</strong>
            </div>
            <div className="c-cost-row">
              <span>PB1 (10%)</span>
              <strong>{formatRupiah(pb1)}</strong>
            </div>
            <div className="c-cost-row total">
              <span>Total Pembayaran</span>
              <strong>{formatRupiah(total)}</strong>
            </div>
            <div className="c-paid-row">
              <Icon name="verified" />
              <span>{isPaid || !order ? 'Lunas QRIS' : 'Belum Dibayar'}</span>
            </div>
          </div>
        </section>
      </main>

      <div className="c-track-bottom">
        <button type="button" className="c-primary-button" onClick={() => navigate('/')}>
          <Icon name="restaurant_menu" />
          Pesan Menu Lainnya
        </button>
      </div>

      {toast}
    </div>
  )
}
