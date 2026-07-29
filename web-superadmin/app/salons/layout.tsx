'use client';

import { AppShell } from '@/components/AppShell';

export default function SalonsLayout({ children }: { children: React.ReactNode }) {
  return <AppShell>{children}</AppShell>;
}
