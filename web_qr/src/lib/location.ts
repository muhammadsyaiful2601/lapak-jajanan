const STORAGE_KEY = 'lapak-jajanan-location'

/** Deteksi lokasi dari QR code: /?location=<uuid> (FR-P01). */
export function getLocationId(): string | null {
  const fromQuery = new URLSearchParams(window.location.search).get('location')
  if (fromQuery) {
    sessionStorage.setItem(STORAGE_KEY, fromQuery)
    return fromQuery
  }
  return sessionStorage.getItem(STORAGE_KEY)
}

export function getLocationLabel(): string {
  const id = getLocationId()
  if (!id) return 'Lokasi belum dipilih'
  return id === 'lokasi-utama' ? 'Lokasi Utama' : id === 'pasar-kuliner' ? 'Pasar Kuliner' : 'Lokasi Terpilih'
}
