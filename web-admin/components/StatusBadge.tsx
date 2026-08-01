'use client';

import { useTranslations } from 'next-intl';

const STATUS_STYLES: Record<string, { dot: string; text: string }> = {
  PENDING: { dot: 'bg-amber-500', text: 'text-amber-700' },
  CONFIRMED: { dot: 'bg-green-600', text: 'text-green-700' },
  IN_PROGRESS: { dot: 'bg-blue-500', text: 'text-blue-700' },
  COMPLETED: { dot: 'bg-gray-400', text: 'text-gray-500' },
  CANCELLED: { dot: 'bg-red-500', text: 'text-red-600' },
  NO_SHOW: { dot: 'bg-gray-400', text: 'text-gray-500' },
};

const STATUS_KEYS: Record<string, string> = {
  PENDING: 'pending',
  CONFIRMED: 'confirmed',
  IN_PROGRESS: 'inProgress',
  COMPLETED: 'completed',
  CANCELLED: 'cancelled',
  NO_SHOW: 'noShow',
};

export function StatusBadge({ status }: { status: string }) {
  const t = useTranslations('statusBadge');
  const style = STATUS_STYLES[status] ?? { dot: 'bg-gray-400', text: 'text-gray-500' };
  const label = STATUS_KEYS[status] ? t(STATUS_KEYS[status]) : status;

  return (
    <span className={`inline-flex items-center gap-1.5 text-xs font-medium ${style.text}`}>
      <span className={`w-1.5 h-1.5 rounded-full ${style.dot}`} />
      {label}
    </span>
  );
}

