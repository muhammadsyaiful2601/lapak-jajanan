import { createClient, type SupabaseClient } from '@supabase/supabase-js'

const url = import.meta.env.VITE_SUPABASE_URL as string | undefined
const key = (import.meta.env.VITE_SUPABASE_PUBLISHABLE_KEY ||
  import.meta.env.VITE_SUPABASE_ANON_KEY) as string | undefined

export const isSupabaseConfigured = Boolean(url && key)

/** `null` saat env belum diisi — halaman tetap bisa dibuka untuk preview UI. */
export const supabase: SupabaseClient | null = isSupabaseConfigured
  ? createClient(url as string, key as string)
  : null

export function formatRupiah(value: number): string {
  return `Rp ${value.toLocaleString('id-ID')}`
}
