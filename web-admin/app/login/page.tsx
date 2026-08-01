'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import Link from 'next/link';
import { useTranslations } from 'next-intl';
import { Scissors, Eye, EyeOff } from 'lucide-react';
import { login, googleLogin, fetchMe } from '@/lib/auth';
import { useAppStore } from '@/lib/store';
import { GoogleButton } from '@/components/GoogleButton';
import { LocaleSwitcher } from '@/components/LocaleSwitcher';
import { inputClass } from '@/components/Modal';

export default function LoginPage() {
  const t = useTranslations('login');
  const router = useRouter();
  const setUser = useAppStore((s) => s.setUser);
  const setSalons = useAppStore((s) => s.setSalons);

  const [phone, setPhone] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [loading, setLoading] = useState(false);
  const [googleLoading, setGoogleLoading] = useState(false);
  const [error, setError] = useState('');

  const afterSignedIn = async (user: Parameters<typeof setUser>[0]) => {
    setUser(user);
    const me = await fetchMe();
    setSalons(me?.salons ?? []);
    router.push('/dashboard');
  };

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    if (phone.trim().length < 6) return setError(t('errPhone'));
    if (password.length < 6) return setError(t('errPassword'));

    setLoading(true);
    try {
      const { user } = await login(phone.trim(), password);
      await afterSignedIn(user);
    } catch (err) {
      setError(err instanceof Error ? err.message : t('errLoginFailed'));
    } finally {
      setLoading(false);
    }
  };

  const handleGoogle = async (idToken: string) => {
    setError('');
    setGoogleLoading(true);
    try {
      const { user } = await googleLogin(idToken);
      await afterSignedIn(user);
    } catch (err) {
      setError(err instanceof Error ? err.message : t('errGoogleFailed'));
    } finally {
      setGoogleLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-[#F4F6F8] flex items-center justify-center p-4">
      <div className="w-full max-w-[300px] space-y-3">
        <div className="card p-4 space-y-3">
          <div className="text-center">
            <div className="w-9 h-9 rounded-lg bg-gradient-to-br from-primary to-primary-dark flex items-center justify-center mx-auto shadow-sm">
              <Scissors size={16} className="text-white" />
            </div>
            <h1 className="text-sm font-bold text-gray-900 mt-2">{t('welcomeBack')}</h1>
            <p className="text-xs text-gray-400 mt-0.5">{t('subtitle')}</p>
          </div>

          <form onSubmit={handleLogin} className="space-y-2">
            {error && (
              <div className="px-2.5 py-1.5 bg-red-50 border border-red-200 rounded-md text-red-600 text-xs">
                {error}
              </div>
            )}

            <div>
              <label htmlFor="phone" className="block text-xs font-medium text-gray-700 mb-1">
                {t('phoneNumber')}
              </label>
              <input
                id="phone"
                type="tel"
                placeholder="98765 43210"
                value={phone}
                onChange={(e) => setPhone(e.target.value)}
                autoComplete="tel"
                className={inputClass}
                required
              />
            </div>

            <div>
              <label htmlFor="password" className="block text-xs font-medium text-gray-700 mb-1">
                {t('password')}
              </label>
              <div className="relative">
                <input
                  id="password"
                  type={showPassword ? 'text' : 'password'}
                  placeholder="••••••••"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  autoComplete="current-password"
                  className={`${inputClass} pr-9`}
                  required
                />
                <button
                  type="button"
                  onClick={() => setShowPassword((v) => !v)}
                  aria-label={showPassword ? t('hidePassword') : t('showPassword')}
                  className="absolute right-1 top-1/2 -translate-y-1/2 p-1.5 rounded text-gray-400 hover:text-gray-600 hover:bg-gray-100"
                  tabIndex={-1}
                >
                  {showPassword ? <EyeOff size={13} /> : <Eye size={13} />}
                </button>
              </div>
            </div>

            <button type="submit" disabled={loading} className="btn-primary w-full disabled:opacity-60">
              {loading ? t('signingIn') : t('signIn')}
            </button>
          </form>

          <div className="flex items-center gap-2">
            <div className="flex-1 h-px bg-gray-200" />
            <span className="text-xs text-gray-400">{t('or')}</span>
            <div className="flex-1 h-px bg-gray-200" />
          </div>

          <GoogleButton onToken={handleGoogle} onError={setError} text="signin_with" />
          {googleLoading && <p className="text-xs text-gray-400 text-center">{t('signingIn')}</p>}

          <p className="text-center text-xs text-gray-500">
            {t('newHere')}{' '}
            <Link href="/signup" className="text-primary font-semibold hover:underline">
              {t('createAccount')}
            </Link>
          </p>
        </div>
        <LocaleSwitcher />
      </div>
    </div>
  );
}
