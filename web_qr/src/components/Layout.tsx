import { Link, NavLink, Outlet } from 'react-router-dom'
import { useCart } from '../context/useCart'
import { getLocationLabel } from '../lib/location'

export function Layout() {
  const { totalQuantity } = useCart()

  return (
    <div className="app-shell">
      <header className="app-header">
        <Link to="/" className="brand">
          <span className="brand-mark">🍢</span>
          <span>
            <strong>Lapak Jajanan</strong>
            <small>{getLocationLabel()}</small>
          </span>
        </Link>
      </header>

      <main className="app-content">
        <Outlet />
      </main>

      <nav className="bottom-nav" aria-label="Navigasi utama">
        <NavLink to="/" end>
          <span>🍽️</span> Menu
        </NavLink>
        <NavLink to="/cart">
          <span>🧺</span> Keranjang{totalQuantity > 0 ? ` (${totalQuantity})` : ''}
        </NavLink>
        <NavLink to="/riwayat">
          <span>📋</span> Riwayat
        </NavLink>
      </nav>
    </div>
  )
}
