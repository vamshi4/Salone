import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/api.dart';
import '../core/format.dart';
import '../core/helpers.dart';
import '../l10n/app_localizations.dart';
import 'customer_profile_sheet.dart';
import '../theme.dart';

/// New booking sheet, ported from v2's `_ManualBookingSheet` with the same
/// two modes: "Done service" (log a finished walk-in now, no slot — the
/// default, since there's no pre-booking in the common case) and "Schedule
/// later" (a real future appointment, slot-validated). Restyled with a
/// sticky running-total footer so the total is always visible while
/// picking services.
class NewBookingSheet extends StatefulWidget {
  const NewBookingSheet({
    super.key,
    required this.salon,
    required this.staffRelations,
    required this.allBookings,
    this.prefill,
  });

  final Map<String, dynamic> salon;
  final List<Map<String, dynamic>> staffRelations;

  /// Passed in rather than read via DashboardScope.of(context) — this sheet
  /// is shown via showModalBottomSheet, which renders outside the Navigator
  /// route that DashboardScope wraps, so the InheritedWidget lookup would
  /// fail here even though it works from the calling screen.
  final List<Map<String, dynamic>> allBookings;

  /// A past booking to rebook — same shape as items in `DashboardData.bookings`
  /// (`customer`, `stylist`, `services[]`). When set, the sheet opens with
  /// the same customer/stylist/services pre-selected, defaulting to
  /// "Schedule later" since a rebook is a new future visit, not one that
  /// already happened. The owner still confirms/adjusts before saving.
  final Map<String, dynamic>? prefill;

  @override
  State<NewBookingSheet> createState() => _NewBookingSheetState();
}

class _NewBookingSheetState extends State<NewBookingSheet> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dateController = TextEditingController(text: dateInput(DateTime.now()));
  Map<String, dynamic>? _stylist;
  final Set<String> _selectedServiceIds = <String>{};
  List<DateTime> _slots = [];
  DateTime? _selectedSlot;
  bool _loadingSlots = false;
  String? _slotError;
  bool _saving = false;
  String? _formError;
  bool _completed = true; // "Done service" (log now) vs "Schedule later"
  String _paymentMethod = 'CASH'; // only sent/collected when _completed
  List<Map<String, dynamic>> _customers = [];
  bool _showSuggestions = false;

  AppLocalizations get t => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    final prefill = widget.prefill;
    if (prefill != null) {
      _nameController.text = '${prefill['customer']?['name'] ?? ''}';
      _phoneController.text = '${prefill['customer']?['phone'] ?? ''}';
      final prefillStylistId = prefill['stylist']?['id']?.toString();
      _stylist = firstOrNull(
            _activeStylists.where((s) => s['id']?.toString() == prefillStylistId).toList(),
          ) ??
          firstOrNull(_activeStylists);
      final prefillServiceIds = List<Map<String, dynamic>>.from(prefill['services'] ?? [])
          .map((item) => item['service']?['id']?.toString())
          .whereType<String>()
          .toSet();
      final availableIds = _servicesFor(_stylist).map((s) => '${s['id']}').toSet();
      _selectedServiceIds
        ..clear()
        ..addAll(prefillServiceIds.where(availableIds.contains));
      if (_selectedServiceIds.isEmpty) _resetSelectedServices();
      _completed = false; // rebook = a new future visit, not one already done
    } else {
      _stylist = firstOrNull(_activeStylists);
      _resetSelectedServices();
    }
    if (!_completed) _loadSlots();
    _loadCustomers();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _loadCustomers() async {
    try {
      final res = await api().get('/api/v2/salons/${widget.salon['id']}/customers');
      if (!mounted) return;
      setState(() => _customers = List<Map<String, dynamic>>.from(res.data as List));
    } catch (_) {
      // Autocomplete is a convenience; a failure here shouldn't block booking.
    }
  }

  List<Map<String, dynamic>> get _customerSuggestions {
    final phoneQ = _phoneController.text.trim();
    final nameQ = _nameController.text.trim();
    final q = phoneQ.isNotEmpty ? phoneQ : nameQ;
    if (q.length < 2) return const [];
    final lower = q.toLowerCase();
    return _customers.where((c) {
      final name = '${c['name'] ?? ''}'.toLowerCase();
      final phone = '${c['phone'] ?? ''}';
      return phone.contains(q) || name.contains(lower);
    }).take(5).toList();
  }

  void _openCustomerProfile(Map<String, dynamic> customer) {
    final customerId = customer['id']?.toString();
    if (customerId == null) return;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CustomerProfileSheet(
        salonId: '${widget.salon['id']}',
        customerId: customerId,
        customerName: '${customer['name'] ?? ''}',
        customerPhone: '${customer['phone'] ?? ''}',
        allBookings: widget.allBookings,
      ),
    );
  }

  void _pickCustomer(Map<String, dynamic> customer) {
    setState(() {
      _nameController.text = '${customer['name'] ?? ''}';
      _phoneController.text = '${customer['phone'] ?? ''}';
      _showSuggestions = false;
      _formError = null;
    });
  }

  List<Map<String, dynamic>> get _activeStylists => widget.staffRelations
      .where((r) => r['status'] == 'ACTIVE')
      .map((r) => r['stylist'])
      .whereType<Map<String, dynamic>>()
      .toList();

  List<Map<String, dynamic>> _servicesFor(Map<String, dynamic>? stylist) {
    final stylistServices = List<Map<String, dynamic>>.from(stylist?['services'] ?? []);
    if (stylistServices.isNotEmpty) return stylistServices;
    return List<Map<String, dynamic>>.from(widget.salon['services'] ?? []);
  }

  List<Map<String, dynamic>> get _selectedServices =>
      _servicesFor(_stylist).where((s) => _selectedServiceIds.contains('${s['id']}')).toList();

  int get _selectedServicesTotal =>
      _selectedServices.fold<int>(0, (sum, s) => sum + ((s['basePrice'] ?? 0) as int));

  void _resetSelectedServices() {
    _selectedServiceIds
      ..clear()
      ..addAll(_servicesFor(_stylist).take(1).map((s) => '${s['id']}'));
  }

  Future<void> _loadSlots() async {
    final stylist = _stylist;
    final selectedServices = _selectedServices;
    final date = _dateController.text.trim();

    if (stylist == null || selectedServices.isEmpty || date.isEmpty) {
      setState(() {
        _slots = [];
        _selectedSlot = null;
        _slotError = t.chooseStaffServiceDate;
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
      final res = await api().get(
        '/api/v2/stylists/${stylist['id']}/availability',
        queryParameters: {
          'date': date,
          'serviceIds': selectedServices.map((s) => s['id']).join(','),
        },
      );
      final slots = ((res.data['slots'] ?? []) as List)
          .map((slot) => DateTime.parse(slot['dateTime']).toLocal())
          .toList();
      setState(() {
        _slots = slots;
        _selectedSlot = firstOrNull(slots);
        _slotError = slots.isEmpty ? t.noSlotsForDate : null;
      });
    } catch (e) {
      setState(() => _slotError = t.couldNotLoadSlots);
    } finally {
      if (mounted) setState(() => _loadingSlots = false);
    }
  }

  Future<void> _save() async {
    final stylist = _stylist;
    final selectedServices = _selectedServices;
    final phone = _phoneController.text.trim();
    final dateTime = _selectedSlot;

    if (_nameController.text.trim().length < 2) {
      setState(() => _formError = t.enterCustomerName);
      return;
    }
    if (stylist == null || selectedServices.isEmpty) {
      setState(() => _formError = t.chooseStaffAndService);
      return;
    }
    if (phone.length < 6) {
      setState(() => _formError = t.enterCustomerPhone);
      return;
    }
    if (!_completed && dateTime == null) {
      setState(() => _formError = t.chooseAvailableSlot);
      return;
    }

    setState(() {
      _saving = true;
      _formError = null;
    });
    try {
      await api().post('/v2/bookings/salon-manual', data: {
        'salonId': widget.salon['id'],
        'stylistId': stylist['id'],
        'serviceIds': selectedServices.map((s) => s['id']).toList(),
        'customerName': _nameController.text.trim(),
        'customerPhone': phone,
        if (_completed) 'completed': true else 'dateTime': dateTime!.toUtc().toIso8601String(),
        if (_completed) 'paymentMethod': _paymentMethod,
      });
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (kDebugMode) debugPrint('Manual booking create failed: $e');
      final serverMessage = (e is DioException && e.response?.data is Map)
          ? (e.response?.data as Map)['error']
          : null;
      setState(() =>
          _formError = serverMessage is String ? serverMessage : t.couldNotCreateBooking);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final stylists = _activeStylists;
    final services = _servicesFor(_stylist);

    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.06),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(width: 36, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(999))),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.newBooking, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 14),
                    SegmentedButton<bool>(
                      segments: [
                        ButtonSegment(value: true, icon: const Icon(Icons.check_circle_outline), label: Text(t.doneServiceOption)),
                        ButtonSegment(value: false, icon: const Icon(Icons.event_outlined), label: Text(t.scheduleLaterOption)),
                      ],
                      selected: {_completed},
                      showSelectedIcon: false,
                      onSelectionChanged: (sel) {
                        setState(() {
                          _completed = sel.first;
                          _formError = null;
                        });
                        if (!_completed) _loadSlots();
                      },
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      key: const Key('booking_customer_name'),
                      controller: _nameController,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(labelText: t.customerNameLabel),
                      onChanged: (_) => setState(() => _showSuggestions = true),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      key: const Key('booking_customer_phone'),
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(labelText: t.customerPhoneLabel),
                      onChanged: (_) => setState(() => _showSuggestions = true),
                    ),
                    if (_showSuggestions && _customerSuggestions.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        decoration: cardDecoration(color: AppColors.surfaceAlt),
                        child: Material(
                          color: Colors.transparent,
                          child: Column(
                            children: _customerSuggestions.map((customer) {
                              final name = '${customer['name'] ?? ''}'.trim();
                              return ListTile(
                                dense: true,
                                leading: Icon(Icons.person_outline, color: AppColors.accent),
                                title: Text(name.isEmpty ? t.customerLabel : name,
                                    style: const TextStyle(fontWeight: FontWeight.w700)),
                                subtitle: Text('${customer['phone'] ?? ''}'),
                                trailing: IconButton(
                                  tooltip: t.viewProfileTooltip,
                                  icon: const Icon(Icons.info_outline, size: 20),
                                  onPressed: () => _openCustomerProfile(customer),
                                ),
                                onTap: () => _pickCustomer(customer),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      key: const Key('booking_staff'),
                      initialValue: _stylist?['id']?.toString(),
                      decoration: InputDecoration(labelText: t.staffLabel),
                      items: stylists
                          .map((s) => DropdownMenuItem(value: s['id']?.toString(), child: Text(s['user']?['name'] ?? t.staffLabel)))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _stylist = firstOrNull(
                              stylists.where((s) => s['id']?.toString() == value).toList());
                          _resetSelectedServices();
                        });
                        _loadSlots();
                      },
                    ),
                    const SizedBox(height: 10),
                    InputDecorator(
                      decoration: InputDecoration(labelText: t.servicesLabel, border: const OutlineInputBorder()),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: services.map((service) {
                          final serviceId = '${service['id']}';
                          final selected = _selectedServiceIds.contains(serviceId);
                          return Material(
                            color: Colors.transparent,
                            child: CheckboxListTile(
                              key: Key('booking_service_name_${service['name']}'),
                              value: selected,
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor: AppColors.accent,
                              title: Text('${service['name']} · ${formatMoney((service['basePrice'] ?? 0) as int)}'),
                              onChanged: (value) {
                                setState(() {
                                  if (value == true) {
                                    _selectedServiceIds.add(serviceId);
                                  } else {
                                    _selectedServiceIds.remove(serviceId);
                                  }
                                });
                                _loadSlots();
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (_completed) ...[
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: cardDecoration(),
                        child: Row(
                          children: [
                            const Icon(Icons.schedule, size: 18, color: AppColors.inkMuted),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(t.recordedNowDate(formatFullDate(DateTime.now())),
                                  style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.inkMuted)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(t.paymentMethodLabel, style: const TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      SegmentedButton<String>(
                        key: const Key('booking_payment_method'),
                        segments: [
                          ButtonSegment(value: 'CASH', label: Text(t.paymentMethodCash)),
                          ButtonSegment(value: 'CARD', label: Text(t.paymentMethodCard)),
                          ButtonSegment(value: 'UPI', label: Text(t.paymentMethodUpi)),
                        ],
                        selected: {_paymentMethod},
                        showSelectedIcon: false,
                        onSelectionChanged: (sel) => setState(() => _paymentMethod = sel.first),
                      ),
                    ] else ...[
                      TextField(
                        key: const Key('booking_date'),
                        controller: _dateController,
                        decoration: InputDecoration(labelText: t.dateLabel, helperText: t.yyyymmddHint),
                        onChanged: (_) => _loadSlots(),
                      ),
                      const SizedBox(height: 12),
                      Text(t.availableSlots, style: const TextStyle(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      if (_loadingSlots)
                        const LinearProgressIndicator(minHeight: 3)
                      else if (_slotError != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_slotError!, style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 8),
                            OutlinedButton.icon(
                                onPressed: _loadSlots, icon: const Icon(Icons.refresh), label: Text(t.retry)),
                          ],
                        )
                      else
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _slots.asMap().entries.map((entry) {
                            final slot = entry.value;
                            final selected = _selectedSlot != null && slot.isAtSameMomentAs(_selectedSlot!);
                            return ChoiceChip(
                              key: Key('booking_slot_${entry.key}'),
                              selected: selected,
                              label: Text(formatTime(slot)),
                              selectedColor: AppColors.accent,
                              labelStyle: TextStyle(color: selected ? Colors.white : AppColors.inkMuted),
                              onSelected: (_) => setState(() => _selectedSlot = slot),
                            );
                          }).toList(),
                        ),
                    ],
                    if (_formError != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.dangerSoft,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          border: Border.all(color: AppColors.danger.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, color: AppColors.danger, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(_formError!,
                                  style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            // Sticky running-total footer so the total stays visible while
            // scrolling through services — matches the mocked design.
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 14),
                child: Column(
                  children: [
                    if (_selectedServices.isNotEmpty)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(AppRadius.md)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                '${t.completedServicesCount(_selectedServices.length)}${_stylist != null ? ' · ${_stylist!['user']?['name'] ?? ''}' : ''}',
                                style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                            Text(formatMoney(_selectedServicesTotal),
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
                          ],
                        ),
                      ),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _saving ? null : () => Navigator.pop(context),
                            child: Text(t.cancel),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: FilledButton(
                            key: const Key('booking_create'),
                            onPressed: _saving ? null : _save,
                            child: _saving
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                  )
                                : Text(_selectedServices.isEmpty
                                    ? t.saveBooking
                                    : t.saveBookingWithTotal(formatMoney(_selectedServicesTotal))),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
