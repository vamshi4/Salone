import axios from 'axios';

export const API_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3000';

const TOKEN_KEY = 'salone_admin_token';

export function getToken(): string | null {
  if (typeof window === 'undefined') return null;
  return localStorage.getItem(TOKEN_KEY);
}

export function saveToken(token: string) {
  if (typeof window !== 'undefined') localStorage.setItem(TOKEN_KEY, token);
}

export function clearToken() {
  if (typeof window !== 'undefined') localStorage.removeItem(TOKEN_KEY);
}

// Requests to these paths go out without a bearer token — there's no
// session yet when calling them, matching the mobile app's anonApi().
const PUBLIC_PATHS = [
  '/auth/login',
  '/auth/salon-signup',
  '/auth/google-login',
  '/auth/forgot-password',
  '/auth/reset-password-otp',
  '/auth/demo-token',
];

export const apiClient = axios.create({
  baseURL: `${API_URL}/api/v2`,
  headers: {
    'Content-Type': 'application/json',
  },
});

apiClient.interceptors.request.use((config) => {
  const isPublic = PUBLIC_PATHS.some((p) => config.url?.includes(p));
  if (!isPublic) {
    const token = getToken();
    if (token) config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// Endpoints where a 401 means something other than "your session token is
// invalid" — e.g. change-password's 401 means "the current password you
// typed is wrong," not "you've been logged out." Auto-redirecting on those
// would silently kick the user out of the app over a form validation error.
const SESSION_EXEMPT_401_PATHS = ['/auth/change-password'];

apiClient.interceptors.response.use(
  (res) => res,
  (error) => {
    const isExempt = SESSION_EXEMPT_401_PATHS.some((p) => error.config?.url?.includes(p));
    if (error.response?.status === 401 && !isExempt && typeof window !== 'undefined') {
      clearToken();
      if (!window.location.pathname.startsWith('/login')) {
        window.location.href = '/login';
      }
    }
    return Promise.reject(error);
  }
);

export default apiClient;
