import { Route, Routes } from 'react-router-dom'
import { Layout } from './components/Layout'
import { CartPage } from './pages/CartPage'
import { CheckoutPage } from './pages/CheckoutPage'
import { HistoryPage } from './pages/HistoryPage'
import { MenuPage } from './pages/MenuPage'
import { TrackingPage } from './pages/TrackingPage'

export default function App() {
  return (
    <Routes>
      {/* Katalog & keranjang memakai shell Layout (header + bottom nav). */}
      <Route element={<Layout />}>
        <Route path="/" element={<MenuPage />} />
        <Route path="/cart" element={<CartPage />} />
      </Route>

      {/* Halaman customer tampil full-screen dengan app bar sendiri,
          identik dengan tampilan mobile (checkout / tracking / riwayat). */}
      <Route path="/checkout" element={<CheckoutPage />} />
      <Route path="/track/:ticketCode" element={<TrackingPage />} />
      <Route path="/riwayat" element={<HistoryPage />} />
    </Routes>
  )
}
