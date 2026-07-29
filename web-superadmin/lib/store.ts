import { create } from 'zustand';
import type { AdminUser } from '@/types';

interface AppState {
  admin: AdminUser | null;
  setAdmin: (admin: AdminUser | null) => void;
  logout: () => void;
}

export const useAppStore = create<AppState>((set) => ({
  admin: null,
  setAdmin: (admin) => set({ admin }),
  logout: () => set({ admin: null }),
}));
