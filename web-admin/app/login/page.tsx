'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';

export default function LoginPage() {
  const router = useRouter();
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    try {
      // TODO: Implement login with backend
      router.push('/dashboard');
    } catch (err) {
      setError('Login failed. Please try again.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-primary-light to-gray-50 flex items-center justify-center p-4">
      <div className="w-full max-w-md">
        <div className="card p-8 space-y-6">
          {/* Logo */}
          <div className="text-center">
            <h1 className="text-3xl font-bold text-primary flex items-center justify-center gap-2">
              🏪 Salone
            </h1>
            <p className="text-gray-600 text-sm mt-2">Salon Owner Dashboard</p>
          </div>

          {/* Form */}
          <form onSubmit={handleLogin} className="space-y-4">
            {error && (
              <div className="p-4 bg-danger/10 border border-danger/20 rounded-lg text-danger text-sm">
                {error}
              </div>
            )}

            <div>
              <label htmlFor="email" className="block text-sm font-medium text-gray-900 mb-2">
                Email or Phone
              </label>
              <input
                id="email"
                type="text"
                placeholder="you@example.com"
                value={email}
                onChange={(e) => setEmail(e.target.value)}
                className="w-full"
                required
              />
            </div>

            <div>
              <label htmlFor="password" className="block text-sm font-medium text-gray-900 mb-2">
                Password
              </label>
              <input
                id="password"
                type="password"
                placeholder="••••••••"
                value={password}
                onChange={(e) => setPassword(e.target.value)}
                className="w-full"
                required
              />
            </div>

            <button
              type="submit"
              disabled={loading}
              className="btn-primary w-full"
            >
              {loading ? 'Logging in...' : 'Sign In'}
            </button>
          </form>

          {/* Links */}
          <div className="text-center space-y-2 text-sm">
            <p className="text-gray-600">
              Don't have an account?{' '}
              <a href="/signup" className="text-primary font-medium hover:underline">
                Sign up
              </a>
            </p>
            <p>
              <a href="/forgot-password" className="text-primary font-medium hover:underline">
                Forgot password?
              </a>
            </p>
          </div>
        </div>

        {/* Footer */}
        <div className="text-center text-xs text-gray-600 mt-6">
          <p>© 2026 Salone. All rights reserved.</p>
        </div>
      </div>
    </div>
  );
}
