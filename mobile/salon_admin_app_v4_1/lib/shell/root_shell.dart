import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/api.dart';
import '../core/format.dart';
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
      MaterialPageRoute(builder: (_) => AccountScreen(onLogout: widget.onLogout, data: _data)),
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
          if (_data.loading && _data.salons.isEmpty) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          // Note: currentSalon is also null while viewingAllBranches — that's
          // a deliberate, valid state, not "no salon." salons.isEmpty is the
          // real "nothing linked to this account" signal.
          if (_data.salons.isEmpty) {
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
            body: Column(
              children: [
                _BranchSwitcherBar(data: _data),
                Expanded(child: IndexedStack(index: _tab, children: screens)),
              ],
            ),
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

/// Thin persistent bar above the tabs showing the active branch, with a
/// tap-to-switch affordance. Lives at shell level (not per-screen, unlike
/// every other header in this app) because every one of the 5 tabs shows
/// salon-scoped data — an owner on Staff/Services/Insights needs to see
/// (and change) which branch they're looking at just as much as on Home.
/// A single-branch owner just sees a static name with a one-entry switcher
/// sheet; not worth conditionally hiding for that case.
class _BranchSwitcherBar extends StatelessWidget {
  const _BranchSwitcherBar({required this.data});
  final DashboardData data;

  Future<void> _openSwitcher(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _BranchSwitcherSheet(data: data),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final salon = data.currentSalon;
    if (salon == null && !data.viewingAllBranches) return const SizedBox.shrink();
    final title = data.viewingAllBranches ? t.allBranchesLabel : '${salon?['name'] ?? ''}';
    return SafeArea(
      bottom: false,
      child: Material(
        color: AppColors.bg,
        child: InkWell(
          key: const Key('branch_switcher_bar'),
          onTap: () => _openSwitcher(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                const Icon(Icons.storefront_outlined, size: 16, color: AppColors.inkMuted),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                ),
                const SizedBox(width: 8),
                // A pill, not just a chevron — a plain label+arrow read as
                // static header text and owners didn't realize the whole bar
                // was tappable to switch branches.
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.accentSoft,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (data.salons.length > 1) ...[
                        Text('${data.salons.length}',
                            style: TextStyle(fontSize: 12, color: AppColors.accent, fontWeight: FontWeight.w800)),
                        const SizedBox(width: 4),
                      ],
                      Text(t.switchLabel,
                          style: TextStyle(fontSize: 12, color: AppColors.accent, fontWeight: FontWeight.w700)),
                      Icon(Icons.expand_more, size: 16, color: AppColors.accent),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BranchSwitcherSheet extends StatefulWidget {
  const _BranchSwitcherSheet({required this.data});
  final DashboardData data;

  @override
  State<_BranchSwitcherSheet> createState() => _BranchSwitcherSheetState();
}

class _BranchSwitcherSheetState extends State<_BranchSwitcherSheet> {
  String? _switchingTo;

  AppLocalizations get t => AppLocalizations.of(context)!;

  int _activeStaffCount(Map<String, dynamic> salon) =>
      List<Map<String, dynamic>>.from(salon['stylists'] ?? []).where((r) => r['status'] == 'ACTIVE').length;

  Future<void> _select(String salonId) async {
    if (salonId == widget.data.selectedSalonId) {
      Navigator.of(context).pop();
      return;
    }
    setState(() => _switchingTo = salonId);
    await widget.data.switchSalon(salonId);
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _selectAllBranches() async {
    if (widget.data.viewingAllBranches) {
      Navigator.of(context).pop();
      return;
    }
    setState(() => _switchingTo = DashboardData.allBranchesId);
    await widget.data.switchToAllBranches();
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _addBranch() async {
    final created = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _AddBranchSheet(),
    );
    if (created == true) {
      await widget.data.load();
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.3),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.switchBranchTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 14),
                if (widget.data.salons.length > 1)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      key: const Key('branch_option_all'),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      onTap: _switchingTo != null ? null : _selectAllBranches,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: cardDecoration(
                          color: AppColors.accentSoft,
                          borderColor: widget.data.viewingAllBranches ? AppColors.accent : AppColors.border,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(t.allBranchesLabel,
                                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                                  Text(t.allBranchesSubtitle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 12, color: AppColors.inkMuted)),
                                  const SizedBox(height: 4),
                                  Text(
                                    t.branchStatsLine(
                                      widget.data.salons
                                          .fold<int>(0, (sum, s) => sum + ((s['todayStats']?['count'] ?? 0) as int)),
                                      formatMoney(widget.data.salons.fold<int>(
                                          0, (sum, s) => sum + ((s['todayStats']?['revenue'] ?? 0) as int))),
                                      widget.data.salons.fold<int>(0, (sum, s) => sum + _activeStaffCount(s)),
                                    ),
                                    style: TextStyle(fontSize: 12, color: AppColors.accent, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            if (_switchingTo == DashboardData.allBranchesId)
                              const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                            else if (widget.data.viewingAllBranches)
                              Icon(Icons.check_circle, color: AppColors.accent, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                for (final salon in widget.data.salons)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      key: Key('branch_option_${salon['id']}'),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      onTap: _switchingTo != null ? null : () => _select('${salon['id']}'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: cardDecoration(
                          borderColor: '${salon['id']}' == widget.data.selectedSalonId && !widget.data.viewingAllBranches
                              ? AppColors.accent
                              : AppColors.border,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${salon['name'] ?? ''}',
                                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                                  Text('${salon['address'] ?? ''}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 12, color: AppColors.inkMuted)),
                                  const SizedBox(height: 4),
                                  Text(
                                    t.branchStatsLine(
                                      (salon['todayStats']?['count'] ?? 0) as int,
                                      formatMoney((salon['todayStats']?['revenue'] ?? 0) as int),
                                      _activeStaffCount(salon),
                                    ),
                                    style: const TextStyle(fontSize: 12, color: AppColors.inkMuted, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            if (_switchingTo == '${salon['id']}')
                              const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                            else if ('${salon['id']}' == widget.data.selectedSalonId && !widget.data.viewingAllBranches)
                              Icon(Icons.check_circle, color: AppColors.accent, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    key: const Key('branch_add_button'),
                    onPressed: _addBranch,
                    icon: const Icon(Icons.add),
                    label: Text(t.addBranchButton),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Minimal branch-creation form (name + address), calling the new
/// POST /api/v2/salons. Same "just enough" scope as everything else this
/// session — no location picker/country-currency here, matching the
/// first-branch signup flow's own optional-location precedent.
class _AddBranchSheet extends StatefulWidget {
  const _AddBranchSheet();

  @override
  State<_AddBranchSheet> createState() => _AddBranchSheetState();
}

class _AddBranchSheetState extends State<_AddBranchSheet> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  bool _saving = false;
  String? _error;

  AppLocalizations get t => AppLocalizations.of(context)!;

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final address = _addressController.text.trim();
    if (name.length < 2 || address.length < 5) {
      setState(() => _error = t.branchNameAddressRequired);
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await api().post('/api/v2/salons', data: {'name': name, 'address': address});
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (kDebugMode) debugPrint('Add branch failed: $e');
      if (mounted) setState(() => _error = t.couldNotAddBranch);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height * 0.3,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.addBranchTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 14),
                TextField(
                  key: const Key('add_branch_name'),
                  controller: _nameController,
                  decoration: InputDecoration(labelText: t.salonNameLabel, prefixIcon: const Icon(Icons.storefront_outlined)),
                ),
                const SizedBox(height: 10),
                TextField(
                  key: const Key('add_branch_address'),
                  controller: _addressController,
                  minLines: 1,
                  maxLines: 2,
                  decoration: InputDecoration(labelText: t.salonAddressLabel, prefixIcon: const Icon(Icons.location_on_outlined)),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 8),
                  Text(_error!, style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.w600)),
                ],
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    key: const Key('add_branch_save'),
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const SizedBox(
                            width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : Text(t.saveDetailsButton),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
