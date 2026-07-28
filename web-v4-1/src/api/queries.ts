import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import apiClient from './client';
import type { Salon, Booking, Staff, Service, Product, InsightsData, User } from '../types';

export const useGetMe = () => {
  return useQuery<{ user: User; salon: Salon; salons: Salon[] }>({
    queryKey: ['auth', 'me'],
    queryFn: () => apiClient.get('/auth/me').then((res) => res.data),
  });
};

export const useGetSalons = () => {
  return useQuery<Salon[]>({
    queryKey: ['salons'],
    queryFn: () => apiClient.get('/salons').then((res) => res.data.salons),
  });
};

export const useGetSalon = (salonId: string) => {
  return useQuery<Salon>({
    queryKey: ['salons', salonId],
    queryFn: () => apiClient.get(`/salons/${salonId}`).then((res) => res.data),
    enabled: !!salonId,
  });
};

export const useGetBookings = (salonId: string, date?: string) => {
  return useQuery<Booking[]>({
    queryKey: ['bookings', salonId, date],
    queryFn: () =>
      apiClient
        .get(`/salons/${salonId}/bookings`, { params: { date } })
        .then((res) => res.data.bookings),
    enabled: !!salonId,
  });
};

export const useCreateBooking = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (data: any) => apiClient.post(`/salons/${data.salonId}/bookings`, data),
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: ['bookings', variables.salonId] });
    },
  });
};

export const useUpdateBooking = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ({ salonId, bookingId, data }: any) =>
      apiClient.patch(`/salons/${salonId}/bookings/${bookingId}`, data),
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: ['bookings', variables.salonId] });
    },
  });
};

export const useGetStaff = (salonId: string) => {
  return useQuery<Staff[]>({
    queryKey: ['staff', salonId],
    queryFn: () =>
      apiClient.get(`/salons/${salonId}/stylists`).then((res) => res.data.stylists),
    enabled: !!salonId,
  });
};

export const useCreateStaff = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (data: any) =>
      apiClient.post(`/salons/${data.salonId}/stylists`, data),
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: ['staff', variables.salonId] });
    },
  });
};

export const useUpdateStaff = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ({ salonId, staffId, data }: any) =>
      apiClient.patch(`/salons/${salonId}/stylists/${staffId}`, data),
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: ['staff', variables.salonId] });
    },
  });
};

export const useGetServices = (salonId: string) => {
  return useQuery<Service[]>({
    queryKey: ['services', salonId],
    queryFn: () =>
      apiClient.get(`/salons/${salonId}/services`).then((res) => res.data.services),
    enabled: !!salonId,
  });
};

export const useCreateService = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (data: any) =>
      apiClient.post(`/salons/${data.salonId}/services`, data),
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: ['services', variables.salonId] });
    },
  });
};

export const useGetProducts = (salonId: string) => {
  return useQuery<Product[]>({
    queryKey: ['products', salonId],
    queryFn: () =>
      apiClient.get(`/salons/${salonId}/products`).then((res) => res.data.products),
    enabled: !!salonId,
  });
};

export const useCreateProduct = () => {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (data: any) =>
      apiClient.post(`/salons/${data.salonId}/products`, data),
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: ['products', variables.salonId] });
    },
  });
};

export const useGetInsights = (salonId: string, period?: string) => {
  return useQuery<InsightsData>({
    queryKey: ['insights', salonId, period],
    queryFn: () =>
      apiClient
        .get(`/salons/${salonId}/retention`, { params: { period } })
        .then((res) => res.data),
    enabled: !!salonId,
  });
};

export const useGetEarnings = (salonId: string, period?: string) => {
  return useQuery({
    queryKey: ['earnings', salonId, period],
    queryFn: () =>
      apiClient
        .get(`/salons/${salonId}/earnings`, { params: { period } })
        .then((res) => res.data),
    enabled: !!salonId,
  });
};
