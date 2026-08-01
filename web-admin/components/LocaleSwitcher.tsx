'use client';

import { useRouter } from 'next/navigation';
import { useLocale } from 'next-intl';
import { Globe } from 'lucide-react';
import { locales, localeNames, type Locale } from '@/i18n/locales';
import { setLocaleCookie } from '@/lib/locale';

/** Compact language picker for pages that render before login (no
 * Preferences tab to switch from there). */
export function LocaleSwitcher() {
  const locale = useLocale();
  const router = useRouter();

  return (
    <div className="flex items-center justify-center gap-1.5 text-xs text-gray-400">
      <Globe size={12} />
      <select
        className="bg-transparent text-gray-500 focus:outline-none cursor-pointer"
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
    </div>
  );
}
