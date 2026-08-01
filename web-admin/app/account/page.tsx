'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { useTranslations, useLocale } from 'next-intl';
import { PageLayout } from '@/components/PageLayout';
import { BookingLinkCard } from '@/components/BookingLinkCard';
import { Field, inputClass } from '@/components/Modal';
import { updateProfile, changePassword, AuthError } from '@/lib/auth';
import { useAppStore } from '@/lib/store';
import { locales, localeNames, type Locale } from '@/i18n/locales';
import { setLocaleCookie } from '@/lib/locale';
import { User, Lock, Globe, Store } from 'lucide-react';

const TABS = [
  { id: 'profile', labelKey: 'tabProfile', icon: User },
  { id: 'salon', labelKey: 'tabSalon', icon: Store },
  { id: 'security', labelKey: 'tabSecurity', icon: Lock },
  { id: 'preferences', labelKey: 'tabPreferences', icon: Globe },
] as const;

function formatJoined(iso: string | undefined, locale: string) {
  if (!iso) return null;
  return new Date(iso).toLocaleDateString(locale, { day: 'numeric', month: 'long', year: 'numeric' });
}

export default function AccountPage() {
  const t = useTranslations('account');
  const locale = useLocale();
  const router = useRouter();
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

  const changeLocale = (next: Locale) => {
    setLocaleCookie(next);
    router.refresh();
  };

  const joined = formatJoined(user?.createdAt, locale);

  return (
    <PageLayout title={t('title')} subtitle={t('subtitle')}>
      <div className="space-y-4">
        {/* Plan banner */}
        <div className="flex items-center justify-between card px-4 py-3">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-primary-light rounded-full flex items-center justify-center text-primary-dark text-base font-medium">
              {(user?.name || '?').charAt(0).toUpperCase()}
            </div>
            <div>
              <p className="text-sm font-medium text-gray-900">{user?.name}</p>
              {joined && <p className="text-xs text-gray-400">{t('joined', { date: joined })}</p>}
            </div>
          </div>
          <span className="px-2.5 py-1 rounded-md bg-gray-100 text-gray-600 text-xs font-medium">
            {t('freePlan')}
          </span>
        </div>

        {/* Tabs */}
        <div className="flex gap-1 bg-gray-100 p-0.5 rounded-md w-fit">
          {TABS.map((tabItem) => {
            const Icon = tabItem.icon;
            return (
              <button
                key={tabItem.id}
                onClick={() => setTab(tabItem.id)}
                className={`flex items-center gap-1.5 px-3 py-1.5 rounded font-medium text-xs transition-colors ${
                  tab === tabItem.id ? 'bg-white text-gray-900 shadow-sm' : 'text-gray-500 hover:text-gray-900'
                }`}
              >
                <Icon size={13} />
                {t(tabItem.labelKey)}
              </button>
            );
          })}
        </div>

        {tab === 'profile' && (
          <div className="card p-4 space-y-3 max-w-lg">
            <div className="grid grid-cols-2 gap-3">
              <Field label={t('yourName')}>
                <input className={inputClass} value={ownerName} onChange={(e) => setOwnerName(e.target.value)} />
              </Field>
              <Field label={t('phone')}>
                <input className={inputClass} value={ownerPhone} onChange={(e) => setOwnerPhone(e.target.value)} />
              </Field>
            </div>
            <Field label={t('email')}>
              <input className={inputClass} value={ownerEmail} onChange={(e) => setOwnerEmail(e.target.value)} placeholder={t('emailPlaceholder')} />
            </Field>
            {profileError && <p className="text-xs text-red-600">{profileError}</p>}
            <button onClick={saveProfile} disabled={profileSaving} className="btn-primary disabled:opacity-60">
              {profileSaving ? t('saving') : profileSaved ? t('saved') : t('save')}
            </button>
          </div>
        )}

        {tab === 'salon' && (
          <div className="card p-4 space-y-3 max-w-lg">
            {!salon ? (
              <p className="text-xs text-gray-400">{t('noSalon')}</p>
            ) : (
              <>
                <Field label={t('salonName')}>
                  <input className={inputClass} value={salonName} onChange={(e) => setSalonName(e.target.value)} />
                </Field>
                <Field label={t('address')}>
                  <input className={inputClass} value={address} onChange={(e) => setAddress(e.target.value)} />
                </Field>
                <Field label={t('dailyGoal')}>
                  <input
                    type="number"
                    className={inputClass}
                    value={goal}
                    onChange={(e) => setGoal(e.target.value)}
                    placeholder="6000"
                  />
                </Field>
                <p className="text-xs text-gray-400">
                  {salons.length > 1 ? t('goalHelperMulti') : t('goalHelperSingle')}
                </p>
                <Field label={t('upiId')}>
                  <input
                    className={inputClass}
                    value={upiId}
                    onChange={(e) => setUpiId(e.target.value)}
                    placeholder="yoursalon@okhdfcbank"
                  />
                </Field>
                <p className="text-xs text-gray-400 -mt-2">{t('upiHelper')}</p>
                <div className="flex items-center justify-between px-3 py-2.5 rounded-md bg-gray-50">
                  <div>
                    <p className="text-xs font-medium text-gray-900">{t('gstRegistered')}</p>
                    <p className="text-xs text-gray-400">{t('gstHelper')}</p>
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
                  <Field label={t('gstRate')}>
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
                  {salonSaving ? t('saving') : salonSaved ? t('saved') : t('save')}
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
            <Field label={t('currentPassword')}>
              <input type="password" className={inputClass} value={pwCurrent} onChange={(e) => setPwCurrent(e.target.value)} />
            </Field>
            <div className="grid grid-cols-2 gap-3">
              <Field label={t('newPassword')}>
                <input type="password" className={inputClass} value={pwNew} onChange={(e) => setPwNew(e.target.value)} />
              </Field>
              <Field label={t('confirmNewPassword')}>
                <input type="password" className={inputClass} value={pwConfirm} onChange={(e) => setPwConfirm(e.target.value)} />
              </Field>
            </div>
            {pwMessage && (
              <p className={`text-xs ${pwError ? 'text-red-600' : 'text-green-700'}`}>{pwMessage}</p>
            )}
            <button onClick={submitPasswordChange} disabled={pwSaving} className="btn-primary disabled:opacity-60">
              {pwSaving ? t('updating') : t('updatePassword')}
            </button>
          </div>
        )}

        {tab === 'preferences' && (
          <div className="card p-4 space-y-3 max-w-lg">
            <div className="flex items-center justify-between px-3 py-2.5 rounded-md bg-gray-50">
              <div>
                <p className="text-xs font-medium text-gray-900">{t('language')}</p>
                <p className="text-xs text-gray-400">{t('languageHelper')}</p>
              </div>
              <select
                className={`${inputClass} w-36`}
                value={locale}
                onChange={(e) => changeLocale(e.target.value as Locale)}
              >
                {locales.map((code) => (
                  <option key={code} value={code}>
                    {localeNames[code]}
                  </option>
                ))}
              </select>
            </div>
            <div className="flex items-center justify-between px-3 py-2.5 rounded-md bg-gray-50">
              <div>
                <p className="text-xs font-medium text-gray-900">{t('countryCurrency')}</p>
                <p className="text-xs text-gray-400">{t('countryCurrencyHelper')}</p>
              </div>
              <select className={`${inputClass} w-36`}>
                <option>India (₹)</option>
                <option>UAE (د.إ)</option>
                <option>USA ($)</option>
              </select>
            </div>
            <p className="text-xs text-gray-400">{t('savedLocally')}</p>
          </div>
        )}
      </div>
    </PageLayout>
  );
}
