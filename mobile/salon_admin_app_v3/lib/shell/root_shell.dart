import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../screens/account_screen.dart';
import '../screens/bookings_screen.dart';
import '../screens/home_screen.dart';
import '../screens/insights_screen.dart';
import '../screens/staff_screen.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';
import 'dashboard_data.dart';
import 'dashboard_scope.dart';

/// The bottom-nav shell that replaces v2's single scrolling dashboard +
/// app-bar-icon navigation. Five destinations: Home, Bookings, Staff,
/// Insights (Earnings + Retention merged), Account (replaces the old
/// logout/settings app-bar icons).
class RootShell extends StatefulWidget {
  const RootShell({super.key, required this.onLogout});

  final Future<void> Function() onLogout;

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> with WidgetsBindingObserver {
  final _data = DashboardData();
  final Map<String, DateTime> _snoozedUntil = {};
  Timer? _pollTimer;
  Timer? _alarmTimer;
  Timer? _snoozeTimer;
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _data.addListener(_syncPendingAlarm);
    _data.load(onAuthExpired: () => widget.onLogout());
    _startPolling();
  }

  void _startPolling() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 20), (_) {
      if (!_data.loading) {
        _data.load(onAuthExpired: () => widget.onLogout());
      }
    });
  }

  List<Map<String, dynamic>> get _unsnoozedBookings {
    final now = DateTime.now();
    return _data.needsAction.where((booking) {
      final until = _snoozedUntil[booking['id'].toString()];
      return until == null || !until.isAfter(now);
    }).toList();
  }

  void _syncPendingAlarm() {
    final pendingIds = _data.needsAction.map((b) => b['id'].toString()).toSet();
    _snoozedUntil.removeWhere((id, _) => !pendingIds.contains(id));

    if (_unsnoozedBookings.isEmpty) {
      _alarmTimer?.cancel();
      _alarmTimer = null;
    } else if (_alarmTimer == null) {
      SystemSound.play(SystemSoundType.alert);
      _alarmTimer = Timer.periodic(
        const Duration(seconds: 15),
        (_) => SystemSound.play(SystemSoundType.alert),
      );
    }

    _scheduleSnoozeWakeUp();
  }

  void _scheduleSnoozeWakeUp() {
    _snoozeTimer?.cancel();
    _snoozeTimer = null;
    if (_snoozedUntil.isEmpty) return;

    final now = DateTime.now();
    final next = _snoozedUntil.values.reduce((a, b) => a.isBefore(b) ? a : b);
    final delay = next.difference(now);
    _snoozeTimer = Timer(delay.isNegative ? Duration.zero : delay, () {
      if (!mounted) return;
      setState(_syncPendingAlarm);
    });
  }

  void _snooze(Map<String, dynamic> booking) {
    _snoozedUntil[booking['id'].toString()] =
        DateTime.now().add(const Duration(minutes: 5));
    setState(_syncPendingAlarm);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _data.load(onAuthExpired: () => widget.onLogout());
      _startPolling();
    } else {
      _pollTimer?.cancel();
      _alarmTimer?.cancel();
      _alarmTimer = null;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pollTimer?.cancel();
    _alarmTimer?.cancel();
    _snoozeTimer?.cancel();
    _data.removeListener(_syncPendingAlarm);
    _data.dispose();
    super.dispose();
  }

  Widget _pendingAlarmCard(Map<String, dynamic> booking) {
    final t = AppLocalizations.of(context)!;
    final customer = booking['customer']?['name'] ?? t.customerLabel;
    return Material(
      color: AppColors.dangerSoft,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
          child: Row(
            children: [
              const Icon(Icons.notifications_active, color: AppColors.danger),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(t.needsActionHeading,
                        style: const TextStyle(
                            fontWeight: FontWeight.w800, color: AppColors.ink)),
                    Text(customer,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.inkMuted)),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: () => _snooze(booking),
                icon: const Icon(Icons.snooze, size: 18),
                label: const Text('5 min'),
              ),
              FilledButton(
                onPressed: () => setState(() => _tab = 1),
                child: Text(t.navBookings),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return DashboardScope(
      data: _data,
      child: AnimatedBuilder(
        animation: _data,
        builder: (context, _) {
          if (_data.loading && _data.salon == null) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          }

          if (_data.salon == null) {
            return Scaffold(
              appBar: AppBar(title: Text(t.salonAdminTitle)),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.storefront_outlined,
                          size: 42, color: AppColors.inkFaint),
                      const SizedBox(height: 12),
                      Text(
                        t.noSalonLinked,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 14),
                      FilledButton.icon(
                        onPressed: () =>
                            _data.load(onAuthExpired: () => widget.onLogout()),
                        icon: const Icon(Icons.refresh),
                        label: Text(t.retry),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          final screens = [
            const HomeScreen(),
            const BookingsScreen(),
            const StaffScreen(),
            const InsightsScreen(),
            AccountScreen(onLogout: widget.onLogout),
          ];

          final pendingAlerts = _unsnoozedBookings;
          return Scaffold(
            body: Column(
              children: [
                if (pendingAlerts.isNotEmpty)
                  _pendingAlarmCard(pendingAlerts.first),
                Expanded(child: IndexedStack(index: _tab, children: screens)),
              ],
            ),
            bottomNavigationBar: NavigationBar(
              selectedIndex: _tab,
              onDestinationSelected: (i) => setState(() => _tab = i),
              destinations: [
                NavigationDestination(
                    icon: const Icon(Icons.home_outlined),
                    selectedIcon: const Icon(Icons.home),
                    label: t.navHome),
                NavigationDestination(
                    icon: const Icon(Icons.calendar_today_outlined),
                    selectedIcon: const Icon(Icons.calendar_today),
                    label: t.navBookings),
                NavigationDestination(
                    icon: const Icon(Icons.people_outline),
                    selectedIcon: const Icon(Icons.people),
                    label: t.navStaff),
                NavigationDestination(
                    icon: const Icon(Icons.bar_chart_outlined),
                    selectedIcon: const Icon(Icons.bar_chart),
                    label: t.navInsights),
                NavigationDestination(
                    icon: const Icon(Icons.person_outline),
                    selectedIcon: const Icon(Icons.person),
                    label: t.navAccount),
              ],
            ),
          );
        },
      ),
    );
  }
}
