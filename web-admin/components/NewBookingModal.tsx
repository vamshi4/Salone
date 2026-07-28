'use client';

import { useMemo, useState } from 'react';
import { Modal, Field, inputClass } from './Modal';
import {
  useDataStore,
  formatINR,
  type Booking,
  type PaymentMethod,
} from '@/lib/data';

/** Two modes matching the mobile app: "Done service" (log a finished
 * walk-in now — the default) and "Schedule later" (a future appointment). */
export function NewBookingModal({
  onClose,
  prefill,
}: {
  onClose: () => void;
  prefill?: Booking;
}) {
  const { staff, services, customers, logBooking } = useDataStore();
  const activeStaff = staff.filter((s) => s.status === 'ACTIVE');

  const prefillCustomer = prefill ? customers.find((c) => c.id === prefill.customerId) : undefined;

  const [completed, setCompleted] = useState(!prefill);
  const [name, setName] = useState(prefillCustomer?.name ?? '');
  const [phone, setPhone] = useState(prefillCustomer?.phone ?? '');
  const [stylistId, setStylistId] = useState(prefill?.stylistId ?? activeStaff[0]?.id ?? '');
  const [selected, setSelected] = useState<Set<string>>(new Set(prefill?.serviceIds ?? []));
  const [payment, setPayment] = useState<PaymentMethod>('CASH');
  const [date, setDate] = useState(() => new Date().toISOString().slice(0, 10));
  const [time, setTime] = useState('17:00');
  const [error, setError] = useState('');
  const [showSuggestions, setShowSuggestions] = useState(false);

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

  const total = [...selected].reduce(
    (sum, id) => sum + (services.find((s) => s.id === id)?.price ?? 0),
    0
  );

  const toggle = (id: string) => {
    setSelected((prev) => {
      const next = new Set(prev);
      if (next.has(id)) next.delete(id);
      else next.add(id);
      return next;
    });
  };

  const save = () => {
    if (!name.trim()) return setError('Enter the customer name');
    if (!stylistId) return setError('Pick a staff member');
    if (selected.size === 0) return setError('Pick at least one service');
    logBooking({
      customerName: name,
      customerPhone: phone,
      stylistId,
      serviceIds: [...selected],
      completed,
      time: completed ? undefined : new Date(`${date}T${time}`).toISOString(),
      paymentMethod: completed ? payment : undefined,
    });
    onClose();
  };

  return (
    <Modal
      title={prefill ? 'Rebook customer' : 'New booking'}
      subtitle={completed ? 'Log a finished service' : 'Schedule a future visit'}
      onClose={onClose}
    >
      <div className="space-y-3">
        {/* Mode toggle */}
        <div className="flex gap-1 bg-gray-100 p-0.5 rounded-md">
          {[
            { label: 'Done service', value: true },
            { label: 'Schedule later', value: false },
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
          <Field label="Customer name">
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
          <Field label="Phone">
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

        <Field label="Staff">
          <div className="flex flex-wrap gap-1.5">
            {activeStaff.map((s) => (
              <button
                key={s.id}
                onClick={() => setStylistId(s.id)}
                className={`px-2.5 py-1.5 rounded-md text-xs font-medium transition-colors ${
                  stylistId === s.id
                    ? 'bg-primary-light text-primary-dark'
                    : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                }`}
              >
                {s.name}
              </button>
            ))}
          </div>
        </Field>

        <Field label="Services">
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
                  <span className="text-gray-400">{s.duration} min</span>
                </span>
                <span className="text-xs text-gray-900 tabular-nums">{formatINR(s.price)}</span>
              </label>
            ))}
          </div>
        </Field>

        {completed ? (
          <Field label="Payment method">
            <div className="flex gap-1.5">
              {(['CASH', 'UPI', 'CARD'] as const).map((p) => (
                <button
                  key={p}
                  onClick={() => setPayment(p)}
                  className={`px-3 py-1.5 rounded-md text-xs font-medium transition-colors ${
                    payment === p
                      ? 'bg-primary-light text-primary-dark'
                      : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                  }`}
                >
                  {p === 'CASH' ? 'Cash' : p === 'UPI' ? 'UPI' : 'Card'}
                </button>
              ))}
            </div>
          </Field>
        ) : (
          <div className="grid grid-cols-2 gap-2">
            <Field label="Date">
              <input type="date" className={inputClass} value={date} onChange={(e) => setDate(e.target.value)} />
            </Field>
            <Field label="Time">
              <input type="time" className={inputClass} value={time} onChange={(e) => setTime(e.target.value)} />
            </Field>
          </div>
        )}

        {error && <p className="text-xs text-red-600">{error}</p>}

        {/* Sticky running total footer */}
        <div className="flex items-center justify-between pt-3 border-t border-gray-200">
          <div>
            <p className="text-xs text-gray-400">Total</p>
            <p className="text-base font-semibold text-gray-900 tabular-nums">{formatINR(total)}</p>
          </div>
          <button onClick={save} className="btn-primary">
            {completed ? 'Log service' : 'Schedule booking'}
          </button>
        </div>
      </div>
    </Modal>
  );
}
