// Thin wrapper around the Meta Pixel's global fbq() — the base code (loaded
// in app/layout.tsx) attaches fbq to window; this file just guards every
// call so nothing throws when the Pixel isn't configured (local dev has no
// NEXT_PUBLIC_META_PIXEL_ID and never loads the base code).
declare global {
  interface Window {
    fbq?: (...args: unknown[]) => void;
  }
}

export function trackPixelEvent(eventName: string, params?: Record<string, unknown>) {
  if (typeof window === 'undefined' || typeof window.fbq !== 'function') return;
  window.fbq('track', eventName, params);
}
