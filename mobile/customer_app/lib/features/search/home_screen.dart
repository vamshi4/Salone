import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/providers/booking_provider.dart';
import '../booking/bookings_screen.dart';
import '../notifications/notifications_screen.dart';
import '../profile/profile_screen.dart';
import 'salons_tab.dart';
import 'stylists_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.onLogout});
  final Future<void> Function() onLogout;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _DiscoveryPage(tabController: _tabController),
          const BookingsScreen(),
          ProfileScreen(onLogout: widget.onLogout),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Discover',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'Bookings',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _DiscoveryPage extends StatefulWidget {
  const _DiscoveryPage({required this.tabController});

  final TabController tabController;

  @override
  State<_DiscoveryPage> createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<_DiscoveryPage> {
  final _searchController = TextEditingController();
  final Set<String> _filters = {};
  double? _latitude;
  double? _longitude;
  bool _locating = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleFilter(String filter) {
    setState(() {
      if (!_filters.add(filter)) _filters.remove(filter);
    });
  }

  void _clearFilters() {
    _searchController.clear();
    setState(_filters.clear);
  }

  Future<void> _toggleNearby() async {
    if (_filters.contains('nearby')) {
      setState(() => _filters.remove('nearby'));
      return;
    }
    setState(() => _locating = true);
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw Exception('Turn on location services to find nearby salons.');
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception('Location permission is required for Nearby.');
      }
      final position = await Geolocator.getCurrentPosition();
      if (!mounted) return;
      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _filters.add('nearby');
      });
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(error.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _locating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'GlamBook',
                            style: TextStyle(
                              fontSize: 25,
                              height: 1.1,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0,
                              color: Color(0xFF17121F),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Salon services near you',
                            style: TextStyle(
                              color: Color(0xFF756E80),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Consumer(
                      builder: (context, ref, _) {
                        final pendingCount = ref.watch(
                          bookingsProvider.select(
                            (value) => value.maybeWhen(
                              data: (bookings) => bookings
                                  .where(
                                      (booking) => booking.needsCustomerAction)
                                  .length,
                              orElse: () => 0,
                            ),
                          ),
                        );

                        return _NotificationButton(
                          pendingCount: pendingCount,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const NotificationsScreen(),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search services or stylists',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon:
                        _searchController.text.isEmpty && _filters.isEmpty
                            ? null
                            : IconButton(
                                onPressed: _clearFilters,
                                tooltip: 'Clear search and filters',
                                icon: const Icon(Icons.close),
                              ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                          color: Colors.black.withValues(alpha: 0.08)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                          color: Colors.black.withValues(alpha: 0.08)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 36,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      _FilterChip(
                        label: 'Haircut',
                        icon: Icons.content_cut,
                        selected: _filters.contains('haircut'),
                        onTap: () => _toggleFilter('haircut'),
                      ),
                      _FilterChip(
                        label: 'Home service',
                        icon: Icons.home_outlined,
                        selected: _filters.contains('home'),
                        onTap: () => _toggleFilter('home'),
                      ),
                      _FilterChip(
                        label: 'Top rated',
                        icon: Icons.star_border,
                        selected: _filters.contains('rated'),
                        onTap: () => _toggleFilter('rated'),
                      ),
                      _FilterChip(
                        label: _locating ? 'Locating...' : 'Nearby',
                        icon: Icons.near_me_outlined,
                        selected: _filters.contains('nearby'),
                        onTap: _locating ? null : _toggleNearby,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFFAF7FC),
              border: Border(
                bottom: BorderSide(color: Colors.black.withValues(alpha: 0.08)),
              ),
            ),
            child: TabBar(
              controller: widget.tabController,
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: const Color(0xFF756E80),
              indicatorColor: Theme.of(context).colorScheme.primary,
              indicatorWeight: 3,
              labelStyle:
                  const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              tabs: const [
                Tab(text: 'Salons'),
                Tab(text: 'Stylists'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: widget.tabController,
              children: [
                SalonsTab(
                  query: _searchController.text,
                  filters: _filters,
                  latitude: _latitude,
                  longitude: _longitude,
                  onClear: _clearFilters,
                ),
                StylistsTab(
                  query: _searchController.text,
                  filters: _filters,
                  latitude: _latitude,
                  longitude: _longitude,
                  onClear: _clearFilters,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton({
    required this.pendingCount,
    this.onTap,
  });

  final int pendingCount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton.filledTonal(
          onPressed: onTap,
          icon: const Icon(Icons.notifications_none),
          tooltip: 'Notifications',
        ),
        if (pendingCount > 0)
          Positioned(
            right: 2,
            top: 2,
            child: Container(
              width: 18,
              height: 18,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xFFE06464),
                shape: BoxShape.circle,
              ),
              child: Text(
                pendingCount > 9 ? '9+' : '$pendingCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.icon,
    required this.selected,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: selected,
        onSelected: onTap == null ? null : (_) => onTap!(),
        avatar: Icon(icon, size: 16, color: selected ? primary : null),
        label: Text(label),
        showCheckmark: false,
        selectedColor: const Color(0xFFF0ECFF),
        side: BorderSide(
          color: selected ? primary : Colors.black.withValues(alpha: 0.08),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        labelStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 12,
          color: selected ? primary : const Color(0xFF2B2532),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 5),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
