import { isSupabaseConfigured } from '../lib/supabase'

/** Muncul saat env Supabase belum diisi — katalog memakai data contoh. */
export function SetupNotice() {
  if (isSupabaseConfigured) return null

  return (
    <div className="notice">
      <strong>Mode preview</strong>
      <p>
        Menampilkan data contoh. Isi <code>.env</code> dari <code>.env.example</code> untuk memakai data Supabase.
      </p>
    </div>
  )
}
