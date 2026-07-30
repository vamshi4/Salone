'use client';

import { useState } from 'react';
import { Modal, Field } from './Modal';
import { PaymentMethodPicker } from './PaymentMethodPicker';
import { PaymentQr } from './PaymentQr';
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
  const [payment, setPayment] = useState<PaymentMethod>('CASH');
  const setStatus = useSetBookingStatus(salon.id);

  const confirm = () => {
    setStatus.mutate(
      { bookingId: booking.id, status: 'COMPLETED', paymentMethod: payment },
      { onSuccess: onClose }
    );
  };

  return (
    <Modal title="Complete booking" subtitle={`${booking.customerName} · ${formatINR(booking.price)}`} onClose={onClose}>
      <div className="space-y-3">
        <Field label="Payment method">
          <PaymentMethodPicker value={payment} onChange={setPayment} />
        </Field>
        {payment === 'UPI' && (
          <PaymentQr salon={salon} price={booking.price} note={`${booking.customerName} · ${salon.name}`} />
        )}
        <button
          onClick={confirm}
          disabled={setStatus.isPending}
          className="btn-primary w-full disabled:opacity-60"
        >
          {setStatus.isPending ? 'Saving…' : 'Mark as done'}
        </button>
      </div>
    </Modal>
  );
}
