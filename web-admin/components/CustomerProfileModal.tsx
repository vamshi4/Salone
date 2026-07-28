'use client';

import { useState } from 'react';
import { Modal, Field, inputClass } from './Modal';
import { StatusBadge } from './StatusBadge';
import {
  useDataStore,
  formatINR,
  formatTime,
  formatDay,
  bookingServiceNames,
  type Customer,
} from '@/lib/data';
import { X } from 'lucide-react';

export function CustomerProfileModal({
  customer,
  onClose,
}: {
  customer: Customer;
  onClose: () => void;
}) {
  const { bookings, services, staff, saveCustomerProfile } = useDataStore();
  const [notes, setNotes] = useState(customer.notes);
  const [tags, setTags] = useState<string[]>(customer.tags);
  const [tagInput, setTagInput] = useState('');
  const [saved, setSaved] = useState(false);

  const history = bookings
    .filter((b) => b.customerId === customer.id)
    .sort((a, b) => b.time.localeCompare(a.time));
  const done = history.filter((b) => b.status === 'COMPLETED');
  const totalSpend = done.reduce((s, b) => s + b.price, 0);
  const last = done[0];

  const addTag = () => {
    const t = tagInput.trim().toLowerCase();
    if (t && !tags.includes(t)) setTags([...tags, t]);
    setTagInput('');
  };

  const save = () => {
    saveCustomerProfile(customer.id, notes, tags);
    setSaved(true);
    setTimeout(() => setSaved(false), 1500);
  };

  return (
    <Modal title={customer.name} subtitle={customer.phone} onClose={onClose}>
      <div className="space-y-4">
        {/* Stats */}
        <div className="grid grid-cols-3 gap-2">
          <div className="bg-gray-50 rounded-md px-3 py-2">
            <p className="text-xs text-gray-500">Visits</p>
            <p className="text-base font-semibold text-gray-900 tabular-nums">{done.length}</p>
          </div>
          <div className="bg-gray-50 rounded-md px-3 py-2">
            <p className="text-xs text-gray-500">Total spend</p>
            <p className="text-base font-semibold text-gray-900 tabular-nums">{formatINR(totalSpend)}</p>
          </div>
          <div className="bg-gray-50 rounded-md px-3 py-2">
            <p className="text-xs text-gray-500">Last visit</p>
            <p className="text-base font-semibold text-gray-900">
              {last ? formatDay(new Date(last.time)) : '—'}
            </p>
          </div>
        </div>

        {/* Notes + tags */}
        <Field label="Notes">
          <textarea
            className={`${inputClass} min-h-[56px] resize-y`}
            value={notes}
            onChange={(e) => setNotes(e.target.value)}
            placeholder="Preferences, allergies, reminders"
          />
        </Field>
        <Field label="Tags">
          <div className="flex flex-wrap items-center gap-1.5">
            {tags.map((t) => (
              <span
                key={t}
                className="inline-flex items-center gap-1 px-2 py-0.5 rounded text-xs bg-primary-light text-primary-dark"
              >
                {t}
                <button onClick={() => setTags(tags.filter((x) => x !== t))}>
                  <X size={11} />
                </button>
              </span>
            ))}
            <input
              className="px-2 py-1 rounded-md text-xs border border-gray-300 focus:outline-none focus:ring-1 focus:ring-primary/40 w-28"
              value={tagInput}
              onChange={(e) => setTagInput(e.target.value)}
              onKeyDown={(e) => e.key === 'Enter' && addTag()}
              placeholder="Add tag"
            />
          </div>
        </Field>
        <button onClick={save} className="btn-secondary">
          {saved ? 'Saved' : 'Save notes'}
        </button>

        {/* History */}
        <div>
          <p className="text-xs font-semibold text-gray-900 mb-1.5">History</p>
          <div className="border border-gray-200 rounded-md divide-y divide-gray-100">
            {history.length === 0 && (
              <p className="px-3 py-3 text-xs text-gray-400">No bookings yet.</p>
            )}
            {history.map((b) => (
              <div key={b.id} className="flex items-center justify-between px-3 py-2">
                <div>
                  <p className="text-xs text-gray-900">
                    {bookingServiceNames(b, services)}
                    <span className="text-gray-400">
                      {' '}· {staff.find((s) => s.id === b.stylistId)?.name ?? ''}
                    </span>
                  </p>
                  <p className="text-xs text-gray-400">
                    {formatDay(new Date(b.time))} · {formatTime(b.time)}
                  </p>
                </div>
                <div className="flex items-center gap-2.5">
                  <span className="text-xs text-gray-900 tabular-nums">{formatINR(b.price)}</span>
                  <StatusBadge status={b.status} />
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </Modal>
  );
}
