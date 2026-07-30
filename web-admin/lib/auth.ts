import axios from 'axios';
import apiClient, { API_URL, saveToken, clearToken, getToken } from './api';
import type { User, Salon } from '@/types';

export interface ApiUser {
  id: string;
  phone: string;
  email: string | null;
  role: 'SALON_OWNER' | 'STYLIST' | 'SUPER_ADMIN' | 'CUSTOMER';
  name: string | null;
  createdAt?: string;
}

export interface ApiSalon {
  id: string;
  name: string;
  ownerId: string;
  address: string;
  currency: string;
  countryCode: string;
  dailyRevenueGoal?: number | null;
  upiId?: string | null;
  gstEnabled?: boolean;
  gstRate?: number;
}

function mapUser(u: ApiUser): User {
  return {
    id: u.id,
    phone: u.phone,
    email: u.email ?? '',
    name: u.name ?? '',
    role: u.role === 'STYLIST' || u.role === 'SUPER_ADMIN' || u.role === 'SALON_OWNER' ? u.role : 'SALON_OWNER',
    salons: [],
    createdAt: u.createdAt,
  };
}

function mapSalon(s: ApiSalon): Salon {
  return {
    id: s.id,
    name: s.name,
    ownerId: s.ownerId,
    address: s.address,
    currency: s.currency,
    countryCode: s.countryCode,
    dailyRevenueGoal: s.dailyRevenueGoal ?? null,
    upiId: s.upiId ?? null,
    gstEnabled: s.gstEnabled ?? false,
    gstRate: s.gstRate ?? 18,
  };
}

export class AuthError extends Error {
  status?: number;
  constructor(message: string, status?: number) {
    super(message);
    this.status = status;
  }
}

function extractError(e: unknown, fallback: string): AuthError {
  if (axios.isAxiosError(e)) {
    if (!e.response) return new AuthError('Could not reach the server. Is the backend running?');
    const message = (e.response.data as { error?: string } | undefined)?.error ?? fallback;
    return new AuthError(message, e.response.status);
  }
  return new AuthError(fallback);
}

export async function login(phone: string, password: string): Promise<{ user: User }> {
  try {
    const res = await apiClient.post('/auth/login', { phone, password, role: 'SALON_OWNER' });
    saveToken(res.data.token as string);
    return { user: mapUser(res.data.user) };
  } catch (e) {
    throw extractError(e, 'Login failed. Please try again.');
  }
}

export async function googleLogin(idToken: string): Promise<{ user: User }> {
  try {
    const res = await apiClient.post('/auth/google-login', { idToken, role: 'SALON_OWNER' });
    saveToken(res.data.token as string);
    return { user: mapUser(res.data.user) };
  } catch (e) {
    throw extractError(e, 'Google sign-in failed.');
  }
}

export interface SignupPayload {
  ownerName: string;
  phone: string;
  password?: string;
  googleIdToken?: string;
  salonName: string;
  address: string;
  countryCode?: string;
  currency?: string;
}

export async function signup(payload: SignupPayload): Promise<{ user: User; salon: Salon }> {
  try {
    const res = await apiClient.post('/auth/salon-signup', payload);
    saveToken(res.data.token as string);
    return { user: mapUser(res.data.user), salon: mapSalon(res.data.salon) };
  } catch (e) {
    throw extractError(e, 'Sign up failed. Please try again.');
  }
}

export async function fetchMe(): Promise<{ user: User; salons: Salon[] } | null> {
  const token = getToken();
  if (!token) return null;
  try {
    const res = await apiClient.get('/auth/me');
    const salons = ((res.data.salons ?? []) as ApiSalon[]).map(mapSalon);
    return { user: mapUser(res.data.user), salons };
  } catch (e) {
    if (axios.isAxiosError(e) && e.response?.status === 401) {
      clearToken();
      return null;
    }
    throw extractError(e, 'Could not load your account.');
  }
}

export interface UpdateProfilePayload {
  ownerName?: string;
  phone?: string;
  email?: string;
  // Legacy single-salon fields — only meaningful (and only accepted by the
  // backend) when the account owns exactly one salon; see PATCH /auth/me.
  salonName?: string;
  address?: string;
  dailyRevenueGoal?: number;
  countryCode?: string;
  currency?: string;
  upiId?: string;
  gstEnabled?: boolean;
  gstRate?: number;
}

export async function updateProfile(
  payload: UpdateProfilePayload
): Promise<{ user: User; salon: Salon | null }> {
  try {
    const res = await apiClient.patch('/auth/me', payload);
    return {
      user: mapUser(res.data.user),
      salon: res.data.salon ? mapSalon(res.data.salon) : null,
    };
  } catch (e) {
    throw extractError(e, 'Could not save your changes.');
  }
}

export async function changePassword(currentPassword: string, newPassword: string): Promise<void> {
  try {
    await apiClient.post('/auth/change-password', { currentPassword, newPassword });
  } catch (e) {
    throw extractError(e, 'Could not update your password.');
  }
}

export function logoutLocal() {
  clearToken();
}

export { API_URL };
