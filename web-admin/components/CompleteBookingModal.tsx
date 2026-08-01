'use client';

import { useState } from 'react';
import { useTranslations } from 'next-intl';
import { Modal, Field } from './Modal';
import { PaymentMethodPicker } from './PaymentMethodPicker';
import { PaymentQr } from './PaymentQr';
import { ProductPicker, productsTotal, toProductSaleItems } from './ProductPicker';
import { formatINR, type Booking, type PaymentMethod, type SalonSummary } from '@/lib/salon-api';
import { useSetBookingStatus } from '@/lib/salon-queries';

export function CompleteBookingModal({
  booking,
  salon,
  onClose,
}: {
  booking: Booking;
  salon: SalonSummary;
  onClose: () => void;
}) {
  const t = useTranslations('completeBooking');
  const [payment, setPayment] = useState<PaymentMethod>('CASH');
  const [productQty, setProductQty] = useState<Map<string, number>>(new Map());
  const setStatus = useSetBookingStatus(salon.id);

  const retailAddOn = productsTotal(salon.products, productQty);
  const total = booking.price + retailAddOn;

  const confirm = () => {
    setStatus.mutate(
      {
        bookingId: booking.id,
        status: 'COMPLETED',
        paymentMethod: payment,
        products: toProductSaleItems(productQty),
      },
      { onSuccess: onClose }
    );
  };

  return (
    <Modal title={t('title')} subtitle={`${booking.customerName} · ${formatINR(booking.price)}`} onClose={onClose}>
      <div className="space-y-3">
        {salon.products.some((p) => p.stockQty > 0) && (
          <Field label={t('addProducts')}>
            <ProductPicker products={salon.products} selected={productQty} onChange={setProductQty} />
          </Field>
        )}
        <Field label={t('paymentMethod')}>
          <PaymentMethodPicker value={payment} onChange={setPayment} />
        </Field>
        {payment === 'UPI' && (
          <PaymentQr salon={salon} price={total} note={`${booking.customerName} · ${salon.name}`} />
        )}
        {retailAddOn > 0 && (
          <p className="text-xs text-gray-500">
            {t('breakdown', { service: formatINR(booking.price), products: formatINR(retailAddOn) })}{' '}
            <span className="font-medium text-gray-900">{formatINR(total)}</span>
          </p>
        )}
        <button
          onClick={confirm}
          disabled={setStatus.isPending}
          className="btn-primary w-full disabled:opacity-60"
        >
          {setStatus.isPending ? t('saving') : t('markAsDone')}
        </button>
      </div>
    </Modal>
  );
}
