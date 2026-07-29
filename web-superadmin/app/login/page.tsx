'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { ShieldCheck, Eye, EyeOff } from 'lucide-react';
import { login } from '@/lib/auth';
import { useAppStore } from '@/lib/store';
import { inputClass } from '@/components/Modal';

export default function LoginPage() {
  const router = useRouter();
  const setAdmin = useAppStore((s) => s.setAdmin);

  const [phone, setPhone] = useState('');
  const [password, setPassword] = useState('');
  const [showPassword, setShowPassword] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setError('');
    if (phone.trim().length < 6) return setError('Enter a valid phone number');
    if (password.length < 6) return setError('Enter your password');

    setLoading(true);
    try {
      const { user } = await login(phone.trim(), password);
      setAdmin(user);
      router.push('/dashboard');
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Login failed. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-[#F4F6F8] flex items-center justify-center p-4">
      <div className="w-full max-w-[300px]">
        <div className="card p-4 space-y-3">
          <div className="text-center">
            <div className="w-9 h-9 rounded-lg bg-gradient-to-br from-primary to-primary-dark flex items-center justify-center mx-auto shadow-sm">
              <ShieldCheck size={16} className="text-white" />
            </div>
            <h1 className="text-sm font-bold text-gray-900 mt-2">Super Admin</h1>
            <p className="text-xs text-gray-400 mt-0.5">Sign in with a super-admin account</p>
          </div>

          <form onSubmit={handleLogin} className="space-y-2">
            {error && (
              <div className="px-2.5 py-1.5 bg-red-50 border border-red-200 rounded-md text-red-600 text-xs">
                {error}
              </div>
            )}

            <div>
              <label htmlFor="phone" className="block text-xs font-medium text-gray-700 mb-1">
                Phone number
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
                Password
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
                  aria-label={showPassword ? 'Hide password' : 'Show password'}
                  className="absolute right-1 top-1/2 -translate-y-1/2 p-1.5 rounded text-gray-400 hover:text-gray-600 hover:bg-gray-100"
                  tabIndex={-1}
                >
                  {showPassword ? <EyeOff size={13} /> : <Eye size={13} />}
                </button>
              </div>
            </div>

            <button type="submit" disabled={loading} className="btn-primary w-full disabled:opacity-60">
              {loading ? 'Signing in…' : 'Sign in'}
            </button>
          </form>
        </div>
      </div>
    </div>
  );
}
