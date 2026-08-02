'use client';

import { useState } from 'react';
import { useTranslations } from 'next-intl';
import { Modal, Field } from './Modal';
import { PaymentMethodPicker } from './PaymentMethodPicker';
import { PaymentQr } from './PaymentQr';
import { ProductPicker, productsTotal, toProductSaleItems } from './ProductPicker';
import { formatCurrency, type Booking, type PaymentMethod, type RazorpayPaymentFields, type SalonSummary } from '@/lib/salon-api';
import { useSetBookingStatus } from '@/lib/salon-queries';
import { collectRazorpayPayment } from '@/lib/razorpay';

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
  const [error, setError] = useState('');
  const [collectingPayment, setCollectingPayment] = useState(false);
  const setStatus = useSetBookingStatus(salon.id);

  const retailAddOn = productsTotal(salon.products, productQty);
  const total = booking.price + retailAddOn;

  const confirm = async () => {
    setError('');
    let razorpay: RazorpayPaymentFields | undefined;
    if (payment === 'RAZORPAY') {
      setCollectingPayment(true);
      try {
        razorpay = await collectRazorpayPayment({
          amountPaise: Math.round(total * 100),
          salonName: salon.name,
          customerName: booking.customerName,
          customerPhone: booking.customerPhone,
        });
      } catch (e) {
        setCollectingPayment(false);
        return setError(e instanceof Error ? e.message : t('saving'));
      }
      setCollectingPayment(false);
    }

    setStatus.mutate(
      {
        bookingId: booking.id,
        status: 'COMPLETED',
        paymentMethod: payment,
        products: toProductSaleItems(productQty),
        razorpay,
      },
      {
        onSuccess: onClose,
        onError: (e) => setError(e instanceof Error ? e.message : t('saving')),
      }
    );
  };

  return (
    <Modal title={t('title')} subtitle={`${booking.customerName} · ${formatCurrency(booking.price, salon.currency)}`} onClose={onClose}>
      <div className="space-y-3">
        {salon.products.some((p) => p.stockQty > 0) && (
          <Field label={t('addProducts')}>
            <ProductPicker products={salon.products} selected={productQty} onChange={setProductQty} currency={salon.currency} />
          </Field>
        )}
        <Field label={t('paymentMethod')}>
          <PaymentMethodPicker value={payment} onChange={setPayment} currency={salon.currency} />
        </Field>
        {payment === 'UPI' && (
          <PaymentQr salon={salon} price={total} note={`${booking.customerName} · ${salon.name}`} />
        )}
        {retailAddOn > 0 && (
          <p className="text-xs text-gray-500">
            {t('breakdown', { service: formatCurrency(booking.price, salon.currency), products: formatCurrency(retailAddOn, salon.currency) })}{' '}
            <span className="font-medium text-gray-900">{formatCurrency(total, salon.currency)}</span>
          </p>
        )}
        {error && <p className="text-xs text-red-600">{error}</p>}
        <button
          onClick={confirm}
          disabled={setStatus.isPending || collectingPayment}
          className="btn-primary w-full disabled:opacity-60"
        >
          {collectingPayment ? t('collectingPayment') : setStatus.isPending ? t('saving') : t('markAsDone')}
        </button>
      </div>
    </Modal>
  );
}
