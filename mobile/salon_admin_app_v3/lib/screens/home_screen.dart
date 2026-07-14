import 'package:flutter/material.dart';

import '../core/format.dart';
import '../l10n/app_localizations.dart';
import '../shell/dashboard_scope.dart';
import '../sheets/new_booking_sheet.dart';
import '../theme.dart';
import '../widgets/booking_widgets.dart';
import '../widgets/common.dart';

/// Home = a "today" briefing, not a stat wall. No schedule preview and no
/// "needs your response" queue here on purpose — the salon logs walk-ins
/// manually rather than taking advance bookings, so there's nothing to
/// "confirm" in the common case (see conversation: no pre-booking). The
/// rare pending/reschedule item still exists as a real feature — it surfaces
/// on the Bookings tab instead of competing for space here.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                            style: const TextStyle(color: AppColors.inkMuted, fontSize: 13)),
                        const SizedBox(height: 2),
                        Text('${salon['name'] ?? t.salonLabel}', style: Theme.of(context).textTheme.headlineSmall),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.accentSoft,
                    child: Icon(Icons.storefront, color: AppColors.accent, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              NewBookingButton(onPressed: () => _openNewBooking(context)),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: StatTile(label: t.statToday, value: '${data.todayCount}', helper: t.statLoggedHelper)),
                  const SizedBox(width: 10),
                  Expanded(child: StatTile(label: t.statRepeat, value: '${data.repeatCustomers}', helper: t.statBackHelper)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: StatTile(label: t.statToday, value: formatMoney(data.todayRevenue))),
                  const SizedBox(width: 10),
                  Expanded(child: StatTile(label: t.statWeek, value: formatMoney(data.weekRevenue))),
                  const SizedBox(width: 10),
                  Expanded(child: StatTile(label: t.statMonth, value: formatMoney(data.monthRevenue))),
                ],
              ),
              const SizedBox(height: 18),
              SectionTitle(title: t.loggedTodayHeading),
              const SizedBox(height: 10),
              if (logged.isEmpty)
                EmptyCard(text: t.nothingLoggedToday)
              else
                ...logged.map((b) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: BookingLogRow(booking: b),
                    )),
            ],
          ),
        ),
      ),
    );
  }
}
