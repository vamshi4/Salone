'use client';

import { useState } from 'react';
import { PageLayout } from '@/components/PageLayout';
import { BookingLinkCard } from '@/components/BookingLinkCard';
import { Field, inputClass } from '@/components/Modal';
import { updateProfile, changePassword, AuthError } from '@/lib/auth';
import { useAppStore } from '@/lib/store';
import { User, Lock, Globe, Store } from 'lucide-react';

const TABS = [
  { id: 'profile', label: 'Profile', icon: User },
  { id: 'salon', label: 'Salon', icon: Store },
  { id: 'security', label: 'Security', icon: Lock },
  { id: 'preferences', label: 'Preferences', icon: Globe },
] as const;

function formatJoined(iso?: string) {
  if (!iso) return null;
  return new Date(iso).toLocaleDateString('en-IN', { day: 'numeric', month: 'long', year: 'numeric' });
}

export default function AccountPage() {
  const user = useAppStore((s) => s.user);
  const setUser = useAppStore((s) => s.setUser);
  const salons = useAppStore((s) => s.salons);
  const selectedSalonId = useAppStore((s) => s.selectedSalonId);
  const salon = salons.find((s) => s.id === selectedSalonId);
  const setSalons = useAppStore((s) => s.setSalons);

  const [tab, setTab] = useState<(typeof TABS)[number]['id']>('profile');

  const [ownerName, setOwnerName] = useState(user?.name ?? '');
  const [ownerPhone, setOwnerPhone] = useState(user?.phone ?? '');
  const [ownerEmail, setOwnerEmail] = useState(user?.email ?? '');
  const [profileSaving, setProfileSaving] = useState(false);
  const [profileSaved, setProfileSaved] = useState(false);
  const [profileError, setProfileError] = useState('');

  const [salonName, setSalonName] = useState(salon?.name ?? '');
  const [address, setAddress] = useState(salon?.address ?? '');
  // dailyRevenueGoal is stored in paise (minor units) like every other money
  // field on the backend — /100 for display, *100 when saving (see saveSalon).
  const [goal, setGoal] = useState(salon?.dailyRevenueGoal ? String(Math.round(salon.dailyRevenueGoal / 100)) : '');
  const [upiId, setUpiId] = useState(salon?.upiId ?? '');
  const [gstEnabled, setGstEnabled] = useState(salon?.gstEnabled ?? false);
  const [gstRate, setGstRate] = useState(String(salon?.gstRate ?? 18));
  const [salonSaving, setSalonSaving] = useState(false);
  const [salonSaved, setSalonSaved] = useState(false);
  const [salonError, setSalonError] = useState('');

  const [pwCurrent, setPwCurrent] = useState('');
  const [pwNew, setPwNew] = useState('');
  const [pwConfirm, setPwConfirm] = useState('');
  const [pwSaving, setPwSaving] = useState(false);
  const [pwMessage, setPwMessage] = useState('');
  const [pwError, setPwError] = useState(false);

  const saveProfile = async () => {
    setProfileError('');
    setProfileSaving(true);
    try {
      const { user: updated } = await updateProfile({
        ownerName: ownerName.trim(),
        phone: ownerPhone.trim(),
        email: ownerEmail.trim(),
      });
      setUser(updated);
      setProfileSaved(true);
      setTimeout(() => setProfileSaved(false), 1500);
    } catch (e) {
      setProfileError(e instanceof AuthError ? e.message : 'Could not save your changes.');
    } finally {
      setProfileSaving(false);
    }
  };

  const saveSalon = async () => {
    setSalonError('');
    setSalonSaving(true);
    try {
      const { salon: updated } = await updateProfile({
        salonName: salonName.trim(),
        address: address.trim(),
        dailyRevenueGoal: (parseInt(goal, 10) || 0) * 100,
        upiId: upiId.trim(),
        gstEnabled,
        gstRate: parseInt(gstRate, 10) || 0,
      });
      if (updated) {
        setSalons(salons.map((s) => (s.id === updated.id ? updated : s)));
      }
      setSalonSaved(true);
      setTimeout(() => setSalonSaved(false), 1500);
    } catch (e) {
      setSalonError(e instanceof AuthError ? e.message : 'Could not save your changes.');
    } finally {
      setSalonSaving(false);
    }
  };

  const submitPasswordChange = async () => {
    setPwError(false);
    if (!pwCurrent || !pwNew) {
      setPwError(true);
      return setPwMessage('Fill in all password fields.');
    }
    if (pwNew.length < 6) {
      setPwError(true);
      return setPwMessage('New password must be at least 6 characters.');
    }
    if (pwNew !== pwConfirm) {
      setPwError(true);
      return setPwMessage("New passwords don't match.");
    }
    setPwSaving(true);
    setPwMessage('');
    try {
      await changePassword(pwCurrent, pwNew);
      setPwCurrent('');
      setPwNew('');
      setPwConfirm('');
      setPwMessage('Password updated.');
      setTimeout(() => setPwMessage(''), 2500);
    } catch (e) {
      setPwError(true);
      setPwMessage(e instanceof AuthError ? e.message : 'Could not update your password.');
    } finally {
      setPwSaving(false);
    }
  };

  const joined = formatJoined(user?.createdAt);

  return (
    <PageLayout title="Account" subtitle="Your profile and salon settings">
      <div className="space-y-4">
        {/* Plan banner */}
        <div className="flex items-center justify-between card px-4 py-3">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-primary-light rounded-full flex items-center justify-center text-primary-dark text-base font-medium">
              {(user?.name || '?').charAt(0).toUpperCase()}
            </div>
            <div>
              <p className="text-sm font-medium text-gray-900">{user?.name}</p>
              {joined && <p className="text-xs text-gray-400">Joined {joined}</p>}
            </div>
          </div>
          <span className="px-2.5 py-1 rounded-md bg-gray-100 text-gray-600 text-xs font-medium">
            Free plan
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
              <input className={inputClass} value={ownerEmail} onChange={(e) => setOwnerEmail(e.target.value)} placeholder="you@example.com" />
            </Field>
            {profileError && <p className="text-xs text-red-600">{profileError}</p>}
            <button onClick={saveProfile} disabled={profileSaving} className="btn-primary disabled:opacity-60">
              {profileSaving ? 'Saving…' : profileSaved ? 'Saved' : 'Save changes'}
            </button>
          </div>
        )}

        {tab === 'salon' && (
          <div className="card p-4 space-y-3 max-w-lg">
            {!salon ? (
              <p className="text-xs text-gray-400">No salon found on your account yet.</p>
            ) : (
              <>
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
                  {salons.length > 1
                    ? "You have multiple branches — this updates your account's primary salon record."
                    : 'The goal powers the pace bar on your Home briefing.'}
                </p>
                <Field label="UPI ID">
                  <input
                    className={inputClass}
                    value={upiId}
                    onChange={(e) => setUpiId(e.target.value)}
                    placeholder="yoursalon@okhdfcbank"
                  />
                </Field>
                <p className="text-xs text-gray-400 -mt-2">
                  Shown as a scannable payment QR when you complete a booking with UPI.
                </p>
                <div className="flex items-center justify-between px-3 py-2.5 rounded-md bg-gray-50">
                  <div>
                    <p className="text-xs font-medium text-gray-900">GST registered</p>
                    <p className="text-xs text-gray-400">Adds GST on top of the total shown on the UPI QR</p>
                  </div>
                  <button
                    onClick={() => setGstEnabled((v) => !v)}
                    className={`relative w-9 h-5 rounded-full transition-colors ${gstEnabled ? 'bg-primary' : 'bg-gray-300'}`}
                  >
                    <span
                      className={`absolute top-0.5 w-4 h-4 rounded-full bg-white transition-transform ${gstEnabled ? 'translate-x-4' : 'translate-x-0.5'}`}
                    />
                  </button>
                </div>
                {gstEnabled && (
                  <Field label="GST rate (%)">
                    <input
                      type="number"
                      className={inputClass}
                      value={gstRate}
                      onChange={(e) => setGstRate(e.target.value)}
                      placeholder="18"
                    />
                  </Field>
                )}
                {salonError && <p className="text-xs text-red-600">{salonError}</p>}
                <button onClick={saveSalon} disabled={salonSaving} className="btn-primary disabled:opacity-60">
                  {salonSaving ? 'Saving…' : salonSaved ? 'Saved' : 'Save changes'}
                </button>
              </>
            )}
          </div>
        )}

        {tab === 'salon' && salon && (
          <div className="max-w-lg">
            <BookingLinkCard salonId={salon.id} salonName={salon.name} />
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
            {pwMessage && (
              <p className={`text-xs ${pwError ? 'text-red-600' : 'text-green-700'}`}>{pwMessage}</p>
            )}
            <button onClick={submitPasswordChange} disabled={pwSaving} className="btn-primary disabled:opacity-60">
              {pwSaving ? 'Updating…' : 'Update password'}
            </button>
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
