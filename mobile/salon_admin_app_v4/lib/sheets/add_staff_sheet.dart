import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/api.dart';
import '../core/format.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';

class _NewService {
  _NewService(this.name, this.price);
  final String name;
  final double price; // whole currency units, not paise — converted on submit
}

/// Add staff sheet. Unlike v2's single "starter service", this collects a
/// list of services up front. The backend's `staff-setup` endpoint only
/// accepts one service at creation time (`serviceName`/`basePrice`), so this
/// sends the first service through that call, then adds any further
/// services with the existing `POST /stylists/:id/services` endpoint —
/// no backend change needed, just two calls chained client-side.
class AddStaffSheet extends StatefulWidget {
  const AddStaffSheet({super.key, required this.salon});

  final Map<String, dynamic> salon;

  @override
  State<AddStaffSheet> createState() => _AddStaffSheetState();
}

class _AddStaffSheetState extends State<AddStaffSheet> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _serviceNameController = TextEditingController();
  final _servicePriceController = TextEditingController();
  final _openController = TextEditingController(text: '09:00');
  final _closeController = TextEditingController(text: '18:00');
  final Set<int> _workDays = {1, 2, 3, 4, 5, 6};
  final List<_NewService> _services = [_NewService('Haircut', 499)];
  bool _saving = false;

  AppLocalizations get t => AppLocalizations.of(context)!;

  List<String> get _dayLabels =>
      [t.daySun, t.dayMon, t.dayTue, t.dayWed, t.dayThu, t.dayFri, t.daySat];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _serviceNameController.dispose();
    _servicePriceController.dispose();
    _openController.dispose();
    _closeController.dispose();
    super.dispose();
  }

  void _addServiceField() {
    final name = _serviceNameController.text.trim();
    final price = double.tryParse(_servicePriceController.text.trim());
    if (name.length < 2 || price == null || price < 1) {
      _show(t.enterServiceNamePrice);
      return;
    }
    setState(() {
      _services.add(_NewService(name, price));
      _serviceNameController.clear();
      _servicePriceController.clear();
    });
  }

  void _removeService(int index) => setState(() => _services.removeAt(index));

  void _show(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final open = _openController.text.trim();
    final close = _closeController.text.trim();
    final clock = RegExp(r'^([01]\d|2[0-3]):[0-5]\d$');

    if (name.length < 2 || phone.length < 6) {
      _show(t.fillStaffNamePhone);
      return;
    }
    if (_services.isEmpty) {
      _show(t.addAtLeastOneService);
      return;
    }
    if (!clock.hasMatch(open) || !clock.hasMatch(close)) {
      _show(t.enterValidOpenCloseTimes);
      return;
    }
    if (_workDays.isEmpty) {
      _show(t.selectAtLeastOneWorkingDay);
      return;
    }

    setState(() => _saving = true);
    try {
      final first = _services.first;
      final res = await api().post(
        '/api/v2/salons/${widget.salon['id']}/staff-setup',
        data: {
          'name': name,
          'phone': phone,
          'serviceName': first.name,
          'basePrice': (first.price * 100).round(),
          'startTime': open,
          'endTime': close,
          'days': (_workDays.toList()..sort()),
        },
      );

      final stylistId = res.data['id'];
      // Any services beyond the first go through the existing per-stylist
      // services endpoint, one call each.
      for (final extra in _services.skip(1)) {
        await api().post(
          '/api/v2/stylists/$stylistId/services',
          data: {'name': extra.name, 'category': 'Salon', 'duration': 60, 'basePrice': (extra.price * 100).round()},
        );
      }

      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 409) {
        _show(t.staffPhoneInUse);
      } else {
        if (kDebugMode) debugPrint('Staff setup failed: $e');
        _show(t.couldNotAddStaff);
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, 24, 12, viewInsets + 12 + MediaQuery.of(context).viewPadding.bottom),
        child: Container(
          decoration: cardDecoration(),
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.addStaff, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text(
                    t.addStaffSubtitle,
                    style: const TextStyle(color: AppColors.inkMuted, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    key: const Key('staff_setup_name'),
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    decoration:
                        InputDecoration(labelText: t.staffNameLabel, prefixIcon: const Icon(Icons.person_outline)),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    key: const Key('staff_setup_phone'),
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    decoration:
                        InputDecoration(labelText: t.staffPhoneLabel, prefixIcon: const Icon(Icons.phone_outlined)),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Text(t.servicesLabel, style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700)),
                      const Spacer(),
                      Text(t.servicesAddedCount(_services.length),
                          style: const TextStyle(color: AppColors.inkMuted, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  for (var i = 0; i < _services.length; i++) _serviceRow(i),
                  const SizedBox(height: 4),
                  _addServiceRow(),
                  const SizedBox(height: 18),
                  Text(t.workingHours, style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          key: const Key('staff_setup_open'),
                          controller: _openController,
                          decoration: InputDecoration(labelText: t.opens, hintText: t.hhmmHint),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          key: const Key('staff_setup_close'),
                          controller: _closeController,
                          decoration: InputDecoration(labelText: t.closes, hintText: t.hhmmHint),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(t.workingDays, style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (var i = 0; i < 7; i++)
                        FilterChip(
                          label: Text(_dayLabels[i]),
                          selected: _workDays.contains(i),
                          showCheckmark: false,
                          selectedColor: AppColors.accent,
                          labelStyle: TextStyle(
                            color: _workDays.contains(i) ? Colors.white : AppColors.inkMuted,
                            fontWeight: FontWeight.w600,
                          ),
                          onSelected: (on) => setState(() {
                            if (on) {
                              _workDays.add(i);
                            } else {
                              _workDays.remove(i);
                            }
                          }),
                        ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      key: const Key('staff_setup_submit'),
                      onPressed: _saving ? null : _submit,
                      icon: _saving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.check),
                      label: Text(_saving ? t.savingEllipsis : t.addStaff),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _serviceRow(int index) {
    final service = _services[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: cardDecoration(),
      child: Row(
        children: [
          Icon(Icons.content_cut, size: 16, color: AppColors.accent),
          const SizedBox(width: 8),
          Expanded(child: Text(service.name, style: const TextStyle(fontWeight: FontWeight.w600))),
          Text(formatMoney((service.price * 100).round()), style: const TextStyle(color: AppColors.inkMuted)),
          IconButton(
            icon: const Icon(Icons.close, size: 16),
            onPressed: () => _removeService(index),
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  Widget _addServiceRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: TextField(
              controller: _serviceNameController,
              decoration: InputDecoration(
                  hintText: t.serviceNameHint, border: InputBorder.none, isDense: true, filled: false),
            ),
          ),
          SizedBox(
            width: 72,
            child: TextField(
              controller: _servicePriceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
              decoration: InputDecoration(
                  hintText: t.priceHint, border: InputBorder.none, isDense: true, filled: false),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add_circle, color: AppColors.accent),
            onPressed: _addServiceField,
          ),
        ],
      ),
    );
  }
}
