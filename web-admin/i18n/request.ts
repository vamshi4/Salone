import { getRequestConfig } from 'next-intl/server';
import { cookies, headers } from 'next/headers';
import { locales, parseAcceptLanguage, type Locale } from './locales';

export default getRequestConfig(async () => {
  const store = await cookies();
  const cookieLocale = store.get('locale')?.value;
  let locale: Locale;
  if (locales.includes(cookieLocale as Locale)) {
    locale = cookieLocale as Locale;
  } else {
    // No explicit choice saved yet — guess from the browser's own language
    // list instead of always rendering English first.
    const headerStore = await headers();
    locale = parseAcceptLanguage(headerStore.get('accept-language'));
  }

  return {
    locale,
    messages: (await import(`../messages/${locale}.json`)).default,
  };
});
