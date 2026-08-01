'use client';

import { useTranslations } from 'next-intl';
import type { PaymentMethod } from '@/lib/salon-api';

export function PaymentMethodPicker({
  value,
  onChange,
}: {
  value: PaymentMethod;
  onChange: (method: PaymentMethod) => void;
}) {
  const t = useTranslations('paymentMethod');
  const LABELS: Record<PaymentMethod, string> = { CASH: t('cash'), UPI: t('upi'), CARD: t('card') };

  return (
    <div className="flex gap-1.5">
      {(['CASH', 'UPI', 'CARD'] as const).map((p) => (
        <button
          key={p}
          onClick={() => onChange(p)}
          className={`px-3 py-1.5 rounded-md text-xs font-medium transition-colors ${
            value === p ? 'bg-primary-light text-primary-dark' : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
          }`}
        >
          {LABELS[p]}
        </button>
      ))}
    </div>
  );
}
