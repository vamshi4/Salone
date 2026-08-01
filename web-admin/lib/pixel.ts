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

const PIXEL_ID = process.env.NEXT_PUBLIC_META_PIXEL_ID;

function getFbq(): ((...args: unknown[]) => void) | null {
  if (typeof window === 'undefined') return null;
  if (typeof fbq === 'function') return fbq;
  if (typeof window.fbq === 'function') return window.fbq;
  return null;
}

export function trackPixelEvent(eventName: string, params?: Record<string, unknown>) {
  getFbq()?.('track', eventName, params);
}

// Re-initializing the Pixel with Advanced Matching data right before the
// conversion event (name/phone aren't known at page-load init time, only
// after the signup form is filled) lets Meta match this event to a real ad
// click without us hashing anything ourselves — the Pixel SDK hashes
// whatever we pass here client-side before it ever leaves the browser.
export function trackCompleteRegistration(userData?: { phone?: string; firstName?: string; lastName?: string }) {
  const fn = getFbq();
  if (!fn) return;
  if (userData && PIXEL_ID) {
    fn('init', PIXEL_ID, {
      ph: userData.phone,
      fn: userData.firstName,
      ln: userData.lastName,
    });
  }
  fn('track', 'CompleteRegistration');
  fn('track', 'Lead');
}
