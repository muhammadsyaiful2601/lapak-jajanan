/** PB1 (Pajak Barang dan Jasa Restoran) yang ditampilkan di keranjang & checkout. */
export const PB1_RATE = 0.1

export function calculatePb1(subtotal: number): number {
  return Math.round(subtotal * PB1_RATE)
}

export function calculateGrandTotal(subtotal: number, shippingFee = 0): number {
  return subtotal + calculatePb1(subtotal) + shippingFee
}
