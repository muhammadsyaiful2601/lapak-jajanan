import { useState, type FormEvent } from 'react'
import { Link } from 'react-router-dom'
import { SetupNotice } from '../components/SetupNotice'
import { formatRupiah, supabase } from '../lib/supabase'
import type { Order } from '../types'

export function HistoryPage() {
  const [whatsapp, setWhatsapp] = useState('')
  const [orders, setOrders] = useState<Order[]>([])
  const [searched, setSearched] = useState(false)

  async function handleSearch(event: FormEvent) {
    event.preventDefault()
    setSearched(true)
    if (!supabase) return

    const { data } = await supabase
      .from('orders')
      .select('*')
      .eq('customer_whatsapp', whatsapp)
      .order('created_at', { ascending: false })
    setOrders((data as Order[]) ?? [])
  }

  return (
    <div className="page">
      <SetupNotice />
      <h1>Riwayat Pesanan</h1>
      <p className="muted">Cari berdasarkan nomor WhatsApp yang dipakai saat checkout (FR-P10).</p>

      <form className="search-form" onSubmit={handleSearch}>
        <input
          placeholder="081234567890"
          value={whatsapp}
          onChange={(event) => setWhatsapp(event.target.value)}
          required
        />
        <button type="submit" className="primary-button">Cari</button>
      </form>

      {searched && orders.length === 0 && <p className="muted">Tidak ada pesanan untuk nomor ini.</p>}

      {orders.map((order) => (
        <Link key={order.id} to={`/track/${order.ticket_code}`} className="history-card">
          <div>
            <strong>{order.ticket_code}</strong>
            <small className="muted">{new Date(order.created_at).toLocaleString('id-ID')}</small>
          </div>
          <span className="history-right">
            <strong>{formatRupiah(Number(order.total_amount))}</strong>
            <small>{order.order_status.replaceAll('_', ' ')}</small>
          </span>
        </Link>
      ))}
    </div>
  )
}
