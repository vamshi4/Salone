'use client';

import { Sidebar } from '@/components/Sidebar';
import { TopBar } from '@/components/TopBar';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { useAppStore } from '@/lib/store';
import { fetchMe } from '@/lib/auth';
import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';

const queryClient = new QueryClient();

function ShellContent({ children }: { children: React.ReactNode }) {
  const router = useRouter();
  const setAdmin = useAppStore((state) => state.setAdmin);
  const [status, setStatus] = useState<'checking' | 'ready' | 'error'>('checking');
  const [error, setError] = useState('');
  const [mobileNavOpen, setMobileNavOpen] = useState(false);

  const boot = async () => {
    setStatus('checking');
    try {
      const me = await fetchMe();
      if (!me) {
        router.replace('/login');
        return;
      }
      setAdmin(me.user);
      setStatus('ready');
    } catch (e) {
      setError(e instanceof Error ? e.message : 'Could not reach the server.');
      setStatus('error');
    }
  };

  useEffect(() => {
    boot();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  if (status === 'checking') {
    return (
      <div className="min-h-screen flex items-center justify-center bg-[#F4F6F8]">
        <p className="text-sm text-gray-400">Loading…</p>
      </div>
    );
  }

  if (status === 'error') {
    return (
      <div className="min-h-screen flex items-center justify-center bg-[#F4F6F8] p-4">
        <div className="card p-6 max-w-sm text-center space-y-3">
          <p className="text-sm font-semibold text-gray-900">Couldn&apos;t load your account</p>
          <p className="text-xs text-gray-500">{error}</p>
          <button onClick={boot} className="btn-primary">Retry</button>
        </div>
      </div>
    );
  }

  return (
    <div className="flex h-screen bg-gray-50">
      <Sidebar mobileOpen={mobileNavOpen} onCloseMobile={() => setMobileNavOpen(false)} />
      <div className="flex-1 flex flex-col overflow-hidden">
        <TopBar onOpenMobileNav={() => setMobileNavOpen(true)} />
        <main className="flex-1 overflow-y-auto">{children}</main>
      </div>
    </div>
  );
}

export function AppShell({ children }: { children: React.ReactNode }) {
  return (
    <QueryClientProvider client={queryClient}>
      <ShellContent>{children}</ShellContent>
    </QueryClientProvider>
  );
}
