import 'package:flutter/material.dart';

import '../core/format.dart';
import '../core/helpers.dart';
import '../l10n/app_localizations.dart';
import '../shell/dashboard_data.dart';
import '../shell/dashboard_scope.dart';
import '../sheets/customer_profile_sheet.dart';
import '../sheets/new_booking_sheet.dart';
import '../theme.dart';
import '../widgets/booking_widgets.dart';
import '../widgets/common.dart';

/// The full booking log: a "needs action" banner up top for the rare
/// pending/reschedule item (see Home for why that's not the main focus),
/// then everything grouped by day with a search box and staff/period
/// filters, day totals, and a repeat-customer tag.
class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  String _query = '';
  String? _staffId; // null = all staff
  int _periodDays = 7; // 7 = this week, 0 = all time

  Future<void> _openNewBooking(BuildContext context, DashboardData data) async {
    if (data.viewingAllBranches) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.pickBranchFirst)));
      return;
    }
    final salon = data.currentSalon;
    if (salon == null || data.staffRelations.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.addStaffBeforeBookings)));
      return;
    }
    final created = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          NewBookingSheet(salon: salon, staffRelations: data.staffRelations, allBookings: data.bookings),
    );
    if (created == true) await data.load();
  }

  /// Resolves the specific salon a (possibly merged, all-branches) booking
  /// belongs to via its `_branchId` tag — falls back to currentSalon for the
  /// normal single-branch case, where bookings aren't tagged at all.
  Map<String, dynamic>? _resolveBookingSalon(DashboardData data, Map<String, dynamic> booking) {
    final branchId = booking['_branchId'];
    if (branchId == null) return data.currentSalon;
    for (final s in data.salons) {
      if ('${s['id']}' == '$branchId') return s;
    }
    return null;
  }

  void _openCustomerProfile(BuildContext context, DashboardData data, Map<String, dynamic> booking) {
    final salon = _resolveBookingSalon(data, booking);
    final customerId = customerKey(booking);
    if (salon == null || customerId == null) return;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CustomerProfileSheet(
        salonId: '${salon['id']}',
        customerId: customerId,
        customerName: '${booking['customer']?['name'] ?? ''}',
        customerPhone: '${booking['customer']?['phone'] ?? ''}',
        allBookings: data.bookings,
      ),
    );
  }

  Future<void> _openRebook(BuildContext context, DashboardData data, Map<String, dynamic> booking) async {
    final salon = _resolveBookingSalon(data, booking);
    if (salon == null) return;
    final branchStaff = List<Map<String, dynamic>>.from(salon['stylists'] ?? []);
    if (branchStaff.isEmpty) return;
    final created = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NewBookingSheet(
        salon: salon,
        staffRelations: branchStaff,
        allBookings: data.bookings,
        prefill: booking,
      ),
    );
    if (created == true) await data.load();
  }

  bool _matchesQuery(Map<String, dynamic> booking, AppLocalizations t) {
    if (_query.trim().isEmpty) return true;
    final q = _query.trim().toLowerCase();
    final customer = '${booking['customer']?['name'] ?? ''}'.toLowerCase();
    final service = bookingServiceSummary(booking, t).toLowerCase();
    return customer.contains(q) || service.contains(q);
  }

  bool _matchesStaff(Map<String, dynamic> booking) {
    if (_staffId == null) return true;
    return '${booking['stylist']?['id']}' == _staffId;
  }

  bool _matchesPeriod(DateTime day) {
    if (_periodDays == 0) return true;
    final cutoff = DateTime.now().subtract(Duration(days: _periodDays));
    return day.isAfter(DateTime(cutoff.year, cutoff.month, cutoff.day));
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final data = DashboardScope.of(context);
    final staffOptions = data.staffRelations
        .map((r) => r['stylist'])
        .whereType<Map<String, dynamic>>()
        .toList();

    final needsAction = data.needsAction;
    final byDay = data.bookingsByDay;
    final visibleDays = byDay.entries.where((e) => _matchesPeriod(e.key)).toList();

    // Apply search + staff filters within each day, drop empty days.
    final filteredByDay = <MapEntry<DateTime, List<Map<String, dynamic>>>>[];
    for (final entry in visibleDays) {
      final bookings =
          entry.value.where((b) => _matchesQuery(b, t) && _matchesStaff(b)).toList();
      if (bookings.isNotEmpty) filteredByDay.add(MapEntry(entry.key, bookings));
    }

    final periodTotal = filteredByDay.fold<int>(
        0, (sum, e) => sum + e.value.fold<int>(0, (s, b) => s + ((b['price'] ?? 0) as int)));
    final periodCount = filteredByDay.fold<int>(0, (sum, e) => sum + e.value.length);
    final avgTicket = periodCount == 0 ? 0 : periodTotal ~/ periodCount;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: data.load,
          child: ListView(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 24 + MediaQuery.of(context).padding.bottom),
            children: [
              Row(
                children: [
                  Expanded(child: Text(t.bookingsTitle, style: Theme.of(context).textTheme.headlineSmall)),
                  NewBookingButton(compact: true, onPressed: () => _openNewBooking(context, data)),
                ],
              ),
              const SizedBox(height: 14),
              TextField(
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: t.searchCustomerOrService,
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _filterChip(t.filterThisWeek, _periodDays == 7, () => setState(() => _periodDays = 7)),
                    const SizedBox(width: 8),
                    _filterChip(t.filterAllTime, _periodDays == 0, () => setState(() => _periodDays = 0)),
                    const SizedBox(width: 8),
                    _filterChip(t.filterAllStaff, _staffId == null, () => setState(() => _staffId = null)),
                    for (final s in staffOptions) ...[
                      const SizedBox(width: 8),
                      _filterChip('${s['user']?['name'] ?? t.staffLabel}', _staffId == '${s['id']}',
                          () => setState(() => _staffId = '${s['id']}')),
                    ],
                  ],
                ),
              ),
              if (needsAction.isNotEmpty) ...[
                const SizedBox(height: 16),
                SectionTitle(title: t.needsActionHeading, trailing: '${needsAction.length}'),
                const SizedBox(height: 8),
                ...needsAction.map((b) => BookingActionCard(booking: b, onChanged: data.load)),
              ],
              if (data.todaySchedule.isNotEmpty) ...[
                const SizedBox(height: 16),
                SectionTitle(title: t.todayScheduleHeading, trailing: '${data.todaySchedule.length}'),
                const SizedBox(height: 8),
                ...data.todaySchedule.map((b) => BookingActionCard(booking: b, onChanged: data.load)),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: StatTile(label: t.statTotal, value: formatMoney(periodTotal))),
                  const SizedBox(width: 10),
                  Expanded(child: StatTile(label: t.statServices, value: '$periodCount')),
                  const SizedBox(width: 10),
                  Expanded(child: StatTile(label: t.statAvgTicket, value: formatMoney(avgTicket))),
                ],
              ),
              const SizedBox(height: 16),
              if (filteredByDay.isEmpty)
                EmptyCard(text: t.noBookingsMatchFilter)
              else
                for (final entry in filteredByDay) ...[
                  _DayHeader(day: entry.key, bookings: entry.value),
                  const SizedBox(height: 8),
                  ...entry.value.map((b) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: BookingLogRow(
                          booking: b,
                          isRepeat: data.repeatCustomerKeys.contains(customerKey(b)),
                          onRebook: () => _openRebook(context, data, b),
                          onTap: () => _openCustomerProfile(context, data, b),
                        ),
                      )),
                  const SizedBox(height: 8),
                ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterChip(String label, bool selected, VoidCallback onTap) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      showCheckmark: false,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.accent,
      labelStyle: TextStyle(
        color: selected ? Colors.white : AppColors.inkMuted,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _DayHeader extends StatelessWidget {
  const _DayHeader({required this.day, required this.bookings});

  final DateTime day;
  final List<Map<String, dynamic>> bookings;

  String _label(AppLocalizations t) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    if (day == today) return t.today;
    if (day == yesterday) return t.yesterday;
    return formatFullDate(day);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final total = bookings.fold<int>(0, (sum, b) => sum + ((b['price'] ?? 0) as int));
    return Row(
      children: [
        Expanded(
          child: Text(_label(t), style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.inkMuted)),
        ),
        Text(t.dayTotalServices(formatMoney(total), bookings.length),
            style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.inkMuted, fontSize: 12)),
      ],
    );
  }
}
