import { useEffect, useState, type FormEvent } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import { Icon } from '../components/customer-ui'
import { useToast } from '../components/useToast'
import { SetupNotice } from '../components/SetupNotice'
import { formatRupiah, supabase } from '../lib/supabase'
import type { Order } from '../types'
import '../customer.css'

const WA_HELP = '6281288992345'
const WA_RECEIPT = '6281388992345'

interface OrderItemRow {
  menu_name: string
  quantity: number
  subtotal: number
}

const DEMO_ACTIVE: Order = {
  id: 'demo',
  ticket_code: '#KD-5082',
  order_type: 'DELIVERY',
  order_source: 'WEB_QR',
  customer_name: 'Rizky Ramadhan',
  customer_whatsapp: '+62 813-8899-2345',
  delivery_address: 'Titik lokasi: -6.2241, 106.8095',
  shipping_fee: 10000,
  payment_method: 'QRIS',
  payment_status: 'PAID',
  order_status: 'DIANTAR',
  subtotal_amount: 53000,
  total_amount: 68300,
  created_at: new Date().toISOString(),
}

const DEMO_ITEMS: OrderItemRow[] = [
  { menu_name: 'Bakmi Spesial', quantity: 1, subtotal: 28000 },
  { menu_name: 'Dimsum Mentai', quantity: 1, subtotal: 20000 },
  { menu_name: 'Es Teh Manis', quantity: 1, subtotal: 5000 },
]

const DEMO_COMPLETED: Array<Order & { date: string; type: string }> = [
  {
    id: 'demo-4912',
    ticket_code: '#KD-4912',
    order_type: 'PICKUP',
    order_source: 'WEB_QR',
    customer_name: 'Rizky Ramadhan',
    customer_whatsapp: '+62 813-8899-2345',
    delivery_address: null,
    shipping_fee: 0,
    payment_method: 'QRIS',
    payment_status: 'PAID',
    order_status: 'SELESAI',
    subtotal_amount: 32000,
    total_amount: 32000,
    created_at: new Date(Date.now() - 86400000).toISOString(),
    date: 'Kemarin, 18:20 WIB',
    type: 'Pickup',
  },
  {
    id: 'demo-4200',
    ticket_code: '#KD-4200',
    order_type: 'DELIVERY',
    order_source: 'WEB_QR',
    customer_name: 'Rizky Ramadhan',
    customer_whatsapp: '+62 813-8899-2345',
    delivery_address: 'Jl. Senopati No. 45',
    shipping_fee: 10000,
    payment_method: 'QRIS',
    payment_status: 'PAID',
    order_status: 'SELESAI',
    subtotal_amount: 25000,
    total_amount: 35000,
    created_at: '2026-11-20T12:15:00+07:00',
    date: '20 Nov 2026, 12:15 WIB',
    type: 'Delivery',
  },
]

const STATUS_LABEL: Record<Order['order_status'], string> = {
  MENUNGGU_KONFIRMASI: 'Menunggu Konfirmasi',
  DIPROSES: 'Diproses',
  DIANTAR: 'Diantar',
  SELESAI: 'Selesai',
}

function progressOf(order: Order): number {
  switch (order.order_status) {
    case 'MENUNGGU_KONFIRMASI':
      return 1 / 3
    case 'DIPROSES':
      return 2 / 3
    case 'DIANTAR':
      return 2 / 3
    case 'SELESAI':
      return 1
  }
}

export function HistoryPage() {
  const navigate = useNavigate()
  const { show, node: toast } = useToast()

  const [whatsapp, setWhatsapp] = useState('')
  const [orders, setOrders] = useState<Order[]>([])
  const [itemsByOrder, setItemsByOrder] = useState<Record<string, OrderItemRow[]>>({})
  const [searched, setSearched] = useState(false)
  const [showCompleted, setShowCompleted] = useState(false)
  const [searching, setSearching] = useState(false)

  async function handleSearch(event: FormEvent) {
    event.preventDefault()
    setSearched(true)
    setSearching(true)
    if (!supabase) {
      setSearching(false)
      return
    }

    const { data } = await supabase
      .from('orders')
      .select('*')
      .eq('customer_whatsapp', whatsapp.trim())
      .order('created_at', { ascending: false })

    const found = (data as Order[]) ?? []
    setOrders(found)

    if (found.length > 0) {
      const { data: rows } = await supabase
        .from('order_items')
        .select('order_id, menu_name, quantity, subtotal')
        .in(
          'order_id',
          found.map((order) => order.id),
        )
      const grouped: Record<string, OrderItemRow[]> = {}
      for (const row of (rows as Array<OrderItemRow & { order_id: string }>) ?? []) {
        ;(grouped[row.order_id] ??= []).push(row)
      }
      setItemsByOrder(grouped)
    } else {
      setItemsByOrder({})
    }
    setSearching(false)
  }

  // Data tampil: hasil pencarian bila ada, else contoh (mode preview).
  const activeOrders = searched
    ? orders.filter((order) => order.order_status !== 'SELESAI')
    : [DEMO_ACTIVE]
  const completedOrders: Array<Order & { date?: string; type?: string }> = searched
    ? orders.filter((order) => order.order_status === 'SELESAI')
    : DEMO_COMPLETED

  const activeCount = searched ? activeOrders.length : 1
  const completedCount = searched ? completedOrders.length : 2

  const activeOrder = activeOrders[0]

  useEffect(() => {
    if (activeOrder && activeOrder.id !== 'demo' && !itemsByOrder[activeOrder.id]) {
      if (!supabase) return
      void supabase
        .from('order_items')
        .select('menu_name, quantity, subtotal')
        .eq('order_id', activeOrder.id)
        .then(({ data }) => {
          if (data) setItemsByOrder((prev) => ({ ...prev, [activeOrder.id]: data as OrderItemRow[] }))
        })
    }
  }, [activeOrder, itemsByOrder])

  const items = activeOrder
    ? (itemsByOrder[activeOrder.id]?.length ? itemsByOrder[activeOrder.id] : DEMO_ITEMS)
    : []
  const subtotal = activeOrder ? Number(activeOrder.subtotal_amount) : 53000
  const shipping = activeOrder ? Number(activeOrder.shipping_fee) : 10000
  const total = activeOrder ? Number(activeOrder.total_amount) : 68300
  const pb1 = Math.max(0, total - subtotal - shipping)

  function openWhatsApp(phone: string, message?: string) {
    const text = message ? `?text=${encodeURIComponent(message)}` : ''
    window.open(`https://wa.me/${phone}${text}`, '_blank', 'noopener')
  }

  return (
    <div className="c-shell">
      <header className="c-brand-header">
        <div className="c-brand-main">
          <div className="c-brand-row">
            <Link to="/" className="c-brand-name" style={{ textDecoration: 'none' }}>
              Lapak Jajan
            </Link>
            <span className="c-brand-sep">/</span>
            <span className="c-brand-sub">Rasa Nusantara</span>
          </div>
          <p className="c-brand-loc">
            <Icon name="circle" />
            <span>Lokasi Utama • Buka 10:00 - 22:00 WIB</span>
          </p>
        </div>
        <span className="c-avatar">
          <Icon name="person" />
        </span>
      </header>

      <main className="c-body">
        <SetupNotice />

        <div className="c-tabs">
          <button
            type="button"
            className={`c-tab${showCompleted ? '' : ' active'}`}
            onClick={() => setShowCompleted(false)}
          >
            <Icon name={showCompleted ? 'circle' : 'radio_button_checked'} />
            Dalam Proses ({activeCount})
          </button>
          <button
            type="button"
            className={`c-tab${showCompleted ? ' active' : ''}`}
            onClick={() => setShowCompleted(true)}
          >
            <Icon name={showCompleted ? 'radio_button_checked' : 'history'} />
            Riwayat Selesai ({completedCount})
          </button>
        </div>

        <form className="c-search-row" onSubmit={handleSearch}>
          <input
            value={whatsapp}
            onChange={(event) => setWhatsapp(event.target.value)}
            placeholder="Cari nomor WhatsApp (081234567890)"
            inputMode="tel"
            aria-label="Nomor WhatsApp"
          />
          <button type="submit" disabled={searching}>
            {searching ? 'Mencari...' : 'Cari'}
          </button>
        </form>

        {searched && !searching && orders.length === 0 && (
          <div className="c-empty">
            <Icon name="receipt_long" />
            <strong>Tidak ada pesanan untuk nomor ini.</strong>
            <p>Periksa kembali nomor WhatsApp yang dipakai saat checkout.</p>
          </div>
        )}

        {showCompleted ? (
          completedOrders.map((order) => {
            const entry = order as Order & { date?: string; type?: string }
            const ticket = entry.ticket_code
            const date =
              entry.date ??
              new Date(entry.created_at).toLocaleString('id-ID', {
                day: 'numeric',
                month: 'short',
                year: 'numeric',
                hour: '2-digit',
                minute: '2-digit',
              })
            const type = entry.type ?? (entry.order_type === 'PICKUP' ? 'Pickup' : 'Delivery')
            return (
              <article className="c-completed-card" key={ticket}>
                <div className="c-completed-top">
                  <span className="c-completed-check">
                    <Icon name="check" />
                  </span>
                  <div className="c-completed-main">
                    <div className="c-top">
                      <span className="c-ticket">{ticket}</span>
                      <span className={`c-badge tiny${type === 'Pickup' ? '' : ' green'}`}>{type}</span>
                    </div>
                    <small>{date}</small>
                  </div>
                  <span className="c-completed-amount">{formatRupiah(Number(entry.total_amount))}</span>
                </div>
                <div className="c-completed-divider" />
                <div className="c-receipt-actions" style={{ marginTop: 0 }}>
                  <button
                    type="button"
                    className="c-outline-button"
                    onClick={() =>
                      entry.id === 'demo'
                        ? show(`Struk ${ticket} siap dilihat.`)
                        : navigate(`/track/${ticket}`)
                    }
                  >
                    <Icon name="receipt_long" />
                    Lihat Struk
                  </button>
                  <button
                    type="button"
                    className="c-fill-button"
                    onClick={() => {
                      show(`Menu dari pesanan ${ticket} ditambahkan ke keranjang.`)
                      navigate('/')
                    }}
                  >
                    <Icon name="replay" />
                    Pesan Lagi
                  </button>
                </div>
              </article>
            )
          })
        ) : (
          <>
            {activeOrder && (
              <>
                <div className="c-active-banner">
                  <span className="c-active-banner-icon">
                    <Icon name="two_wheeler" />
                  </span>
                  <div className="c-active-banner-main">
                    <div className="c-top">
                      <strong>{activeOrder.ticket_code}</strong>
                      <span className="c-live-badge">LIVE</span>
                    </div>
                    <p>
                      {activeOrder.order_status === 'SELESAI'
                        ? 'Pesanan selesai. Terima kasih!'
                        : `${STATUS_LABEL[activeOrder.order_status]} • Tiba ~10 mnt`}
                    </p>
                  </div>
                  <button
                    type="button"
                    className="c-track-button"
                    onClick={() =>
                      activeOrder.id === 'demo'
                        ? navigate('/track/KD-5082')
                        : navigate(`/track/${activeOrder.ticket_code}`)
                    }
                  >
                    <Icon name="near_me" />
                    Lacak
                  </button>
                </div>

                <article className="c-receipt">
                  <div className="c-receipt-head">
                    <div className="c-receipt-head-main">
                      <div className="c-top">
                        <span className="c-ticket">{activeOrder.ticket_code}</span>
                        <span className="c-badge tiny green">
                          <Icon name="two_wheeler" />
                          {activeOrder.order_type === 'PICKUP' ? 'Pickup' : 'Delivery'}
                        </span>
                      </div>
                      <small>
                        {new Date(activeOrder.created_at).toLocaleString('id-ID', {
                          day: 'numeric',
                          month: 'long',
                          hour: '2-digit',
                          minute: '2-digit',
                        })}{' '}
                        WIB
                      </small>
                    </div>
                    <div className="c-receipt-head-amount">
                      <strong>{formatRupiah(total)}</strong>
                      <span className="c-paid">
                        <Icon name="verified" />
                        {activeOrder.payment_status === 'PAID' ? 'QRIS Lunas' : 'Belum Dibayar'}
                      </span>
                    </div>
                  </div>

                  <div className="c-progress">
                    <div className="c-progress-labels">
                      <span>Pesanan Diterima</span>
                      <span className="on">Di Jalan</span>
                      <span>Tiba</span>
                    </div>
                    <div className="c-progress-track">
                      <div
                        className="c-progress-fill"
                        style={{ width: `${Math.round(progressOf(activeOrder) * 100)}%` }}
                      />
                    </div>
                  </div>

                  <div className="c-receipt-body">
                    <div className="c-receipt-title">
                      <Icon name="receipt_long" />
                      <strong>Pratinjau Struk Digital</strong>
                      <span className="c-wa-sync">
                        <Icon name="chat" />
                        WhatsApp Synced
                      </span>
                    </div>

                    <div className="c-receipt-store">
                      <span className="c-store-avatar">
                        <Icon name="local_cafe" />
                      </span>
                      <div className="c-receipt-store-main">
                        <strong>Lapak Jajan</strong>
                        <span>Lokasi Utama</span>
                      </div>
                      <span className="c-store-chip">{activeOrder.ticket_code}</span>
                    </div>

                    <div className="c-receipt-cust">
                      <div className="c-receipt-cust-main">
                        <strong>{activeOrder.customer_name}</strong>
                        <span>{activeOrder.customer_whatsapp ?? '-'}</span>
                      </div>
                      <span className="c-loc-chip-static">
                        <Icon name="pin_drop" />
                        WA Share Loc
                      </span>
                    </div>

                    <div className="c-receipt-items">
                      {items.map((item) => (
                        <div className="c-receipt-item" key={item.menu_name}>
                          <span className="c-qty">{item.quantity}x</span>
                          <span className="c-name">{item.menu_name}</span>
                          <span className="c-price">{formatRupiah(Number(item.subtotal))}</span>
                        </div>
                      ))}
                    </div>

                    <div className="c-receipt-cost">
                      <div className="c-cost-row">
                        <span>
                          {activeOrder.order_type === 'PICKUP'
                            ? 'Biaya Layanan Pickup'
                            : 'Ongkir Delivery (Share Loc)'}
                        </span>
                        <strong>{shipping === 0 ? 'Gratis' : formatRupiah(shipping)}</strong>
                      </div>
                      <div className="c-cost-row">
                        <span>PB1 (10%)</span>
                        <strong>{formatRupiah(pb1)}</strong>
                      </div>
                      <div className="c-cost-row total">
                        <span>Total Tagihan</span>
                        <strong>{formatRupiah(total)}</strong>
                      </div>
                    </div>

                    <div className="c-receipt-msg">
                      <Icon name="mark_chat_read" />
                      <span>Struk terkirim otomatis ke WhatsApp pelanggan.</span>
                    </div>

                    <div className="c-receipt-actions">
                      <button
                        type="button"
                        className="c-outline-button"
                        onClick={() => {
                          show('Menu pesanan ditambahkan ke keranjang.')
                          navigate('/')
                        }}
                      >
                        <Icon name="add_shopping_cart" />
                        Pesan Lagi
                      </button>
                      <button
                        type="button"
                        className="c-fill-button wa"
                        onClick={() =>
                          openWhatsApp(
                            WA_RECEIPT,
                            `Halo Lapak Jajan, saya ingin melihat struk pesanan ${activeOrder.ticket_code}.`,
                          )
                        }
                      >
                        <Icon name="chat" />
                        Buka di WhatsApp
                      </button>
                    </div>
                  </div>
                </article>
              </>
            )}
          </>
        )}

        <div className="c-help-banner">
          <span className="c-help-icon">
            <Icon name="support_agent" />
          </span>
          <strong>Butuh bantuan pesanan?</strong>
          <button
            type="button"
            className="c-help-button"
            onClick={() => openWhatsApp(WA_HELP, 'Halo Lapak Jajan, saya butuh bantuan pesanan.')}
          >
            Chat CS
          </button>
        </div>
      </main>

      {toast}
    </div>
  )
}
