import 'package:flutter/material.dart';

import '../../core/models/marketplace_salon.dart';
import '../booking/salon_booking_screen.dart';
import 'stylist_profile_screen.dart';

class SalonDetailScreen extends StatelessWidget {
  const SalonDetailScreen({super.key, required this.salon});

  final MarketplaceSalon salon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Salon profile')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: _boxDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0ECFF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(Icons.storefront,
                        color: Color(0xFF5B3DB8), size: 54),
                  ),
                ),
                const SizedBox(height: 14),
                Text(salon.name,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        size: 18, color: Color(0xFFFFB000)),
                    const SizedBox(width: 4),
                    Text(
                      '${salon.rating.toStringAsFixed(1)}  ${salon.totalReviews} reviews',
                      style: const TextStyle(
                          color: Color(0xFF756E80),
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  salon.address,
                  style: const TextStyle(
                      color: Color(0xFF756E80), fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          _Section(
            title: 'Services',
            child: Column(
              children: salon.services.isEmpty
                  ? const [
                      Text(
                        'Services will be listed soon.',
                        style: TextStyle(
                            color: Color(0xFF756E80),
                            fontWeight: FontWeight.w700),
                      ),
                    ]
                  : salon.services
                      .map(
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
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(service.priceText,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w900)),
                            ],
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
          const SizedBox(height: 14),
          _Section(
            title: 'Featured staff',
            child: Column(
              children: salon.staff.isEmpty
                  ? const [
                      Text(
                        'Staff will be listed soon.',
                        style: TextStyle(
                            color: Color(0xFF756E80),
                            fontWeight: FontWeight.w700),
                      ),
                    ]
                  : salon.staff
                      .map(
                        (stylist) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: const CircleAvatar(
                              backgroundColor: Color(0xFFF0ECFF),
                              child: Icon(Icons.person_outline,
                                  color: Color(0xFF5B3DB8)),
                            ),
                            title: Text(stylist.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w900)),
                            subtitle: Text(stylist.priceText),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      StylistProfileScreen(stylist: stylist)),
                            ),
                          ),
                        ),
                      )
                      .toList(),
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
                  builder: (_) => SalonBookingScreen(salon: salon)),
            ),
            icon: const Icon(Icons.calendar_month_outlined),
            label: const Text('Book at this salon'),
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

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black.withValues(alpha: 0.07)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
