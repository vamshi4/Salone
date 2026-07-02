import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';

import '../../core/api/api_client.dart';
import '../../core/models/stylist.dart';
import '../../core/providers/booking_provider.dart';
import 'booking_success_screen.dart';

class BookingScreen extends ConsumerStatefulWidget {
  final Stylist stylist;

  const BookingScreen({super.key, required this.stylist});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  late StylistService _selectedService;
  late Set<String> _selectedServiceIds;
  DateTime? _selectedSlot;
  List<DateTime> _slots = [];
  bool _homeService = false;
  String? _eligibilityError;
  String? _slotError;
  int _travelFee = 0;
  bool _checking = false;
  bool _booking = false;
  bool _loadingSlots = true;
  int _slotRequestVersion = 0;

  @override
  void initState() {
    super.initState();
    _selectedService = widget.stylist.bookableServices.first;
    _selectedServiceIds = {_selectedService.id};
    _loadSlots();
  }

  List<StylistService> get _selectedServices => widget.stylist.bookableServices
      .where((service) => _selectedServiceIds.contains(service.id))
      .toList();

  int get _servicesTotal =>
      _selectedServices.fold(0, (total, service) => total + service.basePrice);

  int get _total => _servicesTotal + (_homeService ? _travelFee : 0);

  Future<void> _loadSlots() async {
    final requestVersion = ++_slotRequestVersion;
    final serviceIds = _selectedServiceIds.join(',');

    setState(() {
      _loadingSlots = true;
      _slotError = null;
      _slots = [];
      _selectedSlot = null;
    });

    try {
      final date = _bookingDate();
      final query =
          'date=${Uri.encodeQueryComponent(_dateParam(date))}&serviceIds=${Uri.encodeQueryComponent(serviceIds)}';
      final res = await ApiClient().get(
        '/api/v2/stylists/${widget.stylist.id}/availability?$query',
      );

      if (!mounted || requestVersion != _slotRequestVersion) return;

      final slots = ((res.data['slots'] ?? []) as List)
          .map((slot) => DateTime.parse(slot['dateTime']).toLocal())
          .toList();

      setState(() {
        _slots = slots;
        _selectedSlot = slots.isNotEmpty ? slots.first : null;
        _slotError =
            slots.isEmpty ? 'No available slots for this service.' : null;
      });
    } catch (e) {
      if (!mounted || requestVersion != _slotRequestVersion) return;
      setState(() => _slotError = e.toString());
    } finally {
      if (mounted && requestVersion == _slotRequestVersion) {
        setState(() => _loadingSlots = false);
      }
    }
  }

  DateTime _bookingDate() {
    final now = DateTime.now();
    return now.hour >= 17 ? now.add(const Duration(days: 1)) : now;
  }

  String _dateParam(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  Future<void> _checkHomeService() async {
    setState(() {
      _checking = true;
      _eligibilityError = null;
    });

    try {
      final pos = await Geolocator.getCurrentPosition();
      final res =
          await ApiClient().post('/v2/bookings/check-home-service', data: {
        'stylistId': widget.stylist.id,
        'customerLat': pos.latitude,
        'customerLng': pos.longitude,
      });

      setState(() {
        _travelFee = res.data['travelFee'];
        _eligibilityError = null;
      });
    } catch (e) {
      setState(() {
        _eligibilityError = e.toString().replaceAll('Exception: ', '');
        _homeService = false;
      });
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  Future<void> _confirmBooking() async {
    setState(() => _booking = true);

    try {
      final pos = _homeService ? await Geolocator.getCurrentPosition() : null;
      final selectedSlot = _selectedSlot;
      if (selectedSlot == null) {
        throw Exception('Please select an available slot');
      }

      final res = await ApiClient().post('/v2/bookings', data: {
        'stylistId': widget.stylist.id,
        'serviceIds': _selectedServiceIds.toList(),
        'dateTime': selectedSlot.toUtc().toIso8601String(),
        'isHomeService': _homeService,
        if (pos != null) ...{
          'customerLat': pos.latitude,
          'customerLng': pos.longitude,
        },
      });

      ref.invalidate(bookingsProvider);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BookingSuccessScreen(
            bookingId: res.data['id'],
            provider: widget.stylist.displayName,
            total: 'Rs ${_total ~/ 100}',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking failed: ${_errorMessage(e)}')),
      );
    } finally {
      if (mounted) setState(() => _booking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final canBookHome = widget.stylist.registrationType == 'INDEPENDENT' &&
        widget.stylist.homeServiceEnabled;

    return Scaffold(
      appBar: AppBar(title: const Text('Book appointment')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _Section(
            title: '1. Select service',
            child: Column(
              children: widget.stylist.bookableServices.map((service) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _ServiceCheckTile(
                    service: service,
                    selected: _selectedServiceIds.contains(service.id),
                    onTap: () {
                      setState(() {
                        if (_selectedServiceIds.contains(service.id)) {
                          if (_selectedServiceIds.length > 1) {
                            _selectedServiceIds.remove(service.id);
                          }
                        } else {
                          _selectedServiceIds.add(service.id);
                        }
                        _selectedService = _selectedServices.first;
                      });
                      _loadSlots();
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 14),
          _Section(
            title: '2. Select time',
            child: _loadingSlots
                ? const LinearProgressIndicator(minHeight: 3)
                : _slotError != null
                    ? _SlotError(message: _slotError!, onRetry: _loadSlots)
                    : Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _slots.map((slot) {
                          final selected = _selectedSlot != null &&
                              slot.isAtSameMomentAs(_selectedSlot!);
                          return ChoiceChip(
                            selected: selected,
                            label: Text(_formatFullSlot(slot)),
                            onSelected: (_) =>
                                setState(() => _selectedSlot = slot),
                          );
                        }).toList(),
                      ),
          ),
          const SizedBox(height: 14),
          _Section(
            title: '3. Choose location',
            child: Column(
              children: [
                _ChoiceRow(
                  icon: Icons.storefront,
                  title: 'Salon visit',
                  subtitle:
                      'Booking is handled at ${widget.stylist.primarySalon?.name ?? 'the salon'}',
                  selected: !_homeService,
                  onTap: () {
                    setState(() {
                      _homeService = false;
                      _eligibilityError = null;
                    });
                  },
                ),
                if (canBookHome) ...[
                  const SizedBox(height: 10),
                  _ChoiceRow(
                    icon: Icons.home_outlined,
                    title: 'Home service',
                    subtitle: 'Allowed within 5 km. Location check required.',
                    selected: _homeService,
                    onTap: () {
                      setState(() => _homeService = true);
                      _checkHomeService();
                    },
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 14),
          if (_checking)
            const LinearProgressIndicator(minHeight: 3)
          else if (_eligibilityError != null)
            _NoticeBox(
              icon: Icons.error_outline,
              text: _eligibilityError!,
              background: const Color(0xFFFFECEC),
              color: const Color(0xFFC33B3B),
            )
          else if (_homeService)
            _NoticeBox(
              icon: Icons.check_circle_outline,
              text:
                  'Home service eligible. Travel fee: Rs ${_travelFee ~/ 100}',
              background: const Color(0xFFE8F7EF),
              color: const Color(0xFF0F8D58),
            )
          else if (widget.stylist.registrationType == 'SALON_EXCLUSIVE')
            const _NoticeBox(
              icon: Icons.info_outline,
              text: 'Exclusive stylists are available only inside the salon.',
              background: Color(0xFFFFF4DD),
              color: Color(0xFF9B6410),
            ),
          const SizedBox(height: 14),
          _SummaryCard(
            serviceName:
                _selectedServices.map((service) => service.name).join(', '),
            time: _selectedSlot == null
                ? 'Select an available slot'
                : _formatFullSlot(_selectedSlot!),
            total: 'Rs ${_total ~/ 100}',
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _booking ||
                    _checking ||
                    _selectedServiceIds.isEmpty ||
                    _selectedSlot == null ||
                    _slotError != null ||
                    (_homeService && _eligibilityError != null)
                ? null
                : _confirmBooking,
            icon: _booking
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.check_circle_outline),
            label: Text(_booking ? 'Sending...' : 'Send booking request'),
          ),
        ],
      ),
    );
  }

  String _formatSlot(DateTime slot) {
    final hour = slot.hour > 12 ? slot.hour - 12 : slot.hour;
    final minute = slot.minute.toString().padLeft(2, '0');
    final suffix = slot.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $suffix';
  }

  String _formatFullSlot(DateTime slot) {
    final now = DateTime.now();
    final label =
        slot.year == now.year && slot.month == now.month && slot.day == now.day
            ? 'Today'
            : '${slot.day}/${slot.month}';
    return '$label, ${_formatSlot(slot)}';
  }

  String _errorMessage(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map && data['error'] != null) return '${data['error']}';
      if (data is String && data.isNotEmpty) return data;
      return error.message ?? 'Request failed';
    }
    return '$error'.replaceAll('Exception: ', '');
  }
}

class _SlotError extends StatelessWidget {
  const _SlotError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          message,
          style: const TextStyle(
            color: Color(0xFFE06464),
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: const Text('Retry'),
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
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _ServiceCheckTile extends StatelessWidget {
  const _ServiceCheckTile({
    required this.service,
    required this.selected,
    required this.onTap,
  });

  final StylistService service;
  final bool selected;
  final VoidCallback onTap;

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
            Icon(Icons.spa_outlined, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(service.name,
                      style: const TextStyle(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 2),
                  Text(
                    '${service.duration} min • ${service.category}',
                    style: const TextStyle(
                        color: Color(0xFF756E80),
                        fontWeight: FontWeight.w600,
                        fontSize: 12),
                  ),
                ],
              ),
            ),
            Text(service.priceText,
                style: const TextStyle(fontWeight: FontWeight.w900)),
            const SizedBox(width: 8),
            Icon(
              selected ? Icons.check_box : Icons.check_box_outline_blank,
              color: color,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChoiceRow extends StatelessWidget {
  const _ChoiceRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

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
            Icon(selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: color),
          ],
        ),
      ),
    );
  }
}

class _NoticeBox extends StatelessWidget {
  const _NoticeBox({
    required this.icon,
    required this.text,
    required this.background,
    required this.color,
  });

  final IconData icon;
  final String text;
  final Color background;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: background, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text,
                style: TextStyle(color: color, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.serviceName,
    required this.time,
    required this.total,
  });

  final String serviceName;
  final String time;
  final String total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: const Color(0xFF17121F),
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          _SummaryRow(label: 'Service', value: serviceName),
          const SizedBox(height: 10),
          _SummaryRow(label: 'Time', value: time),
          const Divider(height: 24, color: Colors.white24),
          _SummaryRow(label: 'Estimated total', value: total, strong: true),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.strong = false,
  });

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
