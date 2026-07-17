import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/api.dart';
import '../core/format.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';

/// Add/edit a salon-wide catalog service (v4 Services tab). Distinct from
/// the per-stylist "add a service while adding staff" flow in
/// `add_staff_sheet.dart`/`staff_manage_sheet.dart`, but the two are now
/// reconciled via [staffRelations]: a service created here can optionally
/// be assigned to staff (or left unassigned — usable by any stylist as a
/// booking fallback, see `new_booking_sheet.dart`). Writes through the
/// `/api/v2/salons/:salonId/services` endpoints (see
/// `backend/src/routes/salon.routes.ts`), which accept a single `stylistId`
/// per row — the `Service` model has no many-to-many staff relation, each
/// row belongs to at most one stylist. So picking multiple staff while
/// *adding* a new service fans out into one row per selected stylist (same
/// name/price/duration, independently editable afterward); *editing* an
/// existing service stays single-select since it's editing one specific
/// row/assignment.
class ServiceSheet extends StatefulWidget {
  const ServiceSheet({
    super.key,
    required this.salonId,
    this.service,
    this.categories = const [],
    this.staffRelations = const [],
  });

  final String salonId;
  final Map<String, dynamic>? service;
  final List<String> categories;
  final List<Map<String, dynamic>> staffRelations;

  @override
  State<ServiceSheet> createState() => _ServiceSheetState();
}

class _ServiceSheetState extends State<ServiceSheet> {
  late final _nameController =
      TextEditingController(text: '${widget.service?['name'] ?? ''}');
  late final _categoryController =
      TextEditingController(text: '${widget.service?['category'] ?? (widget.categories.isNotEmpty ? widget.categories.first : 'Salon')}');
  late final _durationController =
      TextEditingController(text: '${widget.service?['duration'] ?? 45}');
  late final _priceController = TextEditingController(
      text: widget.service == null ? '' : (((widget.service!['basePrice'] ?? 0) as int) / 100).toStringAsFixed(0));

  late List<Map<String, dynamic>> _selectedStylists = _initialStylists();

  bool _saving = false;
  bool _deleting = false;
  String? _error;

  bool get _isEdit => widget.service != null;

  AppLocalizations get t => AppLocalizations.of(context)!;

  List<Map<String, dynamic>> get _stylists => widget.staffRelations
      .where((r) => r['status'] == 'ACTIVE')
      .map((r) => r['stylist'])
      .whereType<Map<String, dynamic>>()
      .toList();

  List<Map<String, dynamic>> _initialStylists() {
    final existingId = widget.service?['stylistId'] ?? widget.service?['stylist']?['id'];
    if (existingId == null) return [];
    final match = widget.staffRelations
        .map((r) => r['stylist'])
        .whereType<Map<String, dynamic>>()
        .where((s) => '${s['id']}' == '$existingId');
    return match.isEmpty ? [] : [match.first];
  }

  Future<void> _openStaffPicker() async {
    var tempSelected = List<Map<String, dynamic>>.from(_selectedStylists);
    final result = await showModalBottomSheet<List<Map<String, dynamic>>>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setSheetState) {
          void selectAny() => setSheetState(() => tempSelected = []);
          void toggle(Map<String, dynamic> stylist) => setSheetState(() {
                final already = tempSelected.any((s) => s['id'] == stylist['id']);
                if (_isEdit) {
                  tempSelected = already ? [] : [stylist];
                } else if (already) {
                  tempSelected = tempSelected.where((s) => s['id'] != stylist['id']).toList();
                } else {
                  tempSelected = [...tempSelected, stylist];
                }
              });

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(sheetContext).viewPadding.bottom),
              child: Container(
                margin: const EdgeInsets.all(12),
                constraints: BoxConstraints(maxHeight: MediaQuery.of(sheetContext).size.height * 0.7),
                decoration: cardDecoration(radius: AppRadius.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                      child: Text(t.assignToStaffLabel, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                    ),
                    Flexible(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          CheckboxListTile(
                            value: tempSelected.isEmpty,
                            onChanged: (_) => selectAny(),
                            title: Text(t.anyStaffOption),
                            activeColor: AppColors.accent,
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                          for (final stylist in _stylists)
                            CheckboxListTile(
                              value: tempSelected.any((s) => s['id'] == stylist['id']),
                              onChanged: (_) => toggle(stylist),
                              title: Text('${stylist['user']?['name'] ?? t.staffLabel}'),
                              activeColor: AppColors.accent,
                              controlAffinity: ListTileControlAffinity.leading,
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () => Navigator.of(sheetContext).pop(tempSelected),
                          child: Text(t.done),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
    if (result != null && mounted) setState(() => _selectedStylists = result);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _durationController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final category = _categoryController.text.trim();
    final duration = int.tryParse(_durationController.text.trim());
    final priceMajor = double.tryParse(_priceController.text.trim());

    if (name.length < 2 || category.isEmpty || duration == null || duration < 15 || priceMajor == null || priceMajor < 0) {
      setState(() => _error = t.fillServiceFields);
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final basePrice = (priceMajor * 100).round();
      if (_isEdit) {
        await api().patch('/api/v2/salons/${widget.salonId}/services/${widget.service!['id']}', data: {
          'name': name,
          'category': category,
          'duration': duration,
          'basePrice': basePrice,
          'stylistId': _selectedStylists.isEmpty ? null : _selectedStylists.first['id'],
        });
      } else if (_selectedStylists.isEmpty) {
        await api().post('/api/v2/salons/${widget.salonId}/services', data: {
          'name': name,
          'category': category,
          'duration': duration,
          'basePrice': basePrice,
          'stylistId': null,
        });
      } else {
        // Fan out: one row per selected stylist (see class doc — Service
        // has no many-to-many staff relation).
        await Future.wait(_selectedStylists.map((s) => api().post('/api/v2/salons/${widget.salonId}/services', data: {
              'name': name,
              'category': category,
              'duration': duration,
              'basePrice': basePrice,
              'stylistId': s['id'],
            })));
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (kDebugMode) debugPrint('Service save failed: $e');
      if (mounted) setState(() => _error = t.couldNotSaveService);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
    setState(() {
      _deleting = true;
      _error = null;
    });
    try {
      await api().delete('/api/v2/salons/${widget.salonId}/services/${widget.service!['id']}');
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (kDebugMode) debugPrint('Service delete failed: $e');
      if (mounted) setState(() => _error = t.couldNotSaveService);
    } finally {
      if (mounted) setState(() => _deleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 12, 20, 24 + MediaQuery.of(context).viewPadding.bottom),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              Text(_isEdit ? t.editServiceTitle : t.addServiceTitle, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: t.serviceNameLabel),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: t.categoryLabel),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _priceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(labelText: t.priceLabel, prefixText: '${CurrencyController.instance.symbol} '),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _durationController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: t.durationMinutesLabel),
                    ),
                  ),
                ],
              ),
              if (_stylists.isNotEmpty) ...[
                const SizedBox(height: 12),
                InkWell(
                  onTap: _openStaffPicker,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(AppRadius.md)),
                    child: Row(
                      children: [
                        const Icon(Icons.person_outline, color: AppColors.inkMuted, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(t.assignToStaffLabel, style: const TextStyle(color: AppColors.inkMuted, fontSize: 11)),
                              Text(
                                _selectedStylists.isEmpty
                                    ? t.anyStaffOption
                                    : _selectedStylists.map((s) => '${s['user']?['name'] ?? t.staffLabel}').join(', '),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down, color: AppColors.inkFaint),
                      ],
                    ),
                  ),
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 10),
                Text(_error!, style: const TextStyle(color: AppColors.danger, fontSize: 13, fontWeight: FontWeight.w600)),
              ],
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _saving || _deleting ? null : _save,
                  child: _saving
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text(_isEdit ? t.saveDetailsButton : t.addServiceTitle),
                ),
              ),
              if (_isEdit) ...[
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _saving || _deleting ? null : _delete,
                    style: OutlinedButton.styleFrom(foregroundColor: AppColors.danger, side: const BorderSide(color: Color(0xFFE8B4AC))),
                    child: _deleting
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : Text(t.deleteServiceButton),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
