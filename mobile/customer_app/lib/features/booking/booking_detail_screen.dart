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
        '/v2/bookings/${widget.booking.id}/status',
        data: {'status': 'CANCELLED'},
      ),
      message: 'Reschedule rejected',
    );
  }

  Future<void> _acceptReschedule() async {
    await _updateBooking(
      request: () => ApiClient()
          .patch('/v2/bookings/${widget.booking.id}/accept-reschedule'),
      message: 'Reschedule accepted',
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Update failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;
    final isRescheduled = booking.status == 'PENDING_RESCHEDULE';

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
              ],
            ),
          ),
          const SizedBox(height: 14),
          _Section(
            title: 'Appointment',
            children: [
              _InfoRow(
                icon: Icons.schedule,
                label: 'Time',
                value: _formatDate(booking.slotStart),
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
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: Color(0xFF9B6410)),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Master suggested this new time. Accept it to confirm the appointment, or reject it to cancel.',
                      style: TextStyle(
                        color: Color(0xFF9B6410),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
      ),
    );
  }

  String _formatDate(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final suffix = date.hour >= 12 ? 'PM' : 'AM';
    return '${date.day}/${date.month}, $hour:00 $suffix';
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
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          ...children,
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
            child: Text(label,
                style: const TextStyle(
                    color: Color(0xFF756E80), fontWeight: FontWeight.w700)),
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
