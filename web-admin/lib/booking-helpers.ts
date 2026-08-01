import type { Booking } from './salon-api';

export function startOfDay(d: Date) {
  return new Date(d.getFullYear(), d.getMonth(), d.getDate());
}

export function isSameDay(a: Date, b: Date) {
  return a.getFullYear() === b.getFullYear() && a.getMonth() === b.getMonth() && a.getDate() === b.getDate();
}

// Returns a translation key for "today"/"yesterday", or a pre-formatted
// string for anything older — callers translate the key via their own
// useTranslations() since this file has no access to the current locale's
// messages.
export function formatDay(d: Date, locale: string): { key: 'today' | 'yesterday' } | { text: string } {
  const today = startOfDay(new Date());
  const day = startOfDay(d);
  const diff = Math.round((today.getTime() - day.getTime()) / 86400000);
  if (diff === 0) return { key: 'today' };
  if (diff === 1) return { key: 'yesterday' };
  return { text: d.toLocaleDateString(locale, { weekday: 'short', day: 'numeric', month: 'short' }) };
}

export function formatTime(iso: string, locale: string) {
  return new Date(iso).toLocaleTimeString(locale, { hour: 'numeric', minute: '2-digit', hour12: true }).toLowerCase();
}

export function bookingsToday(bookings: Booking[]) {
  const now = new Date();
  return bookings.filter((b) => isSameDay(new Date(b.time), now));
}

export function loggedToday(bookings: Booking[]) {
  return bookingsToday(bookings)
    .filter((b) => b.status === 'COMPLETED')
    .sort((a, b) => b.time.localeCompare(a.time));
}

export function needsAction(bookings: Booking[]) {
  return bookings.filter((b) => b.status === 'PENDING' || b.status === 'PENDING_RESCHEDULE');
}

export function todaySchedule(bookings: Booking[]) {
  const now = new Date();
  return bookingsToday(bookings)
    .filter((b) => b.status === 'CONFIRMED' && new Date(b.time) > now)
    .sort((a, b) => a.time.localeCompare(b.time));
}

export function repeatCustomerIds(bookings: Booking[]) {
  const counts = new Map<string, number>();
  for (const b of bookings) {
    if (b.status !== 'COMPLETED') continue;
    counts.set(b.customerId, (counts.get(b.customerId) ?? 0) + 1);
  }
  return new Set([...counts.entries()].filter(([, n]) => n >= 2).map(([id]) => id));
}
