import { create } from 'zustand';
import type { ColorSeed, Salon, User } from '../types';

interface AppStore {
  user: User | null;
  selectedSalonId: string | null;
  salons: Salon[];
  colorSeed: ColorSeed;
  sidebarOpen: boolean;

  setUser: (user: User) => void;
  setSalons: (salons: Salon[]) => void;
  setSelectedSalon: (salonId: string) => void;
  setColorSeed: (seed: ColorSeed) => void;
  setSidebarOpen: (open: boolean) => void;
  logout: () => void;
}

export const useAppStore = create<AppStore>((set) => ({
  user: null,
  selectedSalonId: null,
  salons: [],
  colorSeed: 'magenta',
  sidebarOpen: true,

  setUser: (user) => set({ user }),
  setSalons: (salons) => set({ salons, selectedSalonId: salons[0]?.id || null }),
  setSelectedSalon: (salonId) => set({ selectedSalonId: salonId }),
  setColorSeed: (colorSeed) => set({ colorSeed }),
  setSidebarOpen: (sidebarOpen) => set({ sidebarOpen }),
  logout: () => {
    localStorage.removeItem('auth_token');
    set({ user: null, selectedSalonId: null, salons: [] });
  },
}));
