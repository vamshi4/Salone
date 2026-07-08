import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'theme.dart';

const _baseUrl = String.fromEnvironment(
  'API_URL',
  defaultValue: 'http://10.0.2.2:3000',
);

/// This build's version. Keep in sync with pubspec.yaml `version:`.
/// The backend's `salonAdminMinVersion` is compared against this to force updates.
const appVersion = '2.0.0';

String? _sessionToken;

/// Returns true when [current] is a lower semver than [min] (x.y.z).
bool _isVersionLower(String current, String min) {
  List<int> parse(String v) => v
      .split('.')
      .map((p) => int.tryParse(p.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0)
      .toList();
  final c = parse(current);
  final m = parse(min);
  for (var i = 0; i < 3; i++) {
    final cv = i < c.length ? c[i] : 0;
    final mv = i < m.length ? m[i] : 0;
    if (cv != mv) return cv < mv;
  }
  return false;
}

Dio _api() {
  return Dio(
    BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 8),
      sendTimeout: const Duration(seconds: 8),
      receiveTimeout: const Duration(seconds: 8),
    ),
  )
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (!options.path.contains('/auth/login')) {
            final token = await _authToken();
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }
          handler.next(options);
        },
      ),
    );
}

Future<String?> _authToken() async {
  if (_sessionToken != null) return _sessionToken;
  final prefs = await SharedPreferences.getInstance();
  _sessionToken = prefs.getString('salon_admin_token');
  return _sessionToken;
}

Future<void> _saveAuthToken(String token) async {
  _sessionToken = token;
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('salon_admin_token', token);
}

Future<void> _clearAuthToken() async {
  _sessionToken = null;
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('salon_admin_token');
}

void main() => runApp(const SalonAdminApp());

class SalonAdminApp extends StatelessWidget {
  const SalonAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salon Admin',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _loading = true;
  bool _signedIn = false;
  bool _updateRequired = false;
  String _storeUrl = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await _checkVersion();
    final token = await _authToken();
    setState(() {
      _signedIn = token != null;
      _loading = false;
    });
  }

  /// Force-update gate: if this build is older than the backend's minimum,
  /// block the app. Fails open (never blocks) if the check can't run.
  Future<void> _checkVersion() async {
    try {
      final res = await _api().get('/api/v2/app-config');
      final min = '${res.data['salonAdminMinVersion'] ?? appVersion}';
      _storeUrl = '${res.data['salonAdminStoreUrl'] ?? ''}';
      if (_isVersionLower(appVersion, min)) _updateRequired = true;
    } catch (e) {
      if (kDebugMode) debugPrint('Version check skipped: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_updateRequired) {
      return UpdateRequiredScreen(storeUrl: _storeUrl);
    }

    return _signedIn
        ? AdminDashboardScreen(
            onLogout: () async {
              await _clearAuthToken();
              setState(() => _signedIn = false);
            },
          )
        : LoginScreen(onSignedIn: () => setState(() => _signedIn = true));
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.onSignedIn});

  final VoidCallback onSignedIn;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _salonNameController = TextEditingController();
  final _addressController = TextEditingController();
  bool _loading = false;
  bool _signupMode = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _ownerNameController.dispose();
    _salonNameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final phone = _phoneController.text.trim();
    if (phone.length < 6) {
      _show('Enter salon owner phone');
      return;
    }
    if (_passwordController.text.length < 6) {
      _show('Enter your password');
      return;
    }

    setState(() => _loading = true);
    try {
      if (kDebugMode) {
        debugPrint('Salon admin login -> $_baseUrl/api/v2/auth/login');
      }
      final res = await Dio(
        BaseOptions(
          baseUrl: _baseUrl,
          connectTimeout: const Duration(seconds: 8),
          sendTimeout: const Duration(seconds: 8),
          receiveTimeout: const Duration(seconds: 8),
        ),
      ).post(
        '/api/v2/auth/login',
        data: {
          'phone': phone,
          'password': _passwordController.text,
          'role': 'SALON_OWNER',
        },
      );
      await _saveAuthToken(res.data['token'] as String);
      widget.onSignedIn();
    } catch (e) {
      if (kDebugMode) debugPrint('Salon admin login failed: $e');
      if (e is DioException && e.response?.statusCode == 401) {
        _show('No salon owner account found for this phone.');
      } else if (e is DioException) {
        _show('Login failed. Check backend connection.');
      } else {
        _show('Login failed. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _signup() async {
    final phone = _phoneController.text.trim();
    final ownerName = _ownerNameController.text.trim();
    final salonName = _salonNameController.text.trim();
    final address = _addressController.text.trim();

    if (ownerName.length < 2 ||
        salonName.length < 2 ||
        address.length < 5 ||
        phone.length < 6) {
      _show('Fill owner name, salon name, address, and phone');
      return;
    }
    if (_passwordController.text.length < 6) {
      _show('Password must be at least 6 characters');
      return;
    }

    setState(() => _loading = true);
    try {
      if (kDebugMode) {
        debugPrint('Salon admin signup -> $_baseUrl/api/v2/auth/salon-signup');
      }
      final res = await Dio(
        BaseOptions(
          baseUrl: _baseUrl,
          connectTimeout: const Duration(seconds: 8),
          sendTimeout: const Duration(seconds: 8),
          receiveTimeout: const Duration(seconds: 8),
        ),
      ).post(
        '/api/v2/auth/salon-signup',
        data: {
          'ownerName': ownerName,
          'phone': phone,
          'password': _passwordController.text,
          'salonName': salonName,
          'address': address,
        },
      );
      await _saveAuthToken(res.data['token'] as String);
      widget.onSignedIn();
    } catch (e) {
      if (kDebugMode) debugPrint('Salon admin signup failed: $e');
      if (e is DioException && e.response?.statusCode == 409) {
        _show('This phone is already registered. Please sign in instead.');
      } else if (e is DioException) {
        _show('Signup failed. Check backend connection.');
      } else {
        _show('Signup failed. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _show(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _field({
    required Key key,
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscure = false,
  }) {
    return TextField(
      key: key,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 68,
                      height: 68,
                      decoration: const BoxDecoration(
                        color: AppColors.accentSoft,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.storefront,
                          size: 32, color: AppColors.accent),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _signupMode ? 'Create salon account' : 'Welcome back',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _signupMode
                        ? 'Set up your salon, then step right in.'
                        : 'Sign in to your salon dashboard.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 32),
                  if (_signupMode) ...[
                    _field(
                      key: const Key('signup_owner_name'),
                      controller: _ownerNameController,
                      label: 'Owner name',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 14),
                    _field(
                      key: const Key('signup_salon_name'),
                      controller: _salonNameController,
                      label: 'Salon name',
                      icon: Icons.storefront_outlined,
                    ),
                    const SizedBox(height: 14),
                    _field(
                      key: const Key('signup_address'),
                      controller: _addressController,
                      label: 'Salon address',
                      icon: Icons.location_on_outlined,
                    ),
                    const SizedBox(height: 14),
                  ],
                  _field(
                    key: const Key('auth_phone'),
                    controller: _phoneController,
                    label: 'Phone number',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 14),
                  _field(
                    key: const Key('auth_password'),
                    controller: _passwordController,
                    label: 'Password',
                    icon: Icons.lock_outline,
                    obscure: true,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    key: const Key('auth_submit'),
                    onPressed:
                        _loading ? null : (_signupMode ? _signup : _login),
                    child: _loading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : Text(_signupMode ? 'Create account' : 'Sign in'),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _signupMode
                            ? 'Already have an account?'
                            : 'New to Glamour?',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextButton(
                        key: const Key('auth_toggle_mode'),
                        onPressed: _loading
                            ? null
                            : () => setState(() => _signupMode = !_signupMode),
                        child: Text(_signupMode ? 'Sign in' : 'Create account'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key, required this.onLogout});

  final Future<void> Function() onLogout;

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final Dio _dio = _api();
  Map<String, dynamic>? _salon;
  List<Map<String, dynamic>> _staffRelations = [];
  List<Map<String, dynamic>> _bookings = [];
  bool _loading = true;
  bool _saving = false;
  int _tabIndex = 0;
  String _bookingFilter = 'ACTION';

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
      if (salons.isEmpty) {
        if (mounted) {
          setState(() {
            _salon = null;
            _staffRelations = [];
            _bookings = [];
          });
        }
        return;
      }

      final salon = salons.first;
      final bookingsRes = await _dio.get(
        '/api/v2/salons/${salon['id']}/bookings',
      );

      setState(() {
        _salon = salon;
        _staffRelations = List<Map<String, dynamic>>.from(
          salon['stylists'] ?? [],
        );
        _bookings = List<Map<String, dynamic>>.from(bookingsRes.data);
      });
    } catch (e) {
      if (e is DioException) {
        final status = e.response?.statusCode;
        if (status == 401 || status == 403) {
          await widget.onLogout();
          return;
        }
      }
      if (kDebugMode) debugPrint('Error loading dashboard: $e');
      _show('Could not load dashboard. Check your connection and try again.');
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
      return slot.isAfter(
        DateTime(weekStart.year, weekStart.month, weekStart.day),
      );
    }).fold<int>(
      0,
      (total, booking) => total + ((booking['salonPayout'] ?? 0) as int),
    );
  }

  int get _uniqueCustomers => _customerKeys(_bookings).length;

  int get _repeatCustomers {
    final counts = <String, int>{};
    for (final booking in _bookings) {
      final key = _customerKey(booking);
      if (key == null) continue;
      counts[key] = (counts[key] ?? 0) + 1;
    }
    return counts.values.where((count) => count > 1).length;
  }

  String get _topService {
    final counts = <String, int>{};
    for (final booking in _bookings) {
      final bundle = List<Map<String, dynamic>>.from(booking['services'] ?? []);
      final names = bundle
          .map((item) => item['service']?['name'])
          .whereType<String>()
          .where((name) => name.trim().isNotEmpty)
          .toList();
      if (names.isEmpty) {
        final fallback = booking['service']?['name'];
        if (fallback is String && fallback.trim().isNotEmpty) {
          counts[fallback] = (counts[fallback] ?? 0) + 1;
        }
        continue;
      }
      for (final name in names) {
        counts[name] = (counts[name] ?? 0) + 1;
      }
    }
    if (counts.isEmpty) return 'No data';
    return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  List<Map<String, dynamic>> get _recentCustomers {
    final seen = <String>{};
    final recent = <Map<String, dynamic>>[];
    for (final booking in _bookings) {
      final key = _customerKey(booking);
      if (key == null || seen.contains(key)) continue;
      seen.add(key);
      recent.add(booking);
      if (recent.length == 4) break;
    }
    return recent;
  }

  List<Map<String, dynamic>> get _filteredBookings {
    if (_bookingFilter == 'ALL') return _bookings;
    if (_bookingFilter == 'ACTION') {
      return _bookings.where((booking) {
        final status = booking['status'];
        return status == 'PENDING' ||
            (status == 'PENDING_RESCHEDULE' &&
                booking['rescheduleProposedBy'] == 'CUSTOMER');
      }).toList();
    }

    return _bookings
        .where((booking) => booking['status'] == _bookingFilter)
        .toList();
  }

  Future<void> _toggleCanSetOwnPrice(
    Map<String, dynamic> relation,
    bool value,
  ) async {
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
      if (kDebugMode) debugPrint('Staff permission update failed: $e');
      _show('Could not update staff permission. Please try again.');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _showManualBookingSheet() async {
    final salon = _salon;
    if (salon == null || _staffRelations.isEmpty) {
      _show('Add active staff before creating bookings');
      return;
    }

    final created = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ManualBookingSheet(
        salon: salon,
        staffRelations: _staffRelations,
      ),
    );

    if (created == true) {
      await _loadDashboard();
      _show('Booking created');
    }
  }

  Future<void> _showStaffSetupSheet() async {
    final salon = _salon;
    if (salon == null) return;

    final created = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _StaffSetupSheet(salon: salon),
    );

    if (created == true) {
      await _loadDashboard();
      _show('Staff, service, and timings added');
    }
  }

  Future<void> _showStaffManageSheet(Map<String, dynamic> relation) async {
    final updated = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _StaffManageSheet(relation: relation),
    );

    if (updated == true) {
      await _loadDashboard();
    }
  }

  Future<void> _showAccountSettingsSheet() async {
    final updated = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _AccountSettingsSheet(),
    );

    if (updated == true) {
      await _loadDashboard();
      _show('Account updated');
    }
  }

  void _showCustomerProfile(Map<String, dynamic> booking) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CustomerProfileSheet(
        booking: booking,
        bookings: _bookings,
      ),
    );
  }

  void _show(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.storefront_outlined,
                  size: 42,
                  color: Color(0xFF6B7280),
                ),
                const SizedBox(height: 12),
                const Text(
                  'No salon is linked to this owner account yet.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 14),
                FilledButton.icon(
                  onPressed: _loadDashboard,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(salon['name'] ?? 'Salon Admin'),
        actions: [
          IconButton(
            onPressed: _showManualBookingSheet,
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'New booking',
          ),
          IconButton(
            key: const Key('dashboard_open_retention'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => RetentionScreen(salon: salon),
                ),
              );
            },
            icon: const Icon(Icons.query_stats),
            tooltip: 'Retention report',
          ),
          IconButton(
            onPressed: _loadDashboard,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
          IconButton(
            onPressed: _showAccountSettingsSheet,
            icon: const Icon(Icons.account_circle_outlined),
            tooltip: 'Account settings',
          ),
          IconButton(
            onPressed: widget.onLogout,
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadDashboard,
        child: ListView(
          padding: EdgeInsets.fromLTRB(
              16, 8, 16, 28 + MediaQuery.of(context).padding.bottom),
          children: [
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    icon: Icons.calendar_today,
                    label: 'Today',
                    value: '$_todayBookings',
                    helper: 'appointments',
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MetricCard(
                    icon: Icons.payments_outlined,
                    label: 'This week',
                    value: '₹${_weekRevenue ~/ 100}',
                    helper: 'salon payout',
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    icon: Icons.people_outline,
                    label: 'Customers',
                    value: '$_uniqueCustomers',
                    helper: 'unique profiles',
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MetricCard(
                    icon: Icons.replay_outlined,
                    label: 'Repeat',
                    value: '$_repeatCustomers',
                    helper: 'came back',
                    color: AppColors.violet,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _CustomerSnapshotCard(
              topService: _topService,
              recentBookings: _recentCustomers,
              onCustomerTap: _showCustomerProfile,
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
              Row(
                children: [
                  const Expanded(child: _SectionTitle(title: 'Bookings')),
                  FilledButton.icon(
                    onPressed: _showManualBookingSheet,
                    icon: const Icon(Icons.add),
                    label: const Text('New'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _BookingFilters(
                selected: _bookingFilter,
                bookings: _bookings,
                onChanged: (value) => setState(() => _bookingFilter = value),
              ),
              const SizedBox(height: 10),
              if (_filteredBookings.isEmpty)
                const _EmptyCard(text: 'No salon bookings yet')
              else
                _BookingQueue(
                  bookings: _filteredBookings,
                  allBookings: _bookings,
                  onChanged: _loadDashboard,
                ),
            ] else ...[
              Row(
                children: [
                  const Expanded(
                      child: _SectionTitle(title: 'Staff permissions')),
                  FilledButton.icon(
                    key: const Key('staff_add_button'),
                    onPressed: _showStaffSetupSheet,
                    icon: const Icon(Icons.person_add_alt_1),
                    label: const Text('Add staff'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (_staffRelations.isEmpty)
                _EmptyCard(
                  text: 'No active staff yet',
                  actionLabel: 'Add first staff',
                  actionKey: const Key('staff_empty_add_button'),
                  onAction: _showStaffSetupSheet,
                )
              else
                ..._staffRelations.map(
                  (relation) => _StaffCard(
                    relation: relation,
                    saving: _saving,
                    onEdit: () => _showStaffManageSheet(relation),
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

class _AccountSettingsSheet extends StatefulWidget {
  const _AccountSettingsSheet();

  @override
  State<_AccountSettingsSheet> createState() => _AccountSettingsSheetState();
}

class _AccountSettingsSheetState extends State<_AccountSettingsSheet> {
  final _ownerNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _salonNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _loading = true;
  bool _savingProfile = false;
  bool _savingPassword = false;
  String _joined = '';
  String _plan = 'FREE';

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _ownerNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _salonNameController.dispose();
    _addressController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final res = await _api().get('/api/v2/auth/me');
      final user = Map<String, dynamic>.from(res.data['user'] ?? {});
      final salon = Map<String, dynamic>.from(res.data['salon'] ?? {});
      _ownerNameController.text = '${user['name'] ?? ''}';
      _phoneController.text = '${user['phone'] ?? ''}';
      _emailController.text = '${user['email'] ?? ''}';
      _salonNameController.text = '${salon['name'] ?? ''}';
      _addressController.text = '${salon['address'] ?? ''}';
      _plan = '${salon['saasPlan'] ?? 'FREE'}';
      final createdAt = user['createdAt'];
      _joined = createdAt is String ? _shortDate(DateTime.parse(createdAt)) : '';
    } catch (e) {
      if (kDebugMode) debugPrint('Account settings load failed: $e');
      _show('Could not load account details');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _saveProfile() async {
    final ownerName = _ownerNameController.text.trim();
    final phone = _phoneController.text.trim();
    final salonName = _salonNameController.text.trim();
    final address = _addressController.text.trim();
    if (ownerName.length < 2 ||
        phone.length < 6 ||
        salonName.length < 2 ||
        address.length < 5) {
      _show('Fill owner, phone, salon name, and address');
      return;
    }

    setState(() => _savingProfile = true);
    try {
      await _api().patch('/api/v2/auth/me', data: {
        'ownerName': ownerName,
        'phone': phone,
        'email': _emailController.text.trim(),
        'salonName': salonName,
        'address': address,
      });
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (kDebugMode) debugPrint('Account settings save failed: $e');
      if (e is DioException && e.response?.statusCode == 409) {
        _show('Phone or email is already used');
      } else {
        _show('Could not save account details');
      }
    } finally {
      if (mounted) setState(() => _savingProfile = false);
    }
  }

  Future<void> _changePassword() async {
    final current = _currentPasswordController.text;
    final next = _newPasswordController.text;
    if (next.length < 6) {
      _show('New password must be at least 6 characters');
      return;
    }
    if (next != _confirmPasswordController.text) {
      _show('New passwords do not match');
      return;
    }

    setState(() => _savingPassword = true);
    try {
      await _api().post('/api/v2/auth/change-password', data: {
        'currentPassword': current,
        'newPassword': next,
      });
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      _show('Password changed');
    } catch (e) {
      if (kDebugMode) debugPrint('Password change failed: $e');
      if (e is DioException && e.response?.statusCode == 401) {
        _show('Current password is incorrect');
      } else {
        _show('Could not change password');
      }
    } finally {
      if (mounted) setState(() => _savingPassword = false);
    }
  }

  void _show(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: _loading
            ? const SizedBox(
                height: 220,
                child: Center(child: CircularProgressIndicator()),
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.account_circle_outlined, color: Color(0xFF00796B)),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'Account settings',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                          tooltip: 'Close',
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _SettingsSummary(joined: _joined, plan: _plan),
                    const SizedBox(height: 18),
                    const _SectionTitle(title: 'Admin profile'),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _ownerNameController,
                      decoration: const InputDecoration(
                        labelText: 'Owner name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone number',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.mail_outline),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const _SectionTitle(title: 'Salon details'),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _salonNameController,
                      decoration: const InputDecoration(
                        labelText: 'Salon name',
                        prefixIcon: Icon(Icons.storefront_outlined),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _addressController,
                      minLines: 1,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Salon address',
                        prefixIcon: Icon(Icons.location_on_outlined),
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        key: const Key('account_save_profile'),
                        onPressed: _savingProfile ? null : _saveProfile,
                        icon: _savingProfile
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.save_outlined),
                        label: Text(_savingProfile ? 'Saving...' : 'Save details'),
                      ),
                    ),
                    const SizedBox(height: 22),
                    const _SectionTitle(title: 'Security'),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _currentPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Current password',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _newPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'New password',
                        prefixIcon: Icon(Icons.password_outlined),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Confirm new password',
                        prefixIcon: Icon(Icons.verified_user_outlined),
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        key: const Key('account_change_password'),
                        onPressed: _savingPassword ? null : _changePassword,
                        icon: const Icon(Icons.lock_reset),
                        label: Text(_savingPassword ? 'Changing...' : 'Change password'),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _SettingsSummary extends StatelessWidget {
  const _SettingsSummary({required this.joined, required this.plan});

  final String joined;
  final String plan;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F1EF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Wrap(
        spacing: 16,
        runSpacing: 8,
        children: [
          const _SummaryPill(icon: Icons.badge_outlined, label: 'Role', value: 'Salon owner'),
          _SummaryPill(icon: Icons.workspace_premium_outlined, label: 'Plan', value: plan),
          if (joined.isNotEmpty)
            _SummaryPill(icon: Icons.event_outlined, label: 'Joined', value: joined),
        ],
      ),
    );
  }
}

class _SummaryPill extends StatelessWidget {
  const _SummaryPill({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: const Color(0xFF00796B)),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: const TextStyle(
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w900)),
      ],
    );
  }
}

class _BookingFilters extends StatelessWidget {
  const _BookingFilters({
    required this.selected,
    required this.bookings,
    required this.onChanged,
  });

  final String selected;
  final List<Map<String, dynamic>> bookings;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final filters = [
      ('ACTION', 'Needs action'),
      ('PENDING', 'Pending'),
      ('PENDING_RESCHEDULE', 'Reschedule'),
      ('CONFIRMED', 'Confirmed'),
      ('COMPLETED', 'Completed'),
      ('CANCELLED', 'Cancelled'),
      ('ALL', 'All'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final selectedFilter = selected == filter.$1;
          final count = _countFor(filter.$1);
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              key: Key('booking_filter_${filter.$1}'),
              selected: selectedFilter,
              label: Text('${filter.$2} $count'),
              onSelected: (_) => onChanged(filter.$1),
            ),
          );
        }).toList(),
      ),
    );
  }

  int _countFor(String filter) {
    if (filter == 'ALL') return bookings.length;
    if (filter == 'ACTION') {
      return bookings.where((booking) {
        final status = booking['status'];
        return status == 'PENDING' ||
            (status == 'PENDING_RESCHEDULE' &&
                booking['rescheduleProposedBy'] == 'CUSTOMER');
      }).length;
    }

    return bookings.where((booking) => booking['status'] == filter).length;
  }
}

class _CustomerSnapshotCard extends StatelessWidget {
  const _CustomerSnapshotCard({
    required this.topService,
    required this.recentBookings,
    required this.onCustomerTap,
  });

  final String topService;
  final List<Map<String, dynamic>> recentBookings;
  final ValueChanged<Map<String, dynamic>> onCustomerTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.insights_outlined, color: Color(0xFF00796B)),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Customer insights',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
              ),
              Flexible(
                child: Text(
                  topService,
                  textAlign: TextAlign.right,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF00796B),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (recentBookings.isEmpty)
            const Text(
              'No customer bookings yet',
              style: TextStyle(
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w700,
              ),
            )
          else
            ...recentBookings.map((booking) => _RecentCustomerRow(
                  booking: booking,
                  onTap: () => onCustomerTap(booking),
                )),
        ],
      ),
    );
  }
}

class _ManualBookingSheet extends StatefulWidget {
  const _ManualBookingSheet({
    required this.salon,
    required this.staffRelations,
  });

  final Map<String, dynamic> salon;
  final List<Map<String, dynamic>> staffRelations;

  @override
  State<_ManualBookingSheet> createState() => _ManualBookingSheetState();
}

class _StaffSetupSheet extends StatefulWidget {
  const _StaffSetupSheet({required this.salon});

  final Map<String, dynamic> salon;

  @override
  State<_StaffSetupSheet> createState() => _StaffSetupSheetState();
}

class _StaffManageSheet extends StatefulWidget {
  const _StaffManageSheet({required this.relation});

  final Map<String, dynamic> relation;

  @override
  State<_StaffManageSheet> createState() => _StaffManageSheetState();
}

class _CustomerProfileSheet extends StatefulWidget {
  const _CustomerProfileSheet({
    required this.booking,
    required this.bookings,
  });

  final Map<String, dynamic> booking;
  final List<Map<String, dynamic>> bookings;

  @override
  State<_CustomerProfileSheet> createState() => _CustomerProfileSheetState();
}

class _StaffSetupSheetState extends State<_StaffSetupSheet> {
  final _staffNameController = TextEditingController();
  final _staffPhoneController = TextEditingController();
  final _serviceNameController = TextEditingController(text: 'Haircut');
  final _priceController = TextEditingController(text: '499');
  bool _saving = false;

  @override
  void dispose() {
    _staffNameController.dispose();
    _staffPhoneController.dispose();
    _serviceNameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _createStaffSetup() async {
    final staffName = _staffNameController.text.trim();
    final staffPhone = _staffPhoneController.text.trim();
    final serviceName = _serviceNameController.text.trim();
    final priceRupees = int.tryParse(_priceController.text.trim());

    if (staffName.length < 2 ||
        staffPhone.length < 6 ||
        serviceName.length < 2 ||
        priceRupees == null ||
        priceRupees < 1) {
      _show('Fill staff name, phone, service, and price');
      return;
    }

    setState(() => _saving = true);
    try {
      // One atomic backend call instead of chaining separate create/make-
      // exclusive/service/hours requests: if any step failed partway
      // through the old chain, the phone number was left "used up" by a
      // half-created stylist with no service or hours, and there was no
      // way to finish or retry with the same phone.
      await _api().post(
        '/api/v2/salons/${widget.salon['id']}/staff-setup',
        data: {
          'name': staffName,
          'phone': staffPhone,
          'serviceName': serviceName,
          'basePrice': priceRupees * 100,
        },
      );

      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 409) {
        _show('That staff phone is already in use');
      } else {
        if (kDebugMode) debugPrint('Staff setup failed: $e');
        _show('Could not add staff setup. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _show(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, 24, 12, viewInsets + 12),
        child: Container(
          decoration: _boxDecoration(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add staff',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Create your first staff member with a starter service and weekly timings.',
                    style: TextStyle(
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    key: const Key('staff_setup_name'),
                    controller: _staffNameController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Staff name',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    key: const Key('staff_setup_phone'),
                    controller: _staffPhoneController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Staff phone',
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    key: const Key('staff_setup_service'),
                    controller: _serviceNameController,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Starter service',
                      prefixIcon: Icon(Icons.content_cut_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    key: const Key('staff_setup_price'),
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Price (Rs)',
                      prefixIcon: Icon(Icons.currency_rupee),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F1EF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Working hours will be added as Monday to Saturday, 9:00 AM to 6:00 PM. You can change this later.',
                      style: TextStyle(
                        color: Color(0xFF0F766E),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      key: const Key('staff_setup_submit'),
                      onPressed: _saving ? null : _createStaffSetup,
                      icon: _saving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.check_circle_outline),
                      label: Text(_saving ? 'Saving...' : 'Create staff setup'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StaffManageSheetState extends State<_StaffManageSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  final _serviceNameController = TextEditingController();
  final _servicePriceController = TextEditingController();
  final _hoursStartController = TextEditingController(text: '09:00');
  final _hoursEndController = TextEditingController(text: '18:00');
  bool _savingProfile = false;
  bool _savingService = false;
  bool _savingHours = false;
  bool _loadingHours = true;
  List<Map<String, dynamic>> _availabilityRules = [];
  // Tracks whether anything was saved during this sheet session so the
  // dashboard knows to refresh when the sheet is finally closed.
  bool _changed = false;
  // Local, mutable copy of the stylist's services. Add/edit/delete update
  // this list in place instead of closing the whole sheet, so an admin can
  // manage several services in one visit to "Manage staff".
  late List<Map<String, dynamic>> _services;

  Map<String, dynamic> get _stylist =>
      Map<String, dynamic>.from(widget.relation['stylist'] ?? {});

  Map<String, dynamic> get _user =>
      Map<String, dynamic>.from(_stylist['user'] ?? {});

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: '${_user['name'] ?? ''}');
    _phoneController = TextEditingController(text: '${_user['phone'] ?? ''}');
    _services = List<Map<String, dynamic>>.from(_stylist['services'] ?? []);
    _loadAvailability();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _serviceNameController.dispose();
    _servicePriceController.dispose();
    _hoursStartController.dispose();
    _hoursEndController.dispose();
    super.dispose();
  }

  Future<void> _loadAvailability() async {
    try {
      final res = await _api().get(
        '/api/v2/stylists/${_stylist['id']}/availability-rules',
      );
      if (mounted) {
        setState(() {
          _availabilityRules = List<Map<String, dynamic>>.from(res.data);
        });
      }
    } catch (_) {
      // Keep sheet usable even if timings fail to load.
    } finally {
      if (mounted) setState(() => _loadingHours = false);
    }
  }

  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    if (name.length < 2 || phone.length < 6) {
      _show('Enter valid staff name and phone');
      return;
    }

    setState(() => _savingProfile = true);
    try {
      await _api().patch(
        '/api/v2/stylists/${_stylist['id']}',
        data: {'name': name, 'phone': phone},
      );
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 409) {
        _show('That phone is already in use');
      } else {
        _show('Could not update staff');
      }
    } finally {
      if (mounted) setState(() => _savingProfile = false);
    }
  }

  Future<void> _addService() async {
    final name = _serviceNameController.text.trim();
    final price = int.tryParse(_servicePriceController.text.trim());
    if (name.length < 2 || price == null || price < 1) {
      _show('Enter service name and price');
      return;
    }

    setState(() => _savingService = true);
    try {
      final res = await _api().post(
        '/api/v2/stylists/${_stylist['id']}/services',
        data: {
          'name': name,
          'category': 'Salon',
          'duration': 60,
          'basePrice': price * 100,
        },
      );
      if (mounted) {
        setState(() {
          _services.add(Map<String, dynamic>.from(res.data));
          _serviceNameController.clear();
          _servicePriceController.clear();
          _changed = true;
        });
      }
    } catch (e) {
      _show('Could not add service');
    } finally {
      if (mounted) setState(() => _savingService = false);
    }
  }

  Future<void> _saveHours() async {
    final startTime = _hoursStartController.text.trim();
    final endTime = _hoursEndController.text.trim();
    if (!_validClock(startTime) || !_validClock(endTime)) {
      _show('Use HH:mm for working hours');
      return;
    }

    setState(() => _savingHours = true);
    try {
      for (final day in [1, 2, 3, 4, 5, 6]) {
        await _api().post(
          '/api/v2/stylists/${_stylist['id']}/availability',
          data: {
            'dayOfWeek': day,
            'startTime': startTime,
            'endTime': endTime,
          },
        );
      }
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      _show('Could not add working hours');
    } finally {
      if (mounted) setState(() => _savingHours = false);
    }
  }

  Future<void> _deleteAvailability(String availabilityId) async {
    try {
      await _api().delete(
        '/api/v2/stylists/${_stylist['id']}/availability/$availabilityId',
      );
      await _loadAvailability();
    } catch (_) {
      _show('Could not remove timing');
    }
  }

  Future<void> _editService(Map<String, dynamic> service) async {
    final nameController =
        TextEditingController(text: '${service['name'] ?? ''}');
    final priceController = TextEditingController(
      text: '${((service['basePrice'] ?? 0) as int) ~/ 100}',
    );
    final saved = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final viewInsets = MediaQuery.of(context).viewInsets.bottom;
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(12, 24, 12, viewInsets + 12),
            child: Container(
              decoration: _boxDecoration(),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Edit service',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Service name',
                        prefixIcon: Icon(Icons.content_cut_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Price (Rs)',
                        prefixIcon: Icon(Icons.currency_rupee),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () async {
                          final name = nameController.text.trim();
                          final price =
                              int.tryParse(priceController.text.trim());
                          if (name.length < 2 || price == null || price < 1) {
                            _show('Enter valid service name and price');
                            return;
                          }
                          try {
                            final res = await _api().patch(
                              '/api/v2/stylists/${_stylist['id']}/services/${service['id']}',
                              data: {'name': name, 'basePrice': price * 100},
                            );
                            if (context.mounted) {
                              Navigator.of(
                                context,
                              ).pop(Map<String, dynamic>.from(res.data));
                            }
                          } catch (_) {
                            _show('Could not update service');
                          }
                        },
                        child: const Text('Save service'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    nameController.dispose();
    priceController.dispose();
    if (saved != null && mounted) {
      setState(() {
        final index = _services.indexWhere(
          (item) => '${item['id']}' == '${saved['id']}',
        );
        if (index != -1) {
          _services[index] = saved;
        }
        _changed = true;
      });
    }
  }

  Future<void> _deleteService(Map<String, dynamic> service) async {
    try {
      await _api().delete(
        '/api/v2/stylists/${_stylist['id']}/services/${service['id']}',
      );
      if (mounted) {
        setState(() {
          _services.removeWhere(
            (item) => '${item['id']}' == '${service['id']}',
          );
          _changed = true;
        });
      }
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 400) {
        _show('${e.response?.data?['error'] ?? 'Could not remove service'}');
      } else {
        _show('Could not remove service');
      }
    }
  }

  bool _validClock(String value) => RegExp(r'^\d{2}:\d{2}$').hasMatch(value);

  void _show(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, 24, 12, viewInsets + 12),
        child: Container(
          decoration: _boxDecoration(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Manage staff',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    TextButton(
                      key: const Key('staff_manage_done'),
                      onPressed: () => Navigator.of(context).pop(_changed),
                      child: const Text('Done'),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Add, edit, or remove services and hours below, then tap Done.',
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  key: const Key('staff_manage_name'),
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Staff name',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  key: const Key('staff_manage_phone'),
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Staff phone',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    key: const Key('staff_manage_save'),
                    onPressed: _savingProfile ? null : _saveProfile,
                    child: Text(_savingProfile ? 'Saving...' : 'Save staff'),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Services',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 10),
                if (_services.isEmpty)
                  const Text(
                    'No services yet',
                    style: TextStyle(
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w700,
                    ),
                  )
                else
                  ..._services.map(
                    (service) => Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F8F7),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.black.withValues(alpha: 0.06),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${service['name']}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w800),
                            ),
                          ),
                          Text(
                            'Rs ${((service['basePrice'] ?? 0) as int) ~/ 100}',
                            style: const TextStyle(
                              color: Color(0xFF00796B),
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                _editService(service);
                              } else if (value == 'delete') {
                                _deleteService(service);
                              }
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem(
                                value: 'edit',
                                child: Text('Edit'),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Text('Delete'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                TextField(
                  key: const Key('staff_manage_new_service_name'),
                  controller: _serviceNameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'New service',
                    prefixIcon: Icon(Icons.content_cut_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  key: const Key('staff_manage_new_service_price'),
                  controller: _servicePriceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Price (Rs)',
                    prefixIcon: Icon(Icons.currency_rupee),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    key: const Key('staff_manage_add_service'),
                    onPressed: _savingService ? null : _addService,
                    icon: const Icon(Icons.add),
                    label: Text(_savingService ? 'Adding...' : 'Add service'),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Working hours',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 10),
                if (_loadingHours)
                  const LinearProgressIndicator(minHeight: 3)
                else if (_availabilityRules.isEmpty)
                  const Text(
                    'No timings yet',
                    style: TextStyle(
                      color: Color(0xFF6B7280),
                      fontWeight: FontWeight.w700,
                    ),
                  )
                else
                  ..._availabilityRules.map(
                    (rule) => Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F8F7),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.black.withValues(alpha: 0.06),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${_dayLabel(rule['dayOfWeek'])}  ${rule['startTime']} - ${rule['endTime']}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w800),
                            ),
                          ),
                          IconButton(
                            onPressed: () =>
                                _deleteAvailability('${rule['id']}'),
                            icon: const Icon(Icons.delete_outline),
                            tooltip: 'Remove',
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        key: const Key('staff_manage_hours_start'),
                        controller: _hoursStartController,
                        decoration: const InputDecoration(
                          labelText: 'Start',
                          helperText: 'HH:mm',
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        key: const Key('staff_manage_hours_end'),
                        controller: _hoursEndController,
                        decoration: const InputDecoration(
                          labelText: 'End',
                          helperText: 'HH:mm',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    key: const Key('staff_manage_add_hours'),
                    onPressed: _savingHours ? null : _saveHours,
                    icon: const Icon(Icons.schedule),
                    label:
                        Text(_savingHours ? 'Saving...' : 'Add Mon-Sat hours'),
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

class _CustomerProfileSheetState extends State<_CustomerProfileSheet> {
  final _notesController = TextEditingController();
  final _tagsController = TextEditingController();
  bool _loadingMeta = true;
  bool _savingMeta = false;

  @override
  void initState() {
    super.initState();
    _loadMeta();
  }

  @override
  void dispose() {
    _notesController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  Future<void> _loadMeta() async {
    final salonId = widget.booking['salonId'];
    final customerId = widget.booking['customer']?['id'];
    if (salonId == null || customerId == null) {
      setState(() => _loadingMeta = false);
      return;
    }

    try {
      final res =
          await _api().get('/api/v2/salons/$salonId/customers/$customerId');
      final tags = res.data['tags'];
      _notesController.text = '${res.data['notes'] ?? ''}';
      _tagsController.text = tags is List ? tags.join(', ') : '';
    } catch (_) {
      // Keep the profile usable even if notes have not been created yet.
    } finally {
      if (mounted) setState(() => _loadingMeta = false);
    }
  }

  Future<void> _saveMeta() async {
    final salonId = widget.booking['salonId'];
    final customerId = widget.booking['customer']?['id'];
    if (salonId == null || customerId == null) return;

    setState(() => _savingMeta = true);
    try {
      await _api().patch(
        '/api/v2/salons/$salonId/customers/$customerId',
        data: {
          'notes': _notesController.text.trim(),
          'tags': _tagsController.text
              .split(',')
              .map((tag) => tag.trim())
              .where((tag) => tag.isNotEmpty)
              .toList(),
        },
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Customer notes saved')),
        );
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Customer notes save failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not save. Please try again.')),
        );
      }
    } finally {
      if (mounted) setState(() => _savingMeta = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;
    final bookings = widget.bookings;
    final customer = booking['customer'] ?? {};
    final name = customer['name'] ?? 'Customer';
    final phone = customer['phone'] ?? 'No phone';
    final customerBookings = bookings
        .where((item) => _customerKey(item) == _customerKey(booking))
        .toList()
      ..sort((a, b) => DateTime.parse(b['slotStart'])
          .compareTo(DateTime.parse(a['slotStart'])));
    final completed =
        customerBookings.where((item) => item['status'] == 'COMPLETED').length;
    final totalSpend = customerBookings.fold<int>(
      0,
      (total, item) => total + ((item['price'] ?? 0) as int),
    );
    final lastVisit = customerBookings.isEmpty
        ? null
        : DateTime.parse(customerBookings.first['slotStart']).toLocal();
    final services = customerBookings
        .map((item) => item['service']?['name'])
        .whereType<String>()
        .toSet()
        .join(', ');

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                        Text(
                          '$name',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          '$phone',
                          style: const TextStyle(color: Color(0xFF6B7280)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _MiniStat(
                      label: 'Visits',
                      value: '${customerBookings.length}',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _MiniStat(
                      label: 'Completed',
                      value: '$completed',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _MiniStat(
                      label: 'Spent',
                      value: 'Rs ${totalSpend ~/ 100}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _ProfileLine(
                icon: Icons.schedule,
                label: 'Last visit',
                value: lastVisit == null ? 'No visits' : _shortDate(lastVisit),
              ),
              _ProfileLine(
                icon: Icons.spa_outlined,
                label: 'Services',
                value: services.isEmpty ? 'No services yet' : services,
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _tagsController,
                enabled: !_loadingMeta && !_savingMeta,
                decoration: const InputDecoration(
                  labelText: 'Tags',
                  helperText: 'VIP, bridal, sensitive skin',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _notesController,
                enabled: !_loadingMeta && !_savingMeta,
                minLines: 2,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Salon notes',
                  hintText: 'Formula, allergies, preferences',
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton.icon(
                  onPressed: _loadingMeta || _savingMeta ? null : _saveMeta,
                  icon: _savingMeta
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save_outlined),
                  label: Text(_savingMeta ? 'Saving...' : 'Save notes'),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Booking history',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              ...customerBookings.map((item) => _CustomerBookingRow(
                    booking: item,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F8F7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _ProfileLine extends StatelessWidget {
  const _ProfileLine({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF00796B), size: 20),
          const SizedBox(width: 10),
          SizedBox(
            width: 82,
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFF6B7280)),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomerBookingRow extends StatelessWidget {
  const _CustomerBookingRow({required this.booking});

  final Map<String, dynamic> booking;

  @override
  Widget build(BuildContext context) {
    final service = _bookingServiceSummary(booking);
    final stylist = booking['stylist']?['user']?['name'] ?? 'Stylist';
    final slot = DateTime.parse(booking['slotStart']).toLocal();
    final status = booking['status'] ?? 'CONFIRMED';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F8F7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 2),
                Text(
                  '${_shortDate(slot)} with $stylist',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          _StatusBadge(status: status),
        ],
      ),
    );
  }
}

class _ManualBookingSheetState extends State<_ManualBookingSheet> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dateController =
      TextEditingController(text: _dateInput(DateTime.now()));
  Map<String, dynamic>? _stylist;
  final Set<String> _selectedServiceIds = <String>{};
  List<DateTime> _slots = [];
  DateTime? _selectedSlot;
  bool _loadingSlots = false;
  String? _slotError;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _stylist = _firstOrNull(_activeStylists);
    _resetSelectedServices();
    _loadSlots();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _activeStylists => widget.staffRelations
      .map((relation) => relation['stylist'])
      .whereType<Map<String, dynamic>>()
      .toList();

  List<Map<String, dynamic>> _servicesFor(Map<String, dynamic>? stylist) {
    final stylistServices =
        List<Map<String, dynamic>>.from(stylist?['services'] ?? []);
    if (stylistServices.isNotEmpty) return stylistServices;
    return List<Map<String, dynamic>>.from(widget.salon['services'] ?? []);
  }

  List<Map<String, dynamic>> get _selectedServices => _servicesFor(_stylist)
      .where((service) => _selectedServiceIds.contains('${service['id']}'))
      .toList();

  void _resetSelectedServices() {
    _selectedServiceIds
      ..clear()
      ..addAll(
        _servicesFor(_stylist)
            .take(1)
            .map((service) => '${service['id']}'),
      );
  }

  Future<void> _loadSlots() async {
    final stylist = _stylist;
    final selectedServices = _selectedServices;
    final date = _dateController.text.trim();

    if (stylist == null || selectedServices.isEmpty || date.isEmpty) {
      setState(() {
        _slots = [];
        _selectedSlot = null;
        _slotError = 'Choose staff, service, and date';
      });
      return;
    }

    setState(() {
      _loadingSlots = true;
      _slotError = null;
      _slots = [];
      _selectedSlot = null;
    });

    try {
      final res = await _api().get(
        '/api/v2/stylists/${stylist['id']}/availability',
        queryParameters: {
          'date': date,
          'serviceIds':
              selectedServices.map((service) => service['id']).join(','),
        },
      );

      final slots = ((res.data['slots'] ?? []) as List)
          .map((slot) => DateTime.parse(slot['dateTime']).toLocal())
          .toList();

      setState(() {
        _slots = slots;
        _selectedSlot = _firstOrNull(slots);
        _slotError = slots.isEmpty ? 'No available slots for this date.' : null;
      });
    } catch (e) {
      setState(() => _slotError = 'Could not load slots');
    } finally {
      if (mounted) setState(() => _loadingSlots = false);
    }
  }

  Future<void> _save() async {
    final stylist = _stylist;
    final selectedServices = _selectedServices;
    final phone = _phoneController.text.trim();
    final dateTime = _selectedSlot;

    if (stylist == null || selectedServices.isEmpty) {
      _show('Choose staff and at least one service');
      return;
    }
    if (phone.length < 6) {
      _show('Enter customer phone');
      return;
    }
    if (dateTime == null) {
      _show('Choose an available slot');
      return;
    }

    setState(() => _saving = true);
    try {
      await _api().post('/v2/bookings/salon-manual', data: {
        'salonId': widget.salon['id'],
        'stylistId': stylist['id'],
        'serviceIds': selectedServices.map((service) => service['id']).toList(),
        'customerName': _nameController.text.trim(),
        'customerPhone': phone,
        'dateTime': dateTime.toUtc().toIso8601String(),
      });
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (kDebugMode) debugPrint('Manual booking create failed: $e');
      if (e is DioException && e.response?.data is Map) {
        final serverMessage = (e.response?.data as Map)['error'];
        _show(serverMessage is String ? serverMessage : 'Could not create booking. Please try again.');
      } else {
        _show('Could not create booking. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _show(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stylists = _activeStylists;
    final services = _servicesFor(_stylist);

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'New booking',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 14),
              TextField(
                key: const Key('booking_customer_name'),
                controller: _nameController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Customer name'),
              ),
              const SizedBox(height: 10),
              TextField(
                key: const Key('booking_customer_phone'),
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Customer phone'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                key: const Key('booking_staff'),
                initialValue: _stylist?['id']?.toString(),
                decoration: const InputDecoration(labelText: 'Staff'),
                items: stylists
                    .map((stylist) => DropdownMenuItem(
                          value: stylist['id']?.toString(),
                          child: Text(stylist['user']?['name'] ?? 'Stylist'),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _stylist = stylists
                        .where((stylist) => stylist['id']?.toString() == value)
                        .firstOrNull;
                    _resetSelectedServices();
                  });
                  _loadSlots();
                },
              ),
              const SizedBox(height: 10),
              InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Services',
                  border: OutlineInputBorder(),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: services.map((service) {
                    final serviceId = '${service['id']}';
                    final selected = _selectedServiceIds.contains(serviceId);
                    return Material(
                      color: Colors.transparent,
                      child: CheckboxListTile(
                        key: Key(
                          'booking_service_name_${service['name']}',
                        ),
                        value: selected,
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(
                          '${service['name']} - Rs ${((service['basePrice'] ?? 0) as int) ~/ 100}',
                        ),
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              _selectedServiceIds.add(serviceId);
                            } else {
                              _selectedServiceIds.remove(serviceId);
                            }
                          });
                          _loadSlots();
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                key: const Key('booking_date'),
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Date',
                  helperText: 'YYYY-MM-DD',
                ),
                onChanged: (_) => _loadSlots(),
              ),
              const SizedBox(height: 12),
              const Text(
                'Available slots',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              if (_loadingSlots)
                const LinearProgressIndicator(minHeight: 3)
              else if (_slotError != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _slotError!,
                      style: const TextStyle(
                        color: Color(0xFFC33B3B),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: _loadSlots,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                )
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _slots.asMap().entries.map((entry) {
                    final slot = entry.value;
                    final selected = _selectedSlot != null &&
                        slot.isAtSameMomentAs(_selectedSlot!);
                    return ChoiceChip(
                      key: Key('booking_slot_${entry.key}'),
                      selected: selected,
                      label: Text(_formatSlot(slot)),
                      onSelected: (_) => setState(() => _selectedSlot = slot),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _saving ? null : () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton.icon(
                      key: const Key('booking_create'),
                      onPressed: _saving ? null : _save,
                      icon: _saving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.check_circle_outline),
                      label: Text(_saving ? 'Saving...' : 'Create'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentCustomerRow extends StatelessWidget {
  const _RecentCustomerRow({required this.booking, required this.onTap});

  final Map<String, dynamic> booking;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final customer = booking['customer'] ?? {};
    final name = customer['name'] ?? 'Customer';
    final phone = customer['phone'] ?? 'No phone';
    final slot = DateTime.parse(booking['slotStart']).toLocal();

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFFE7F4F1),
              child: Icon(Icons.person_outline, color: Color(0xFF00796B)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$name',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$phone',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Color(0xFF6B7280)),
                  ),
                ],
              ),
            ),
            Text(
              _shortDate(slot),
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Set<String> _customerKeys(List<Map<String, dynamic>> bookings) {
  return bookings.map(_customerKey).whereType<String>().toSet();
}

String? _customerKey(Map<String, dynamic> booking) {
  final customer = booking['customer'];
  if (customer is! Map) return null;
  final id = customer['id'];
  final phone = customer['phone'];
  if (id is String && id.isNotEmpty) return id;
  if (phone is String && phone.isNotEmpty) return phone;
  return null;
}

String _shortDate(DateTime date) {
  final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
  final suffix = date.hour >= 12 ? 'PM' : 'AM';
  return '${date.day}/${date.month} $hour $suffix';
}

String _formatSlot(DateTime date) {
  final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
  final minute = date.minute.toString().padLeft(2, '0');
  final suffix = date.hour >= 12 ? 'PM' : 'AM';
  return '$hour:$minute $suffix';
}

T? _firstOrNull<T>(List<T> items) => items.isEmpty ? null : items.first;

String _dateInput(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year}-$month-$day';
}

class _BookingQueue extends StatelessWidget {
  const _BookingQueue({
    required this.bookings,
    required this.allBookings,
    required this.onChanged,
  });

  final List<Map<String, dynamic>> bookings;
  final List<Map<String, dynamic>> allBookings;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final groups = [
      _QueueGroup('Needs action', _needsAction),
      _QueueGroup('Today', _today),
      _QueueGroup('Upcoming', _upcoming),
      _QueueGroup('History', _history),
    ];

    return Column(
      children: groups
          .map(
            (group) => _QueueSection(
              title: group.title,
              bookings: bookings.where(group.test).toList(),
              allBookings: allBookings,
              onChanged: onChanged,
            ),
          )
          .where((section) => section.bookings.isNotEmpty)
          .toList(),
    );
  }

  bool _needsAction(Map<String, dynamic> booking) {
    final status = booking['status'];
    return status == 'PENDING' ||
        (status == 'PENDING_RESCHEDULE' &&
            booking['rescheduleProposedBy'] == 'CUSTOMER');
  }

  bool _today(Map<String, dynamic> booking) {
    if (_needsAction(booking) || _history(booking)) return false;
    final slot = DateTime.parse(booking['slotStart']).toLocal();
    final now = DateTime.now();
    return slot.year == now.year &&
        slot.month == now.month &&
        slot.day == now.day;
  }

  bool _upcoming(Map<String, dynamic> booking) {
    if (_needsAction(booking) || _today(booking) || _history(booking)) {
      return false;
    }
    final slot = DateTime.parse(booking['slotStart']).toLocal();
    return slot.isAfter(DateTime.now());
  }

  bool _history(Map<String, dynamic> booking) {
    final status = booking['status'];
    final slot = DateTime.parse(booking['slotStart']).toLocal();
    return status == 'CANCELLED' ||
        status == 'COMPLETED' ||
        status == 'NO_SHOW' ||
        slot.isBefore(DateTime.now());
  }
}

class _QueueGroup {
  const _QueueGroup(this.title, this.test);

  final String title;
  final bool Function(Map<String, dynamic>) test;
}

class _QueueSection extends StatelessWidget {
  const _QueueSection({
    required this.title,
    required this.bookings,
    required this.allBookings,
    required this.onChanged,
  });

  final String title;
  final List<Map<String, dynamic>> bookings;
  final List<Map<String, dynamic>> allBookings;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, top: 6),
          child: Text(
            '$title ${bookings.length}',
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        ...bookings.map(
          (booking) => _BookingCard(
            booking: booking,
            allBookings: allBookings,
            onChanged: onChanged,
            queueLabel: title,
          ),
        ),
      ],
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
      padding: const EdgeInsets.all(18),
      decoration: cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.ink,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          Text(
            helper,
            style: const TextStyle(color: AppColors.inkFaint, fontSize: 12.5),
          ),
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
            buttonKey: const Key('dashboard_tab_bookings'),
            label: 'Bookings',
            count: bookingsCount,
            selected: selectedIndex == 0,
            onTap: () => onChanged(0),
          ),
          _TabButton(
            buttonKey: const Key('dashboard_tab_staff'),
            label: 'Staff',
            count: staffCount,
            selected: selectedIndex == 1,
            onTap: () => onChanged(1),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    this.buttonKey,
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final Key? buttonKey;
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        key: buttonKey,
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
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({
    required this.booking,
    required this.allBookings,
    required this.onChanged,
    required this.queueLabel,
  });

  final Map<String, dynamic> booking;
  final List<Map<String, dynamic>> allBookings;
  final VoidCallback onChanged;
  final String queueLabel;

  @override
  Widget build(BuildContext context) {
    final service = _bookingServiceSummary(booking);
    final stylist = booking['stylist']?['user']?['name'] ?? 'Stylist';
    final customer = booking['customer']?['name'] ?? 'Customer';
    final slot = DateTime.parse(booking['slotStart']);
    final payout = ((booking['salonPayout'] ?? 0) as int) ~/ 100;
    final status = booking['status'] ?? 'CONFIRMED';
    final customerRequestedReschedule = status == 'PENDING_RESCHEDULE' &&
        booking['rescheduleProposedBy'] == 'CUSTOMER';
    final proposedSlot = booking['proposedDateTime'] == null
        ? null
        : DateTime.parse(booking['proposedDateTime']);

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
                child: Text(
                  service,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              _StatusBadge(status: status),
            ],
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => _showCustomer(context),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                '$customer with $stylist',
                style: const TextStyle(
                  color: Color(0xFF00796B),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.schedule, size: 18, color: Color(0xFF00796B)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  _formatDate(slot),
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
              Text(
                'Rs $payout',
                style: const TextStyle(
                  color: Color(0xFF00796B),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _queueHint(
              queueLabel: queueLabel,
              status: status,
              customerRequestedReschedule: customerRequestedReschedule,
            ),
            style: const TextStyle(
              color: Color(0xFF00796B),
              fontWeight: FontWeight.w800,
            ),
          ),
          if (customerRequestedReschedule && proposedSlot != null) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF4DD),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Customer requested ${_formatDate(proposedSlot)}',
                style: const TextStyle(
                  color: Color(0xFF9B6410),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _rejectReschedule(context),
                    icon: const Icon(Icons.close),
                    label: const Text('Reject'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _acceptReschedule(context),
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Accept'),
                  ),
                ),
              ],
            ),
          ] else if (status == 'PENDING') ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _updateStatus(context, 'CANCELLED'),
                    icon: const Icon(Icons.close),
                    label: const Text('Reject'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => _updateStatus(context, 'CONFIRMED'),
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Confirm'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _queueHint({
    required String queueLabel,
    required String status,
    required bool customerRequestedReschedule,
  }) {
    if (status == 'PENDING') return 'Customer waiting for confirmation';
    if (customerRequestedReschedule) return 'Customer requested reschedule';
    if (queueLabel == 'Today') return 'Confirmed today';
    if (queueLabel == 'Upcoming') return 'Upcoming appointment';
    if (queueLabel == 'History') return 'Past or closed booking';
    return queueLabel;
  }

  void _showCustomer(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CustomerProfileSheet(
        booking: booking,
        bookings: allBookings,
      ),
    );
  }

  Future<void> _updateStatus(BuildContext context, String status) async {
    try {
      await _api().patch(
        '/v2/bookings/${booking['id']}/status',
        data: {'status': status},
      );
      onChanged();
    } catch (e) {
      if (kDebugMode) debugPrint('Booking status update failed: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not update booking. Please try again.')),
        );
      }
    }
  }

  Future<void> _acceptReschedule(BuildContext context) async {
    try {
      await _api().patch(
        '/v2/bookings/${booking['id']}/accept-reschedule',
        data: {'acceptedBy': 'STYLIST'},
      );
      onChanged();
    } catch (e) {
      if (kDebugMode) debugPrint('Reschedule accept failed: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not accept reschedule. Please try again.')),
        );
      }
    }
  }

  Future<void> _rejectReschedule(BuildContext context) async {
    try {
      await _api().patch(
        '/v2/bookings/${booking['id']}/reject-reschedule',
        data: {'rejectedBy': 'STYLIST'},
      );
      onChanged();
    } catch (e) {
      if (kDebugMode) debugPrint('Reschedule reject failed: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not reject reschedule. Please try again.')),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final suffix = date.hour >= 12 ? 'PM' : 'AM';
    return '${date.day}/${date.month}, $hour:$minute $suffix';
  }
}

class _StaffCard extends StatelessWidget {
  const _StaffCard({
    required this.relation,
    required this.saving,
    required this.onEdit,
    required this.onTogglePrice,
  });

  final Map<String, dynamic> relation;
  final bool saving;
  final VoidCallback onEdit;
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    Text(
                      user['name'] ?? 'Stylist',
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${stylist['registrationType'] ?? 'STYLIST'} - Active',
                      style: const TextStyle(color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Switch(
                value: canSetOwnPrice,
                onChanged: saving ? null : onTogglePrice,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${List<Map<String, dynamic>>.from(stylist['services'] ?? []).length} services',
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                key: Key(
                    'staff_edit_${relation['stylist']?['id'] ?? 'unknown'}'),
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String _dayLabel(dynamic dayOfWeek) {
  switch (dayOfWeek) {
    case 0:
      return 'Sun';
    case 1:
      return 'Mon';
    case 2:
      return 'Tue';
    case 3:
      return 'Wed';
    case 4:
      return 'Thu';
    case 5:
      return 'Fri';
    case 6:
      return 'Sat';
    default:
      return 'Day';
  }
}

String _bookingServiceSummary(Map<String, dynamic> booking) {
  final bundle = List<Map<String, dynamic>>.from(booking['services'] ?? []);
  final names = bundle
      .map((item) => item['service']?['name'])
      .whereType<String>()
      .where((name) => name.trim().isNotEmpty)
      .toList();

  if (names.isNotEmpty) {
    if (names.length == 1) return names.first;
    if (names.length == 2) return '${names[0]} + ${names[1]}';
    return '${names.first} + ${names.length - 1} more';
  }

  return booking['service']?['name'] ?? 'Service';
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
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Color(0xFF00796B),
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  const _EmptyCard({
    required this.text,
    this.actionLabel,
    this.actionKey,
    this.onAction,
  });

  final String text;
  final String? actionLabel;
  final Key? actionKey;
  final VoidCallback? onAction;

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
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 12),
            FilledButton.icon(
              key: actionKey,
              onPressed: onAction,
              icon: const Icon(Icons.add),
              label: Text(actionLabel!),
            ),
          ],
        ],
      ),
    );
  }
}

BoxDecoration _boxDecoration() => cardDecoration();

const _brand = AppColors.accent;

class RetentionScreen extends StatefulWidget {
  const RetentionScreen({super.key, required this.salon});

  final Map<String, dynamic> salon;

  @override
  State<RetentionScreen> createState() => _RetentionScreenState();
}

class _RetentionScreenState extends State<RetentionScreen> {
  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _data;
  List<Map<String, dynamic>> _atRisk = [];
  int _atRiskRevenue = 0;
  String? _selectedCohort; // 'retained' | 'new' | 'reactivated' | 'churned'
  bool _atRiskExpanded = false;
  bool _cohortExpanded = false;
  bool _missedExpanded = false;

  @override
  void initState() {
    super.initState();
    if (_hasAccess) {
      _load();
    } else {
      _loading = false;
    }
  }

  bool get _hasAccess =>
      '${widget.salon['saasPlan'] ?? 'FREE'}'.toUpperCase() != 'FREE';

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final id = widget.salon['id'];
      final results = await Future.wait([
        _api().get('/api/v2/salons/$id/retention'),
        _api().get('/api/v2/salons/$id/at-risk'),
      ]);
      if (mounted) {
        setState(() {
          _data = Map<String, dynamic>.from(results[0].data);
          final risk = Map<String, dynamic>.from(results[1].data);
          _atRisk = List<Map<String, dynamic>>.from(risk['customers'] ?? []);
          _atRiskRevenue = (risk['atRiskRevenue'] ?? 0) as int;
        });
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Retention load failed: $e');
      if (mounted) setState(() => _error = 'Could not load retention report.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _remind(Map<String, dynamic> c) async {
    final digits = '${c['phone'] ?? ''}'.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return;
    final intl = digits.length == 10 ? '91$digits' : digits;
    final name = '${c['name'] ?? 'there'}';
    final salonName = '${widget.salon['name'] ?? 'our salon'}';
    final text = Uri.encodeComponent(
      "Hi $name! We've missed you at $salonName. Book your next visit and "
      "enjoy a special welcome-back offer. See you soon!",
    );
    final uri = Uri.parse('https://wa.me/$intl?text=$text');
    try {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open WhatsApp')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open WhatsApp')),
        );
      }
    }
  }

  String _rupees(num paise) => '₹${(paise / 100).round()}';

  String _shortDate(String iso) {
    final d = DateTime.tryParse(iso)?.toLocal();
    if (d == null) return '';
    return '${d.day}/${d.month}/${d.year}';
  }

  /// "View all (N more)" / "Show less" toggle shown under a capped list.
  Widget _viewMore(int hidden, bool expanded, VoidCallback onTap) {
    if (hidden <= 0) return const SizedBox.shrink();
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: onTap,
        icon: Icon(expanded ? Icons.expand_less : Icons.expand_more, size: 18),
        label: Text(expanded ? 'Show less' : 'View all ($hidden more)'),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          minimumSize: const Size(0, 0),
        ),
      ),
    );
  }

  /// "Reach out now" — regulars overdue vs their own visit rhythm.
  Widget _atRiskSection() {
    if (_atRisk.isEmpty) return const SizedBox(height: 2);
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accentSoft,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.notifications_active_outlined,
                  color: AppColors.accent, size: 20),
              SizedBox(width: 8),
              Text('Reach out now',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${_atRisk.length} regulars are slipping · ${_rupees(_atRiskRevenue)} at risk',
            style: const TextStyle(fontSize: 13, color: AppColors.inkMuted),
          ),
          const SizedBox(height: 12),
          ...(_atRiskExpanded ? _atRisk : _atRisk.take(5)).map(_atRiskTile),
          _viewMore(_atRisk.length - 5, _atRiskExpanded,
              () => setState(() => _atRiskExpanded = !_atRiskExpanded)),
        ],
      ),
    );
  }

  Widget _atRiskTile(Map<String, dynamic> c) {
    final cadence = c['cadenceDays'] ?? 0;
    final overdue = c['overdueDays'] ?? 0;
    final ratio = (c['overdueRatio'] ?? 1).toString();
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text('${c['name'] ?? 'Customer'}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 15)),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppColors.dangerSoft,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('$ratio× overdue',
                          style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              color: AppColors.danger)),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  'Usually every ${cadence}d · ${overdue}d overdue · spent ${_rupees((c['totalSpend'] ?? 0) as int)}',
                  style: const TextStyle(fontSize: 12, color: AppColors.inkMuted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: () => _remind(c),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.whatsapp,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            icon: const Icon(Icons.chat, size: 16),
            label: const Text('Remind'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Retention report')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (!_hasAccess) return _upsell();
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!),
            const SizedBox(height: 12),
            FilledButton(onPressed: _load, child: const Text('Retry')),
          ],
        ),
      );
    }

    final data = _data!;
    final s = Map<String, dynamic>.from(data['summary'] ?? {});
    final missed = List<Map<String, dynamic>>.from(data['missed'] ?? []);
    final churn = (s['churnRate'] ?? 0).toDouble();
    final revThis = (s['revenueThisMonth'] ?? 0) as int;
    final revLast = (s['revenueLastMonth'] ?? 0) as int;
    final revDrop = (s['revenueDropPct'] ?? 0).toDouble();

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        key: const Key('retention_body'),
        padding: EdgeInsets.fromLTRB(
            16, 16, 16, 24 + MediaQuery.of(context).padding.bottom),
        children: [
          _atRiskSection(),
          Text(
            '${data['month']} vs ${data['previousMonth']}',
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 12),
          if (s['alert'] == true)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFDECEA),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFF5B5AE)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: Color(0xFFC0392B)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '${churn.toStringAsFixed(0)}% of last month\'s customers '
                      'did not return. Send them a reminder below.',
                      style: const TextStyle(
                          color: Color(0xFFC0392B), fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          // Cohort breakdown — interactive donut. Tap a slice to drill in.
          _cohortDonut(),
          const SizedBox(height: 16),
          _bigStat(
            'Churn (dropped customers)',
            '${churn.toStringAsFixed(0)}%',
            '${s['churnedCustomers'] ?? 0} of ${s['activeLastMonth'] ?? 0} last-month customers',
            churn >= 10 ? const Color(0xFFC0392B) : _brand,
          ),
          const SizedBox(height: 12),
          _bigStat(
            'Revenue this month',
            _rupees(revThis),
            revDrop > 0
                ? 'Down ${revDrop.toStringAsFixed(0)}% vs last month (${_rupees(revLast)})'
                : 'Up ${(-revDrop).toStringAsFixed(0)}% vs last month (${_rupees(revLast)})',
            revDrop > 0 ? const Color(0xFFC0392B) : const Color(0xFF2E7D32),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              const Text('Missed customers',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _brand.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('${missed.length}',
                    style: const TextStyle(
                        color: _brand, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text('Tap "Remind" to message them on WhatsApp.',
              style: TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 10),
          if (missed.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text('No customers missed this month. 🎉'),
            )
          else ...[
            ...(_missedExpanded ? missed : missed.take(10)).map(_missedTile),
            _viewMore(missed.length - 10, _missedExpanded,
                () => setState(() => _missedExpanded = !_missedExpanded)),
          ],
        ],
      ),
    );
  }

  List<(String, String, Color, List<dynamic>)> _cohortSlices() {
    final cohorts = Map<String, dynamic>.from(_data?['cohorts'] ?? {});
    List<dynamic> m(String k) => List<dynamic>.from(cohorts[k] ?? []);
    return [
      ('retained', 'Constant', AppColors.accent, m('retained')),
      ('new', 'New', AppColors.success, m('new')),
      ('reactivated', 'Back', AppColors.violet, m('reactivated')),
      ('churned', 'Churned', AppColors.danger, m('churned')),
    ];
  }

  Widget _cohortDonut() {
    final slices = _cohortSlices();
    final total = slices.fold<int>(0, (t, s) => t + s.$4.length);
    final sel = _selectedCohort == null
        ? null
        : slices.firstWhere((s) => s.$1 == _selectedCohort);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 196,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  centerSpaceRadius: 58,
                  sectionsSpace: 3,
                  startDegreeOffset: -90,
                  pieTouchData: PieTouchData(
                    touchCallback: (event, resp) {
                      if (event is FlTapUpEvent) {
                        final i = resp?.touchedSection?.touchedSectionIndex ?? -1;
                        if (i >= 0 && i < slices.length) {
                          setState(() {
                            final k = slices[i].$1;
                            _selectedCohort = _selectedCohort == k ? null : k;
                            _cohortExpanded = false;
                          });
                        }
                      }
                    },
                  ),
                  sections: [
                    for (final s in slices)
                      PieChartSectionData(
                        value: s.$4.isEmpty ? 0.0001 : s.$4.length.toDouble(),
                        color: (_selectedCohort != null && _selectedCohort != s.$1)
                            ? s.$3.withValues(alpha: 0.22)
                            : s.$3,
                        radius: _selectedCohort == s.$1 ? 34 : 26,
                        showTitle: false,
                      ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => setState(() => _selectedCohort = null),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${sel == null ? total : sel.$4.length}',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: sel == null ? AppColors.ink : sel.$3,
                      ),
                    ),
                    Text(
                      sel == null ? 'customers' : sel.$2.toLowerCase(),
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.inkMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [for (final s in slices) _legendChip(s)],
        ),
        if (sel != null) ...[
          const SizedBox(height: 14),
          _cohortDrill(sel),
        ],
      ],
    );
  }

  Widget _legendChip((String, String, Color, List<dynamic>) s) {
    final selected = _selectedCohort == s.$1;
    return GestureDetector(
      onTap: () => setState(() {
        _selectedCohort = selected ? null : s.$1;
        _cohortExpanded = false;
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
              color: selected ? AppColors.ink : AppColors.border,
              width: selected ? 1.4 : 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(color: s.$3, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text('${s.$2} ${s.$4.length}',
                style: const TextStyle(
                    fontSize: 12.5, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  Widget _cohortDrill((String, String, Color, List<dynamic>) s) {
    final isChurn = s.$1 == 'churned';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${s.$2} — ${s.$4.length}',
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w900, color: s.$3)),
        const SizedBox(height: 8),
        if (s.$4.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text('No ${s.$2.toLowerCase()} customers this period.',
                style: const TextStyle(color: AppColors.inkMuted)),
          )
        else ...[
          ...(_cohortExpanded ? s.$4 : s.$4.take(10)).map((m) =>
              _cohortMemberTile(Map<String, dynamic>.from(m as Map), isChurn)),
          _viewMore(s.$4.length - 10, _cohortExpanded,
              () => setState(() => _cohortExpanded = !_cohortExpanded)),
        ],
      ],
    );
  }

  Widget _cohortMemberTile(Map<String, dynamic> c, bool isChurn) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${c['name'] ?? 'Customer'}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 14.5)),
                const SizedBox(height: 2),
                Text(
                  '${c['visits'] ?? 0} visits · spent ${_rupees((c['totalSpend'] ?? 0) as int)} · last ${_shortDate('${c['lastVisit']}')}',
                  style:
                      const TextStyle(fontSize: 12, color: AppColors.inkMuted),
                ),
              ],
            ),
          ),
          if (isChurn) ...[
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: () => _remind(c),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.whatsapp,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              icon: const Icon(Icons.chat, size: 16),
              label: const Text('Remind'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _bigStat(String label, String value, String sub, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 13, color: Colors.black54)),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                  fontSize: 26, fontWeight: FontWeight.w900, color: color)),
          const SizedBox(height: 2),
          Text(sub, style: const TextStyle(fontSize: 12, color: Colors.black45)),
        ],
      ),
    );
  }

  Widget _missedTile(Map<String, dynamic> c) {
    final lapsed = c['status'] == 'LAPSED';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text('${c['name'] ?? 'Customer'}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 15)),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: lapsed
                            ? const Color(0xFFEDE7F6)
                            : const Color(0xFFFDECEA),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        lapsed ? 'LAPSED' : 'DROPPED',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: lapsed
                                ? const Color(0xFF6A1B9A)
                                : const Color(0xFFC0392B)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  'Last visit ${_shortDate('${c['lastVisit']}')} · '
                  '${c['visits'] ?? 0} visits · spent ${_rupees((c['totalSpend'] ?? 0) as int)}',
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: () => _remind(c),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF25D366),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            icon: const Icon(Icons.chat, size: 16),
            label: const Text('Remind'),
          ),
        ],
      ),
    );
  }

  Widget _upsell() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.workspace_premium_outlined,
                size: 56, color: _brand),
            const SizedBox(height: 16),
            const Text('Retention insights are a PRO feature',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            const Text(
              'See who stopped coming, your new-vs-returning split, and win '
              'back lost customers with one-tap reminders.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: () {},
              child: const Text('Upgrade to PRO'),
            ),
          ],
        ),
      ),
    );
  }
}

class UpdateRequiredScreen extends StatelessWidget {
  const UpdateRequiredScreen({super.key, required this.storeUrl});

  final String storeUrl;

  Future<void> _openStore(BuildContext context) async {
    if (storeUrl.isEmpty) return;
    final uri = Uri.tryParse(storeUrl);
    if (uri == null) return;
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the store')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: AppColors.accentSoft,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.system_update, size: 34, color: AppColors.accent),
                ),
                const SizedBox(height: 22),
                Text('Update required',
                    style: Theme.of(context).textTheme.displaySmall),
                const SizedBox(height: 10),
                Text(
                  'A newer version of the app is available. Please update to '
                  'keep using your salon dashboard.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 26),
                if (storeUrl.isNotEmpty)
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => _openStore(context),
                      icon: const Icon(Icons.download),
                      label: const Text('Update now'),
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
