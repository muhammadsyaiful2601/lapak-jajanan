import { useEffect, useMemo, useReducer, type ReactNode } from 'react'
import { CartContext, type CartContextValue } from './cart-context'
import type { CartItem } from '../types'

const STORAGE_KEY = 'lapak-jajanan-cart'

type CartAction =
  | { type: 'add'; item: CartItem }
  | { type: 'remove'; key: string }
  | { type: 'quantity'; key: string; delta: number }
  | { type: 'note'; key: string; note: string }
  | { type: 'replace'; items: CartItem[] }
  | { type: 'clear' }

function cartReducer(state: CartItem[], action: CartAction): CartItem[] {
  switch (action.type) {
    case 'add': {
      const existing = state.find((item) => item.key === action.item.key)
      if (existing) {
        return state.map((item) =>
          item.key === action.item.key
            ? { ...item, quantity: item.quantity + action.item.quantity }
            : item,
        )
      }
      return [...state, action.item]
    }
    case 'remove':
      return state.filter((item) => item.key !== action.key)
    case 'quantity':
      return state
        .map((item) =>
          item.key === action.key
            ? { ...item, quantity: item.quantity + action.delta }
            : item,
        )
        .filter((item) => item.quantity > 0)
    case 'note':
      return state.map((item) =>
        item.key === action.key ? { ...item, note: action.note } : item,
      )
    case 'replace':
      return action.items
    case 'clear':
      return []
  }
}

export function CartProvider({ children }: { children: ReactNode }) {
  const [items, dispatch] = useReducer(cartReducer, [] as CartItem[])

  useEffect(() => {
    const saved = localStorage.getItem(STORAGE_KEY)
    if (saved) {
      try {
        dispatch({ type: 'replace', items: JSON.parse(saved) as CartItem[] })
      } catch {
        localStorage.removeItem(STORAGE_KEY)
      }
    }
  }, [])

  useEffect(() => {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(items))
  }, [items])

  const value = useMemo<CartContextValue>(() => {
    return {
      items,
      subtotal: items.reduce(
        (sum, item) => sum + item.unitPrice * item.quantity,
        0,
      ),
      totalQuantity: items.reduce((sum, item) => sum + item.quantity, 0),
      addItem: (item) => dispatch({ type: 'add', item }),
      removeItem: (key) => dispatch({ type: 'remove', key }),
      changeQuantity: (key, delta) => dispatch({ type: 'quantity', key, delta }),
      setNote: (key, note) => dispatch({ type: 'note', key, note }),
      clear: () => dispatch({ type: 'clear' }),
    }
  }, [items])

  return <CartContext.Provider value={value}>{children}</CartContext.Provider>
}
