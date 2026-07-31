'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import Link from 'next/link';
import { Scissors, Eye, EyeOff, CheckCircle2 } from 'lucide-react';
import { signup, fetchMe } from '@/lib/auth';
import { useAppStore } from '@/lib/store';
import { GoogleButton } from '@/components/GoogleButton';
import { inputClass } from '@/components/Modal';
import { trackPixelEvent } from '@/lib/pixel';

const COUNTRIES = [
  { code: 'IN', label: 'India', currency: 'INR' },
  { code: 'AE', label: 'UAE', currency: 'AED' },
  { code: 'US', label: 'USA', currency: 'USD' },
  { code: 'GB', label: 'UK', currency: 'GBP' },
];

export default function SignupPage() {
  const router = useRouter();
  const setUser = useAppStore((s) => s.setUser);
  const setSalons = useAppStore((s) => s.setSalons);

  const [ownerName, setOwnerName] = useState('');
  const [phone, setPhone] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [salonName, setSalonName] = useState('');
  const [address, setAddress] = useState('');
  const [countryCode, setCountryCode] = useState('IN');

  const [googleIdToken, setGoogleIdToken] = useState<string | null>(null);
  const [googleEmail, setGoogleEmail] = useState<string | null>(null);

  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const country = COUNTRIES.find((c) => c.code === countryCode)!;

  const decodeEmail = (idToken: string): string | null => {
    try {
      const payload = JSON.parse(atob(idToken.split('.')[1].replace(/-/g, '+').replace(/_/g, '/')));
      return payload.email ?? null;
    } catch {
      return null;
    }
  };

  const handleGoogleToken = (idToken: string) => {
    setError('');
    setGoogleIdToken(idToken);
    setGoogleEmail(decodeEmail(idToken));
  };

  const validate = () => {
    if (ownerName.trim().length < 2) return 'Enter your name';
    if (phone.trim().length < 6) return 'Enter a valid phone number';
    if (!googleIdToken && password.length < 6) return 'Password must be at least 6 characters';
    if (salonName.trim().length < 2) return 'Enter your salon name';
    if (address.trim().length < 5) return 'Enter your salon address';
    return null;
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    const validationError = validate();
    if (validationError) return setError(validationError);

    setError('');
    setLoading(true);
    try {
      const { user, salon } = await signup({
        ownerName: ownerName.trim(),
        phone: phone.trim(),
        ...(googleIdToken ? { googleIdToken } : { password }),
        salonName: salonName.trim(),
        address: address.trim(),
        countryCode: country.code,
        currency: country.currency,
      });
      setUser(user);
      const me = await fetchMe();
      setSalons(me?.salons ?? [salon]);
      // Fired here — after signup() has actually resolved and the account
      // exists — not on form submit/click, so a failed signup (bad phone,
      // duplicate account, network error) never counts as a conversion.
      trackPixelEvent('CompleteRegistration');
      router.push('/dashboard');
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Sign up failed. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-[#F4F6F8] flex items-center justify-center p-4 py-6">
      <div className="w-full max-w-[300px]">
        <div className="card p-4 space-y-3">
          <div className="text-center">
            <div className="w-9 h-9 rounded-lg bg-gradient-to-br from-primary to-primary-dark flex items-center justify-center mx-auto shadow-sm">
              <Scissors size={16} className="text-white" />
            </div>
            <h1 className="text-sm font-bold text-gray-900 mt-2">Create your account</h1>
            <p className="text-xs text-gray-400 mt-0.5">Set up your salon on Salone</p>
          </div>

          <form onSubmit={handleSubmit} className="space-y-2">
            {error && (
              <div className="px-2.5 py-1.5 bg-red-50 border border-red-200 rounded-md text-red-600 text-xs">
                {error}
              </div>
            )}

            <div>
              <label htmlFor="signup_owner" className="block text-xs font-medium text-gray-700 mb-1">Your name</label>
              <input id="signup_owner" value={ownerName} onChange={(e) => setOwnerName(e.target.value)} placeholder="Priya Sharma" className={inputClass} required />
            </div>

            <div className="grid grid-cols-2 gap-2">
              <div>
                <label htmlFor="signup_country" className="block text-xs font-medium text-gray-700 mb-1">Country</label>
                <select id="signup_country" value={countryCode} onChange={(e) => setCountryCode(e.target.value)} className={inputClass}>
                  {COUNTRIES.map((c) => (
                    <option key={c.code} value={c.code}>{c.label}</option>
                  ))}
                </select>
              </div>
              <div>
                <label htmlFor="signup_phone" className="block text-xs font-medium text-gray-700 mb-1">Phone number</label>
                <input id="signup_phone" value={phone} onChange={(e) => setPhone(e.target.value)} placeholder="98765 43210" autoComplete="tel" className={inputClass} required />
              </div>
            </div>

            {googleIdToken ? (
              <div className="flex items-center gap-2 px-2.5 py-1.5 bg-primary-50 border border-primary/20 rounded-md">
                <CheckCircle2 size={13} className="text-primary flex-shrink-0" />
                <span className="text-xs text-gray-700 flex-1 truncate">
                  {googleEmail ? `Signed in as ${googleEmail}` : 'Signed in with Google'}
                </span>
                <button
                  type="button"
                  onClick={() => {
                    setGoogleIdToken(null);
                    setGoogleEmail(null);
                  }}
                  className="text-xs text-primary font-medium hover:underline flex-shrink-0"
                >
                  Use password
                </button>
              </div>
            ) : (
              <div>
                <label htmlFor="signup_password" className="block text-xs font-medium text-gray-700 mb-1">Password</label>
                <div className="relative">
                  <input
                    id="signup_password"
                    type={showPassword ? 'text' : 'password'}
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    placeholder="At least 6 characters"
                    autoComplete="new-password"
                    className={`${inputClass} pr-9`}
                    required
                  />
                  <button
                    type="button"
                    onClick={() => setShowPassword((v) => !v)}
                    aria-label={showPassword ? 'Hide password' : 'Show password'}
                    className="absolute right-1 top-1/2 -translate-y-1/2 p-1.5 rounded text-gray-400 hover:text-gray-600 hover:bg-gray-100"
                    tabIndex={-1}
                  >
                    {showPassword ? <EyeOff size={13} /> : <Eye size={13} />}
                  </button>
                </div>
              </div>
            )}

            <div className="pt-1 border-t border-gray-100" />

            <div>
              <label htmlFor="signup_salon_name" className="block text-xs font-medium text-gray-700 mb-1">Salon name</label>
              <input id="signup_salon_name" value={salonName} onChange={(e) => setSalonName(e.target.value)} placeholder="Lotus Salon & Spa" className={inputClass} required />
            </div>

            <div>
              <label htmlFor="signup_address" className="block text-xs font-medium text-gray-700 mb-1">Salon address</label>
              <input id="signup_address" value={address} onChange={(e) => setAddress(e.target.value)} placeholder="Street, area, city" className={inputClass} required />
            </div>

            <button type="submit" disabled={loading} className="btn-primary w-full disabled:opacity-60">
              {loading ? 'Creating account…' : 'Create account'}
            </button>
          </form>

          {!googleIdToken && (
            <>
              <div className="flex items-center gap-2">
                <div className="flex-1 h-px bg-gray-200" />
                <span className="text-xs text-gray-400">or</span>
                <div className="flex-1 h-px bg-gray-200" />
              </div>
              <GoogleButton onToken={handleGoogleToken} onError={setError} text="signup_with" />
            </>
          )}

          <p className="text-center text-xs text-gray-500">
            Already have an account?{' '}
            <Link href="/login" className="text-primary font-semibold hover:underline">
              Sign in
            </Link>
          </p>
        </div>
      </div>
    </div>
  );
}
