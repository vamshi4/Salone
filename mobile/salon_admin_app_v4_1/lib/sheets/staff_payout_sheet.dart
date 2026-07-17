import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/api.dart';
import '../core/format.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// A stylist's earnings + commission-payout view: period earnings (mirrors
/// Insights' earnings pattern), how much is currently unpaid (bookings with
/// no linked StylistPayout yet), a one-tap settle action, and payout
/// history. Separate from StaffManageSheet on purpose — editing staff config
/// and reviewing money owed are different mental modes, and ManageSheet is
/// already a long scroll (profile + services + hours).
class StaffPayoutSheet extends StatefulWidget {
  const StaffPayoutSheet({super.key, required this.stylistId, required this.stylistName, required this.salonId});

  final String stylistId;
  final String stylistName;
  final String salonId;

  @override
  State<StaffPayoutSheet> createState() => _StaffPayoutSheetState();
}

class _StaffPayoutSheetState extends State<StaffPayoutSheet> {
  String _period = 'month';
  bool _loading = true;
  bool _settling = false;
  bool _payingSalary = false;
  String? _error;
  Map<String, dynamic>? _earnings;
  List<Map<String, dynamic>> _payouts = [];

  AppLocalizations get t => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final salonId = widget.salonId;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait([
        api().get('/api/v2/salons/$salonId/stylists/${widget.stylistId}/earnings?period=$_period'),
        api().get('/api/v2/salons/$salonId/stylists/${widget.stylistId}/payouts'),
      ]);
      if (!mounted) return;
      setState(() {
        _earnings = Map<String, dynamic>.from(results[0].data as Map);
        _payouts = List<Map<String, dynamic>>.from(results[1].data as List);
      });
    } catch (e) {
      if (kDebugMode) debugPrint('Payout sheet load failed: $e');
      if (mounted) setState(() => _error = t.couldNotLoadPayouts);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _setPeriod(String p) {
    if (p == _period) return;
    setState(() => _period = p);
    _load();
  }

  Future<void> _markAsPaid() async {
    final salonId = widget.salonId;
    setState(() => _settling = true);
    try {
      await api().post(
        '/api/v2/salons/$salonId/stylists/${widget.stylistId}/payouts',
        data: {
          // Settles everything currently unpaid, not just the selected
          // display period — matches unpaidTotal, which is itself
          // intentionally not period-filtered.
          'periodStart': DateTime(2000).toUtc().toIso8601String(),
          'periodEnd': DateTime.now().toUtc().toIso8601String(),
        },
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.payoutSettled)));
      }
      await _load();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.couldNotMarkPaid)));
      }
    } finally {
      if (mounted) setState(() => _settling = false);
    }
  }

  Future<void> _paySalary() async {
    final salonId = widget.salonId;
    setState(() => _payingSalary = true);
    try {
      await api().post(
        '/api/v2/salons/$salonId/stylists/${widget.stylistId}/payouts',
        data: {'type': 'SALARY'},
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.salaryPaid)));
      }
      await _load();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.couldNotPaySalary)));
      }
    } finally {
      if (mounted) setState(() => _payingSalary = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final earnings = _earnings;
    final unpaidTotal = (earnings?['unpaidTotal'] ?? 0) as int;
    final unpaidCount = (earnings?['unpaidCount'] ?? 0) as int;
    final payType = '${earnings?['payType'] ?? 'COMMISSION'}';
    final salaryAmount = (earnings?['salaryAmount'] ?? 0) as int;
    final salaryPaidThisMonth = earnings?['salaryPaidThisMonth'] == true;
    final showCommission = payType == 'COMMISSION' || payType == 'BOTH';
    final showSalary = payType == 'SALARY' || payType == 'BOTH';

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
                  Text(widget.stylistName.isEmpty ? t.staffLabel : widget.stylistName,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Text(t.payoutsTitle, style: const TextStyle(fontSize: 13, color: AppColors.inkMuted)),
                  const SizedBox(height: 14),
                  SegmentedButton<String>(
                    segments: [
                      ButtonSegment(value: 'day', label: Text(t.periodToday)),
                      ButtonSegment(value: 'week', label: Text(t.periodWeek)),
                      ButtonSegment(value: 'month', label: Text(t.periodMonth)),
                    ],
                    selected: {_period},
                    showSelectedIcon: false,
                    onSelectionChanged: (s) => _setPeriod(s.first),
                  ),
                  const SizedBox(height: 16),
                  if (_loading)
                    const Padding(
                        padding: EdgeInsets.only(top: 30), child: Center(child: CircularProgressIndicator()))
                  else if (_error != null)
                    Text(_error!, style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.w700))
                  else ...[
                    Row(
                      children: [
                        Expanded(
                          child: StatTile(
                            label: t.grossRevenueLabel,
                            value: formatMoney((earnings?['grossRevenue'] ?? 0) as int),
                            accentColor: AppColors.inkMuted,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: StatTile(
                            label: t.totalPayoutLabel,
                            value: formatMoney((earnings?['totalPayout'] ?? 0) as int),
                            accentColor: AppColors.accent,
                          ),
                        ),
                      ],
                    ),
                    if (showCommission) ...[
                      const SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.accentSoft,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t.unpaidLabel,
                                style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.accent)),
                            const SizedBox(height: 4),
                            Text(formatMoney(unpaidTotal),
                                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 22)),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                key: const Key('staff_payout_mark_paid'),
                                onPressed: (unpaidCount == 0 || _settling) ? null : _markAsPaid,
                                child: _settling
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                    : Text(t.markAsPaidButton),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (showSalary) ...[
                      const SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: salaryPaidThisMonth ? AppColors.successSoft : AppColors.accentSoft,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t.salaryThisMonthLabel,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: salaryPaidThisMonth ? AppColors.success : AppColors.accent)),
                            const SizedBox(height: 4),
                            Text(formatMoney(salaryAmount),
                                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 22)),
                            const SizedBox(height: 12),
                            if (salaryPaidThisMonth)
                              StatusPill(label: t.salaryPaidStatus, color: AppColors.success, background: AppColors.surface)
                            else
                              SizedBox(
                                width: double.infinity,
                                child: FilledButton(
                                  key: const Key('staff_payout_pay_salary'),
                                  onPressed: (salaryAmount == 0 || _payingSalary) ? null : _paySalary,
                                  child: _payingSalary
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                      : Text(t.paySalaryButton),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 18),
                    SectionTitle(title: t.payoutHistoryHeading, trailing: '${_payouts.length}'),
                    const SizedBox(height: 8),
                    if (_payouts.isEmpty)
                      EmptyCard(text: t.noPayoutsYet)
                    else
                      for (final p in _payouts)
                        Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: cardDecoration(),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(formatFullDate(DateTime.parse('${p['paidAt']}').toLocal()),
                                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                                    Text(
                                        p['isSalaryPayout'] == true
                                            ? t.salaryThisMonthLabel
                                            : '${p['bookingCount']} bookings',
                                        style: const TextStyle(fontSize: 12, color: AppColors.inkMuted)),
                                  ],
                                ),
                              ),
                              Text(formatMoney((p['totalPayout'] ?? 0) as int),
                                  style: const TextStyle(fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
