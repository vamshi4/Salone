'use client';

import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { useAppStore } from './store';
import * as api from './salon-api';

// Every hook here scopes to the currently-selected salon. Re-exported so
// pages don't each need to pull selectedSalonId out of the store themselves.
export function useSelectedSalonId() {
  return useAppStore((s) => s.selectedSalonId);
}

export function useSalons() {
  return useQuery({
    queryKey: ['salon-summaries'],
    queryFn: api.fetchSalons,
    staleTime: 10_000,
  });
}

export function useCreateSalon() {
  const inv = useInvalidate();
  return useMutation({
    mutationFn: api.createSalon,
    onSuccess: () => inv.salons(),
  });
}

export function useCurrentSalon() {
  const salonId = useSelectedSalonId();
  const { data } = useSalons();
  return data?.find((s) => s.id === salonId);
}

export function useBookings(salonId: string | null) {
  return useQuery({
    queryKey: ['bookings', salonId],
    queryFn: () => api.fetchBookings(salonId!),
    enabled: !!salonId,
  });
}

export function useCustomers(salonId: string | null) {
  return useQuery({
    queryKey: ['customers', salonId],
    queryFn: () => api.fetchCustomers(salonId!),
    enabled: !!salonId,
  });
}

function useInvalidate() {
  const qc = useQueryClient();
  return {
    salons: () => qc.invalidateQueries({ queryKey: ['salon-summaries'] }),
    bookings: (salonId: string) => qc.invalidateQueries({ queryKey: ['bookings', salonId] }),
    customers: (salonId: string) => qc.invalidateQueries({ queryKey: ['customers', salonId] }),
  };
}

export function useLogBooking() {
  const inv = useInvalidate();
  return useMutation({
    mutationFn: api.logBooking,
    onSuccess: (_data, variables) => {
      inv.bookings(variables.salonId);
      inv.salons();
      inv.customers(variables.salonId);
    },
  });
}

export function useSetBookingStatus(salonId: string) {
  const inv = useInvalidate();
  return useMutation({
    mutationFn: ({ bookingId, status, paymentMethod }: {
      bookingId: string;
      status: api.BookingStatus;
      paymentMethod?: api.PaymentMethod;
    }) => api.setBookingStatus(bookingId, status, paymentMethod),
    onSuccess: () => {
      inv.bookings(salonId);
      inv.salons();
    },
  });
}

export function useSaveService(salonId: string) {
  const inv = useInvalidate();
  return useMutation({
    mutationFn: (svc: Parameters<typeof api.saveService>[1]) => api.saveService(salonId, svc),
    onSuccess: () => inv.salons(),
  });
}

export function useAddStarterServices(salonId: string) {
  const inv = useInvalidate();
  return useMutation({
    mutationFn: () => api.addStarterServices(salonId),
    onSuccess: () => inv.salons(),
  });
}

export function useDeleteService(salonId: string) {
  const inv = useInvalidate();
  return useMutation({
    mutationFn: (serviceId: string) => api.deleteService(salonId, serviceId),
    onSuccess: () => inv.salons(),
  });
}

export function useSaveProduct(salonId: string) {
  const inv = useInvalidate();
  return useMutation({
    mutationFn: (p: Parameters<typeof api.saveProduct>[1]) => api.saveProduct(salonId, p),
    onSuccess: () => inv.salons(),
  });
}

export function useDeleteProduct(salonId: string) {
  const inv = useInvalidate();
  return useMutation({
    mutationFn: (productId: string) => api.deleteProduct(salonId, productId),
    onSuccess: () => inv.salons(),
  });
}

export function useAddStaff(salonId: string) {
  const inv = useInvalidate();
  return useMutation({
    mutationFn: (payload: api.AddStaffPayload) => api.addStaff(salonId, payload),
    onSuccess: () => inv.salons(),
  });
}

export function useUpdateStaff(salonId: string) {
  const inv = useInvalidate();
  return useMutation({
    mutationFn: ({ stylistId, payload }: { stylistId: string; payload: api.UpdateStaffPayload }) =>
      api.updateStaff(salonId, stylistId, payload),
    onSuccess: () => inv.salons(),
  });
}

export function useStylistEarnings(salonId: string, stylistId: string, period: 'day' | 'week' | 'month') {
  return useQuery({
    queryKey: ['stylist-earnings', salonId, stylistId, period],
    queryFn: () => api.fetchStylistEarnings(salonId, stylistId, period),
    enabled: !!salonId && !!stylistId,
  });
}

export function useEarnings(salonId: string | null, period: 'day' | 'week' | 'month') {
  return useQuery({
    queryKey: ['earnings', salonId, period],
    queryFn: () => api.fetchEarnings(salonId!, period),
    enabled: !!salonId,
  });
}

export function useRetention(salonId: string | null) {
  return useQuery({
    queryKey: ['retention', salonId],
    queryFn: () => api.fetchRetention(salonId!),
    enabled: !!salonId,
  });
}

export function useDownloadEarningsCsv() {
  return useMutation({
    mutationFn: ({ salonId, period }: { salonId: string; period: 'day' | 'week' | 'month' }) =>
      api.downloadEarningsCsv(salonId, period),
  });
}

export function useAtRisk(salonId: string | null) {
  return useQuery({
    queryKey: ['at-risk', salonId],
    queryFn: () => api.fetchAtRisk(salonId!),
    enabled: !!salonId,
  });
}

export function useCustomerProfile(salonId: string | null, customerId: string | null) {
  return useQuery({
    queryKey: ['customer-profile', salonId, customerId],
    queryFn: () => api.fetchCustomerProfile(salonId!, customerId!),
    enabled: !!salonId && !!customerId,
  });
}

export function useSaveCustomerProfile(salonId: string) {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: ({ customerId, notes, tags }: { customerId: string; notes: string; tags: string[] }) =>
      api.saveCustomerProfile(salonId, customerId, notes, tags),
    onSuccess: (_data, variables) =>
      qc.invalidateQueries({ queryKey: ['customer-profile', salonId, variables.customerId] }),
  });
}

export function useUpdateStylistProfile(salonId: string) {
  const inv = useInvalidate();
  return useMutation({
    mutationFn: ({ stylistId, payload }: { stylistId: string; payload: { name: string; phone: string } }) =>
      api.updateStylistProfile(stylistId, payload),
    onSuccess: () => inv.salons(),
  });
}

export function useAvailabilityRules(stylistId: string) {
  return useQuery({
    queryKey: ['availability-rules', stylistId],
    queryFn: () => api.fetchAvailabilityRules(stylistId),
    enabled: !!stylistId,
  });
}

export function useAddAvailabilityRule(stylistId: string) {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: (rule: { dayOfWeek: number; startTime: string; endTime: string }) =>
      api.addAvailabilityRule(stylistId, rule),
    onSuccess: () => qc.invalidateQueries({ queryKey: ['availability-rules', stylistId] }),
  });
}

export function useDeleteAvailabilityRule(stylistId: string) {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: (ruleId: string) => api.deleteAvailabilityRule(stylistId, ruleId),
    onSuccess: () => qc.invalidateQueries({ queryKey: ['availability-rules', stylistId] }),
  });
}

export function usePayouts(salonId: string, stylistId: string) {
  return useQuery({
    queryKey: ['payouts', salonId, stylistId],
    queryFn: () => api.fetchPayouts(salonId, stylistId),
    enabled: !!salonId && !!stylistId,
  });
}

export function useSettleCommissionPayout(salonId: string, stylistId: string) {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: () => api.settleCommissionPayout(salonId, stylistId),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['payouts', salonId, stylistId] });
      qc.invalidateQueries({ queryKey: ['stylist-earnings', salonId, stylistId] });
    },
  });
}

export function usePaySalary(salonId: string, stylistId: string) {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: () => api.paySalary(salonId, stylistId),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['payouts', salonId, stylistId] });
      qc.invalidateQueries({ queryKey: ['stylist-earnings', salonId, stylistId] });
    },
  });
}
