'use client';

import { useRouter } from 'next/navigation';
import { useLocale } from 'next-intl';
import { Globe, ChevronDown } from 'lucide-react';
import { locales, localeNames, type Locale } from '@/i18n/locales';
import { setLocaleCookie } from '@/lib/locale';

/** Compact language picker for pages that render before login (no
 * Preferences tab to switch from there) — a small icon+label control meant
 * to sit top-right inside the card, matching the mobile app's
 * auth_pick_language button (login_screen.dart) instead of floating below
 * the form as a disconnected element. */
export function LocaleSwitcher({ className = '' }: { className?: string }) {
  const locale = useLocale();
  const router = useRouter();

  return (
    <div className={`relative inline-flex items-center gap-1 text-xs font-medium text-gray-500 ${className}`}>
      <Globe size={13} />
      <select
        className="appearance-none bg-transparent pr-3.5 focus:outline-none cursor-pointer"
        value={locale}
        onChange={(e) => {
          setLocaleCookie(e.target.value as Locale);
          router.refresh();
        }}
      >
        {locales.map((code) => (
          <option key={code} value={code}>
            {localeNames[code]}
          </option>
        ))}
      </select>
      <ChevronDown size={11} className="pointer-events-none absolute right-0" />
    </div>
  );
}
