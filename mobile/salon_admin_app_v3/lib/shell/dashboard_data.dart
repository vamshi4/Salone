import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../core/api.dart';
import '../core/format.dart';
import '../core/helpers.dart';

/// Shared dashboard state for the whole bottom-nav shell (Home, Bookings,
/// Staff all read from this instead of each re-fetching independently, the
/// way the old single-screen v2 dashboard held one big state object). Insights
/// and Account load their own data separately since their endpoints
/// (`earnings`, `retention`, `auth/me`) aren't part of this payload.
class DashboardData extends ChangeNotifier {
  Map<String, dynamic>? salon;
  List<Map<String, dynamic>> staffRelations = [];
  List<Map<String, dynamic>> bookings = [];
  bool loading = true;
  bool saving = false;
  String? error;

  /// Called once when [RootShell] mounts, and again on pull-to-refresh from
  /// any tab (they all share this one loader).
  Future<void> load({VoidCallback? onAuthExpired}) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final salonsRes = await api().get('/api/v2/salons');
      final salons = List<Map<String, dynamic>>.from(salonsRes.data as List);
      if (salons.isEmpty) {
        salon = null;
        staffRelations = [];
        bookings = [];
        return;
      }

      final s = salons.first;
      final bookingsRes = await api().get('/api/v2/salons/${s['id']}/bookings');

      salon = s;
      staffRelations = List<Map<String, dynamic>>.from(s['stylists'] ?? []);
      bookings = List<Map<String, dynamic>>.from(bookingsRes.data as List);

      // The salon's actual stored currency is the source of truth once one
      // exists — overrides whatever the device-local country pref implies,
      // so two devices looking at the same salon always agree on symbol.
      final currency = s['currency'];
      if (currency is String && currency.isNotEmpty) {
        CurrencyController.instance.applyCurrencyCode(currency);
      }
    } catch (e) {
      if (e is DioException) {
        final status = e.response?.statusCode;
        if (status == 401 || status == 403) {
          onAuthExpired?.call();
          return;
        }
      }
      if (kDebugMode) debugPrint('Error loading dashboard: $e');
      error = 'Could not load dashboard. Check your connection and try again.';
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> toggleCanSetOwnPrice(Map<String, dynamic> relation, bool value) async {
    final s = salon;
    final stylist = relation['stylist'];
    if (s == null || stylist == null) return;

    saving = true;
    notifyListeners();
    try {
      await api().patch(
        '/api/v2/salons/${s['id']}/stylists/${stylist['id']}',
        data: {'canSetOwnPrice': value},
      );
      await load();
    } finally {
      saving = false;
      notifyListeners();
    }
  }

  List<Map<String, dynamic>> get _completedBookings =>
      bookings.where((b) => b['status'] == 'COMPLETED').toList();

  bool _within(Map<String, dynamic> booking, DateTime start) =>
      effectiveBookingTime(booking).isAfter(start.subtract(const Duration(milliseconds: 1)));

  int get todayCount {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    return _completedBookings.where((b) => _within(b, start)).length;
  }

  int _revenueSince(DateTime start) => _completedBookings
      .where((b) => _within(b, start))
      .fold<int>(0, (total, b) => total + ((b['price'] ?? 0) as int));

  int get todayRevenue {
    final now = DateTime.now();
    return _revenueSince(DateTime(now.year, now.month, now.day));
  }

  int get weekRevenue {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return _revenueSince(DateTime(weekStart.year, weekStart.month, weekStart.day));
  }

  int get monthRevenue {
    final now = DateTime.now();
    return _revenueSince(DateTime(now.year, now.month, 1));
  }

  Set<String> get _customerKeys => bookings
      .map(customerKey)
      .whereType<String>()
      .toSet();

  int get uniqueCustomers => _customerKeys.length;

  Map<String, int> get _customerCounts {
    final counts = <String, int>{};
    for (final booking in bookings) {
      final key = customerKey(booking);
      if (key == null) continue;
      counts[key] = (counts[key] ?? 0) + 1;
    }
    return counts;
  }

  int get repeatCustomers => _customerCounts.values.where((count) => count > 1).length;

  /// Customer keys with more than one booking — used to show a "Repeat" tag
  /// next to their name in the Bookings log.
  Set<String> get repeatCustomerKeys =>
      _customerCounts.entries.where((e) => e.value > 1).map((e) => e.key).toSet();

  /// Today's completed bookings, most-recently-logged first — the "Logged
  /// today" list on Home.
  List<Map<String, dynamic>> get loggedToday {
    final now = DateTime.now();
    final today = _completedBookings
        .where((b) => isSameDay(effectiveBookingTime(b), now))
        .toList()
      ..sort((a, b) => effectiveBookingTime(b).compareTo(effectiveBookingTime(a)));
    return today;
  }

  /// Bookings that still need a decision: pending confirmation, or a
  /// customer-proposed reschedule. Rare once "Done service" logging is the
  /// default flow, but real whenever "Schedule later" is used.
  List<Map<String, dynamic>> get needsAction => bookings.where((b) {
        final status = b['status'];
        return status == 'PENDING' ||
            (status == 'PENDING_RESCHEDULE' && b['rescheduleProposedBy'] == 'CUSTOMER');
      }).toList();

  /// All bookings (completed log entries and anything still pending),
  /// grouped by calendar day, most recent day first, for the Bookings tab.
  Map<DateTime, List<Map<String, dynamic>>> get bookingsByDay {
    final map = <DateTime, List<Map<String, dynamic>>>{};
    for (final booking in bookings) {
      final t = effectiveBookingTime(booking);
      final day = DateTime(t.year, t.month, t.day);
      map.putIfAbsent(day, () => []).add(booking);
    }
    for (final list in map.values) {
      list.sort((a, b) => effectiveBookingTime(b).compareTo(effectiveBookingTime(a)));
    }
    final sortedKeys = map.keys.toList()..sort((a, b) => b.compareTo(a));
    return {for (final k in sortedKeys) k: map[k]!};
  }
}
