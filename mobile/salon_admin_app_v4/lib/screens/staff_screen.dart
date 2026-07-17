import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/helpers.dart';
import '../l10n/app_localizations.dart';
import '../shell/dashboard_data.dart';
import '../shell/dashboard_scope.dart';
import '../sheets/add_staff_sheet.dart';
import '../sheets/staff_manage_sheet.dart';
import '../theme.dart';
import '../widgets/common.dart';

String _initial(String name) => name.trim().isEmpty ? '?' : name.trim().substring(0, 1).toUpperCase();

class StaffScreen extends StatelessWidget {
  const StaffScreen({super.key});

  Future<void> _openAddStaff(BuildContext context, DashboardData data) async {
    final salon = data.salon;
    if (salon == null) return;
    final created = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddStaffSheet(salon: salon),
    );
    if (created == true) await data.load();
  }

  Future<void> _openManageStaff(BuildContext context, DashboardData data, Map<String, dynamic> relation) async {
    final updated = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StaffManageSheet(relation: relation),
    );
    if (updated == true) await data.load();
  }

  ({int count, int revenue}) _todayTallyFor(DashboardData data, String stylistId) {
    final now = DateTime.now();
    final todays = data.bookings.where((b) {
      if (b['status'] != 'COMPLETED') return false;
      if ('${b['stylist']?['id']}' != stylistId) return false;
      return isSameDay(effectiveBookingTime(b), now);
    });
    final revenue = todays.fold<int>(0, (sum, b) => sum + ((b['price'] ?? 0) as int));
    return (count: todays.length, revenue: revenue);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final data = DashboardScope.of(context);
    final relations = data.staffRelations;
    final activeCount = relations.where((r) => r['status'] == 'ACTIVE').length;
    final todayTotal = relations.fold<int>(0, (sum, r) {
      final stylist = r['stylist'];
      if (stylist == null) return sum;
      return sum + _todayTallyFor(data, '${stylist['id']}').revenue;
    });

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: data.load,
          child: ListView(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 24 + MediaQuery.of(context).padding.bottom),
            children: [
              Row(
                children: [
                  Expanded(child: Text(t.staffTitle, style: Theme.of(context).textTheme.headlineSmall)),
                  FilledButton.icon(
                    key: const Key('staff_add_button'),
                    onPressed: () => _openAddStaff(context, data),
                    icon: const Icon(Icons.person_add_alt_1, size: 18),
                    label: Text(t.addStaff),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: StatTile(label: t.staffLabel, value: '${relations.length}')),
                  const SizedBox(width: 10),
                  Expanded(child: StatTile(label: t.statActive, value: '$activeCount')),
                  const SizedBox(width: 10),
                  Expanded(child: StatTile(label: t.statTodaysTotal, value: formatMoney(todayTotal))),
                ],
              ),
              const SizedBox(height: 16),
              if (relations.isEmpty)
                EmptyCard(
                  text: t.noActiveStaffYet,
                  actionLabel: t.addFirstStaff,
                  actionKey: const Key('staff_empty_add_button'),
                  onAction: () => _openAddStaff(context, data),
                )
              else
                ...relations.map((relation) {
                  final stylist = relation['stylist'] as Map<String, dynamic>?;
                  final services = List<Map<String, dynamic>>.from(stylist?['services'] ?? []);
                  final serviceNames = services.map((s) => '${s['name']}').join(' · ');
                  final tally = stylist == null
                      ? (count: 0, revenue: 0)
                      : _todayTallyFor(data, '${stylist['id']}');
                  final isActive = relation['status'] == 'ACTIVE';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Opacity(
                      opacity: isActive ? 1 : 0.6,
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: cardDecoration(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: AppColors.accentSoft,
                                  child: Text(
                                    _initial('${stylist?['user']?['name'] ?? '?'}'),
                                    style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${stylist?['user']?['name'] ?? t.staffLabel}',
                                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                                      Text(
                                        isActive
                                            ? (serviceNames.isEmpty ? t.noServicesYet : serviceNames)
                                            : t.notActive,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(color: AppColors.inkMuted, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => _openManageStaff(context, data, relation),
                                  icon: const Icon(Icons.more_horiz),
                                ),
                              ],
                            ),
                            if (isActive) ...[
                              const Divider(height: 24),
                              Row(
                                children: [
                                  Text(t.today, style: const TextStyle(color: AppColors.inkMuted, fontSize: 11)),
                                  const SizedBox(width: 8),
                                  Text(t.staffTodayTally(tally.count, formatMoney(tally.revenue)),
                                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(t.canSetOwnPrice, style: const TextStyle(fontSize: 13)),
                                  ),
                                  Switch(
                                    value: relation['canSetOwnPrice'] == true,
                                    onChanged: data.saving
                                        ? null
                                        : (v) => data.toggleCanSetOwnPrice(relation, v),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}
