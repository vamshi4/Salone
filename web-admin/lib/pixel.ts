// Thin wrapper around the Meta Pixel's global fbq() — the base code (loaded
// in app/layout.tsx) attaches fbq to window; this file just guards every
// call so nothing throws when the Pixel isn't configured (local dev has no
// NEXT_PUBLIC_META_PIXEL_ID and never loads the base code).
declare global {
  interface Window {
    fbq?: (...args: unknown[]) => void;
  }
}

declare const fbq: undefined | ((...args: unknown[]) => void);

export function trackPixelEvent(eventName: string, params?: Record<string, unknown>) {
  if (typeof window === 'undefined') return;
  if (typeof fbq === 'function') {
    fbq('track', eventName, params);
    return;
  }
  if (typeof window.fbq === 'function') window.fbq('track', eventName, params);
}

export function trackCompleteRegistration() {
  if (typeof window === 'undefined') return;
  if (typeof fbq === 'function') {
    fbq('track', 'CompleteRegistration');
    fbq('track', 'Lead');
    return;
  }
  if (typeof window.fbq !== 'function') return;
  window.fbq('track', 'CompleteRegistration');
  window.fbq('track', 'Lead');
}
