'use client';

import { useState } from 'react';
import { Modal, Field, inputClass } from './Modal';
import type { Service } from '@/lib/salon-api';
import { useCurrentSalon, useDeleteService, useSaveService, useSelectedSalonId } from '@/lib/salon-queries';
import { AuthError } from '@/lib/auth';

export function ServiceModal({ service, onClose }: { service?: Service; onClose: () => void }) {
  const salonId = useSelectedSalonId();
  const salon = useCurrentSalon();
  const saveService = useSaveService(salonId ?? '');
  const deleteService = useDeleteService(salonId ?? '');

  const services = salon?.services ?? [];
  const staff = salon?.staff ?? [];
  const categories = [...new Set(services.map((s) => s.category))].sort();

  const [name, setName] = useState(service?.name ?? '');
  const [category, setCategory] = useState(service?.category ?? categories[0] ?? 'Hair');
  const [newCategory, setNewCategory] = useState('');
  const [duration, setDuration] = useState(String(service?.duration ?? 30));
  const [price, setPrice] = useState(service?.price ? String(service.price) : '');
  const [stylistId, setStylistId] = useState(service?.stylistId ?? '');
  const [error, setError] = useState('');

  const save = () => {
    if (!salonId) return setError('No salon selected');
    if (!name.trim()) return setError('Enter a service name');
    const p = parseFloat(price);
    if (!p || p <= 0) return setError('Enter a valid price');

    saveService.mutate(
      {
        id: service?.id,
        name: name.trim(),
        category: newCategory.trim() || category,
        duration: parseInt(duration, 10) || 30,
        price: p,
        stylistId: stylistId || null,
      },
      {
        onSuccess: () => onClose(),
        onError: (e) => setError(e instanceof AuthError ? e.message : 'Could not save this service.'),
      }
    );
  };

  const remove = () => {
    if (!service) return;
    deleteService.mutate(service.id, {
      onSuccess: () => onClose(),
      onError: (e) => setError(e instanceof AuthError ? e.message : 'Could not delete this service.'),
    });
  };

  return (
    <Modal title={service ? 'Edit service' : 'Add service'} onClose={onClose}>
      <div className="space-y-3">
        <Field label="Name">
          <input className={inputClass} value={name} onChange={(e) => setName(e.target.value)} placeholder="Haircut" />
        </Field>
        <div className="grid grid-cols-2 gap-2">
          <Field label="Category">
            <select className={inputClass} value={category} onChange={(e) => setCategory(e.target.value)}>
              {categories.map((c) => (
                <option key={c}>{c}</option>
              ))}
            </select>
          </Field>
          <Field label="Or new category">
            <input className={inputClass} value={newCategory} onChange={(e) => setNewCategory(e.target.value)} placeholder="Makeup" />
          </Field>
        </div>
        <div className="grid grid-cols-2 gap-2">
          <Field label="Duration (min)">
            <input type="number" className={inputClass} value={duration} onChange={(e) => setDuration(e.target.value)} />
          </Field>
          <Field label="Price (₹)">
            <input type="number" className={inputClass} value={price} onChange={(e) => setPrice(e.target.value)} placeholder="300" />
          </Field>
        </div>
        <Field label="Assigned staff (optional)">
          <select className={inputClass} value={stylistId} onChange={(e) => setStylistId(e.target.value)}>
            <option value="">Any staff</option>
            {staff.filter((s) => s.status === 'ACTIVE').map((s) => (
              <option key={s.stylistId} value={s.stylistId}>{s.name}</option>
            ))}
          </select>
        </Field>
        {error && <p className="text-xs text-red-600">{error}</p>}
        <div className="flex justify-between pt-2 border-t border-gray-200">
          {service ? (
            <button onClick={remove} disabled={deleteService.isPending} className="text-xs text-red-600 hover:underline disabled:opacity-60">
              {deleteService.isPending ? 'Deleting…' : 'Delete service'}
            </button>
          ) : (
            <span />
          )}
          <button onClick={save} disabled={saveService.isPending} className="btn-primary disabled:opacity-60">
            {saveService.isPending ? 'Saving…' : 'Save service'}
          </button>
        </div>
      </div>
    </Modal>
  );
}
