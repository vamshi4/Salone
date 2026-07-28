'use client';

import { useState } from 'react';
import { Modal, Field, inputClass } from './Modal';
import { useDataStore, formatINR, isSameDay, type Staff } from '@/lib/data';

export function AddStaffModal({ onClose }: { onClose: () => void }) {
  const { services, addStaff } = useDataStore();
  const [name, setName] = useState('');
  const [phone, setPhone] = useState('');
  const [selected, setSelected] = useState<Set<string>>(new Set());
  const [error, setError] = useState('');

  const toggle = (id: string) =>
    setSelected((prev) => {
      const next = new Set(prev);
      next.has(id) ? next.delete(id) : next.add(id);
      return next;
    });

  const save = () => {
    if (!name.trim()) return setError('Enter a name');
    addStaff(name.trim(), phone.trim(), [...selected]);
    onClose();
  };

  return (
    <Modal title="Add staff" subtitle="New team member" onClose={onClose}>
      <div className="space-y-3">
        <Field label="Name">
          <input className={inputClass} value={name} onChange={(e) => setName(e.target.value)} placeholder="Full name" />
        </Field>
        <Field label="Phone">
          <input className={inputClass} value={phone} onChange={(e) => setPhone(e.target.value)} placeholder="98765 43210" />
        </Field>
        <Field label="Services they offer">
          <div className="flex flex-wrap gap-1.5">
            {services.map((s) => (
              <button
                key={s.id}
                onClick={() => toggle(s.id)}
                className={`px-2.5 py-1.5 rounded-md text-xs font-medium transition-colors ${
                  selected.has(s.id)
                    ? 'bg-primary-light text-primary-dark'
                    : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                }`}
              >
                {s.name}
              </button>
            ))}
          </div>
        </Field>
        {error && <p className="text-xs text-red-600">{error}</p>}
        <div className="flex justify-end pt-2 border-t border-gray-200">
          <button onClick={save} className="btn-primary">Add staff</button>
        </div>
      </div>
    </Modal>
  );
}

export function ManageStaffModal({ member, onClose }: { member: Staff; onClose: () => void }) {
  const { services, updateStaff } = useDataStore();
  const [name, setName] = useState(member.name);
  const [phone, setPhone] = useState(member.phone);
  const [active, setActive] = useState(member.status === 'ACTIVE');
  const [selected, setSelected] = useState<Set<string>>(new Set(member.serviceIds));

  const toggle = (id: string) =>
    setSelected((prev) => {
      const next = new Set(prev);
      next.has(id) ? next.delete(id) : next.add(id);
      return next;
    });

  const save = () => {
    updateStaff(member.id, {
      name: name.trim() || member.name,
      phone: phone.trim(),
      status: active ? 'ACTIVE' : 'INACTIVE',
      serviceIds: [...selected],
    });
    onClose();
  };

  return (
    <Modal title="Manage staff" subtitle={member.name} onClose={onClose}>
      <div className="space-y-3">
        <div className="grid grid-cols-2 gap-2">
          <Field label="Name">
            <input className={inputClass} value={name} onChange={(e) => setName(e.target.value)} />
          </Field>
          <Field label="Phone">
            <input className={inputClass} value={phone} onChange={(e) => setPhone(e.target.value)} />
          </Field>
        </div>
        <Field label="Services they offer">
          <div className="flex flex-wrap gap-1.5">
            {services.map((s) => (
              <button
                key={s.id}
                onClick={() => toggle(s.id)}
                className={`px-2.5 py-1.5 rounded-md text-xs font-medium transition-colors ${
                  selected.has(s.id)
                    ? 'bg-primary-light text-primary-dark'
                    : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
                }`}
              >
                {s.name}
              </button>
            ))}
          </div>
        </Field>
        <label className="flex items-center justify-between px-3 py-2 rounded-md bg-gray-50 cursor-pointer">
          <div>
            <p className="text-xs font-medium text-gray-900">Active</p>
            <p className="text-xs text-gray-400">Inactive staff can't take bookings</p>
          </div>
          <input type="checkbox" checked={active} onChange={(e) => setActive(e.target.checked)} className="w-4 h-4" />
        </label>
        <div className="flex justify-end pt-2 border-t border-gray-200">
          <button onClick={save} className="btn-primary">Save changes</button>
        </div>
      </div>
    </Modal>
  );
}

/** Commission payout summary for one staff member — mirrors the mobile
 * payout sheet: completed services this week/month with the staff's
 * commission share. */
export function PayoutModal({ member, onClose }: { member: Staff; onClose: () => void }) {
  const { bookings } = useDataStore();
  const [period, setPeriod] = useState<'week' | 'month'>('week');

  const days = period === 'week' ? 7 : 30;
  const from = new Date(Date.now() - days * 86400000);
  const done = bookings.filter(
    (b) => b.status === 'COMPLETED' && b.stylistId === member.id && new Date(b.time) >= from
  );
  const gross = done.reduce((s, b) => s + b.price, 0);
  const commission = Math.round((gross * member.commissionPct) / 100);
  const today = bookings.filter(
    (b) => b.status === 'COMPLETED' && b.stylistId === member.id && isSameDay(new Date(b.time), new Date())
  );

  return (
    <Modal title="Payouts" subtitle={member.name} onClose={onClose}>
      <div className="space-y-3">
        <div className="flex gap-1 bg-gray-100 p-0.5 rounded-md w-fit">
          {(['week', 'month'] as const).map((p) => (
            <button
              key={p}
              onClick={() => setPeriod(p)}
              className={`px-3 py-1.5 rounded text-xs font-medium transition-colors ${
                period === p ? 'bg-white text-gray-900 shadow-sm' : 'text-gray-500'
              }`}
            >
              {p === 'week' ? 'Last 7 days' : 'Last 30 days'}
            </button>
          ))}
        </div>

        <div className="grid grid-cols-3 gap-2">
          <div className="bg-gray-50 rounded-md px-3 py-2">
            <p className="text-xs text-gray-500">Services</p>
            <p className="text-base font-semibold text-gray-900 tabular-nums">{done.length}</p>
          </div>
          <div className="bg-gray-50 rounded-md px-3 py-2">
            <p className="text-xs text-gray-500">Gross</p>
            <p className="text-base font-semibold text-gray-900 tabular-nums">{formatINR(gross)}</p>
          </div>
          <div className="bg-primary-light rounded-md px-3 py-2">
            <p className="text-xs text-primary-dark/70">Commission {member.commissionPct}%</p>
            <p className="text-base font-semibold text-primary-dark tabular-nums">{formatINR(commission)}</p>
          </div>
        </div>

        <p className="text-xs text-gray-400">
          Today: {today.length} services · {formatINR(today.reduce((s, b) => s + b.price, 0))}
        </p>
      </div>
    </Modal>
  );
}
