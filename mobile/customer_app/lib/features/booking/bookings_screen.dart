import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/booking.dart';
import '../../core/providers/booking_provider.dart';
import 'booking_detail_screen.dart';

class BookingsScreen extends ConsumerWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsync = ref.watch(bookingsProvider);

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async => ref.invalidate(bookingsProvider),
        child: bookingsAsync.when(
          data: (bookings) {
            if (bookings.isEmpty) {
              return ListView(
                padding: const EdgeInsets.all(24),
                children: const [
                  SizedBox(height: 120),
                  Icon(Icons.calendar_month_outlined,
                      size: 48, color: Color(0xFF756E80)),
                  SizedBox(height: 14),
                  Text(
                    'No bookings yet',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Your confirmed appointments will appear here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xFF756E80), fontWeight: FontWeight.w600),
                  ),
                ],
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
              itemCount: bookings.length + 1,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return const Text(
                    'My bookings',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                  );
                }

                return _BookingCard(
                  booking: bookings[index - 1],
                  onChanged: () => ref.invalidate(bookingsProvider),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const SizedBox(height: 120),
              const Icon(Icons.cloud_off_outlined,
                  size: 48, color: Color(0xFFE06464)),
              const SizedBox(height: 14),
              const Text(
                'Could not load bookings',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              Text(
                '$error',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Color(0xFF756E80), fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({required this.booking, required this.onChanged});

  final CustomerBooking booking;
  final VoidCallback onChanged;

  String _formatDate(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final suffix = date.hour >= 12 ? 'PM' : 'AM';
    return '${date.day}/${date.month}, $hour:00 $suffix';
  }

  @override
  Widget build(BuildContext context) {
    final isRescheduled = booking.status == 'PENDING_RESCHEDULE';

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BookingDetailScreen(booking: booking),
          ),
        );
        onChanged();
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
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
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        booking.serviceName,
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w900),
                      ),
                    ),
                    _StatusBadge(status: booking.status),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  booking.providerText,
                  style: const TextStyle(
                      color: Color(0xFF756E80), fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.schedule,
                        size: 18, color: Color(0xFF5B3DB8)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(_formatDate(booking.slotStart),
                          style: const TextStyle(fontWeight: FontWeight.w800)),
                    ),
                    Text(
                      booking.totalText,
                      style: const TextStyle(
                          color: Color(0xFF0F8D58),
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
                if (isRescheduled) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF4DD),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, color: Color(0xFF9B6410)),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Action needed. Open details to accept or reject.',
                            style: TextStyle(
                                color: Color(0xFF9B6410),
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F7EF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: const TextStyle(
            color: Color(0xFF0F8D58),
            fontSize: 11,
            fontWeight: FontWeight.w900),
      ),
    );
  }
}
