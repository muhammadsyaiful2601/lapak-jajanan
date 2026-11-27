import type { ReactNode } from 'react'

/** Ikon Material Symbols (font dimuat di index.html). */
export function Icon({ name, size }: { name: string; size?: number }) {
  return (
    <span className="msym" style={size ? { fontSize: size } : undefined} aria-hidden="true">
      {name}
    </span>
  )
}

/** Kartu bagian identik dengan `_SectionCard` di mobile. */
export function SectionCard({
  title,
  icon,
  trailing,
  children,
}: {
  title: string
  icon: string
  trailing?: ReactNode
  children: ReactNode
}) {
  return (
    <section className="c-card">
      <div className="c-card-head">
        <span className="c-card-icon">
          <Icon name={icon} />
        </span>
        <h2>{title}</h2>
        {trailing}
      </div>
      {children}
    </section>
  )
}
