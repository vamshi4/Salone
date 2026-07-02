import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() => runApp(const SalonAdminApp());

class SalonAdminApp extends StatelessWidget {
  const SalonAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF00796B);
    const fontFamily = 'AppSans';

    return MaterialApp(
      title: 'Salon Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: fontFamily,
        textTheme: ThemeData.light().textTheme.apply(
              fontFamily: fontFamily,
              bodyColor: const Color(0xFF111827),
              displayColor: const Color(0xFF111827),
            ),
        colorScheme: ColorScheme.fromSeed(seedColor: primary, primary: primary),
        scaffoldBackgroundColor: const Color(0xFFF6F8F7),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF6F8F7),
          elevation: 0,
          scrolledUnderElevation: 0,
          foregroundColor: Color(0xFF111827),
          titleTextStyle: TextStyle(
            fontFamily: fontFamily,
            color: Color(0xFF111827),
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      home: const AdminDashboardScreen(),
    );
  }
}

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://10.0.2.2:3000',
  );

  final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl));
  Map<String, dynamic>? _salon;
  List<Map<String, dynamic>> _staffRelations = [];
  List<Map<String, dynamic>> _bookings = [];
  bool _loading = true;
  bool _saving = false;
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    setState(() => _loading = true);
    try {
      final salonsRes = await _dio.get('/api/v2/salons');
      final salons = List<Map<String, dynamic>>.from(salonsRes.data);
      final salon = salons.firstWhere(
        (item) => item['name'] == 'Glamour Salon',
        orElse: () => salons.first,
      );
      final bookingsRes =
          await _dio.get('/api/v2/salons/${salon['id']}/bookings');

      setState(() {
        _salon = salon;
        _staffRelations =
            List<Map<String, dynamic>>.from(salon['stylists'] ?? []);
        _bookings = List<Map<String, dynamic>>.from(bookingsRes.data);
      });
    } catch (e) {
      _show('Error loading dashboard: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  int get _todayBookings {
    final now = DateTime.now();
    return _bookings.where((booking) {
      final slot = DateTime.parse(booking['slotStart']);
      return slot.year == now.year &&
          slot.month == now.month &&
          slot.day == now.day;
    }).length;
  }

  int get _weekRevenue {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return _bookings.where((booking) {
      final slot = DateTime.parse(booking['slotStart']);
      return slot
          .isAfter(DateTime(weekStart.year, weekStart.month, weekStart.day));
    }).fold<int>(
        0, (total, booking) => total + ((booking['salonPayout'] ?? 0) as int));
  }

  Future<void> _toggleCanSetOwnPrice(
      Map<String, dynamic> relation, bool value) async {
    final salon = _salon;
    final stylist = relation['stylist'];
    if (salon == null || stylist == null) return;

    setState(() => _saving = true);
    try {
      await _dio.patch(
        '/api/v2/salons/${salon['id']}/stylists/${stylist['id']}',
        data: {'canSetOwnPrice': value},
      );
      await _loadDashboard();
      _show('Staff permission updated');
    } catch (e) {
      _show('Update failed: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _show(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final salon = _salon;
    if (salon == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Salon Admin')),
        body: Center(
          child: FilledButton.icon(
            onPressed: _loadDashboard,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(salon['name'] ?? 'Salon Admin'),
        actions: [
          IconButton(
            onPressed: _loadDashboard,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadDashboard,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
          children: [
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    icon: Icons.calendar_today,
                    label: 'Today',
                    value: '$_todayBookings',
                    helper: 'appointments',
                    color: const Color(0xFF00796B),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MetricCard(
                    icon: Icons.payments_outlined,
                    label: 'This week',
                    value: 'Rs ${_weekRevenue ~/ 100}',
                    helper: 'salon payout',
                    color: const Color(0xFF5B3DB8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _SegmentedTabs(
              selectedIndex: _tabIndex,
              bookingsCount: _bookings.length,
              staffCount: _staffRelations.length,
              onChanged: (index) => setState(() => _tabIndex = index),
            ),
            const SizedBox(height: 14),
            if (_tabIndex == 0) ...[
              const _SectionTitle(title: 'Bookings'),
              const SizedBox(height: 10),
              if (_bookings.isEmpty)
                const _EmptyCard(text: 'No salon bookings yet')
              else
                ..._bookings.map((booking) => _BookingCard(booking: booking)),
            ] else ...[
              const _SectionTitle(title: 'Staff permissions'),
              const SizedBox(height: 10),
              if (_staffRelations.isEmpty)
                const _EmptyCard(text: 'No active staff yet')
              else
                ..._staffRelations.map(
                  (relation) => _StaffCard(
                    relation: relation,
                    saving: _saving,
                    onTogglePrice: (value) =>
                        _toggleCanSetOwnPrice(relation, value),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.helper,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final String helper;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 12),
          Text(label,
              style: const TextStyle(
                  color: Color(0xFF6B7280), fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(value,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 2),
          Text(helper,
              style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
        ],
      ),
    );
  }
}

class _SegmentedTabs extends StatelessWidget {
  const _SegmentedTabs({
    required this.selectedIndex,
    required this.bookingsCount,
    required this.staffCount,
    required this.onChanged,
  });

  final int selectedIndex;
  final int bookingsCount;
  final int staffCount;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F1EF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _TabButton(
              label: 'Bookings',
              count: bookingsCount,
              selected: selectedIndex == 0,
              onTap: () => onChanged(0)),
          _TabButton(
              label: 'Staff',
              count: staffCount,
              selected: selectedIndex == 1,
              onTap: () => onChanged(1)),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton(
      {required this.label,
      required this.count,
      required this.selected,
      required this.onTap});

  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$label  $count',
            style: TextStyle(
              color:
                  selected ? const Color(0xFF00796B) : const Color(0xFF6B7280),
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900));
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({required this.booking});

  final Map<String, dynamic> booking;

  @override
  Widget build(BuildContext context) {
    final service = booking['service']?['name'] ?? 'Service';
    final stylist = booking['stylist']?['user']?['name'] ?? 'Stylist';
    final customer = booking['customer']?['name'] ?? 'Customer';
    final slot = DateTime.parse(booking['slotStart']);
    final payout = ((booking['salonPayout'] ?? 0) as int) ~/ 100;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(service,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w900))),
              _StatusBadge(status: booking['status'] ?? 'CONFIRMED'),
            ],
          ),
          const SizedBox(height: 8),
          Text('$customer with $stylist',
              style: const TextStyle(
                  color: Color(0xFF6B7280), fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.schedule, size: 18, color: Color(0xFF00796B)),
              const SizedBox(width: 6),
              Expanded(
                  child: Text(_formatDate(slot),
                      style: const TextStyle(fontWeight: FontWeight.w800))),
              Text('Rs $payout',
                  style: const TextStyle(
                      color: Color(0xFF00796B), fontWeight: FontWeight.w900)),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final suffix = date.hour >= 12 ? 'PM' : 'AM';
    return '${date.day}/${date.month}, $hour:00 $suffix';
  }
}

class _StaffCard extends StatelessWidget {
  const _StaffCard(
      {required this.relation,
      required this.saving,
      required this.onTogglePrice});

  final Map<String, dynamic> relation;
  final bool saving;
  final ValueChanged<bool> onTogglePrice;

  @override
  Widget build(BuildContext context) {
    final stylist = relation['stylist'] ?? {};
    final user = stylist['user'] ?? {};
    final canSetOwnPrice = relation['canSetOwnPrice'] == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: _boxDecoration(),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFE7F4F1),
            child: Icon(Icons.person_outline, color: Color(0xFF00796B)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user['name'] ?? 'Stylist',
                    style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 3),
                Text('${stylist['registrationType'] ?? 'STYLIST'} - Active',
                    style: const TextStyle(color: Color(0xFF6B7280))),
              ],
            ),
          ),
          Switch(
              value: canSetOwnPrice, onChanged: saving ? null : onTogglePrice),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
          color: const Color(0xFFE7F4F1),
          borderRadius: BorderRadius.circular(8)),
      child: Text(
        status,
        style: const TextStyle(
            color: Color(0xFF00796B),
            fontSize: 11,
            fontWeight: FontWeight.w900),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _boxDecoration(),
      child: Column(
        children: [
          const Icon(Icons.inbox_outlined, size: 40, color: Color(0xFF6B7280)),
          const SizedBox(height: 10),
          Text(text, style: const TextStyle(fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

BoxDecoration _boxDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: Colors.black.withValues(alpha: 0.07)),
    boxShadow: [
      BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 16,
          offset: const Offset(0, 8)),
    ],
  );
}
