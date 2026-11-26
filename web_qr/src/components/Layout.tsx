import { Link, NavLink, Outlet } from 'react-router-dom'
import { useCart } from '../context/useCart'
import { getLocationLabel } from '../lib/location'

function PersonIcon() {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.8" aria-hidden="true">
      <circle cx="12" cy="8" r="4" />
      <path d="M4.5 21c0-4.1 3.4-6.5 7.5-6.5s7.5 2.4 7.5 6.5" strokeLinecap="round" />
    </svg>
  )
}

function MenuIcon() {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.7" aria-hidden="true">
      <path d="M4 3v6a2 2 0 0 0 2 2h0V3M7 3v18M14 3c-1.2 2.4-1.8 4.6-1.8 6.8 0 2.2 1 3.4 2.8 3.4V21" strokeLinecap="round" strokeLinejoin="round" />
    </svg>
  )
}

function CartIcon() {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.7" aria-hidden="true">
      <path d="M5.5 8h13l-1 13h-11l-1-13Z" strokeLinejoin="round" />
      <path d="M9 8a3 3 0 0 1 6 0" strokeLinecap="round" />
    </svg>
  )
}

function OrdersIcon() {
  return (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.7" aria-hidden="true">
      <path d="M6 3h12v18l-3-2-3 2-3-2-3 2V3Z" strokeLinejoin="round" />
      <path d="M9 8h6M9 12h6" strokeLinecap="round" />
    </svg>
  )
}

export function Layout() {
  const { totalQuantity } = useCart()

  return (
    <div className="app-shell">
      <header className="app-header">
        <div className="header-inner">
          <div className="header-row">
            <Link to="/" className="brand">
              <span className="brand-name">
                Lapak Jajanan <span className="brand-divider">/</span> Rasa Nusantara
              </span>
            </Link>
            <button type="button" className="avatar-button" aria-label="Profil pelanggan">
              <PersonIcon />
            </button>
          </div>
          <p className="header-location">
            <span className="status-dot" aria-hidden="true" />
            {getLocationLabel()} • Buka 10.00–22.00 WIB
          </p>
        </div>
      </header>

      <main className="app-content">
        <Outlet />
      </main>

      <nav className="bottom-nav" aria-label="Navigasi utama">
        <NavLink to="/" end className={({ isActive }) => (isActive ? 'active' : '')}>
          <span className="nav-icon-wrap"><MenuIcon /></span>
          <span>Menu</span>
        </NavLink>
        <NavLink to="/cart" className={({ isActive }) => (isActive ? 'active' : '')}>
          <span className="nav-icon-wrap">
            <CartIcon />
            <span className={totalQuantity > 0 ? 'nav-badge' : 'nav-badge empty'}>{totalQuantity}</span>
          </span>
          <span>Keranjang</span>
        </NavLink>
        <NavLink to="/riwayat" className={({ isActive }) => (isActive ? 'active' : '')}>
          <span className="nav-icon-wrap"><OrdersIcon /></span>
          <span>Pesanan Saya</span>
        </NavLink>
      </nav>
    </div>
  )
}
