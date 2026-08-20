'use client';

import { useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { getToken } from '@/lib/api';

/**
 * Sends already-signed-in owners straight to the dashboard so the marketing
 * page isn't in the way of daily use. The token lives in localStorage, so the
 * check has to run client-side — keeping it in this leaf component lets the
 * landing page itself stay a server component (renders in the HTML, good for
 * SEO and for how fast the hero paints).
 */
export function RedirectIfAuthed() {
  const router = useRouter();

  useEffect(() => {
    if (getToken()) router.replace('/dashboard');
  }, [router]);

  return null;
}
