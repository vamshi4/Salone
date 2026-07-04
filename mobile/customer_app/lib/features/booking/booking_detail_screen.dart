import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/api_client.dart';
import '../../core/models/booking.dart';
import '../../core/providers/booking_provider.dart';

class BookingDetailScreen extends ConsumerStatefulWidget {
  const BookingDetailScreen({super.key, required this.booking});

  final CustomerBooking booking;

  @override
  ConsumerState<BookingDetailScreen> createState() =>
      _BookingDetailScreenState();
}

class _BookingDetailScreenState extends ConsumerState<BookingDetailScreen> {
  bool _saving = false;

  Future<void> _rejectReschedule() async {
    await _updateBooking(
      request: () => ApiClient().patch(
        '/v2/bookings/${widget.booking.id}/reject-reschedule',
        data: {'rejectedBy': 'CUSTOMER'},
      ),
      message: 'Reschedule rejected',
    );
  }

  Future<void> _acceptReschedule() async {
    await _updateBooking(
      request: () => ApiClient().patch(
        '/v2/bookings/${widget.booking.id}/accept-reschedule',
        data: {'acceptedBy': 'CUSTOMER'},
      ),
      message: 'Reschedule accepted',
    );
  }

  Future<void> _requestReschedule() async {
    final booking = widget.booking;
    if (booking.stylistId == null || booking.serviceId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking cannot be rescheduled yet')),
      );
      return;
    }

    final newTime = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _CustomerRescheduleSheet(
        currentSlot: booking.slotStart,
        stylistId: booking.stylistId!,
        serviceId: booking.serviceId,
      ),
    );

    if (newTime == null) return;

    await _updateBooking(
      request: () => ApiClient().patch(
        '/v2/bookings/${booking.id}/reschedule',
        data: {
          'dateTime': newTime.toUtc().toIso8601String(),
          'proposedBy': 'CUSTOMER',
        },
      ),
      message: 'Reschedule request sent',
    );
  }

  Future<void> _updateBooking({
    required Future<dynamic> Function() request,
    required String message,
  }) async {
    setState(() => _saving = true);
    try {
      await request();
      ref.invalidate(bookingsProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Update failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;
    final isRescheduled = booking.isPendingReschedule;
    final proposedByCustomer = booking.rescheduleByCustomer;
    final proposedByStylist = booking.rescheduleByProvider;
    final canRequestReschedule = booking.status == 'CONFIRMED';

    return Scaffold(
      appBar: AppBar(title: const Text('Booking details')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: _boxDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        booking.serviceName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    _StatusBadge(status: booking.status),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  booking.providerText,
                  style: const TextStyle(
                    color: Color(0xFF756E80),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: booking.needsCustomerAction
                        ? const Color(0xFFFFF4DD)
                        : const Color(0xFFF0ECFF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        booking.needsCustomerAction
                            ? Icons.touch_app_outlined
                            : Icons.info_outline,
                        color: booking.needsCustomerAction
                            ? const Color(0xFF9B6410)
                            : const Color(0xFF5B3DB8),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          booking.customerStatusMessage,
                          style: TextStyle(
                            color: booking.needsCustomerAction
                                ? const Color(0xFF9B6410)
                                : const Color(0xFF5B3DB8),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _TimelineSection(booking: booking),
          const SizedBox(height: 14),
          _Section(
            title: 'Appointment',
            children: [
              _InfoRow(
                icon: Icons.schedule,
                label:
                    booking.proposedDateTime == null ? 'Time' : 'Current time',
                value: _formatDate(booking.slotStart),
              ),
              if (booking.proposedDateTime != null)
                _InfoRow(
                  icon: Icons.update,
                  label: 'Proposed time',
                  value: _formatDate(booking.proposedDateTime!),
                ),
              _InfoRow(
                icon: booking.serviceType == 'HOME_SERVICE'
                    ? Icons.home_outlined
                    : Icons.storefront,
                label: 'Location',
                value: booking.serviceType == 'HOME_SERVICE'
                    ? 'Home service'
                    : 'Salon visit',
              ),
              _InfoRow(
                icon: Icons.payments_outlined,
                label: 'Total',
                value: booking.totalText,
              ),
            ],
          ),
          if (isRescheduled) ...[
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF4DD),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, color: Color(0xFF9B6410)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      proposedByCustomer
                          ? 'Your reschedule request is waiting for the stylist or salon to confirm. The original time stays active until they approve it.'
                          : 'Provider suggested this new time. Accept it to update the appointment, or reject it to keep the original time.',
                      style: const TextStyle(
                        color: Color(0xFF9B6410),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (proposedByStylist) ...[
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _saving ? null : _rejectReschedule,
                      icon: const Icon(Icons.close),
                      label: const Text('Reject'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _saving ? null : _acceptReschedule,
                      icon: const Icon(Icons.check_circle_outline),
                      label: Text(_saving ? 'Saving...' : 'Accept'),
                    ),
                  ),
                ],
              ),
            ],
          ],
          if (canRequestReschedule) ...[
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: _saving ? null : _requestReschedule,
              icon: const Icon(Icons.update),
              label: Text(_saving ? 'Sending...' : 'Request reschedule'),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final suffix = date.hour >= 12 ? 'PM' : 'AM';
    return '${date.day}/${date.month}, $hour:$minute $suffix';
  }
}

class _CustomerRescheduleSheet extends StatefulWidget {
  const _CustomerRescheduleSheet({
    required this.currentSlot,
    required this.stylistId,
    required this.serviceId,
  });

  final DateTime currentSlot;
  final String stylistId;
  final String serviceId;

  @override
  State<_CustomerRescheduleSheet> createState() =>
      _CustomerRescheduleSheetState();
}

class _CustomerRescheduleSheetState extends State<_CustomerRescheduleSheet> {
  DateTime? _selectedSlot;
  List<DateTime> _slots = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSlots();
  }

  Future<void> _loadSlots() async {
    setState(() {
      _loading = true;
      _error = null;
      _slots = [];
      _selectedSlot = null;
    });

    try {
      final date = _dateParam(widget.currentSlot);
      final res = await ApiClient().get(
        '/api/v2/stylists/${widget.stylistId}/availability'
        '?date=${Uri.encodeQueryComponent(date)}'
        '&serviceId=${Uri.encodeQueryComponent(widget.serviceId)}',
      );

      final slots = ((res.data['slots'] ?? []) as List)
          .map((slot) => DateTime.parse(slot['dateTime']).toLocal())
          .where((slot) => !slot.isAtSameMomentAs(widget.currentSlot))
          .toList();

      setState(() {
        _slots = slots;
        _selectedSlot = slots.isNotEmpty ? slots.first : null;
        _error = slots.isEmpty ? 'No other slots available.' : null;
      });
    } catch (e) {
      setState(() => _error = 'Could not load slots: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _dateParam(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  String _formatSlot(DateTime slot) {
    final hour = slot.hour % 12 == 0 ? 12 : slot.hour % 12;
    final minute = slot.minute.toString().padLeft(2, '0');
    final suffix = slot.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $suffix';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Request new time',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 6),
            const Text(
              'Pick an available slot. The stylist or salon must approve it.',
              style: TextStyle(
                color: Color(0xFF756E80),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            if (_loading)
              const LinearProgressIndicator(minHeight: 3)
            else if (_error != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _error!,
                    style: const TextStyle(
                      color: Color(0xFFE06464),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: _loadSlots,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _slots.map((slot) {
                  final selected = _selectedSlot != null &&
                      slot.isAtSameMomentAs(_selectedSlot!);
                  return ChoiceChip(
                    selected: selected,
                    label: Text(_formatSlot(slot)),
                    onSelected: (_) => setState(() => _selectedSlot = slot),
                  );
                }).toList(),
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _selectedSlot == null
                        ? null
                        : () => Navigator.pop(context, _selectedSlot),
                    icon: const Icon(Icons.send_outlined),
                    label: const Text('Request'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}

class _TimelineSection extends StatelessWidget {
  const _TimelineSection({required this.booking});

  final CustomerBooking booking;

  @override
  Widget build(BuildContext context) {
    final items = <_TimelineItem>[
      const _TimelineItem(
        title: 'Requested',
        subtitle: 'Booking request sent',
        done: true,
      ),
      _TimelineItem(
        title: 'Provider confirmation',
        subtitle: _providerSubtitle,
        done: booking.isConfirmed ||
            booking.isPendingReschedule ||
            booking.isCompleted,
        active: booking.isPending,
      ),
      if (booking.isPendingReschedule)
        _TimelineItem(
          title: booking.rescheduleByCustomer
              ? 'Provider review'
              : 'Customer review',
          subtitle: booking.rescheduleByCustomer
              ? 'Waiting for provider to approve your new time'
              : 'Accept or reject the proposed time',
          done: false,
          active: true,
        ),
      _TimelineItem(
        title: booking.isCancelled ? 'Cancelled' : 'Final appointment',
        subtitle: _finalSubtitle,
        done: booking.isConfirmed || booking.isCompleted || booking.isCancelled,
        active: false,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Status timeline',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          ...items.map((item) => _TimelineRow(item: item)),
        ],
      ),
    );
  }

  String get _providerSubtitle {
    if (booking.isPending) return 'Waiting for stylist or salon';
    if (booking.isCancelled) {
      return 'Provider rejected or booking was cancelled';
    }
    return 'Provider accepted';
  }

  String get _finalSubtitle {
    if (booking.isCancelled) return 'This appointment will not happen';
    if (booking.isCompleted) return 'Service completed';
    if (booking.isConfirmed) return 'Appointment time is confirmed';
    return 'Not final yet';
  }
}

class _TimelineItem {
  const _TimelineItem({
    required this.title,
    required this.subtitle,
    required this.done,
    this.active = false,
  });

  final String title;
  final String subtitle;
  final bool done;
  final bool active;
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({required this.item});

  final _TimelineItem item;

  @override
  Widget build(BuildContext context) {
    final color = item.done
        ? const Color(0xFF0F8D58)
        : item.active
            ? const Color(0xFF9B6410)
            : const Color(0xFFB8B0C2);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              item.done
                  ? Icons.check
                  : item.active
                      ? Icons.hourglass_top
                      : Icons.circle_outlined,
              size: 16,
              color: color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 2),
                Text(
                  item.subtitle,
                  style: const TextStyle(
                    color: Color(0xFF756E80),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF756E80),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final pending = status == 'PENDING_RESCHEDULE' || status == 'PENDING';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: pending ? const Color(0xFFFFF4DD) : const Color(0xFFE8F7EF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: pending ? const Color(0xFF9B6410) : const Color(0xFF0F8D58),
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

BoxDecoration _boxDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: Colors.black.withValues(alpha: 0.07)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.04),
        blurRadius: 16,
        offset: const Offset(0, 8),
      ),
    ],
  );
}
