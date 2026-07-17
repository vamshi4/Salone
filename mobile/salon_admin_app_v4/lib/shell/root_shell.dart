import 'dart:ui';

import 'package:flutter/material.dart';

import '../screens/account_screen.dart';
import '../screens/bookings_screen.dart';
import '../screens/home_screen.dart';
import '../screens/insights_screen.dart';
import '../screens/services_screen.dart';
import '../screens/staff_screen.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';
import 'dashboard_data.dart';
import 'dashboard_scope.dart';

/// The bottom-nav shell that replaces v2's single scrolling dashboard +
/// app-bar-icon navigation. Five destinations: Home, Bookings, Staff,
/// Insights (Earnings + Retention merged), Services (v4 — the salon-wide
/// service catalog, see `docs/HANDOFF.md`). Account moved out of the tab bar
/// in v4 — it's reached via the avatar button in the Home header instead,
/// matching the "Open Design" prototype's IA (see [HomeScreen]'s
/// `onOpenAccount` callback).
class RootShell extends StatefulWidget {
  const RootShell({super.key, required this.onLogout});

  final Future<void> Function() onLogout;

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  final _data = DashboardData();
  int _tab = 0;

  void _openAccount() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AccountScreen(onLogout: widget.onLogout)),
    );
  }

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
                      const SizedBox(height: 10),
                      OutlinedButton.icon(
                        onPressed: widget.onLogout,
                        style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.danger, side: const BorderSide(color: Color(0xFFF09595))),
                        icon: const Icon(Icons.logout),
                        label: Text(t.signOut),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          final screens = [
            HomeScreen(onOpenAccount: _openAccount),
            const BookingsScreen(),
            const StaffScreen(),
            const InsightsScreen(),
            const ServicesScreen(),
          ];

          return Scaffold(
            body: IndexedStack(index: _tab, children: screens),
            bottomNavigationBar: _TabBar(
              selectedIndex: _tab,
              onSelected: (i) => setState(() => _tab = i),
              items: [
                _TabItem(icon: Icons.home_outlined, selectedIcon: Icons.home, label: t.navHome),
                _TabItem(icon: Icons.calendar_today_outlined, selectedIcon: Icons.calendar_today, label: t.navBookings),
                _TabItem(icon: Icons.people_outline, selectedIcon: Icons.people, label: t.navStaff),
                _TabItem(icon: Icons.bar_chart_outlined, selectedIcon: Icons.bar_chart, label: t.navInsights),
                _TabItem(icon: Icons.design_services_outlined, selectedIcon: Icons.design_services, label: t.statServices),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TabItem {
  const _TabItem({required this.icon, required this.selectedIcon, required this.label});
  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

/// Flush, translucent-blur bottom tab bar with a thin top indicator line on
/// the active tab — matches the "Open Design" prototype's `.tab-bar`
/// (`backdrop-filter: blur(20px)`, hairline top border, 3px accent
/// indicator) rather than a Material pill indicator or the earlier coral
/// pass's floating rounded bar.
class _TabBar extends StatelessWidget {
  const _TabBar({required this.items, required this.selectedIndex, required this.onSelected});

  final List<_TabItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.of(context).padding.bottom;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xF0FFFFFF),
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          padding: EdgeInsets.only(top: 8, bottom: bottomSafe),
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++) Expanded(child: _tabButton(i)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tabButton(int i) {
    final item = items[i];
    final selected = i == selectedIndex;
    final color = selected ? AppColors.accent : AppColors.inkMuted;
    return InkWell(
      onTap: () => onSelected(i),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 24,
              height: 3,
              margin: const EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                color: selected ? AppColors.accent : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Icon(selected ? item.selectedIcon : item.icon, color: color, size: 24),
            const SizedBox(height: 3),
            Text(
              item.label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                color: color,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
