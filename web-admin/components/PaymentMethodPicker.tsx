'use client';

import { useTranslations } from 'next-intl';
import type { PaymentMethod } from '@/lib/salon-api';
import { RAZORPAY_ENABLED } from '@/lib/razorpay';

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
  const LABELS: Record<PaymentMethod, string> = { CASH: t('cash'), UPI: t('upi'), CARD: t('card'), RAZORPAY: t('razorpay') };
  // UPI and Razorpay are both India-only (UPI's deep link/GST math in
  // lib/upi.ts is meaningless outside INR; Razorpay only onboards
  // India-registered merchants) — neither is offered for salons priced in
  // another currency.
  const isIndia = (currency ?? 'INR') === 'INR';
  const methods = isIndia
    ? ([...(['CASH', 'UPI', 'CARD'] as const), ...(RAZORPAY_ENABLED ? (['RAZORPAY'] as const) : [])])
    : (['CASH', 'CARD'] as const);

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
