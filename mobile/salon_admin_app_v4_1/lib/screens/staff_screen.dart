import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/helpers.dart';
import '../l10n/app_localizations.dart';
import '../shell/dashboard_data.dart';
import '../shell/dashboard_scope.dart';
import '../sheets/add_staff_sheet.dart';
import '../sheets/staff_manage_sheet.dart';
import '../sheets/staff_payout_sheet.dart';
import '../theme.dart';
import '../widgets/common.dart';

String _initial(String name) => name.trim().isEmpty ? '?' : name.trim().substring(0, 1).toUpperCase();

class StaffScreen extends StatefulWidget {
  const StaffScreen({super.key});

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  String _query = '';
  String _filter = 'all'; // all | active | inactive

  Future<void> _openAddStaff(BuildContext context, DashboardData data) async {
    if (data.viewingAllBranches) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.pickBranchFirst)));
      return;
    }
    final salon = data.currentSalon;
    if (salon == null) return;
    final created = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddStaffSheet(salon: salon),
    );
    if (created == true) await data.load();
  }

  /// Resolves the specific salon a (possibly merged, all-branches) staff
  /// relation belongs to via its `_branchId` tag — falls back to
  /// currentSalon for the normal single-branch case.
  Map<String, dynamic>? _resolveRelationSalon(DashboardData data, Map<String, dynamic> relation) {
    final branchId = relation['_branchId'];
    if (branchId == null) return data.currentSalon;
    for (final s in data.salons) {
      if ('${s['id']}' == '$branchId') return s;
    }
    return null;
  }

  Future<void> _openManageStaff(BuildContext context, DashboardData data, Map<String, dynamic> relation) async {
    final salon = _resolveRelationSalon(data, relation);
    if (salon == null) return;
    final updated = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StaffManageSheet(relation: relation, salonId: '${salon['id']}'),
    );
    if (updated == true) await data.load();
  }

  void _openPayouts(BuildContext context, DashboardData data, Map<String, dynamic> relation) {
    final stylist = relation['stylist'] as Map<String, dynamic>?;
    final salon = _resolveRelationSalon(data, relation);
    if (stylist == null || salon == null) return;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StaffPayoutSheet(
        stylistId: '${stylist['id']}',
        stylistName: '${stylist['user']?['name'] ?? ''}',
        salonId: '${salon['id']}',
      ),
    );
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

    final filtered = relations.where((r) {
      final matchesFilter = switch (_filter) {
        'active' => r['status'] == 'ACTIVE',
        'inactive' => r['status'] != 'ACTIVE',
        _ => true,
      };
      if (!matchesFilter) return false;
      if (_query.trim().isEmpty) return true;
      final q = _query.trim().toLowerCase();
      final stylist = r['stylist'] as Map<String, dynamic>?;
      final name = '${stylist?['user']?['name'] ?? ''}'.toLowerCase();
      final phone = '${stylist?['user']?['phone'] ?? ''}';
      return name.contains(q) || phone.contains(q);
    }).toList();

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
              if (relations.isNotEmpty) ...[
                const SizedBox(height: 14),
                TextField(
                  key: const Key('staff_search_field'),
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: t.searchStaffHint,
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _chip(t.filterAllCategories, _filter == 'all', () => setState(() => _filter = 'all')),
                      const SizedBox(width: 8),
                      _chip(t.filterActiveStaff, _filter == 'active', () => setState(() => _filter = 'active')),
                      const SizedBox(width: 8),
                      _chip(t.filterInactiveStaff, _filter == 'inactive', () => setState(() => _filter = 'inactive')),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),
              if (relations.isEmpty)
                EmptyCard(
                  text: t.noActiveStaffYet,
                  actionLabel: t.addFirstStaff,
                  actionKey: const Key('staff_empty_add_button'),
                  onAction: () => _openAddStaff(context, data),
                )
              else if (filtered.isEmpty)
                EmptyCard(text: t.noActiveStaffYet)
              else
                ...filtered.map((relation) {
                  final stylist = relation['stylist'] as Map<String, dynamic>?;
                  final services = List<Map<String, dynamic>>.from(stylist?['services'] ?? []);
                  final serviceNames = services.map((s) => '${s['name']}').join(' · ');
                  final tally = stylist == null
                      ? (count: 0, revenue: 0)
                      : _todayTallyFor(data, '${stylist['id']}');
                  final isActive = relation['status'] == 'ACTIVE';
                  final branchName = relation['_branchName'] as String?;

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
                                        [
                                          if (branchName != null) branchName,
                                          if (isActive)
                                            (serviceNames.isEmpty ? t.noServicesYet : serviceNames)
                                          else
                                            t.notActive,
                                        ].join(' · '),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(color: AppColors.inkMuted, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  key: const Key('staff_payouts_button'),
                                  tooltip: t.payoutsTooltip,
                                  onPressed: () => _openPayouts(context, data, relation),
                                  icon: const Icon(Icons.payments_outlined),
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
                              // canSetOwnPrice/canCancelBooking toggles are hidden until
                              // there's a stylist-facing app for them to actually matter —
                              // the schema/backend/enforcement stay in place, this is UI-only.
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

  Widget _chip(String label, bool selected, VoidCallback onTap) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      showCheckmark: false,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.accent,
      backgroundColor: AppColors.surface,
      labelStyle: TextStyle(
        color: selected ? Colors.white : AppColors.inkMuted,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
