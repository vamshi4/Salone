import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import apiClient from './api';
import type { User, Salon, Booking, Staff, Service, Product } from '@/types';

// Auth
export const useGetMe = () => {
  return useQuery<{ user: User; salons: Salon[] }>({
    queryKey: ['auth', 'me'],
    queryFn: () => apiClient.get('/auth/me').then((res) => res.data),
    retry: 1,
  });
};

// Salons
export const useGetSalons = () => {
  return useQuery<Salon[]>({
    queryKey: ['salons'],
    queryFn: () => apiClient.get('/salons').then((res) => res.data.salons),
  });
};

// Bookings
export const useGetBookings = (salonId: string, date?: string) => {
  return useQuery<Booking[]>({
    queryKey: ['bookings', salonId, date],
    queryFn: () =>
      apiClient
        .get(`/salons/${salonId}/bookings`, { params: { date } })
        .then((res) => res.data.bookings || []),
    enabled: !!salonId,
  });
};

export const useUpdateBookingStatus = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ({ salonId, bookingId, status }: any) =>
      apiClient.patch(`/salons/${salonId}/bookings/${bookingId}/status`, { status }),
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: ['bookings', variables.salonId] });
    },
  });
};

// Staff
export const useGetStaff = (salonId: string) => {
  return useQuery<Staff[]>({
    queryKey: ['staff', salonId],
    queryFn: () =>
      apiClient.get(`/salons/${salonId}/stylists`).then((res) => res.data.stylists || []),
    enabled: !!salonId,
  });
};

// Services
export const useGetServices = (salonId: string) => {
  return useQuery<Service[]>({
    queryKey: ['services', salonId],
    queryFn: () =>
      apiClient.get(`/salons/${salonId}/services`).then((res) => res.data.services || []),
    enabled: !!salonId,
  });
};

// Products
export const useGetProducts = (salonId: string) => {
  return useQuery<Product[]>({
    queryKey: ['products', salonId],
    queryFn: () =>
      apiClient.get(`/salons/${salonId}/products`).then((res) => res.data.products || []),
    enabled: !!salonId,
  });
};
