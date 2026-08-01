'use client';

import { useTranslations } from 'next-intl';
import { QRCodeSVG } from 'qrcode.react';
import { formatCurrency, type SalonSummary } from '@/lib/salon-api';
import { buildUpiLink, totalWithGst } from '@/lib/upi';

/** Shown when payment method is UPI: computes the GST-adjusted total and
 * renders a scannable `upi://pay` QR for the salon's own UPI ID. */
export function PaymentQr({ salon, price, note }: { salon: SalonSummary; price: number; note?: string }) {
  const t = useTranslations('paymentQr');
  const amount = totalWithGst(price, salon);

  if (!salon.upiId) {
    return (
      <p className="text-xs text-amber-600 bg-amber-50 border border-amber-200 rounded-md px-3 py-2">
        {t('noUpiId')}
      </p>
    );
  }

  const link = buildUpiLink({ vpa: salon.upiId, payeeName: salon.name, amount, note });

  return (
    <div className="flex flex-col items-center gap-1.5 py-2 bg-gray-50 rounded-lg border border-gray-200">
      <QRCodeSVG value={link} size={140} />
      <p className="text-base font-semibold text-gray-900 tabular-nums">{formatCurrency(amount, salon.currency)}</p>
      <p className="text-[11px] text-gray-400">
        {salon.gstEnabled ? t('includesGst', { rate: salon.gstRate }) : ''}
        {t('scanToPay')}
      </p>
    </div>
  );
}
