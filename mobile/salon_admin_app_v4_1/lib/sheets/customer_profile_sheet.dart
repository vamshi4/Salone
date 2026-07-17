import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/api.dart';
import '../core/format.dart';
import '../core/helpers.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';
import '../widgets/booking_widgets.dart';
import '../widgets/common.dart';

/// A customer's history at this salon: visit count, total spend, last
/// service, and the full booking history — computed entirely client-side
/// from bookings the shell already loaded (no new "list this customer's
/// bookings" endpoint needed). Also the first home for editing the
/// salon-owned notes/tags on this customer (`SalonCustomer`), an endpoint
/// that already existed with no Flutter UI consuming it.
class CustomerProfileSheet extends StatefulWidget {
  const CustomerProfileSheet({
    super.key,
    required this.salonId,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.allBookings,
  });

  final String salonId;
  final String customerId;
  final String customerName;
  final String customerPhone;

  /// The salon's full booking list (e.g. `DashboardData.bookings`) — filtered
  /// to this customer inside the sheet.
  final List<Map<String, dynamic>> allBookings;

  @override
  State<CustomerProfileSheet> createState() => _CustomerProfileSheetState();
}

class _CustomerProfileSheetState extends State<CustomerProfileSheet> {
  final _notesController = TextEditingController();
  final _tagInputController = TextEditingController();
  List<String> _tags = [];
  bool _loading = true;
  bool _saving = false;
  String? _error;

  AppLocalizations get t => AppLocalizations.of(context)!;

  List<Map<String, dynamic>> get _customerBookings => widget.allBookings
      .where((b) => customerKey(b) == widget.customerId)
      .toList()
    ..sort((a, b) => effectiveBookingTime(b).compareTo(effectiveBookingTime(a)));

  List<Map<String, dynamic>> get _completedBookings =>
      _customerBookings.where((b) => b['status'] == 'COMPLETED').toList();

  int get _visitCount => _completedBookings.length;

  int get _totalSpend =>
      _completedBookings.fold<int>(0, (sum, b) => sum + ((b['price'] ?? 0) as int));

  Map<String, dynamic>? get _lastCompleted =>
      _completedBookings.isEmpty ? null : _completedBookings.first;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _notesController.dispose();
    _tagInputController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final res = await api()
          .get('/api/v2/salons/${widget.salonId}/customers/${widget.customerId}');
      if (!mounted) return;
      final data = res.data as Map;
      setState(() {
        _notesController.text = '${data['notes'] ?? ''}';
        _tags = List<String>.from((data['tags'] ?? []) as List);
      });
    } catch (e) {
      if (kDebugMode) debugPrint('Load customer profile failed: $e');
      if (mounted) setState(() => _error = t.couldNotLoadCustomerProfile);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _save() async {
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await api().patch(
        '/api/v2/salons/${widget.salonId}/customers/${widget.customerId}',
        data: {'notes': _notesController.text.trim(), 'tags': _tags},
      );
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(t.notesSaved)));
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Save customer profile failed: $e');
      if (mounted) setState(() => _error = t.couldNotSaveNotes);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _addTag() {
    final tag = _tagInputController.text.trim();
    if (tag.isEmpty || _tags.contains(tag)) return;
    setState(() {
      _tags = [..._tags, tag];
      _tagInputController.clear();
    });
  }

  void _removeTag(String tag) {
    setState(() => _tags = _tags.where((existing) => existing != tag).toList());
  }

  @override
  Widget build(BuildContext context) {
    final history = _customerBookings;
    final last = _lastCompleted;

    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.08),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
                width: 36,
                height: 4,
                decoration:
                    BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(999))),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(18, 12, 18, 18 + MediaQuery.of(context).padding.bottom),
                children: [
                  Text(widget.customerName.isEmpty ? t.customerLabel : widget.customerName,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Text(widget.customerPhone,
                      style: const TextStyle(fontSize: 13, color: AppColors.inkMuted)),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: StatTile(
                          label: t.statsVisitsLabel,
                          value: '$_visitCount',
                          accentColor: AppColors.accent,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: StatTile(
                          label: t.statsTotalSpentLabel,
                          value: formatMoney(_totalSpend),
                          accentColor: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                  if (last != null) ...[
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: cardDecoration(),
                      child: Row(
                        children: [
                          const Icon(Icons.history, size: 18, color: AppColors.inkMuted),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              t.lastServiceSummary(
                                bookingServiceSummary(last, t),
                                formatFullDate(effectiveBookingTime(last)),
                              ),
                              style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.inkMuted),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 18),
                  Text(t.notesLabel, style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _notesController,
                    maxLines: 3,
                    enabled: !_loading,
                    decoration: InputDecoration(hintText: t.notesHint),
                  ),
                  const SizedBox(height: 12),
                  Text(t.tagsLabel, style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final tag in _tags)
                        Chip(
                          label: Text(tag),
                          onDeleted: () => _removeTag(tag),
                          backgroundColor: AppColors.accentSoft,
                          labelStyle: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w600),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _tagInputController,
                          enabled: !_loading,
                          decoration: InputDecoration(hintText: t.addTagHint),
                          onSubmitted: (_) => _addTag(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: _addTag,
                        icon: Icon(Icons.add_circle, color: AppColors.accent),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: (_loading || _saving) ? null : _save,
                      child: _saving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : Text(t.saveNotesButton),
                    ),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 8),
                    Text(_error!, style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.w600)),
                  ],
                  const SizedBox(height: 18),
                  SectionTitle(title: t.visitHistoryHeading, trailing: '${history.length}'),
                  const SizedBox(height: 8),
                  if (history.isEmpty)
                    EmptyCard(text: t.noVisitsYet)
                  else
                    for (final b in history)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: BookingLogRow(booking: b),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
