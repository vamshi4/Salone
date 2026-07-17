import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/api.dart';
import '../core/format.dart';
import '../core/helpers.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';
import 'common.dart';

String bookingServiceSummary(Map<String, dynamic> booking, AppLocalizations t) {
  final bundle = List<Map<String, dynamic>>.from(booking['services'] ?? []);
  final names = bundle
      .map((item) => item['service']?['name'])
      .whereType<String>()
      .where((name) => name.trim().isNotEmpty)
      .toList();

  if (names.isNotEmpty) {
    if (names.length == 1) return names.first;
    if (names.length == 2) return t.twoServicesJoin(names[0], names[1]);
    return t.plusMoreServices(names.first, names.length - 1);
  }

  return booking['service']?['name'] ?? t.serviceLabel;
}

/// A completed/logged booking row: service, staff, time, price. Used for
/// Home's "Logged today" list and the Bookings day-grouped log. [isRepeat]
/// shows a small "Repeat" tag when this customer has more than one booking.
class BookingLogRow extends StatelessWidget {
  const BookingLogRow({super.key, required this.booking, this.isRepeat = false, this.onTap});

  final Map<String, dynamic> booking;
  final bool isRepeat;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final service = bookingServiceSummary(booking, t);
    final stylist = booking['stylist']?['user']?['name'] ?? t.staffLabel;
    final customer = booking['customer']?['name'] ?? t.customerLabel;
    final time = effectiveBookingTime(booking);
    final price = (booking['price'] ?? 0) as int;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: cardDecoration(),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text.rich(
                          TextSpan(
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                            children: [
                              TextSpan(text: '$customer · '),
                              TextSpan(text: service),
                            ],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isRepeat) ...[
                        const SizedBox(width: 6),
                        StatusPill(label: t.repeatLabel),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text('$stylist · ${formatTime(time)}',
                      style: const TextStyle(fontSize: 12, color: AppColors.inkMuted)),
                ],
              ),
            ),
            Text(formatMoney(price), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

/// A booking that still needs a decision: pending confirmation, or a
/// customer-proposed reschedule. Adapted from v2's `_BookingCard` action
/// buttons — same endpoints, restyled to match the new visual language.
class BookingActionCard extends StatelessWidget {
  const BookingActionCard({super.key, required this.booking, required this.onChanged});

  final Map<String, dynamic> booking;
  final VoidCallback onChanged;

  bool get _isCustomerReschedule =>
      booking['status'] == 'PENDING_RESCHEDULE' && booking['rescheduleProposedBy'] == 'CUSTOMER';

  Future<void> _updateStatus(BuildContext context, String status) async {
    try {
      await api().patch('/v2/bookings/${booking['id']}/status', data: {'status': status});
      onChanged();
    } catch (e) {
      if (kDebugMode) debugPrint('Booking status update failed: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.couldNotUpdateBooking)));
      }
    }
  }

  Future<void> _acceptReschedule(BuildContext context) async {
    try {
      await api().patch('/v2/bookings/${booking['id']}/accept-reschedule', data: {'acceptedBy': 'STYLIST'});
      onChanged();
    } catch (e) {
      if (kDebugMode) debugPrint('Reschedule accept failed: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.couldNotAcceptReschedule)));
      }
    }
  }

  Future<void> _rejectReschedule(BuildContext context) async {
    try {
      await api().patch('/v2/bookings/${booking['id']}/reject-reschedule', data: {'rejectedBy': 'STYLIST'});
      onChanged();
    } catch (e) {
      if (kDebugMode) debugPrint('Reschedule reject failed: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.couldNotRejectReschedule)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final service = bookingServiceSummary(booking, t);
    final stylist = booking['stylist']?['user']?['name'] ?? t.staffLabel;
    final customer = booking['customer']?['name'] ?? t.customerLabel;
    final slot = DateTime.parse(booking['slotStart']).toLocal();
    final proposedSlot =
        booking['proposedDateTime'] == null ? null : DateTime.parse(booking['proposedDateTime']).toLocal();

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: cardDecoration(borderColor: AppColors.amber),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(service, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              ),
              StatusPill(
                label: _isCustomerReschedule ? t.rescheduleLabel : t.pendingLabel,
                color: AppColors.amber,
                background: AppColors.amberSoft,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(t.customerWithStylist(customer, stylist),
              style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700, fontSize: 13)),
          const SizedBox(height: 6),
          Text(formatDateTime(slot), style: const TextStyle(color: AppColors.inkMuted, fontSize: 12)),
          if (_isCustomerReschedule && proposedSlot != null) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                  color: AppColors.amberSoft, borderRadius: BorderRadius.circular(AppRadius.sm)),
              child: Text(t.customerRequestedTime(formatDateTime(proposedSlot)),
                  style: const TextStyle(color: AppColors.amber, fontWeight: FontWeight.w700, fontSize: 12)),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _rejectReschedule(context),
                    icon: const Icon(Icons.close, size: 16),
                    label: Text(t.reject),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _acceptReschedule(context),
                    icon: const Icon(Icons.check, size: 16),
                    label: Text(t.accept),
                  ),
                ),
              ],
            ),
          ] else if (booking['status'] == 'PENDING') ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _updateStatus(context, 'CANCELLED'),
                    icon: const Icon(Icons.close, size: 16),
                    label: Text(t.reject),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _updateStatus(context, 'CONFIRMED'),
                    icon: const Icon(Icons.check, size: 16),
                    label: Text(t.confirm),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
