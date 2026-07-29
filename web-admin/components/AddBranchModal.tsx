'use client';

import { useState } from 'react';
import { Modal, Field, inputClass } from './Modal';
import { useAppStore } from '@/lib/store';
import { useCreateSalon } from '@/lib/salon-queries';
import { AuthError } from '@/lib/auth';

export function AddBranchModal({ onClose }: { onClose: () => void }) {
  const setSelectedSalon = useAppStore((s) => s.setSelectedSalon);
  const addSalonToIdentity = useAppStore((s) => s.addSalon);
  const createSalon = useCreateSalon();
  const [name, setName] = useState('');
  const [address, setAddress] = useState('');
  const [error, setError] = useState('');

  const save = () => {
    if (!name.trim()) return setError('Enter a branch name');
    if (!address.trim()) return setError('Enter an address');

    createSalon.mutate(
      { name: name.trim(), address: address.trim() },
      {
        onSuccess: (salon) => {
          // Two separate salon lists exist: the identity store's basic list
          // (drives the TopBar switcher) and react-query's richer
          // SalonSummary list (drives business-data pages, invalidated by
          // useCreateSalon already). Both need the new branch.
          addSalonToIdentity({
            id: salon.id,
            name: salon.name,
            ownerId: '',
            address: salon.address,
            currency: salon.currency,
            countryCode: salon.countryCode,
            dailyRevenueGoal: salon.dailyRevenueGoal,
          });
          setSelectedSalon(salon.id);
          onClose();
        },
        onError: (e) => setError(e instanceof AuthError ? e.message : 'Could not create this branch.'),
      }
    );
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
        {error && <p className="text-xs text-red-600">{error}</p>}
        <div className="flex justify-end pt-2 border-t border-gray-200">
          <button onClick={save} disabled={createSalon.isPending} className="btn-primary disabled:opacity-60">
            {createSalon.isPending ? 'Creating…' : 'Add branch'}
          </button>
        </div>
      </div>
    </Modal>
  );
}
