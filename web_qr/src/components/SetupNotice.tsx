import { isSupabaseConfigured } from '../lib/supabase'

/** Muncul saat env Supabase belum diisi, supaya jelas why data kosong. */
export function SetupNotice() {
  if (isSupabaseConfigured) return null

  return (
    <div className="notice">
      <strong>Mode preview</strong>
      <p>
        Supabase belum terhubung. Salin <code>.env.example</code> menjadi{' '}
        <code>.env</code>, isi URL dan publishable key, lalu restart{' '}
        <code>npm run dev</code>.
      </p>
    </div>
  )
}
