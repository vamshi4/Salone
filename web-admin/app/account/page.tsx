'use client';

import { useState } from 'react';
import { PageLayout } from '@/components/PageLayout';
import { Field, inputClass } from '@/components/Modal';
import { useDataStore, formatINR } from '@/lib/data';
import { User, Lock, Globe, Store } from 'lucide-react';

const TABS = [
  { id: 'profile', label: 'Profile', icon: User },
  { id: 'salon', label: 'Salon', icon: Store },
  { id: 'security', label: 'Security', icon: Lock },
  { id: 'preferences', label: 'Preferences', icon: Globe },
] as const;

export default function AccountPage() {
  const { salon, updateSalon } = useDataStore();
  const [tab, setTab] = useState<(typeof TABS)[number]['id']>('profile');

  const [ownerName, setOwnerName] = useState(salon.ownerName);
  const [ownerPhone, setOwnerPhone] = useState(salon.ownerPhone);
  const [ownerEmail, setOwnerEmail] = useState(salon.ownerEmail);
  const [salonName, setSalonName] = useState(salon.name);
  const [address, setAddress] = useState(salon.address);
  const [goal, setGoal] = useState(salon.dailyRevenueGoal ? String(salon.dailyRevenueGoal) : '');
  const [saved, setSaved] = useState(false);

  const [pwCurrent, setPwCurrent] = useState('');
  const [pwNew, setPwNew] = useState('');
  const [pwConfirm, setPwConfirm] = useState('');
  const [pwMessage, setPwMessage] = useState('');

  const saveProfile = () => {
    updateSalon({
      ownerName: ownerName.trim(),
      ownerPhone: ownerPhone.trim(),
      ownerEmail: ownerEmail.trim(),
      name: salonName.trim(),
      address: address.trim(),
      dailyRevenueGoal: parseInt(goal, 10) || 0,
    });
    setSaved(true);
    setTimeout(() => setSaved(false), 1500);
  };

  const changePassword = () => {
    if (!pwCurrent || !pwNew) return setPwMessage('Fill in all password fields.');
    if (pwNew !== pwConfirm) return setPwMessage("New passwords don't match.");
    setPwCurrent('');
    setPwNew('');
    setPwConfirm('');
    setPwMessage('Password updated.');
    setTimeout(() => setPwMessage(''), 2000);
  };

  return (
    <PageLayout title="Account" subtitle="Your profile and salon settings">
      <div className="space-y-4">
        {/* Plan banner */}
        <div className="flex items-center justify-between card px-4 py-3">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-primary-light rounded-full flex items-center justify-center text-primary-dark text-base font-medium">
              {salon.ownerName.charAt(0)}
            </div>
            <div>
              <p className="text-sm font-medium text-gray-900">{salon.ownerName}</p>
              <p className="text-xs text-gray-400">Joined {salon.joined}</p>
            </div>
          </div>
          <span className="px-2.5 py-1 rounded-md bg-gray-100 text-gray-600 text-xs font-medium">
            {salon.plan} plan
          </span>
        </div>

        {/* Tabs */}
        <div className="flex gap-1 bg-gray-100 p-0.5 rounded-md w-fit">
          {TABS.map((t) => {
            const Icon = t.icon;
            return (
              <button
                key={t.id}
                onClick={() => setTab(t.id)}
                className={`flex items-center gap-1.5 px-3 py-1.5 rounded font-medium text-xs transition-colors ${
                  tab === t.id ? 'bg-white text-gray-900 shadow-sm' : 'text-gray-500 hover:text-gray-900'
                }`}
              >
                <Icon size={13} />
                {t.label}
              </button>
            );
          })}
        </div>

        {tab === 'profile' && (
          <div className="card p-4 space-y-3 max-w-lg">
            <div className="grid grid-cols-2 gap-3">
              <Field label="Your name">
                <input className={inputClass} value={ownerName} onChange={(e) => setOwnerName(e.target.value)} />
              </Field>
              <Field label="Phone">
                <input className={inputClass} value={ownerPhone} onChange={(e) => setOwnerPhone(e.target.value)} />
              </Field>
            </div>
            <Field label="Email">
              <input className={inputClass} value={ownerEmail} onChange={(e) => setOwnerEmail(e.target.value)} />
            </Field>
            <button onClick={saveProfile} className="btn-primary">{saved ? 'Saved' : 'Save changes'}</button>
          </div>
        )}

        {tab === 'salon' && (
          <div className="card p-4 space-y-3 max-w-lg">
            <Field label="Salon name">
              <input className={inputClass} value={salonName} onChange={(e) => setSalonName(e.target.value)} />
            </Field>
            <Field label="Address">
              <input className={inputClass} value={address} onChange={(e) => setAddress(e.target.value)} />
            </Field>
            <Field label="Daily revenue goal (₹)">
              <input
                type="number"
                className={inputClass}
                value={goal}
                onChange={(e) => setGoal(e.target.value)}
                placeholder="6000"
              />
            </Field>
            <p className="text-xs text-gray-400">
              The goal powers the pace bar on your Home briefing.
              {salon.dailyRevenueGoal > 0 && ` Currently ${formatINR(salon.dailyRevenueGoal)}.`}
            </p>
            <button onClick={saveProfile} className="btn-primary">{saved ? 'Saved' : 'Save changes'}</button>
          </div>
        )}

        {tab === 'security' && (
          <div className="card p-4 space-y-3 max-w-lg">
            <Field label="Current password">
              <input type="password" className={inputClass} value={pwCurrent} onChange={(e) => setPwCurrent(e.target.value)} />
            </Field>
            <div className="grid grid-cols-2 gap-3">
              <Field label="New password">
                <input type="password" className={inputClass} value={pwNew} onChange={(e) => setPwNew(e.target.value)} />
              </Field>
              <Field label="Confirm new password">
                <input type="password" className={inputClass} value={pwConfirm} onChange={(e) => setPwConfirm(e.target.value)} />
              </Field>
            </div>
            {pwMessage && <p className="text-xs text-gray-600">{pwMessage}</p>}
            <button onClick={changePassword} className="btn-primary">Update password</button>
          </div>
        )}

        {tab === 'preferences' && (
          <div className="card p-4 space-y-3 max-w-lg">
            <div className="flex items-center justify-between px-3 py-2.5 rounded-md bg-gray-50">
              <div>
                <p className="text-xs font-medium text-gray-900">Language</p>
                <p className="text-xs text-gray-400">Interface language</p>
              </div>
              <select className={`${inputClass} w-36`}>
                <option>English</option>
                <option>हिन्दी</option>
                <option>తెలుగు</option>
                <option>தமிழ்</option>
              </select>
            </div>
            <div className="flex items-center justify-between px-3 py-2.5 rounded-md bg-gray-50">
              <div>
                <p className="text-xs font-medium text-gray-900">Country and currency</p>
                <p className="text-xs text-gray-400">Formats prices and phone numbers</p>
              </div>
              <select className={`${inputClass} w-36`}>
                <option>India (₹)</option>
                <option>UAE (د.إ)</option>
                <option>USA ($)</option>
              </select>
            </div>
            <p className="text-xs text-gray-400">Preferences are saved on this device only.</p>
          </div>
        )}
      </div>
    </PageLayout>
  );
}
