'use client';

import { useState } from 'react';
import { Modal, Field, inputClass } from './Modal';
import { useAppStore } from '@/lib/store';

export function AddBranchModal({ onClose }: { onClose: () => void }) {
  const addSalon = useAppStore((s) => s.addSalon);
  const user = useAppStore((s) => s.user);
  const [name, setName] = useState('');
  const [address, setAddress] = useState('');
  const [phone, setPhone] = useState('');
  const [error, setError] = useState('');

  const save = () => {
    if (!name.trim()) return setError('Enter a branch name');
    addSalon({
      id: `br-${Date.now()}`,
      name: name.trim(),
      ownerId: user?.id ?? '1',
      address: address.trim(),
      phone: phone.trim(),
      email: '',
      currency: 'INR',
      countryCode: 'IN',
      todayStats: { revenue: 0, count: 0 },
    });
    onClose();
  };

  return (
    <Modal title="Add branch" subtitle="A new location for your salon" onClose={onClose}>
      <div className="space-y-3">
        <Field label="Branch name">
          <input
            className={inputClass}
            value={name}
            onChange={(e) => setName(e.target.value)}
            placeholder="Lotus Salon & Spa — Indiranagar"
          />
        </Field>
        <Field label="Address">
          <input
            className={inputClass}
            value={address}
            onChange={(e) => setAddress(e.target.value)}
            placeholder="Street, area, city"
          />
        </Field>
        <Field label="Phone">
          <input
            className={inputClass}
            value={phone}
            onChange={(e) => setPhone(e.target.value)}
            placeholder="98765 43210"
          />
        </Field>
        {error && <p className="text-xs text-red-600">{error}</p>}
        <div className="flex justify-end pt-2 border-t border-gray-200">
          <button onClick={save} className="btn-primary">Add branch</button>
        </div>
      </div>
    </Modal>
  );
}
