import 'package:flutter/material.dart';

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

class _RootShellState extends State<RootShell> {
  final _data = DashboardData();
  int _tab = 0;

  @override
  void initState() {
    super.initState();
    _data.load(onAuthExpired: () => widget.onLogout());
  }

  @override
  void dispose() {
    _data.dispose();
    super.dispose();
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
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
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
                      const Icon(Icons.storefront_outlined, size: 42, color: AppColors.inkFaint),
                      const SizedBox(height: 12),
                      Text(
                        t.noSalonLinked,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 14),
                      FilledButton.icon(
                        onPressed: () => _data.load(onAuthExpired: () => widget.onLogout()),
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

          return Scaffold(
            body: IndexedStack(index: _tab, children: screens),
            bottomNavigationBar: NavigationBar(
              selectedIndex: _tab,
              onDestinationSelected: (i) => setState(() => _tab = i),
              destinations: [
                NavigationDestination(icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home), label: t.navHome),
                NavigationDestination(
                    icon: const Icon(Icons.calendar_today_outlined),
                    selectedIcon: const Icon(Icons.calendar_today),
                    label: t.navBookings),
                NavigationDestination(
                    icon: const Icon(Icons.people_outline), selectedIcon: const Icon(Icons.people), label: t.navStaff),
                NavigationDestination(
                    icon: const Icon(Icons.bar_chart_outlined), selectedIcon: const Icon(Icons.bar_chart), label: t.navInsights),
                NavigationDestination(
                    icon: const Icon(Icons.person_outline), selectedIcon: const Icon(Icons.person), label: t.navAccount),
              ],
            ),
          );
        },
      ),
    );
  }
}
