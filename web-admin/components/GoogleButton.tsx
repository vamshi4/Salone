'use client';

import Script from 'next/script';
import { useEffect, useRef, useState } from 'react';
import { useTranslations, useLocale } from 'next-intl';

declare global {
  interface Window {
    google?: {
      accounts: {
        id: {
          initialize: (config: { client_id: string; callback: (resp: { credential: string }) => void }) => void;
          renderButton: (el: HTMLElement, options: Record<string, unknown>) => void;
        };
      };
    };
  }
}

/** Renders Google's own "Sign in with Google" button (Google Identity
 * Services) and hands back the ID token JWT — the same credential the
 * mobile app gets from google_sign_in, verified by the backend's
 * verifyGoogleIdToken() against the same GOOGLE_CLIENT_ID. */
export function GoogleButton({
  onToken,
  onError,
  text = 'signin_with',
}: {
  onToken: (idToken: string) => void;
  onError?: (message: string) => void;
  text?: 'signin_with' | 'signup_with';
}) {
  const t = useTranslations('googleButton');
  const locale = useLocale();
  const ref = useRef<HTMLDivElement>(null);
  const [scriptReady, setScriptReady] = useState(false);

  useEffect(() => {
    if (!scriptReady || !ref.current || !window.google) return;
    const clientId = process.env.NEXT_PUBLIC_GOOGLE_CLIENT_ID;
    if (!clientId) {
      onError?.(t('notConfigured'));
      return;
    }
    window.google.accounts.id.initialize({
      client_id: clientId,
      callback: (resp) => onToken(resp.credential),
    });
    window.google.accounts.id.renderButton(ref.current, {
      theme: 'outline',
      size: 'medium',
      width: 268,
      text,
    });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [scriptReady]);

  return (
    <>
      {/* hl=<locale> localizes Google's own rendered button/consent text. */}
      <Script
        src={`https://accounts.google.com/gsi/client?hl=${locale}`}
        strategy="afterInteractive"
        onLoad={() => setScriptReady(true)}
        onError={() => onError?.(t('loadError'))}
      />
      <div ref={ref} className="flex justify-center min-h-[34px]" />
    </>
  );
}
