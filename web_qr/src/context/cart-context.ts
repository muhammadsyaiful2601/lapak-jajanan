import { createContext } from 'react'
import type { CartItem } from '../types'

export interface CartContextValue {
  items: CartItem[]
  subtotal: number
  totalQuantity: number
  addItem: (item: CartItem) => void
  removeItem: (key: string) => void
  changeQuantity: (key: string, delta: number) => void
  setNote: (key: string, note: string) => void
  clear: () => void
}

export const CartContext = createContext<CartContextValue | null>(null)
