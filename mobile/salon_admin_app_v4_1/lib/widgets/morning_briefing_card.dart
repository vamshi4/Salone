import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/api.dart';
import '../core/format.dart';
import '../l10n/app_localizations.dart';
import '../shell/dashboard_scope.dart';
import '../theme.dart';

/// "Here's your day" card at the top of Home: today's appointment count,
/// a pace bar against the owner's daily revenue goal (if they've set one —
/// see Account screen), and the top couple of at-risk customers worth
/// reaching out to today. `todayCount`/`todayRevenue` are already-computed
/// `DashboardData` getters; only the at-risk list needs its own small fetch,
/// since (like Insights) that data isn't part of the shared shell payload.
class MorningBriefingCard extends StatefulWidget {
  const MorningBriefingCard({super.key});

  @override
  State<MorningBriefingCard> createState() => _MorningBriefingCardState();
}

class _MorningBriefingCardState extends State<MorningBriefingCard> {
  bool _loading = true;
  List<Map<String, dynamic>> _atRisk = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final salon = DashboardScope.of(context).currentSalon;
    if (salon == null) {
      setState(() => _loading = false);
      return;
    }
    try {
      final res = await api().get('/api/v2/salons/${salon['id']}/at-risk');
      if (!mounted) return;
      final customers = List<Map<String, dynamic>>.from((res.data['customers'] ?? []) as List);
      setState(() => _atRisk = customers.take(2).toList());
    } catch (e) {
      if (kDebugMode) debugPrint('Morning briefing at-risk load failed: $e');
      // Informational card — a failure here just means the section is empty,
      // not worth a retry button or blocking the rest of Home.
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final data = DashboardScope.of(context);
    final salon = data.currentSalon;
    final goal = salon?['dailyRevenueGoal'];
    final hasGoal = goal is int && goal > 0;
    final pace = hasGoal ? (data.todayRevenue / goal).clamp(0.0, 1.0) : 0.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.morningBriefingHeading, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
          const SizedBox(height: 8),
          Text(
            t.todaysAppointmentsCount(data.todayCount),
            style: const TextStyle(fontSize: 13, color: AppColors.inkMuted, fontWeight: FontWeight.w600),
          ),
          if (hasGoal) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: pace,
                minHeight: 8,
                backgroundColor: AppColors.surfaceAlt,
                valueColor: AlwaysStoppedAnimation(AppColors.accent),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              t.revenueGoalPace(formatMoney(data.todayRevenue), formatMoney(goal)),
              style: const TextStyle(fontSize: 12, color: AppColors.inkMuted),
            ),
          ],
          if (!_loading && _atRisk.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 10),
            Text(t.worthReachingOutHeading,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.amber)),
            const SizedBox(height: 6),
            for (final c in _atRisk)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '${c['name'] ?? t.customerLabel} · ${t.overdueDaysCount((c['overdueDays'] ?? 0) as int)}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
