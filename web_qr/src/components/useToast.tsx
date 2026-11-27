import { useCallback, useRef, useState } from 'react'

/** Toast ala SnackBar Flutter. */
export function useToast() {
  const [message, setMessage] = useState<string | null>(null)
  const timer = useRef<number | undefined>(undefined)

  const show = useCallback((next: string) => {
    setMessage(next)
    window.clearTimeout(timer.current)
    timer.current = window.setTimeout(() => setMessage(null), 2400)
  }, [])

  const node = message ? <div className="c-toast" role="status">{message}</div> : null
  return { show, node }
}
