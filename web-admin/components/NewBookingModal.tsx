'use client';

import { useMemo, useState } from 'react';
import { useTranslations } from 'next-intl';
import { Modal, Field, inputClass } from './Modal';
import { PaymentMethodPicker } from './PaymentMethodPicker';
import { PaymentQr } from './PaymentQr';
import { ProductPicker, productsTotal, toProductSaleItems } from './ProductPicker';
import { formatCurrency, type Booking, type PaymentMethod, type RazorpayPaymentFields } from '@/lib/salon-api';
import { useCurrentSalon, useCustomers, useLogBooking, useSelectedSalonId } from '@/lib/salon-queries';
import { AuthError } from '@/lib/auth';
import { collectRazorpayPayment } from '@/lib/razorpay';

/** Two modes matching the mobile app: "Done service" (log a finished
 * walk-in now — the default) and "Schedule later" (a future appointment). */
export function NewBookingModal({
  onClose,
  prefill,
}: {
  onClose: () => void;
  prefill?: Booking;
}) {
  const t = useTranslations('newBooking');
  const salonId = useSelectedSalonId();
  const salon = useCurrentSalon();
  const { data: customers = [] } = useCustomers(salonId);
  const logBooking = useLogBooking();

  const activeStaff = (salon?.staff ?? []).filter((s) => s.status === 'ACTIVE');
  const services = salon?.services ?? [];

  const [completed, setCompleted] = useState(!prefill);
  const [name, setName] = useState(prefill?.customerName ?? '');
  const [phone, setPhone] = useState(prefill?.customerPhone ?? '');
  const [stylistId, setStylistId] = useState(prefill?.stylistId ?? activeStaff[0]?.stylistId ?? '');
  const [selected, setSelected] = useState<Set<string>>(new Set(prefill?.serviceIds ?? []));
  const [productQty, setProductQty] = useState<Map<string, number>>(new Map());
  const [payment, setPayment] = useState<PaymentMethod>('CASH');
  const [date, setDate] = useState(() => new Date().toISOString().slice(0, 10));
  const [time, setTime] = useState('17:00');
  const [error, setError] = useState('');
  const [showSuggestions, setShowSuggestions] = useState(false);
  const [collectingPayment, setCollectingPayment] = useState(false);

  const availableServices = useMemo(() => {
    return services.filter((s) => !s.stylistId || s.stylistId === stylistId);
  }, [services, stylistId]);

  const suggestions = useMemo(() => {
    const q = (phone.trim() || name.trim()).toLowerCase();
    if (q.length < 2) return [];
    return customers
      .filter((c) => c.name.toLowerCase().includes(q) || c.phone.includes(q))
      .slice(0, 4);
  }, [customers, name, phone]);

  const servicesSubtotal = [...selected].reduce(
    (sum, id) => sum + (services.find((s) => s.id === id)?.price ?? 0),
    0
  );
  const retailAddOn = completed ? productsTotal(salon?.products ?? [], productQty) : 0;
  const total = servicesSubtotal + retailAddOn;

  const toggle = (id: string) => {
    setSelected((prev) => {
      const next = new Set(prev);
      if (next.has(id)) next.delete(id);
      else next.add(id);
      return next;
    });
  };

  const save = async () => {
    if (!salonId) return setError(t('errNoSalon'));
    if (!name.trim()) return setError(t('errName'));
    if (!phone.trim()) return setError(t('errPhone'));
    if (!stylistId) return setError(t('errStaff'));
    if (selected.size === 0) return setError(t('errService'));
    if (!completed && (!date || !time)) return setError(t('errDateTime'));

    setError('');

    let razorpay: RazorpayPaymentFields | undefined;
    if (completed && payment === 'RAZORPAY') {
      setCollectingPayment(true);
      try {
        razorpay = await collectRazorpayPayment({
          amountPaise: Math.round(total * 100),
          salonName: salon?.name ?? '',
          customerName: name.trim(),
          customerPhone: phone.trim(),
        });
      } catch (e) {
        setCollectingPayment(false);
        return setError(e instanceof Error ? e.message : t('errSave'));
      }
      setCollectingPayment(false);
    }

    logBooking.mutate(
      {
        salonId,
        stylistId,
        serviceIds: [...selected],
        customerName: name.trim(),
        customerPhone: phone.trim(),
        completed,
        dateTime: completed ? undefined : new Date(`${date}T${time}`).toISOString(),
        paymentMethod: completed ? payment : undefined,
        products: completed ? toProductSaleItems(productQty) : undefined,
        razorpay,
      },
      {
        onSuccess: () => onClose(),
        onError: (e) => setError(e instanceof AuthError ? e.message : t('errSave')),
      }
    );
  };

  return (
    <Modal
      title={prefill ? t('rebookTitle') : t('newTitle')}
      subtitle={completed ? t('doneSubtitle') : t('scheduleSubtitle')}
      onClose={onClose}
    >
      <div className="space-y-3">
        {/* Mode toggle */}
        <div className="flex gap-1 bg-gray-100 p-0.5 rounded-md">
          {[
            { label: t('doneService'), value: true },
            { label: t('scheduleLater'), value: false },
          ].map((m) => (
            <button
              key={m.label}
              onClick={() => setCompleted(m.value)}
              className={`flex-1 px-3 py-1.5 rounded text-xs font-medium transition-colors ${
                completed === m.value ? 'bg-white text-gray-900 shadow-sm' : 'text-gray-500'
              }`}
            >
              {m.label}
            </button>
          ))}
        </div>

        <div className="grid grid-cols-2 gap-2 relative">
          <Field label={t('customerName')}>
            <input
              className={inputClass}
              value={name}
              onChange={(e) => {
                setName(e.target.value);
                setShowSuggestions(true);
              }}
              placeholder="Asha Rao"
            />
          </Field>
          <Field label={t('phone')}>
            <input
              className={inputClass}
              value={phone}
              onChange={(e) => {
                setPhone(e.target.value);
                setShowSuggestions(true);
              }}
              placeholder="98765 43210"
            />
          </Field>
          {showSuggestions && suggestions.length > 0 && (
            <div className="absolute top-full left-0 right-0 mt-1 bg-white border border-gray-200 rounded-md shadow-lg z-10 overflow-hidden">
              {suggestions.map((c) => (
                <button
                  key={c.id}
                  onClick={() => {
                    setName(c.name);
                    setPhone(c.phone);
                    setShowSuggestions(false);
                  }}
                  className="block w-full text-left px-3 py-1.5 text-xs hover:bg-gray-50"
                >
                  <span className="font-medium text-gray-900">{c.name}</span>
                  <span className="text-gray-400"> · {c.phone}</span>
                </button>
              ))}
            </div>
          )}
        </div>

        <Field label={t('staff')}>
          <div className="flex flex-wrap gap-1.5">
            {activeStaff.map((s) => (
              <button
                key={s.stylistId}
                onClick={() => setStylistId(s.stylistId)}
                className={`px-2.5 py-1.5 rounded-md text-xs font-medium transition-colors ${
                  stylistId === s.stylistId
                    ? 'bg-primary-light text-primary-dark'
                    : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                }`}
              >
                {s.name}
              </button>
            ))}
            {activeStaff.length === 0 && (
              <p className="text-xs text-gray-400">{t('addStaffFirst')}</p>
            )}
          </div>
        </Field>

        <Field label={t('services')}>
          <div className="space-y-1">
            {availableServices.map((s) => (
              <label
                key={s.id}
                className="flex items-center justify-between px-2.5 py-1.5 rounded-md border border-gray-200 hover:bg-gray-50 cursor-pointer"
              >
                <span className="flex items-center gap-2 text-xs text-gray-900">
                  <input
                    type="checkbox"
                    checked={selected.has(s.id)}
                    onChange={() => toggle(s.id)}
                    className="rounded"
                  />
                  {s.name}
                  <span className="text-gray-400">{t('minutes', { count: s.duration })}</span>
                </span>
                <span className="text-xs text-gray-900 tabular-nums">{formatCurrency(s.price, salon?.currency)}</span>
              </label>
            ))}
            {availableServices.length === 0 && (
              <p className="text-xs text-gray-400">{t('noServicesForStaff')}</p>
            )}
          </div>
        </Field>

        {completed ? (
          <>
            {salon && salon.products.some((p) => p.stockQty > 0) && (
              <Field label={t('addProducts')}>
                <ProductPicker products={salon.products} selected={productQty} onChange={setProductQty} currency={salon.currency} />
              </Field>
            )}
            <Field label={t('paymentMethod')}>
              <PaymentMethodPicker value={payment} onChange={setPayment} currency={salon?.currency} />
            </Field>
            {payment === 'UPI' && salon && (
              <PaymentQr salon={salon} price={total} note={`${name.trim() || t('bookingFallback')} · ${salon.name}`} />
            )}
          </>
        ) : (
          <div className="grid grid-cols-2 gap-2">
            <Field label={t('date')}>
              <input type="date" className={inputClass} value={date} onChange={(e) => setDate(e.target.value)} />
            </Field>
            <Field label={t('time')}>
              <input type="time" className={inputClass} value={time} onChange={(e) => setTime(e.target.value)} />
            </Field>
          </div>
        )}

        {error && <p className="text-xs text-red-600">{error}</p>}

        {/* Sticky running total footer */}
        <div className="flex items-center justify-between pt-3 border-t border-gray-200">
          <div>
            <p className="text-xs text-gray-400">{t('total')}</p>
            <p className="text-base font-semibold text-gray-900 tabular-nums">{formatCurrency(total, salon?.currency)}</p>
          </div>
          <button onClick={save} disabled={logBooking.isPending || collectingPayment} className="btn-primary disabled:opacity-60">
            {collectingPayment
              ? t('collectingPayment')
              : logBooking.isPending
                ? t('saving')
                : completed
                  ? t('logService')
                  : t('scheduleBooking')}
          </button>
        </div>
      </div>
    </Modal>
  );
}
