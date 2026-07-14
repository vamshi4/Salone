import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/api.dart';
import '../core/format.dart';
import '../core/prefs.dart';
import '../l10n/app_localizations.dart';
import '../shell/dashboard_scope.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// Insights = the old Earnings and Retention screens merged into one tab
/// with a sub-toggle, instead of two unlabeled app-bar icons that pushed a
/// whole new screen. Same endpoints and business logic as v2's
/// `EarningsScreen` / `RetentionScreen`; cohort labels are plain English
/// ("Stopped coming" instead of "Churned") per product feedback.
class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  int _tab = 0; // 0 = earnings, 1 = retention

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final salon = DashboardScope.of(context).salon!;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(t.insightsTitle, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 12),
                  _SegTabs(index: _tab, onChanged: (i) => setState(() => _tab = i)),
                ],
              ),
            ),
            Expanded(
              child: _tab == 0 ? _EarningsTab(salon: salon) : _RetentionTab(salon: salon),
            ),
          ],
        ),
      ),
    );
  }
}

class _SegTabs extends StatelessWidget {
  const _SegTabs({required this.index, required this.onChanged});
  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    Widget seg(String label, int i) {
      final selected = index == i;
      return Expanded(
        child: GestureDetector(
          onTap: () => onChanged(i),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: selected ? AppColors.accent : Colors.transparent,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            alignment: Alignment.center,
            child: Text(label,
                style: TextStyle(
                    color: selected ? Colors.white : AppColors.inkMuted,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 13)),
          ),
        ),
      );
    }

    final t = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(AppRadius.md)),
      child: Row(children: [seg(t.tabEarnings, 0), seg(t.tabRetention, 1)]),
    );
  }
}

class _EarningsTab extends StatefulWidget {
  const _EarningsTab({required this.salon});
  final Map<String, dynamic> salon;

  @override
  State<_EarningsTab> createState() => _EarningsTabState();
}

class _EarningsTabState extends State<_EarningsTab> {
  String _period = 'day';
  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _data;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final id = widget.salon['id'];
      final res = await api().get('/api/v2/salons/$id/earnings?period=$_period');
      if (mounted) setState(() => _data = Map<String, dynamic>.from(res.data));
    } catch (e) {
      if (kDebugMode) debugPrint('Earnings load failed: $e');
      if (mounted) setState(() => _error = AppLocalizations.of(context)!.earningsLoadError);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _setPeriod(String p) {
    if (p == _period) return;
    setState(() => _period = p);
    _load();
  }

  String _periodLabel(AppLocalizations t) =>
      _period == 'day' ? t.periodToday : _period == 'week' ? t.periodLast7Days : t.periodLast30Days;

  String _vsPeriodLabel(AppLocalizations t) =>
      _period == 'day' ? t.vsYesterday : _period == 'week' ? t.vsLastWeek : t.vsLastMonth;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final total = (_data?['total'] ?? 0) as int;
    final count = (_data?['count'] ?? 0) as int;
    final previousTotal = (_data?['previousTotal'] ?? 0) as int;
    final daily = List<Map<String, dynamic>>.from(_data?['daily'] ?? []);
    final topServices = List<Map<String, dynamic>>.from(_data?['topServices'] ?? []);
    final byStylist = List<Map<String, dynamic>>.from(_data?['byStylist'] ?? []);
    final bookings = List<Map<String, dynamic>>.from(_data?['bookings'] ?? []);

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 24 + MediaQuery.of(context).padding.bottom),
        children: [
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
            const Padding(padding: EdgeInsets.only(top: 40), child: Center(child: CircularProgressIndicator()))
          else if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                children: [
                  Text(_error!, style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(onPressed: _load, icon: const Icon(Icons.refresh), label: Text(t.retry)),
                ],
              ),
            )
          else ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: const Color(0xFF085041), borderRadius: BorderRadius.circular(AppRadius.lg)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_periodLabel(t), style: const TextStyle(color: Color(0xFF9FE1CB), fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 6),
                  Text(formatMoney(total),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 34, letterSpacing: -0.5)),
                  const SizedBox(height: 4),
                  Text(t.completedServicesCount(count),
                      style: const TextStyle(color: Color(0xFF9FE1CB), fontWeight: FontWeight.w600)),
                  if (total > 0 || previousTotal > 0) ...[
                    const SizedBox(height: 8),
                    _ComparisonChip(total: total, previousTotal: previousTotal, label: _vsPeriodLabel(t), t: t),
                  ],
                ],
              ),
            ),
            if (_period != 'day' && daily.isNotEmpty) ...[
              const SizedBox(height: 20),
              _EarningsBars(daily: daily),
            ],
            if (topServices.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(t.topServicesHeading, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              const SizedBox(height: 8),
              ...topServices.map((s) => _RankedRow(
                    label: '${s['name'] ?? ''}',
                    sublabel: t.completedServicesCount((s['count'] ?? 0) as int),
                    value: formatMoney((s['total'] ?? 0) as int),
                  )),
            ],
            if (byStylist.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(t.byStaffHeading, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              const SizedBox(height: 8),
              ...byStylist.map((s) => _RankedRow(
                    label: '${s['name'] ?? ''}',
                    sublabel: t.completedServicesCount((s['count'] ?? 0) as int),
                    value: formatMoney((s['total'] ?? 0) as int),
                  )),
            ],
            const SizedBox(height: 20),
            Text(t.completedServicesHeading, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            const SizedBox(height: 8),
            if (bookings.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(t.noCompletedServices, style: const TextStyle(color: AppColors.inkMuted)),
              )
            else
              ...bookings.map((b) => _EarningRow(booking: b)),
          ],
        ],
      ),
    );
  }
}

class _EarningsBars extends StatelessWidget {
  const _EarningsBars({required this.daily});
  final List<Map<String, dynamic>> daily;

  @override
  Widget build(BuildContext context) {
    final maxVal = daily.fold<int>(1, (m, d) => ((d['total'] ?? 0) as int) > m ? (d['total'] ?? 0) as int : m);
    return SizedBox(
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: daily.map((d) {
          final value = (d['total'] ?? 0) as int;
          final ratio = maxVal == 0 ? 0.0 : value / maxVal;
          final dateStr = d['date'] as String?;
          final date = dateStr == null ? null : DateTime.tryParse(dateStr);
          final label = date == null ? '' : formatShortDate(date);
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 78 * ratio.clamp(0.03, 1.0),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(label, style: const TextStyle(fontSize: 10, color: AppColors.inkMuted)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// "Am I growing?" at a glance — the single most-requested thing missing
/// from a raw total shown in isolation.
class _ComparisonChip extends StatelessWidget {
  const _ComparisonChip({required this.total, required this.previousTotal, required this.label, required this.t});
  final int total;
  final int previousTotal;
  final String label;
  final AppLocalizations t;

  @override
  Widget build(BuildContext context) {
    final change = previousTotal > 0 ? ((total - previousTotal) / previousTotal * 100) : (total > 0 ? 100.0 : 0.0);
    final isUp = change >= 0;
    final color = isUp ? const Color(0xFF6FE3B4) : const Color(0xFFFFAFAF);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(isUp ? Icons.arrow_upward : Icons.arrow_downward, size: 14, color: color),
        const SizedBox(width: 2),
        Text(t.percentChangeLabel(change.abs().round(), label),
            style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12)),
      ],
    );
  }
}

/// Shared row style for the "Top services" / "By staff" leaderboards.
class _RankedRow extends StatelessWidget {
  const _RankedRow({required this.label, required this.sublabel, required this.value});
  final String label;
  final String sublabel;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: cardDecoration(),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                const SizedBox(height: 2),
                Text(sublabel, style: const TextStyle(fontSize: 11, color: AppColors.inkMuted)),
              ],
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _EarningRow extends StatelessWidget {
  const _EarningRow({required this.booking});
  final Map<String, dynamic> booking;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    // The earnings endpoint returns flat customerName/serviceName strings,
    // not nested customer/service objects — reading the nested path here
    // always missed and silently fell back to the generic placeholder text.
    final service = booking['serviceName'] ?? t.serviceLabel;
    final customer = booking['customerName'] ?? t.customerLabel;
    final price = (booking['price'] ?? 0) as int;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: cardDecoration(),
      child: Row(
        children: [
          Expanded(
            child: Text(t.customerServicePair(customer, service),
                overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          ),
          Text(formatMoney(price), style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _RetentionTab extends StatefulWidget {
  const _RetentionTab({required this.salon});
  final Map<String, dynamic> salon;

  @override
  State<_RetentionTab> createState() => _RetentionTabState();
}

class _RetentionTabState extends State<_RetentionTab> {
  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _data;
  List<Map<String, dynamic>> _atRisk = [];
  int _atRiskRevenue = 0;
  String? _selectedCohort;

  bool get _hasAccess {
    final plan = '${widget.salon['saasPlan'] ?? 'FREE'}'.toUpperCase();
    if (plan != 'FREE') return true;
    final created = DateTime.tryParse('${widget.salon['owner']?['createdAt'] ?? ''}');
    if (created == null) return true;
    final trialEnd = DateTime(created.year, created.month + 6, created.day);
    return DateTime.now().isBefore(trialEnd);
  }

  @override
  void initState() {
    super.initState();
    if (_hasAccess) {
      _load();
    } else {
      _loading = false;
    }
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final id = widget.salon['id'];
      final results = await Future.wait([
        api().get('/api/v2/salons/$id/retention'),
        api().get('/api/v2/salons/$id/at-risk'),
      ]);
      if (mounted) {
        setState(() {
          _data = Map<String, dynamic>.from(results[0].data);
          final risk = Map<String, dynamic>.from(results[1].data);
          _atRisk = List<Map<String, dynamic>>.from(risk['customers'] ?? []);
          _atRiskRevenue = (risk['atRiskRevenue'] ?? 0) as int;
        });
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Retention load failed: $e');
      if (mounted) setState(() => _error = AppLocalizations.of(context)!.retentionLoadError);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _remind(Map<String, dynamic> c) async {
    final t = AppLocalizations.of(context)!;
    final digits = '${c['phone'] ?? ''}'.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return;
    // Stored customer numbers are bare national-format (no country code —
    // see docs/GLOBAL-READINESS.md, "Store phone numbers in E.164"), so
    // prefix the SALON's own dial code rather than hardcoding India. Skip
    // the prefix if the number already appears to start with it, so a
    // manually-entered E.164 number doesn't get double-prefixed.
    final dialCode = countryByCode(widget.salon['countryCode'] as String?).dialCode.replaceAll('+', '');
    final intl = digits.startsWith(dialCode) ? digits : '$dialCode$digits';
    final name = '${c['name'] ?? t.customerLabel}';
    final salonName = '${widget.salon['name'] ?? t.salonLabel}';
    final text = Uri.encodeComponent(t.whatsappReminderMessage(name, salonName));
    final uri = Uri.parse('https://wa.me/$intl?text=$text');
    try {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.couldNotOpenWhatsapp)));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.couldNotOpenWhatsapp)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    if (!_hasAccess) return _upsell();
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!),
            const SizedBox(height: 12),
            FilledButton(onPressed: _load, child: Text(t.retry)),
          ],
        ),
      );
    }

    final data = _data!;
    final missed = List<Map<String, dynamic>>.from(data['missed'] ?? []);
    final slices = _cohortSlices();
    final total = slices.fold<int>(0, (t, s) => t + s.members.length);
    final selected = _selectedCohort == null ? null : slices.firstWhere((s) => s.key == _selectedCohort);

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 24 + MediaQuery.of(context).padding.bottom),
        children: [
          if (_atRisk.isNotEmpty) _atRiskSection(t),
          if (_reactivatedCount > 0) _winsSection(t),
          Text(t.customerCohortsHeading, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: _CohortDonut(
                  slices: slices,
                  selectedKey: _selectedCohort,
                  total: total,
                  onTap: (key) => setState(() => _selectedCohort = _selectedCohort == key ? null : key),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: slices
                      .map((s) => Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: _CohortLegendRow(
                              slice: s,
                              selected: _selectedCohort == s.key,
                              onTap: () => setState(() => _selectedCohort = _selectedCohort == s.key ? null : s.key),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
          if (selected != null) ...[
            const SizedBox(height: 14),
            Text(t.cohortMembersLabel(selected.label, selected.members.length),
                style: TextStyle(fontWeight: FontWeight.w700, color: selected.color)),
            const SizedBox(height: 8),
            if (selected.members.isEmpty)
              Text(t.noCohortCustomers(selected.label.toLowerCase()),
                  style: const TextStyle(color: AppColors.inkMuted))
            else
              ...selected.members.map((m) =>
                  _CohortMemberTile(customer: Map<String, dynamic>.from(m as Map), onRemind: _remind, showRemind: selected.key == 'churned')),
          ],
          const SizedBox(height: 20),
          Row(
            children: [
              Text(t.missedCustomersHeading, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              const SizedBox(width: 8),
              StatusPill(label: '${missed.length}'),
            ],
          ),
          const SizedBox(height: 4),
          Text(t.missedCustomersHint, style: const TextStyle(fontSize: 12, color: AppColors.inkMuted)),
          const SizedBox(height: 10),
          if (missed.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(t.noMissedCustomers),
            )
          else
            ...missed.take(10).map((m) => _CohortMemberTile(customer: m, onRemind: _remind, showRemind: true)),
        ],
      ),
    );
  }

  List<_CohortSlice> _cohortSlices() {
    final t = AppLocalizations.of(context)!;
    final cohorts = Map<String, dynamic>.from(_data?['cohorts'] ?? {});
    List<dynamic> m(String k) => List<dynamic>.from(cohorts[k] ?? []);
    return [
      _CohortSlice('retained', t.cohortRegulars, AppColors.accent, m('retained')),
      _CohortSlice('new', t.cohortNew, AppColors.success, m('new')),
      _CohortSlice('reactivated', t.cohortCameBack, AppColors.violet, m('reactivated')),
      _CohortSlice('churned', t.cohortStoppedComing, AppColors.danger, m('churned')),
    ];
  }

  int get _reactivatedCount {
    final summary = Map<String, dynamic>.from(_data?['summary'] ?? {});
    return (summary['reactivatedCustomers'] ?? 0) as int;
  }

  Widget _winsSection(AppLocalizations t) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.successSoft,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          const Icon(Icons.celebration_outlined, color: AppColors.success, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.reactivatedWinsTitle, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                const SizedBox(height: 2),
                Text(t.reactivatedSummary(_reactivatedCount),
                    style: const TextStyle(fontSize: 12, color: AppColors.inkMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _atRiskSection(AppLocalizations t) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accentSoft,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.notifications_active_outlined, color: AppColors.accent, size: 20),
              const SizedBox(width: 8),
              Text(t.reachOutNow, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 4),
          Text(t.atRiskSummary(_atRisk.length, formatMoney(_atRiskRevenue)),
              style: const TextStyle(fontSize: 13, color: AppColors.inkMuted)),
          const SizedBox(height: 10),
          ..._atRisk.take(2).map((c) => _atRiskTile(c, t)),
        ],
      ),
    );
  }

  Widget _atRiskTile(Map<String, dynamic> c, AppLocalizations t) {
    final cadence = c['cadenceDays'] ?? 0;
    final overdue = c['overdueDays'] ?? 0;
    final ratio = (c['overdueRatio'] ?? 1).toString();
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: cardDecoration(),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                        child: Text('${c['name'] ?? t.customerLabel}',
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14))),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(color: AppColors.dangerSoft, borderRadius: BorderRadius.circular(6)),
                      child: Text(t.overdueBadge(ratio),
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.danger)),
                    ),
                  ],
                ),
                Text(t.cadenceOverdue('$cadence', '$overdue'),
                    style: const TextStyle(fontSize: 12, color: AppColors.inkMuted)),
              ],
            ),
          ),
          FilledButton.icon(
            onPressed: () => _remind(c),
            style: FilledButton.styleFrom(backgroundColor: AppColors.whatsapp, padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
            icon: const Icon(Icons.chat, size: 16),
            label: Text(t.remind),
          ),
        ],
      ),
    );
  }

  Widget _upsell() {
    final t = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.workspace_premium_outlined, size: 56, color: AppColors.accent),
            const SizedBox(height: 16),
            Text(t.retentionProTitle,
                textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(
              t.retentionProBody,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.inkMuted),
            ),
            const SizedBox(height: 18),
            FilledButton(onPressed: () {}, child: Text(t.upgradeToPro)),
          ],
        ),
      ),
    );
  }
}

class _CohortSlice {
  _CohortSlice(this.key, this.label, this.color, this.members);
  final String key;
  final String label;
  final Color color;
  final List<dynamic> members;
}

class _CohortDonut extends StatelessWidget {
  const _CohortDonut({required this.slices, required this.selectedKey, required this.total, required this.onTap});
  final List<_CohortSlice> slices;
  final String? selectedKey;
  final int total;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final selected = selectedKey == null ? null : slices.firstWhere((s) => s.key == selectedKey);
    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          size: const Size(120, 120),
          painter: _DonutPainter(slices: slices, selectedKey: selectedKey),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${selected == null ? total : selected.members.length}',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: selected?.color ?? AppColors.ink)),
            Text(selected == null ? t.customersLabel : selected.label.toLowerCase(),
                style: const TextStyle(fontSize: 11, color: AppColors.inkMuted)),
          ],
        ),
      ],
    );
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter({required this.slices, required this.selectedKey});
  final List<_CohortSlice> slices;
  final String? selectedKey;

  @override
  void paint(Canvas canvas, Size size) {
    final total = slices.fold<int>(0, (t, s) => t + s.members.length);
    final rect = Rect.fromLTWH(0, 0, size.width, size.height).deflate(4);
    var start = -90.0;
    final safeTotal = total == 0 ? 1 : total;
    for (final s in slices) {
      final value = s.members.isEmpty ? 0.0001 : s.members.length.toDouble();
      final sweep = 360 * (value / safeTotal);
      final dimmed = selectedKey != null && selectedKey != s.key;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = selectedKey == s.key ? 20 : 16
        ..color = dimmed ? s.color.withValues(alpha: 0.25) : s.color;
      canvas.drawArc(rect, start * 3.1415926535 / 180, sweep * 3.1415926535 / 180, false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) =>
      oldDelegate.slices != slices || oldDelegate.selectedKey != selectedKey;
}

class _CohortLegendRow extends StatelessWidget {
  const _CohortLegendRow({required this.slice, required this.selected, required this.onTap});
  final _CohortSlice slice;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? slice.color.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Row(
          children: [
            Container(width: 10, height: 10, decoration: BoxDecoration(color: slice.color, shape: BoxShape.circle)),
            const SizedBox(width: 8),
            Expanded(child: Text(slice.label, style: const TextStyle(fontSize: 13, color: AppColors.inkMuted))),
            Text('${slice.members.length}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class _CohortMemberTile extends StatelessWidget {
  const _CohortMemberTile({required this.customer, required this.onRemind, required this.showRemind});
  final Map<String, dynamic> customer;
  final void Function(Map<String, dynamic>) onRemind;
  final bool showRemind;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: cardDecoration(),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${customer['name'] ?? t.customerLabel}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                const SizedBox(height: 2),
                Text(
                  t.visitsSpentSummary((customer['visits'] ?? 0) as int, formatMoney((customer['totalSpend'] ?? 0) as int)),
                  style: const TextStyle(fontSize: 12, color: AppColors.inkMuted),
                ),
              ],
            ),
          ),
          if (showRemind) ...[
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => onRemind(customer),
              icon: const Icon(Icons.chat, color: AppColors.whatsapp),
              tooltip: t.remindOnWhatsappTooltip,
            ),
          ],
        ],
      ),
    );
  }
}
