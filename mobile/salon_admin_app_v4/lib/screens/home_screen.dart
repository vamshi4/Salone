import 'package:flutter/material.dart';

import '../core/format.dart';
import '../l10n/app_localizations.dart';
import '../shell/dashboard_scope.dart';
import '../sheets/add_staff_sheet.dart';
import '../sheets/new_booking_sheet.dart';
import '../sheets/service_sheet.dart';
import '../theme.dart';
import '../widgets/booking_widgets.dart';
import '../widgets/common.dart';

/// Home = a "today" briefing, not a stat wall. No schedule preview and no
/// "needs your response" queue here on purpose — the salon logs walk-ins
/// manually rather than taking advance bookings, so there's nothing to
/// "confirm" in the common case (see conversation: no pre-booking). The
/// rare pending/reschedule item still exists as a real feature — it surfaces
/// on the Bookings tab instead of competing for space here.
///
/// v4: Account moved out of the bottom-nav tab bar (see `shell/root_shell.dart`)
/// — [onOpenAccount] wires the header avatar button to push it as a route,
/// matching the "Open Design" prototype's IA.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.onOpenAccount});

  final VoidCallback onOpenAccount;

  Future<void> _openNewBooking(BuildContext context) async {
    final data = DashboardScope.of(context);
    final salon = data.salon;
    if (salon == null || data.staffRelations.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.addStaffBeforeBookings)));
      return;
    }
    final created = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NewBookingSheet(salon: salon, staffRelations: data.staffRelations),
    );
    if (created == true) await data.load();
  }

  Future<void> _openAddStaff(BuildContext context) async {
    final data = DashboardScope.of(context);
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

  Future<void> _openAddService(BuildContext context) async {
    final data = DashboardScope.of(context);
    final salon = data.salon;
    if (salon == null) return;
    final categories = List<Map<String, dynamic>>.from(salon['services'] ?? [])
        .map((s) => '${s['category']}')
        .toSet()
        .toList();
    final created = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ServiceSheet(salonId: '${salon['id']}', categories: categories, staffRelations: data.staffRelations),
    );
    if (created == true) await data.load();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final data = DashboardScope.of(context);
    final salon = data.salon!;
    final logged = data.loggedToday;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: data.load,
          child: ListView(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 24 + MediaQuery.of(context).padding.bottom),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(formatFullDate(DateTime.now()),
                            style: const TextStyle(color: AppColors.inkMuted, fontSize: 13, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 2),
                        Text('${salon['name'] ?? t.salonLabel}', style: Theme.of(context).textTheme.headlineSmall),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: onOpenAccount,
                    borderRadius: BorderRadius.circular(999),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.accent,
                      child: Text(
                        '${salon['name'] ?? t.salonLabel}'.trim().isEmpty
                            ? '?'
                            : '${salon['name']}'.trim().substring(0, 1).toUpperCase(),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              NewBookingButton(onPressed: () => _openNewBooking(context)),
              const SizedBox(height: 14),
              SizedBox(
                height: 84,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    QuickAction(icon: Icons.person_add_alt_1_outlined, label: t.addStaff, onTap: () => _openAddStaff(context)),
                    const SizedBox(width: 10),
                    QuickAction(icon: Icons.design_services_outlined, label: t.addServiceTitle, onTap: () => _openAddService(context)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: StatTile(
                      label: t.statToday,
                      value: '${data.todayCount}',
                      helper: t.statLoggedHelper,
                      accentColor: AppColors.accent,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatTile(
                      label: t.statToday,
                      value: formatMoney(data.todayRevenue),
                      accentColor: AppColors.success,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: StatTile(
                      label: t.statRepeat,
                      value: '${data.repeatCustomers}',
                      helper: t.statBackHelper,
                      accentColor: AppColors.amber,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              SectionTitle(title: t.loggedTodayHeading),
              const SizedBox(height: 10),
              if (logged.isEmpty)
                EmptyCard(text: t.nothingLoggedToday)
              else
                for (var i = 0; i < logged.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: EntranceFade(index: i, child: BookingLogRow(booking: logged[i])),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
