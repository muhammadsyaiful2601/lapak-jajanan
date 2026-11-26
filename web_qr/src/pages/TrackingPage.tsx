import { useEffect, useState } from 'react'
import { Link, useParams } from 'react-router-dom'
import { SetupNotice } from '../components/SetupNotice'
import { formatRupiah, supabase } from '../lib/supabase'
import type { Order, OrderStatus } from '../types'

const STATUS_FLOW: OrderStatus[] = [
  'MENUNGGU_KONFIRMASI',
  'DIPROSES',
  'DIANTAR',
  'SELESAI',
]

const STATUS_LABEL: Record<OrderStatus, string> = {
  MENUNGGU_KONFIRMASI: 'Menunggu Konfirmasi',
  DIPROSES: 'Diproses',
  DIANTAR: 'Diantar',
  SELESAI: 'Selesai',
}

export function TrackingPage() {
  const { ticketCode = '' } = useParams()
  const [order, setOrder] = useState<Order | null>(null)

  useEffect(() => {
    if (!supabase || !ticketCode) return
    void supabase
      .from('orders')
      .select('*')
      .eq('ticket_code', ticketCode)
      .maybeSingle()
      .then(({ data }) => setOrder((data as Order) ?? null))
  }, [ticketCode])

  const currentIndex = order ? STATUS_FLOW.indexOf(order.order_status) : 0

  return (
    <div className="page">
      <SetupNotice />
      <h1>Lacak Pesanan</h1>
      <div className="ticket-card">
        <span>Kode tiket</span>
        <strong>{ticketCode}</strong>
      </div>

      <ol className="timeline">
        {STATUS_FLOW.map((status, index) => (
          <li key={status} className={index <= currentIndex ? 'done' : ''}>
            <span className="timeline-dot" />
            <div>
              <strong>{STATUS_LABEL[status]}</strong>
              {index === currentIndex && <small className="muted">Status saat ini</small>}
            </div>
          </li>
        ))}
      </ol>

      {order && (
        <div className="summary-card">
          <div className="summary-row"><span>Total bayar</span><strong>{formatRupiah(Number(order.total_amount))}</strong></div>
          <div className="summary-row"><span>Metode</span><span>{order.payment_method}</span></div>
          <div className="summary-row"><span>Jenis</span><span>{order.order_type}</span></div>
        </div>
      )}

      <p className="muted">
        Informasi ojek & struk WhatsApp (FR-P09, FR-P11) diimplementasikan pada minggu 4.
      </p>
      <Link to="/riwayat" className="primary-link">Lihat riwayat pesanan</Link>
    </div>
  )
}
