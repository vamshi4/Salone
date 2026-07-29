import axios from 'axios';
import apiClient, { saveToken, clearToken, getToken } from './api';
import type { AdminUser } from '@/types';

interface ApiUser {
  id: string;
  phone: string;
  email: string | null;
  role: string;
  name: string | null;
}

function mapUser(u: ApiUser): AdminUser {
  return {
    id: u.id,
    phone: u.phone,
    email: u.email ?? '',
    name: u.name ?? '',
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

export async function login(phone: string, password: string): Promise<{ user: AdminUser }> {
  try {
    const res = await apiClient.post('/auth/login', { phone, password, role: 'SUPER_ADMIN' });
    saveToken(res.data.token as string);
    return { user: mapUser(res.data.user) };
  } catch (e) {
    throw extractError(e, 'Login failed. Please try again.');
  }
}

export async function fetchMe(): Promise<{ user: AdminUser } | null> {
  const token = getToken();
  if (!token) return null;
  try {
    const res = await apiClient.get('/auth/me');
    return { user: mapUser(res.data.user) };
  } catch (e) {
    if (axios.isAxiosError(e) && e.response?.status === 401) {
      clearToken();
      return null;
    }
    throw extractError(e, 'Could not load your account.');
  }
}

export function logoutLocal() {
  clearToken();
}
