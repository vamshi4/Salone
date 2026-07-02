import 'package:flutter/material.dart';

class BookingSuccessScreen extends StatelessWidget {
  const BookingSuccessScreen({
    super.key,
    required this.bookingId,
    required this.provider,
    required this.total,
  });

  final String bookingId;
  final String provider;
  final String total;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 82,
                height: 82,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4DD),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.hourglass_top_rounded,
                    size: 46, color: Color(0xFF9B6410)),
              ),
              const SizedBox(height: 24),
              const Text(
                'Booking request sent',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              Text(
                'Waiting for $provider to accept',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Color(0xFF756E80), fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF4DD),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Color(0xFF9B6410)),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'You will see the confirmed status after the provider accepts the request.',
                        style: TextStyle(
                          color: Color(0xFF9B6410),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border:
                      Border.all(color: Colors.black.withValues(alpha: 0.07)),
                ),
                child: Column(
                  children: [
                    _Row(label: 'Booking ID', value: bookingId),
                    const Divider(height: 22),
                    _Row(label: 'Estimated total', value: total),
                    const Divider(height: 22),
                    const _Row(
                        label: 'Status', value: 'Waiting for acceptance'),
                  ],
                ),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () =>
                    Navigator.popUntil(context, (route) => route.isFirst),
                child: const Text('Back to home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
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
    );
  }
}
