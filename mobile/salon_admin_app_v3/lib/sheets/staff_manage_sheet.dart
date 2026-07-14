import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/api.dart';
import '../core/format.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';

String _dayLabel(AppLocalizations t, dynamic dayOfWeek) {
  final labels = [t.daySun, t.dayMon, t.dayTue, t.dayWed, t.dayThu, t.dayFri, t.daySat];
  final i = dayOfWeek is int ? dayOfWeek : int.tryParse('$dayOfWeek') ?? -1;
  return i >= 0 && i < labels.length ? labels[i] : '?';
}

/// Manage an existing staff member: edit name/phone, add/edit/delete
/// services, add/remove weekly working hours. Ported from v2's
/// `_StaffManageSheet` — same endpoints, restyled to the new card language.
class StaffManageSheet extends StatefulWidget {
  const StaffManageSheet({super.key, required this.relation});

  final Map<String, dynamic> relation;

  @override
  State<StaffManageSheet> createState() => _StaffManageSheetState();
}

class _StaffManageSheetState extends State<StaffManageSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  final _serviceNameController = TextEditingController();
  final _servicePriceController = TextEditingController();
  final _hoursStartController = TextEditingController(text: '09:00');
  final _hoursEndController = TextEditingController(text: '18:00');
  Set<int> _hourDays = {1, 2, 3, 4, 5, 6};
  bool _savingProfile = false;
  bool _savingService = false;
  bool _savingHours = false;
  bool _loadingHours = true;
  List<Map<String, dynamic>> _availabilityRules = [];
  bool _changed = false;
  late List<Map<String, dynamic>> _services;

  Map<String, dynamic> get _stylist => Map<String, dynamic>.from(widget.relation['stylist'] ?? {});
  Map<String, dynamic> get _user => Map<String, dynamic>.from(_stylist['user'] ?? {});

  AppLocalizations get t => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: '${_user['name'] ?? ''}');
    _phoneController = TextEditingController(text: '${_user['phone'] ?? ''}');
    _services = List<Map<String, dynamic>>.from(_stylist['services'] ?? []);
    _loadAvailability();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _serviceNameController.dispose();
    _servicePriceController.dispose();
    _hoursStartController.dispose();
    _hoursEndController.dispose();
    super.dispose();
  }

  Future<void> _loadAvailability() async {
    try {
      final res = await api().get('/api/v2/stylists/${_stylist['id']}/availability-rules');
      if (mounted) setState(() => _availabilityRules = List<Map<String, dynamic>>.from(res.data));
    } catch (_) {
      // Keep sheet usable even if timings fail to load.
    } finally {
      if (mounted) setState(() => _loadingHours = false);
    }
  }

  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    if (name.length < 2 || phone.length < 6) {
      _show(t.enterValidStaffNamePhone);
      return;
    }
    setState(() => _savingProfile = true);
    try {
      await api().patch('/api/v2/stylists/${_stylist['id']}', data: {'name': name, 'phone': phone});
      _changed = true;
      _show(t.staffDetailsSaved);
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 409) {
        _show(t.phoneAlreadyInUse);
      } else {
        _show(t.couldNotUpdateStaff);
      }
    } finally {
      if (mounted) setState(() => _savingProfile = false);
    }
  }

  Future<void> _addService() async {
    final name = _serviceNameController.text.trim();
    final price = double.tryParse(_servicePriceController.text.trim());
    if (name.length < 2 || price == null || price < 1) {
      _show(t.enterServiceNameAndPriceShort);
      return;
    }
    setState(() => _savingService = true);
    try {
      final res = await api().post(
        '/api/v2/stylists/${_stylist['id']}/services',
        data: {'name': name, 'category': 'Salon', 'duration': 60, 'basePrice': (price * 100).round()},
      );
      if (mounted) {
        setState(() {
          _services.add(Map<String, dynamic>.from(res.data));
          _serviceNameController.clear();
          _servicePriceController.clear();
          _changed = true;
        });
      }
    } catch (_) {
      _show(t.couldNotAddService);
    } finally {
      if (mounted) setState(() => _savingService = false);
    }
  }

  Future<void> _editService(Map<String, dynamic> service) async {
    final saved = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _EditServiceSheet(service: service, stylistId: '${_stylist['id']}'),
    );
    if (saved != null && mounted) {
      setState(() {
        final index = _services.indexWhere((item) => '${item['id']}' == '${saved['id']}');
        if (index != -1) _services[index] = saved;
        _changed = true;
      });
    }
  }

  Future<void> _deleteService(Map<String, dynamic> service) async {
    try {
      await api().delete('/api/v2/stylists/${_stylist['id']}/services/${service['id']}');
      if (mounted) {
        setState(() {
          _services.removeWhere((item) => '${item['id']}' == '${service['id']}');
          _changed = true;
        });
      }
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 400) {
        _show('${e.response?.data?['error'] ?? t.couldNotRemoveServiceDefault}');
      } else {
        _show(t.couldNotRemoveServiceDefault);
      }
    }
  }

  Future<void> _saveHours() async {
    final startTime = _hoursStartController.text.trim();
    final endTime = _hoursEndController.text.trim();
    if (!_validClock(startTime) || !_validClock(endTime)) {
      _show(t.useHHmmWorkingHours);
      return;
    }
    if (_hourDays.isEmpty) {
      _show(t.selectAtLeastOneWorkingDay);
      return;
    }
    setState(() => _savingHours = true);
    try {
      // Replace existing rules only for the selected day(s) first: the
      // backend rejects overlapping availability windows for the same day,
      // so submitting new hours on top of old ones without clearing them
      // first always fails silently and the old hours look "stuck". Other
      // days' rules are left untouched so a single day can be edited
      // without resetting the rest of the week.
      final existingRuleIds = _availabilityRules
          .where((r) => r['dayOfWeek'] is int && _hourDays.contains(r['dayOfWeek'] as int))
          .map((r) => '${r['id']}')
          .toList();
      for (final ruleId in existingRuleIds) {
        await api().delete('/api/v2/stylists/${_stylist['id']}/availability/$ruleId');
      }
      for (final day in _hourDays) {
        await api().post(
          '/api/v2/stylists/${_stylist['id']}/availability',
          data: {'dayOfWeek': day, 'startTime': startTime, 'endTime': endTime},
        );
      }
      await _loadAvailability();
      _changed = true;
      _show(t.hoursAdded);
    } catch (_) {
      _show(t.couldNotAddWorkingHours);
    } finally {
      if (mounted) setState(() => _savingHours = false);
    }
  }

  /// Prefills the hours form from an existing rule so tapping a day's row
  /// lets you edit just that day instead of only being able to delete it.
  void _editHourRule(Map<String, dynamic> rule) {
    final day = rule['dayOfWeek'];
    if (day is! int) return;
    setState(() {
      _hourDays = {day};
      _hoursStartController.text = '${rule['startTime'] ?? '09:00'}';
      _hoursEndController.text = '${rule['endTime'] ?? '18:00'}';
    });
  }

  Future<void> _deleteAvailability(String availabilityId) async {
    try {
      await api().delete('/api/v2/stylists/${_stylist['id']}/availability/$availabilityId');
      _changed = true;
      await _loadAvailability();
    } catch (_) {
      _show(t.couldNotRemoveTiming);
    }
  }

  bool _validClock(String value) => RegExp(r'^\d{2}:\d{2}$').hasMatch(value);

  void _show(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, 24, 12, viewInsets + 12 + MediaQuery.of(context).viewPadding.bottom),
        child: Container(
          decoration: cardDecoration(),
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.88),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(t.manageStaffTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                    ),
                    TextButton(
                      key: const Key('staff_manage_done'),
                      onPressed: () => Navigator.of(context).pop(_changed),
                      child: Text(t.done),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  t.manageStaffSubtitle,
                  style: const TextStyle(color: AppColors.inkMuted, fontSize: 12, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                TextField(
                  key: const Key('staff_manage_name'),
                  controller: _nameController,
                  decoration: InputDecoration(labelText: t.staffNameLabel, prefixIcon: const Icon(Icons.person_outline)),
                ),
                const SizedBox(height: 12),
                TextField(
                  key: const Key('staff_manage_phone'),
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(labelText: t.staffPhoneLabel, prefixIcon: const Icon(Icons.phone_outlined)),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    key: const Key('staff_manage_save'),
                    onPressed: _savingProfile ? null : _saveProfile,
                    child: Text(_savingProfile ? t.savingEllipsis : t.saveStaffButton),
                  ),
                ),
                const SizedBox(height: 22),
                Text(t.servicesLabel, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                if (_services.isEmpty)
                  Text(t.noServicesYet, style: const TextStyle(color: AppColors.inkMuted, fontWeight: FontWeight.w600))
                else
                  ..._services.map(
                    (service) => Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: cardDecoration(color: AppColors.surfaceAlt),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text('${service['name']}', style: const TextStyle(fontWeight: FontWeight.w700)),
                          ),
                          Text(formatMoney((service['basePrice'] ?? 0) as int),
                              style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700)),
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                _editService(service);
                              } else if (value == 'delete') {
                                _deleteService(service);
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(value: 'edit', child: Text(t.edit)),
                              PopupMenuItem(value: 'delete', child: Text(t.delete)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        key: const Key('staff_manage_new_service_name'),
                        controller: _serviceNameController,
                        decoration: InputDecoration(labelText: t.newServiceLabel),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        key: const Key('staff_manage_new_service_price'),
                        controller: _servicePriceController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                        decoration: InputDecoration(labelText: t.priceHint),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    key: const Key('staff_manage_add_service'),
                    onPressed: _savingService ? null : _addService,
                    icon: const Icon(Icons.add),
                    label: Text(_savingService ? t.addingEllipsis : t.addServiceButton),
                  ),
                ),
                const SizedBox(height: 22),
                Text(t.workingHours, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                if (_loadingHours)
                  const LinearProgressIndicator(minHeight: 3)
                else if (_availabilityRules.isEmpty)
                  Text(t.noTimingsYet, style: const TextStyle(color: AppColors.inkMuted, fontWeight: FontWeight.w600))
                else
                  ..._availabilityRules.map(
                    (rule) => InkWell(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      onTap: () => _editHourRule(rule),
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: cardDecoration(color: AppColors.surfaceAlt),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text('${_dayLabel(t, rule['dayOfWeek'])}  ${rule['startTime']} - ${rule['endTime']}',
                                  style: const TextStyle(fontWeight: FontWeight.w700)),
                            ),
                            IconButton(
                              onPressed: () => _deleteAvailability('${rule['id']}'),
                              icon: const Icon(Icons.delete_outline),
                              tooltip: t.removeLabel,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
                Text(t.workingDays, style: const TextStyle(color: AppColors.inkMuted, fontSize: 12, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final day in [1, 2, 3, 4, 5, 6, 0])
                      FilterChip(
                        label: Text(_dayLabel(t, day)),
                        selected: _hourDays.contains(day),
                        showCheckmark: false,
                        selectedColor: AppColors.accent,
                        labelStyle: TextStyle(
                          color: _hourDays.contains(day) ? Colors.white : AppColors.inkMuted,
                          fontWeight: FontWeight.w600,
                        ),
                        onSelected: (on) => setState(() {
                          if (on) {
                            _hourDays.add(day);
                          } else {
                            _hourDays.remove(day);
                          }
                        }),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        key: const Key('staff_manage_hours_start'),
                        controller: _hoursStartController,
                        decoration: InputDecoration(labelText: t.startLabel, helperText: t.hhmmLowerHint),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        key: const Key('staff_manage_hours_end'),
                        controller: _hoursEndController,
                        decoration: InputDecoration(labelText: t.endLabel, helperText: t.hhmmLowerHint),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    key: const Key('staff_manage_add_hours'),
                    onPressed: _savingHours ? null : _saveHours,
                    icon: const Icon(Icons.schedule),
                    label: Text(_savingHours ? t.savingEllipsis : t.saveHoursButton),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Its own StatefulWidget (not an inline builder) so Flutter disposes
/// [_nameController]/[_priceController] at the correct point in the bottom
/// sheet's own element lifecycle. Disposing them manually right after the
/// `showModalBottomSheet` future resolves is too early — the sheet's closing
/// *animation* keeps rebuilding this content for another ~250ms after
/// `Navigator.pop`, and a TextField whose controller was already disposed
/// crashes with "A TextEditingController was used after being disposed."
class _EditServiceSheet extends StatefulWidget {
  const _EditServiceSheet({required this.service, required this.stylistId});

  final Map<String, dynamic> service;
  final String stylistId;

  @override
  State<_EditServiceSheet> createState() => _EditServiceSheetState();
}

class _EditServiceSheetState extends State<_EditServiceSheet> {
  late final _nameController = TextEditingController(text: '${widget.service['name'] ?? ''}');
  late final _priceController = TextEditingController(text: _initialPriceText);

  String get _initialPriceText {
    final value = ((widget.service['basePrice'] ?? 0) as int) / 100;
    return value == value.roundToDouble() ? '${value.round()}' : value.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _save(AppLocalizations t) async {
    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text.trim());
    if (name.length < 2 || price == null || price < 1) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.enterValidServiceNamePrice)));
      return;
    }
    try {
      final res = await api().patch(
        '/api/v2/stylists/${widget.stylistId}/services/${widget.service['id']}',
        data: {'name': name, 'basePrice': (price * 100).round()},
      );
      if (mounted) Navigator.of(context).pop(Map<String, dynamic>.from(res.data));
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.couldNotUpdateService)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;
    final t = AppLocalizations.of(context)!;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, 24, 12, viewInsets + 12 + MediaQuery.of(context).viewPadding.bottom),
        child: Container(
          decoration: cardDecoration(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.editServiceTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  decoration:
                      InputDecoration(labelText: t.serviceNameHint, prefixIcon: const Icon(Icons.content_cut_outlined)),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _priceController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                  decoration: InputDecoration(labelText: t.priceHint, prefixIcon: const Icon(Icons.payments_outlined)),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => _save(t),
                    child: Text(t.saveServiceButton),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
