import type { CatalogMenu } from '../../data/mockCatalog'
import { formatRupiah } from '../../lib/supabase'

interface MenuCardProps {
  menu: CatalogMenu
  onSelect: (menu: CatalogMenu) => void
}

export function MenuCard({ menu, onSelect }: MenuCardProps) {
  return (
    <article className={menu.is_available ? 'menu-row' : 'menu-row sold-out'}>
      <button
        type="button"
        className="menu-row-main"
        onClick={() => onSelect(menu)}
        disabled={!menu.is_available}
        aria-label={`Lihat detail ${menu.name}`}
      >
        <div className={`menu-photo tone-${menu.tone}`}>
          {menu.image_url ? (
            <img className="menu-photo-img" src={menu.image_url} alt={menu.name} />
          ) : (
            <span className="menu-photo-emoji" aria-hidden="true">{menu.emoji}</span>
          )}
          {menu.badge && <span className="menu-badge">{menu.badge}</span>}
        </div>

        <div className="menu-row-body">
          <h3 className="menu-name">{menu.name}</h3>
          <p className="menu-desc">{menu.description}</p>
          <span className="menu-price">{formatRupiah(Number(menu.price))}</span>
        </div>
      </button>

      <button
        type="button"
        className="add-button"
        onClick={() => onSelect(menu)}
        disabled={!menu.is_available}
      >
        <span aria-hidden="true">+</span> {menu.is_available ? 'Tambah' : 'Habis'}
      </button>
    </article>
  )
}
