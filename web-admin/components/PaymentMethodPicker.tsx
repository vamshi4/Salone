'use client';

import { useTranslations } from 'next-intl';
import type { PaymentMethod } from '@/lib/salon-api';

export function PaymentMethodPicker({
  value,
  onChange,
  currency,
}: {
  value: PaymentMethod;
  onChange: (method: PaymentMethod) => void;
  currency?: string | null;
}) {
  const t = useTranslations('paymentMethod');
  const LABELS: Record<PaymentMethod, string> = { CASH: t('cash'), UPI: t('upi'), CARD: t('card') };
  // UPI is India's real-time bank-transfer network — the deep link and GST
  // math it drives (lib/upi.ts) are meaningless outside INR, so it's simply
  // not offered as an option for salons priced in another currency.
  const methods = (currency ?? 'INR') === 'INR' ? (['CASH', 'UPI', 'CARD'] as const) : (['CASH', 'CARD'] as const);

  return (
    <div className="flex gap-1.5">
      {methods.map((p) => (
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
