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
  DateTime _selectedDate = DateTime.now();
  DateTime? _selectedSlot;
  List<DateTime> _slots = [];
  bool _loadingSlots = false;
  String? _slotError;
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
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadSlots());
  }

  bool get _canBook =>
      widget.salon.services.isNotEmpty &&
      _selectedStylist != null &&
      _selectedSlot != null;

  Future<void> _loadSlots() async {
    final stylist = _selectedStylist;
    if (stylist == null || widget.salon.services.isEmpty) {
      setState(() {
        _slots = [];
        _selectedSlot = null;
        _slotError = stylist == null
            ? 'This salon has no active staff yet.'
            : 'This salon has no bookable services yet.';
      });
      return;
    }

    setState(() {
      _loadingSlots = true;
      _slotError = null;
      _slots = [];
      _selectedSlot = null;
    });
    try {
      final response = await ApiClient().get(
        '/api/v2/stylists/${stylist.id}/availability',
        queryParameters: {
          'date': _dateValue(_selectedDate),
          'serviceIds': _selectedService.id,
        },
      );
      final slots = ((response.data['slots'] ?? []) as List)
          .map((slot) => DateTime.parse(slot['dateTime']).toLocal())
          .toList();
      if (!mounted) return;
      setState(() {
        _slots = slots;
        _selectedSlot = slots.isEmpty ? null : slots.first;
        _slotError = slots.isEmpty
            ? 'No times available on this date. Try another day.'
            : null;
      });
    } catch (_) {
      if (mounted) {
        setState(() => _slotError = 'Could not load available times.');
      }
    } finally {
      if (mounted) setState(() => _loadingSlots = false);
    }
  }

  Future<void> _pickDate() async {
    final today = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(today.year, today.month, today.day),
      lastDate: today.add(const Duration(days: 60)),
    );
    if (date == null || date == _selectedDate) return;
    setState(() => _selectedDate = date);
    await _loadSlots();
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
      final res = await ApiClient().post('/api/v2/bookings', data: {
        'stylistId': stylist.id,
        'serviceIds': [_selectedService.id],
        'dateTime': _selectedSlot!.toUtc().toIso8601String(),
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
                        onTap: () {
                          setState(() => _selectedService = service);
                          _loadSlots();
                        },
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
                            onTap: () {
                              setState(() => _selectedStylist = stylist);
                              _loadSlots();
                            },
                          ),
                        ),
                      )
                      .toList(),
            ),
          ),
          const SizedBox(height: 14),
          _Section(
            title: '3. Choose date and time',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OutlinedButton.icon(
                  onPressed: _pickDate,
                  icon: const Icon(Icons.calendar_today_outlined),
                  label: Text(_dateLabel(_selectedDate)),
                ),
                const SizedBox(height: 14),
                const Text('Available times',
                    style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                if (_loadingSlots)
                  const LinearProgressIndicator(minHeight: 3)
                else if (_slotError != null)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline,
                          size: 18, color: Color(0xFF756E80)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(_slotError!,
                            style: const TextStyle(
                                color: Color(0xFF756E80),
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _slots.map((slot) {
                      final selected = slot == _selectedSlot;
                      return ChoiceChip(
                        selected: selected,
                        label: Text(_formatSlot(slot)),
                        onSelected: (_) => setState(() => _selectedSlot = slot),
                      );
                    }).toList(),
                  ),
              ],
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
                    value: _selectedSlot == null
                        ? 'Choose an available time'
                        : '${_dateLabel(_selectedDate)}, ${_formatSlot(_selectedSlot!)}'),
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
            onPressed: _booking || !_canBook ? null : _confirmBooking,
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
    final hour =
        slot.hour == 0 ? 12 : (slot.hour > 12 ? slot.hour - 12 : slot.hour);
    final suffix = slot.hour >= 12 ? 'PM' : 'AM';
    final minute = slot.minute.toString().padLeft(2, '0');
    return '$hour:$minute $suffix';
  }

  String _dateValue(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  String _dateLabel(DateTime date) {
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));
    final prefix = _sameDay(date, today)
        ? 'Today'
        : (_sameDay(date, tomorrow) ? 'Tomorrow' : _weekday(date.weekday));
    return '$prefix, ${date.day} ${_month(date.month)}';
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _weekday(int day) =>
      const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][day - 1];

  String _month(int month) => const [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ][month - 1];
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
