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
  const StaffManageSheet({super.key, required this.relation, required this.salonId});

  final Map<String, dynamic> relation;
  final String salonId;

  @override
  State<StaffManageSheet> createState() => _StaffManageSheetState();
}

class _StaffManageSheetState extends State<StaffManageSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  final _serviceNameController = TextEditingController();
  final _servicePriceController = TextEditingController();
  // Each day of the week is independently on/off with its own start/end —
  // replaces the old "pick days + one shared time range" flow, which made it
  // easy to accidentally apply the same hours to every selected day at once.
  final Map<int, bool> _dayEnabled = {for (final d in [0, 1, 2, 3, 4, 5, 6]) d: false};
  final Map<int, TimeOfDay> _dayStart = {for (final d in [0, 1, 2, 3, 4, 5, 6]) d: const TimeOfDay(hour: 9, minute: 0)};
  final Map<int, TimeOfDay> _dayEnd = {for (final d in [0, 1, 2, 3, 4, 5, 6]) d: const TimeOfDay(hour: 18, minute: 0)};
  final Map<int, String?> _dayRuleId = {};
  final Set<int> _savingDays = {};
  bool _savingProfile = false;
  bool _savingService = false;
  bool _loadingHours = true;
  bool _changed = false;
  late bool _active;
  bool _togglingActive = false;
  late List<Map<String, dynamic>> _services;
  late String _payType;
  late final TextEditingController _commissionRateController;
  late final TextEditingController _salaryController;

  Map<String, dynamic> get _stylist => Map<String, dynamic>.from(widget.relation['stylist'] ?? {});
  Map<String, dynamic> get _user => Map<String, dynamic>.from(_stylist['user'] ?? {});

  AppLocalizations get t => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: '${_user['name'] ?? ''}');
    _phoneController = TextEditingController(text: '${_user['phone'] ?? ''}');
    _active = widget.relation['status'] == 'ACTIVE';
    _services = List<Map<String, dynamic>>.from(_stylist['services'] ?? []);
    _payType = '${widget.relation['payType'] ?? 'COMMISSION'}';
    _commissionRateController = TextEditingController(text: '${widget.relation['commissionRate'] ?? 70}');
    final salaryMajor = ((widget.relation['salaryAmount'] ?? 0) as int) / 100;
    _salaryController = TextEditingController(
        text: salaryMajor == 0 ? '' : (salaryMajor == salaryMajor.roundToDouble() ? '${salaryMajor.round()}' : '$salaryMajor'));
    _loadAvailability();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _serviceNameController.dispose();
    _servicePriceController.dispose();
    _commissionRateController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  TimeOfDay? _parseTime(String? hhmm) {
    final match = RegExp(r'^(\d{1,2}):(\d{2})$').firstMatch('$hhmm');
    if (match == null) return null;
    final h = int.tryParse(match.group(1)!);
    final m = int.tryParse(match.group(2)!);
    if (h == null || m == null || h > 23 || m > 59) return null;
    return TimeOfDay(hour: h, minute: m);
  }

  String _formatTime(TimeOfDay t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

  Future<void> _loadAvailability() async {
    try {
      final res = await api().get('/api/v2/stylists/${_stylist['id']}/availability-rules');
      final rules = List<Map<String, dynamic>>.from(res.data);
      if (mounted) {
        setState(() {
          for (final day in _dayEnabled.keys) {
            _dayEnabled[day] = false;
            _dayRuleId[day] = null;
          }
          for (final rule in rules) {
            final day = rule['dayOfWeek'];
            if (day is! int || !_dayEnabled.containsKey(day)) continue;
            final start = _parseTime('${rule['startTime']}');
            final end = _parseTime('${rule['endTime']}');
            if (start == null || end == null) continue;
            _dayEnabled[day] = true;
            _dayStart[day] = start;
            _dayEnd[day] = end;
            _dayRuleId[day] = '${rule['id']}';
          }
        });
      }
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
    final commissionRate = int.tryParse(_commissionRateController.text.trim()) ?? 70;
    final salaryMajor = double.tryParse(_salaryController.text.trim()) ?? 0;

    setState(() => _savingProfile = true);
    try {
      await api().patch('/api/v2/stylists/${_stylist['id']}', data: {'name': name, 'phone': phone});
      await api().patch(
        '/api/v2/salons/${widget.salonId}/stylists/${_stylist['id']}',
        data: {
          'payType': _payType,
          'commissionRate': commissionRate.clamp(0, 100),
          'salaryAmount': (salaryMajor * 100).round(),
        },
      );
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

  Future<void> _toggleActive(bool value) async {
    final salonId = widget.salonId;
    setState(() {
      _active = value;
      _togglingActive = true;
    });
    try {
      await api().patch(
        '/api/v2/salons/$salonId/stylists/${_stylist['id']}',
        data: {'status': value ? 'ACTIVE' : 'TERMINATED'},
      );
      _changed = true;
    } catch (_) {
      if (mounted) setState(() => _active = !value); // revert on failure
      _show(t.couldNotUpdateStaff);
    } finally {
      if (mounted) setState(() => _togglingActive = false);
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

  /// Re-creates this day's rule from current _dayStart/_dayEnd/_dayEnabled
  /// state — deleting any existing rule first (the backend rejects
  /// overlapping windows for the same day, so replacing rather than
  /// patching-in-place avoids "old hours look stuck" failures). Called
  /// after every toggle or time-picker change so each day saves itself
  /// immediately, matching the auto-save pattern the Active switch above
  /// already uses.
  Future<void> _persistDay(int day) async {
    setState(() => _savingDays.add(day));
    try {
      final existingId = _dayRuleId[day];
      if (existingId != null) {
        await api().delete('/api/v2/stylists/${_stylist['id']}/availability/$existingId');
        _dayRuleId[day] = null;
      }
      if (_dayEnabled[day] == true) {
        final res = await api().post(
          '/api/v2/stylists/${_stylist['id']}/availability',
          data: {
            'dayOfWeek': day,
            'startTime': _formatTime(_dayStart[day]!),
            'endTime': _formatTime(_dayEnd[day]!),
          },
        );
        _dayRuleId[day] = '${res.data['id']}';
      }
      _changed = true;
    } catch (_) {
      _show(t.couldNotAddWorkingHours);
      await _loadAvailability(); // resync with server truth after a failed save
    } finally {
      if (mounted) setState(() => _savingDays.remove(day));
    }
  }

  Future<void> _toggleDay(int day, bool value) async {
    setState(() => _dayEnabled[day] = value);
    await _persistDay(day);
  }

  Future<void> _pickTime(int day, {required bool isStart}) async {
    final current = isStart ? _dayStart[day]! : _dayEnd[day]!;
    final picked = await showTimePicker(context: context, initialTime: current);
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _dayStart[day] = picked;
      } else {
        _dayEnd[day] = picked;
      }
    });
    await _persistDay(day);
  }

  void _show(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _timeChip(TimeOfDay time, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.pill),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(color: AppColors.accentSoft, borderRadius: BorderRadius.circular(AppRadius.pill)),
        child: Text(time.format(context),
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12, color: AppColors.accent)),
      ),
    );
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
                Row(
                  children: [
                    Expanded(
                      child: Text(t.staffActiveLabel, style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                    Switch(
                      key: const Key('staff_manage_active_toggle'),
                      value: _active,
                      onChanged: _togglingActive ? null : _toggleActive,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(t.payTypeLabel, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  key: const Key('staff_manage_pay_type'),
                  segments: [
                    ButtonSegment(value: 'COMMISSION', label: Text(t.payTypeCommission)),
                    ButtonSegment(value: 'SALARY', label: Text(t.payTypeSalary)),
                    ButtonSegment(value: 'BOTH', label: Text(t.payTypeBoth)),
                  ],
                  selected: {_payType},
                  showSelectedIcon: false,
                  onSelectionChanged: (s) => setState(() => _payType = s.first),
                ),
                const SizedBox(height: 12),
                if (_payType == 'COMMISSION' || _payType == 'BOTH')
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TextField(
                      key: const Key('staff_manage_commission_rate'),
                      controller: _commissionRateController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(labelText: t.commissionRateLabel, suffixText: '%'),
                    ),
                  ),
                if (_payType == 'SALARY' || _payType == 'BOTH')
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: TextField(
                      key: const Key('staff_manage_salary'),
                      controller: _salaryController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                      decoration: InputDecoration(
                        labelText: t.monthlySalaryLabel,
                        prefixText: '${CurrencyController.instance.symbol} ',
                      ),
                    ),
                  ),
                const SizedBox(height: 4),
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
                else
                  for (final day in [1, 2, 3, 4, 5, 6, 0])
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: cardDecoration(color: AppColors.surfaceAlt),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 40,
                              child: Text(_dayLabel(t, day), style: const TextStyle(fontWeight: FontWeight.w700)),
                            ),
                            Switch(
                              value: _dayEnabled[day] ?? false,
                              onChanged: _savingDays.contains(day) ? null : (v) => _toggleDay(day, v),
                            ),
                            Expanded(
                              child: (_dayEnabled[day] ?? false)
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        _timeChip(_dayStart[day]!, () => _pickTime(day, isStart: true)),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 6),
                                          child: Text('–', style: TextStyle(color: AppColors.inkMuted)),
                                        ),
                                        _timeChip(_dayEnd[day]!, () => _pickTime(day, isStart: false)),
                                      ],
                                    )
                                  : Text(t.dayOffLabel,
                                      textAlign: TextAlign.end,
                                      style: const TextStyle(color: AppColors.inkMuted, fontSize: 12)),
                            ),
                          ],
                        ),
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
