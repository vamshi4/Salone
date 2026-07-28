import { create } from 'zustand';
import type { User, Salon } from '@/types';

interface AppStore {
  user: User | null;
  selectedSalonId: string | null;
  salons: Salon[];

  setUser: (user: User) => void;
  setSalons: (salons: Salon[]) => void;
  setSelectedSalon: (salonId: string) => void;
  addSalon: (salon: Salon) => void;
  logout: () => void;
}

export const useAppStore = create<AppStore>((set) => ({
  user: null,
  selectedSalonId: null,
  salons: [],

  setUser: (user) => set({ user }),
  setSalons: (salons) => set({ salons, selectedSalonId: salons[0]?.id || null }),
  setSelectedSalon: (salonId) => set({ selectedSalonId: salonId }),
  addSalon: (salon) =>
    set((s) => ({ salons: [...s.salons, salon], selectedSalonId: salon.id })),
  logout: () => {
    set({ user: null, selectedSalonId: null, salons: [] });
  },
}));
