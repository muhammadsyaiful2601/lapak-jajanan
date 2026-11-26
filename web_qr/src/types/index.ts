/** Model data yang mirip dengan skema Supabase di database/database_schema.sql. */

export type OrderStatus =
  | 'MENUNGGU_KONFIRMASI'
  | 'DIPROSES'
  | 'DIANTAR'
  | 'SELESAI'

export interface Location {
  id: string
  name: string
  address: string | null
  open_time: string
  close_time: string
  is_open: boolean
}

export interface Category {
  id: string
  name: string
  sort_order: number
}

export interface Menu {
  id: string
  category_id: string | null
  name: string
  description: string | null
  price: number
  image_url: string | null
  is_available: boolean
}

export interface Topping {
  id: string
  menu_id: string
  topping_name: string
  extra_price: number
  is_available: boolean
}

export interface ShippingRate {
  id: string
  zone_name: string
  fee: number
  is_active: boolean
}

export interface Order {
  id: string
  ticket_code: string
  order_type: 'DELIVERY' | 'PICKUP'
  order_source: 'WEB_QR' | 'POS_WALKIN'
  customer_name: string
  customer_whatsapp: string | null
  delivery_address: string | null
  shipping_fee: number
  payment_method: 'CASH' | 'QRIS'
  payment_status: 'PENDING' | 'PAID'
  order_status: OrderStatus
  subtotal_amount: number
  total_amount: number
  created_at: string
}

export type MenuTone = 'orange' | 'red' | 'green' | 'yellow' | 'brown'

/** Ringkasan menu yang disimpan di keranjang agar tampilan tidak perlu fetch ulang. */
export interface CartMenuSnapshot {
  id: string
  name: string
  description: string | null
  price: number
  image_url: string | null
  emoji: string
  tone: MenuTone
  badge?: string
  tag?: string
}

export interface CartTopping {
  id: string
  name: string
  price: number
}

export interface CartItem {
  key: string
  menuId: string
  name: string
  unitPrice: number
  toppingNames: string[]
  quantity: number
  note: string
  menu?: CartMenuSnapshot
  variantId?: 'reguler' | 'jumbo'
  variantLabel?: string
  variantExtra?: number
  toppings?: CartTopping[]
}
