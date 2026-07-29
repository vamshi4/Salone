'use client';

import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import * as api from './admin-api';

export function useStats() {
  return useQuery({ queryKey: ['admin-stats'], queryFn: api.fetchStats, staleTime: 10_000 });
}

export function useGrowth(days: number) {
  return useQuery({ queryKey: ['admin-growth', days], queryFn: () => api.fetchGrowth(days) });
}

export function useSalons() {
  return useQuery({ queryKey: ['admin-salons'], queryFn: api.fetchSalons, staleTime: 10_000 });
}

export function useSalonDetail(salonId: string | null) {
  return useQuery({
    queryKey: ['admin-salon', salonId],
    queryFn: () => api.fetchSalonDetail(salonId!),
    enabled: !!salonId,
  });
}

function useInvalidateSalon(salonId: string) {
  const qc = useQueryClient();
  return () => {
    qc.invalidateQueries({ queryKey: ['admin-salon', salonId] });
    qc.invalidateQueries({ queryKey: ['admin-salons'] });
  };
}

export function useUpdateSalon(salonId: string) {
  const invalidate = useInvalidateSalon(salonId);
  return useMutation({
    mutationFn: (payload: api.UpdateSalonPayload) => api.updateSalon(salonId, payload),
    onSuccess: invalidate,
  });
}

export function useDeleteSalon(salonId: string) {
  const invalidate = useInvalidateSalon(salonId);
  return useMutation({ mutationFn: () => api.deleteSalon(salonId), onSuccess: invalidate });
}

export function useRestoreSalon() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: (salonId: string) => api.restoreSalon(salonId),
    onSuccess: () => {
      qc.invalidateQueries({ queryKey: ['admin-salons'] });
      qc.invalidateQueries({ queryKey: ['admin-deleted'] });
    },
  });
}

export function useUpdateUser(salonId: string) {
  const invalidate = useInvalidateSalon(salonId);
  return useMutation({
    mutationFn: ({ userId, payload }: { userId: string; payload: api.UpdateUserPayload }) =>
      api.updateUser(userId, payload),
    onSuccess: invalidate,
  });
}

export function useResetUserPassword() {
  return useMutation({
    mutationFn: ({ userId, password }: { userId: string; password: string }) =>
      api.resetUserPassword(userId, password),
  });
}

export function useUpdateUserRole(salonId: string) {
  const invalidate = useInvalidateSalon(salonId);
  return useMutation({
    mutationFn: ({ userId, role }: { userId: string; role: string }) => api.updateUserRole(userId, role),
    onSuccess: invalidate,
  });
}

export function useDeleteUser(salonId: string) {
  const invalidate = useInvalidateSalon(salonId);
  return useMutation({ mutationFn: (userId: string) => api.deleteUser(userId), onSuccess: invalidate });
}

export function useRestoreUser() {
  const qc = useQueryClient();
  return useMutation({
    mutationFn: (userId: string) => api.restoreUser(userId),
    onSuccess: () => qc.invalidateQueries({ queryKey: ['admin-deleted'] }),
  });
}

export function useUpdateBooking(salonId: string) {
  const invalidate = useInvalidateSalon(salonId);
  return useMutation({
    mutationFn: ({ bookingId, payload }: { bookingId: string; payload: api.UpdateBookingPayload }) =>
      api.updateBooking(bookingId, payload),
    onSuccess: invalidate,
  });
}

export function useDeleteBooking(salonId: string) {
  const invalidate = useInvalidateSalon(salonId);
  return useMutation({ mutationFn: (bookingId: string) => api.deleteBooking(bookingId), onSuccess: invalidate });
}

export function useUpdateService(salonId: string) {
  const invalidate = useInvalidateSalon(salonId);
  return useMutation({
    mutationFn: ({ serviceId, payload }: { serviceId: string; payload: api.UpdateServicePayload }) =>
      api.updateService(serviceId, payload),
    onSuccess: invalidate,
  });
}

export function useDeleteService(salonId: string) {
  const invalidate = useInvalidateSalon(salonId);
  return useMutation({ mutationFn: (serviceId: string) => api.deleteService(serviceId), onSuccess: invalidate });
}

export function useUpdateCustomer(salonId: string) {
  const invalidate = useInvalidateSalon(salonId);
  return useMutation({
    mutationFn: ({ salonCustomerId, payload }: { salonCustomerId: string; payload: api.UpdateCustomerPayload }) =>
      api.updateCustomer(salonCustomerId, payload),
    onSuccess: invalidate,
  });
}

export function useDeleteCustomer(salonId: string) {
  const invalidate = useInvalidateSalon(salonId);
  return useMutation({
    mutationFn: (salonCustomerId: string) => api.deleteCustomer(salonCustomerId),
    onSuccess: invalidate,
  });
}

export function useUpdateStylist(salonId: string) {
  const invalidate = useInvalidateSalon(salonId);
  return useMutation({
    mutationFn: ({ stylistId, payload }: { stylistId: string; payload: api.UpdateStylistPayload }) =>
      api.updateStylist(stylistId, payload),
    onSuccess: invalidate,
  });
}

export function useDeleteStylist(salonId: string) {
  const invalidate = useInvalidateSalon(salonId);
  return useMutation({ mutationFn: (stylistId: string) => api.deleteStylist(stylistId), onSuccess: invalidate });
}

export function useRestoreStylist(salonId: string) {
  const invalidate = useInvalidateSalon(salonId);
  return useMutation({ mutationFn: (stylistId: string) => api.restoreStylist(stylistId), onSuccess: invalidate });
}

export function useDeletedItems() {
  return useQuery({ queryKey: ['admin-deleted'], queryFn: api.fetchDeleted });
}

export function useAudit(params?: { targetType?: string; targetId?: string; limit?: number }) {
  return useQuery({ queryKey: ['admin-audit', params], queryFn: () => api.fetchAudit(params) });
}
