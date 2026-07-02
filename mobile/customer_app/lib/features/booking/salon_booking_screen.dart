import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/api/api_client.dart';
import '../../core/models/marketplace_salon.dart';
import '../../core/models/stylist.dart';
import '../../core/providers/booking_provider.dart';
import 'booking_success_screen.dart';

class SalonBookingScreen extends ConsumerStatefulWidget {
  const SalonBookingScreen({super.key, required this.salon});

  final MarketplaceSalon salon;

  @override
  ConsumerState<SalonBookingScreen> createState() => _SalonBookingScreenState();
}

class _SalonBookingScreenState extends ConsumerState<SalonBookingScreen> {
  late SalonService _selectedService;
  Stylist? _selectedStylist;
  late DateTime _selectedSlot;
  bool _booking = false;

  @override
  void initState() {
    super.initState();
    _selectedService = widget.salon.services.isNotEmpty
        ? widget.salon.services.first
        : SalonService(
            id: 'standard-service',
            name: 'Standard Service',
            category: 'Salon',
            duration: 60,
            basePrice: 50000,
          );
    _selectedStylist =
        widget.salon.staff.isNotEmpty ? widget.salon.staff.first : null;
    final now = DateTime.now();
    _selectedSlot = DateTime(now.year, now.month, now.day, now.hour + 1);
  }

  List<DateTime> get _slots {
    final now = DateTime.now();
    return List.generate(6, (index) {
      final hour = index + 1;
      return DateTime(now.year, now.month, now.day, now.hour + hour);
    });
  }

  Future<void> _confirmBooking() async {
    final stylist = _selectedStylist;
    if (stylist == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No staff available for this salon yet')),
      );
      return;
    }

    setState(() => _booking = true);

    try {
      final res = await ApiClient().post('/v2/bookings', data: {
        'stylistId': stylist.id,
        'serviceIds': [_selectedService.id],
        'dateTime': _selectedSlot.toIso8601String(),
        'isHomeService': false,
      });

      ref.invalidate(bookingsProvider);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BookingSuccessScreen(
            bookingId: res.data['id'],
            provider: '${widget.salon.name} with ${stylist.name}',
            total: _selectedService.priceText,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _booking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book salon')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _Section(
            title: '1. Select service',
            child: Column(
              children: (widget.salon.services.isEmpty
                      ? [_selectedService]
                      : widget.salon.services)
                  .map(
                    (service) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _ServiceTile(
                        service: service,
                        selected: service.id == _selectedService.id,
                        onTap: () => setState(() => _selectedService = service),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 14),
          _Section(
            title: '2. Select stylist',
            child: Column(
              children: widget.salon.staff.isEmpty
                  ? const [
                      Text(
                        'No active staff available yet.',
                        style: TextStyle(
                            color: Color(0xFF756E80),
                            fontWeight: FontWeight.w700),
                      ),
                    ]
                  : widget.salon.staff
                      .map(
                        (stylist) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _StylistTile(
                            stylist: stylist,
                            selected: stylist.id == _selectedStylist?.id,
                            onTap: () =>
                                setState(() => _selectedStylist = stylist),
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
          const SizedBox(height: 14),
          _Section(
            title: '3. Select time',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _slots.map((slot) {
                final selected = slot.hour == _selectedSlot.hour &&
                    slot.day == _selectedSlot.day;
                return ChoiceChip(
                  selected: selected,
                  label: Text(_formatSlot(slot)),
                  onSelected: (_) => setState(() => _selectedSlot = slot),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF17121F),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _SummaryRow(label: 'Salon', value: widget.salon.name),
                const SizedBox(height: 10),
                _SummaryRow(label: 'Service', value: _selectedService.name),
                const SizedBox(height: 10),
                _SummaryRow(
                    label: 'Time',
                    value: 'Today, ${_formatSlot(_selectedSlot)}'),
                const Divider(height: 24, color: Colors.white24),
                _SummaryRow(
                    label: 'Estimated total',
                    value: _selectedService.priceText,
                    strong: true),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _booking ? null : _confirmBooking,
            icon: _booking
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.check_circle_outline),
            label: Text(_booking ? 'Confirming...' : 'Confirm booking'),
          ),
        ],
      ),
    );
  }

  String _formatSlot(DateTime slot) {
    final hour = slot.hour > 12 ? slot.hour - 12 : slot.hour;
    final suffix = slot.hour >= 12 ? 'PM' : 'AM';
    return '$hour:00 $suffix';
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
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile(
      {required this.service, required this.selected, required this.onTap});

  final SalonService service;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _SelectableRow(
      selected: selected,
      onTap: onTap,
      icon: Icons.spa_outlined,
      title: service.name,
      subtitle: '${service.duration} min',
      trailing: service.priceText,
    );
  }
}

class _StylistTile extends StatelessWidget {
  const _StylistTile(
      {required this.stylist, required this.selected, required this.onTap});

  final Stylist stylist;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _SelectableRow(
      selected: selected,
      onTap: onTap,
      icon: Icons.person_outline,
      title: stylist.name,
      subtitle: stylist.registrationType == 'SALON_EXCLUSIVE'
          ? 'Exclusive staff'
          : 'Available stylist',
      trailing: stylist.rating.toStringAsFixed(1),
    );
  }
}

class _SelectableRow extends StatelessWidget {
  const _SelectableRow({
    required this.selected,
    required this.onTap,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  final bool selected;
  final VoidCallback onTap;
  final IconData icon;
  final String title;
  final String subtitle;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? Theme.of(context).colorScheme.primary
        : const Color(0xFF756E80);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFF0ECFF) : const Color(0xFFF8F6FA),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected
                ? Theme.of(context).colorScheme.primary
                : Colors.black.withValues(alpha: 0.05),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                        color: Color(0xFF756E80),
                        fontWeight: FontWeight.w600,
                        fontSize: 12),
                  ),
                ],
              ),
            ),
            Text(trailing, style: const TextStyle(fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow(
      {required this.label, required this.value, this.strong = false});

  final String label;
  final String value;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label,
              style: const TextStyle(
                  color: Colors.white70, fontWeight: FontWeight.w700)),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Colors.white,
              fontSize: strong ? 18 : 14,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}
