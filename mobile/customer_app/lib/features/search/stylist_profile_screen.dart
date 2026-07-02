import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../core/models/stylist.dart';
import '../booking/booking_screen.dart';

class StylistProfileScreen extends StatelessWidget {
  const StylistProfileScreen({super.key, required this.stylist});

  final Stylist stylist;

  @override
  Widget build(BuildContext context) {
    final isExclusive = stylist.registrationType == 'SALON_EXCLUSIVE';

    return Scaffold(
      appBar: AppBar(title: const Text('Stylist profile')),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: stylist.avatarUrl,
                        width: 96,
                        height: 96,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) => const _AvatarFallback(),
                        placeholder: (_, __) => const _AvatarFallback(),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stylist.displayName,
                            style: const TextStyle(
                              fontSize: 22,
                              height: 1.15,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded,
                                  size: 19, color: Color(0xFFFFB000)),
                              const SizedBox(width: 4),
                              Text(
                                '${stylist.rating.toStringAsFixed(1)}  ${stylist.totalReviews} reviews',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF756E80)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            stylist.priceText,
                            style: const TextStyle(
                              color: Color(0xFF0F8D58),
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _ProfileChip(
                      icon: isExclusive ? Icons.storefront : Icons.work_outline,
                      label: isExclusive
                          ? 'Exclusive salon partner'
                          : 'Independent stylist',
                      color: const Color(0xFF5B3DB8),
                    ),
                    if (!isExclusive && stylist.homeServiceEnabled)
                      const _ProfileChip(
                        icon: Icons.home_outlined,
                        label: 'Home service available',
                        color: Color(0xFF008F7A),
                      ),
                    const _ProfileChip(
                      icon: Icons.verified_outlined,
                      label: 'Verified provider',
                      color: Color(0xFF5E6572),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: _boxDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Services',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                const SizedBox(height: 12),
                ...stylist.bookableServices.map(
                  (service) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0ECFF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.spa_outlined,
                              color: Color(0xFF5B3DB8)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(service.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w900)),
                              const SizedBox(height: 2),
                              Text(
                                '${service.duration} min • ${service.category}',
                                style: const TextStyle(
                                    color: Color(0xFF756E80),
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        Text(service.priceText,
                            style:
                                const TextStyle(fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isExclusive
                  ? const Color(0xFFFFF4DD)
                  : const Color(0xFFE8F7EF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  isExclusive ? Icons.info_outline : Icons.check_circle_outline,
                  color: isExclusive
                      ? const Color(0xFF9B6410)
                      : const Color(0xFF0F8D58),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    isExclusive
                        ? 'Bookings are attributed to ${stylist.primarySalon?.name ?? 'the salon'}. Home service is disabled.'
                        : 'You can choose salon visit or home service if your location is within 5 km.',
                    style: TextStyle(
                      color: isExclusive
                          ? const Color(0xFF9B6410)
                          : const Color(0xFF0F8D58),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: FilledButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => BookingScreen(stylist: stylist)),
            ),
            icon: const Icon(Icons.calendar_month_outlined),
            label: const Text('Continue to booking'),
          ),
        ),
      ),
    );
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
}

class _AvatarFallback extends StatelessWidget {
  const _AvatarFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 96,
      height: 96,
      color: const Color(0xFFF0ECFF),
      child: const Icon(Icons.person_outline, color: Color(0xFF5B3DB8)),
    );
  }
}

class _ProfileChip extends StatelessWidget {
  const _ProfileChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w800, fontSize: 12)),
        ],
      ),
    );
  }
}
