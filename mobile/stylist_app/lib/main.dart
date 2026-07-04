import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() => runApp(const StylistApp());

class StylistApp extends StatelessWidget {
  const StylistApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF5B3DB8);
    const fontFamily = 'AppSans';

    return MaterialApp(
      title: 'Stylist Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: fontFamily,
        textTheme: ThemeData.light().textTheme.apply(
              fontFamily: fontFamily,
              bodyColor: const Color(0xFF17121F),
              displayColor: const Color(0xFF17121F),
            ),
        colorScheme: ColorScheme.fromSeed(seedColor: primary, primary: primary),
        scaffoldBackgroundColor: const Color(0xFFFAF7FC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFAF7FC),
          elevation: 0,
          scrolledUnderElevation: 0,
          foregroundColor: Color(0xFF17121F),
          titleTextStyle: TextStyle(
            fontFamily: fontFamily,
            color: Color(0xFF17121F),
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://10.0.2.2:3000',
  );

  final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl));
  Map<String, dynamic>? _stylist;
  List<Map<String, dynamic>> _bookings = [];
  List<Map<String, dynamic>> _availability = [];
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
      final listRes = await _dio.get('/api/v2/stylists');
      final stylists = List<Map<String, dynamic>>.from(listRes.data);
      final ravi = stylists.firstWhere(
        (stylist) => stylist['user']?['name'] == 'Ravi',
        orElse: () => stylists.first,
      );
      final detailRes = await _dio.get('/api/v2/stylists/${ravi['id']}');
      final bookingRes = await _dio.get('/v2/bookings/stylist/${ravi['id']}');
      final availabilityRes = await _dio.get(
        '/api/v2/stylists/${ravi['id']}/availability-rules',
      );

      setState(() {
        _stylist = Map<String, dynamic>.from(detailRes.data);
        _bookings = List<Map<String, dynamic>>.from(bookingRes.data);
        _availability = List<Map<String, dynamic>>.from(availabilityRes.data);
      });
    } catch (e) {
      _show('Error loading dashboard: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  bool get _isIndependent => _stylist?['registrationType'] == 'INDEPENDENT';
  bool get _canSetPrice =>
      _isIndependent || _stylist?['canSetOwnPrice'] == true;

  List<Map<String, dynamic>> get _services =>
      List<Map<String, dynamic>>.from(_stylist?['services'] ?? []);

  int get _todayBookings {
    final now = DateTime.now();
    return _bookings.where((booking) {
      final slot = DateTime.parse(booking['slotStart']);
      return slot.year == now.year &&
          slot.month == now.month &&
          slot.day == now.day;
    }).length;
  }

  int get _weekTotal {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    return _bookings.where((booking) {
      final slot = DateTime.parse(booking['slotStart']);
      return slot.isAfter(
        DateTime(weekStart.year, weekStart.month, weekStart.day),
      );
    }).fold<int>(
      0,
      (total, booking) => total + ((booking['stylistPayout'] ?? 0) as int),
    );
  }

  Future<void> _patchStylist(Map<String, dynamic> data) async {
    if (_stylist == null) return;
    setState(() => _saving = true);
    try {
      await _dio.patch('/api/v2/stylists/${_stylist!['id']}', data: data);
      await _loadDashboard();
      _show('Updated');
    } catch (e) {
      _show('Update failed: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _showPriceDialog() async {
    final controller = TextEditingController(
      text: (((_stylist?['basePrice'] ?? 0) as int) / 100).toStringAsFixed(0),
    );
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update price'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(prefixText: 'Rs '),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final rupees = int.tryParse(controller.text);
              if (rupees != null) _patchStylist({'basePrice': rupees * 100});
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _showServiceDialog([Map<String, dynamic>? service]) async {
    final nameController = TextEditingController(text: service?['name'] ?? '');
    final durationController = TextEditingController(
      text: '${service?['duration'] ?? 60}',
    );
    final priceController = TextEditingController(
      text:
          '${((service?['basePrice'] ?? _stylist?['basePrice'] ?? 50000) as int) ~/ 100}',
    );

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service == null ? 'Add service' : 'Edit service',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: nameController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Service name',
                    hintText: 'Haircut, facial, bridal styling',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: durationController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Duration',
                    suffixText: 'min',
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: priceController,
                  enabled: _canSetPrice,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    prefixText: 'Rs ',
                    helperText:
                        _canSetPrice ? null : 'Price is controlled by salon',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    if (service != null)
                      IconButton.outlined(
                        onPressed: _saving
                            ? null
                            : () {
                                Navigator.pop(context);
                                _deleteService(service);
                              },
                        icon: const Icon(Icons.delete_outline),
                        tooltip: 'Delete service',
                      ),
                    if (service != null) const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton(
                        onPressed: _saving
                            ? null
                            : () {
                                _saveService(
                                  service: service,
                                  name: nameController.text,
                                  duration: int.tryParse(
                                        durationController.text.trim(),
                                      ) ??
                                      60,
                                  price: int.tryParse(
                                        priceController.text.trim(),
                                      ) ??
                                      0,
                                );
                                Navigator.pop(context);
                              },
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveService({
    required Map<String, dynamic>? service,
    required String name,
    required int duration,
    required int price,
  }) async {
    if (_stylist == null) return;

    final trimmedName = name.trim();
    if (trimmedName.length < 2) {
      _show('Add a service name');
      return;
    }

    setState(() => _saving = true);
    try {
      final data = {
        'name': trimmedName,
        'category': 'Salon',
        'duration': duration,
        if (_canSetPrice) 'basePrice': price * 100,
      };

      if (service == null) {
        await _dio.post(
          '/api/v2/stylists/${_stylist!['id']}/services',
          data: data,
        );
      } else {
        await _dio.patch(
          '/api/v2/stylists/${_stylist!['id']}/services/${service['id']}',
          data: data,
        );
      }

      await _loadDashboard();
      _show(service == null ? 'Service added' : 'Service updated');
    } catch (e) {
      _show('Service save failed: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _deleteService(Map<String, dynamic> service) async {
    if (_stylist == null) return;

    setState(() => _saving = true);
    try {
      await _dio.delete(
        '/api/v2/stylists/${_stylist!['id']}/services/${service['id']}',
      );
      await _loadDashboard();
      _show('Service removed');
    } catch (e) {
      _show('Remove failed: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _addAvailability({required bool block}) async {
    if (_stylist == null) return;

    final dateController = TextEditingController(
      text: _dateParam(DateTime.now()),
    );
    final startController =
        TextEditingController(text: block ? '13:00' : '09:00');
    final endController =
        TextEditingController(text: block ? '14:00' : '18:00');
    int dayOfWeek = DateTime.now().weekday % 7;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) => Padding(
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    block ? 'Block time' : 'Set working hours',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (block)
                    TextField(
                      controller: dateController,
                      decoration: const InputDecoration(
                        labelText: 'Date',
                        helperText: 'YYYY-MM-DD',
                      ),
                    )
                  else
                    DropdownButtonFormField<int>(
                      initialValue: dayOfWeek,
                      decoration: const InputDecoration(labelText: 'Day'),
                      items: List.generate(7, (index) {
                        return DropdownMenuItem(
                          value: index,
                          child: Text(_dayName(index)),
                        );
                      }),
                      onChanged: (value) =>
                          setSheetState(() => dayOfWeek = value ?? dayOfWeek),
                    ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: startController,
                          decoration: const InputDecoration(
                            labelText: 'Start',
                            helperText: 'HH:mm',
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: endController,
                          decoration: const InputDecoration(
                            labelText: 'End',
                            helperText: 'HH:mm',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _saveAvailability(
                              block: block,
                              dayOfWeek: dayOfWeek,
                              date: dateController.text,
                              startTime: startController.text,
                              endTime: endController.text,
                            );
                          },
                          icon: Icon(block ? Icons.block : Icons.schedule),
                          label: const Text('Save'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveAvailability({
    required bool block,
    required int dayOfWeek,
    required String date,
    required String startTime,
    required String endTime,
  }) async {
    if (_stylist == null) return;

    setState(() => _saving = true);
    try {
      if (block) {
        await _dio.post(
          '/api/v2/stylists/${_stylist!['id']}/block',
          data: {
            'date': date.trim(),
            'startTime': startTime.trim(),
            'endTime': endTime.trim(),
          },
        );
      } else {
        await _dio.post(
          '/api/v2/stylists/${_stylist!['id']}/availability',
          data: {
            'dayOfWeek': dayOfWeek,
            'startTime': startTime.trim(),
            'endTime': endTime.trim(),
            'isBlocked': false,
          },
        );
      }

      await _loadDashboard();
      _show(block ? 'Blocked time added' : 'Working hours added');
    } catch (e) {
      _show('Availability save failed: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _deleteAvailability(Map<String, dynamic> rule) async {
    if (_stylist == null) return;

    setState(() => _saving = true);
    try {
      await _dio.delete(
        '/api/v2/stylists/${_stylist!['id']}/availability/${rule['id']}',
      );
      await _loadDashboard();
      _show('Availability rule removed');
    } catch (e) {
      _show('Remove failed: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String _dateParam(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
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

    final stylist = _stylist;
    if (stylist == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Dashboard')),
        body: Center(
          child: FilledButton.icon(
            onPressed: _loadDashboard,
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ),
      );
    }

    final price = ((stylist['basePrice'] ?? 0) as int) ~/ 100;

    return Scaffold(
      appBar: AppBar(
        title: Text(stylist['user']?['name'] ?? 'My Dashboard'),
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
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    icon: Icons.calendar_today,
                    label: 'Today',
                    value: '$_todayBookings',
                    color: const Color(0xFF5B3DB8),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MetricCard(
                    icon: Icons.payments_outlined,
                    label: 'This week',
                    value: 'Rs ${_weekTotal ~/ 100}',
                    color: const Color(0xFF0F8D58),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _SegmentedTabs(
              selectedIndex: _tabIndex,
              bookingsCount: _bookings.length,
              availabilityCount: _availability.length,
              onChanged: (index) => setState(() => _tabIndex = index),
            ),
            const SizedBox(height: 14),
            if (_tabIndex == 0) ...[
              const Text(
                'Incoming bookings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 10),
              if (_bookings.isEmpty)
                const _EmptyBookings()
              else
                _BookingQueue(
                  bookings: _bookings,
                  onChanged: _loadDashboard,
                ),
            ] else if (_tabIndex == 1) ...[
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Availability',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  IconButton.filledTonal(
                    onPressed:
                        _saving ? null : () => _addAvailability(block: false),
                    icon: const Icon(Icons.schedule),
                    tooltip: 'Add working hours',
                  ),
                  const SizedBox(width: 8),
                  IconButton.filledTonal(
                    onPressed:
                        _saving ? null : () => _addAvailability(block: true),
                    icon: const Icon(Icons.block),
                    tooltip: 'Block time',
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _AvailabilityCard(
                rules: _availability,
                saving: _saving,
                onDelete: _deleteAvailability,
              ),
            ] else ...[
              const Text(
                'Settings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 10),
              _SettingsCard(
                isIndependent: _isIndependent,
                canSetPrice: _canSetPrice,
                saving: _saving,
                price: price,
                services: _services,
                homeServiceEnabled: stylist['homeServiceEnabled'] == true,
                onHomeServiceChanged: (value) =>
                    _patchStylist({'homeServiceEnabled': value}),
                onEditPrice: _showPriceDialog,
                onAddService: () => _showServiceDialog(),
                onEditService: _showServiceDialog,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SegmentedTabs extends StatelessWidget {
  const _SegmentedTabs({
    required this.selectedIndex,
    required this.bookingsCount,
    required this.availabilityCount,
    required this.onChanged,
  });

  final int selectedIndex;
  final int bookingsCount;
  final int availabilityCount;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0ECFF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _TabButton(
            label: 'Bookings $bookingsCount',
            selected: selectedIndex == 0,
            onTap: () => onChanged(0),
          ),
          _TabButton(
            label: 'Hours $availabilityCount',
            selected: selectedIndex == 1,
            onTap: () => onChanged(1),
          ),
          _TabButton(
            label: 'Settings',
            selected: selectedIndex == 2,
            onTap: () => onChanged(2),
          ),
        ],
      ),
    );
  }
}

class _AvailabilityCard extends StatelessWidget {
  const _AvailabilityCard({
    required this.rules,
    required this.saving,
    required this.onDelete,
  });

  final List<Map<String, dynamic>> rules;
  final bool saving;
  final ValueChanged<Map<String, dynamic>> onDelete;

  @override
  Widget build(BuildContext context) {
    if (rules.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(18),
        decoration: _boxDecoration(),
        child: const Text(
          'Default hours are 9:00 AM to 6:00 PM. Add weekly hours or block time to control the real booking slots.',
          style: TextStyle(
            color: Color(0xFF756E80),
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    return Container(
      decoration: _boxDecoration(),
      child: Column(
        children: rules.map((rule) {
          final blocked = rule['isBlocked'] == true;
          final date = rule['date'] == null
              ? _dayName(rule['dayOfWeek'] ?? 0)
              : _formatDateText(rule['date']);

          return ListTile(
            leading: Icon(
              blocked ? Icons.block : Icons.schedule,
              color:
                  blocked ? const Color(0xFFE06464) : const Color(0xFF5B3DB8),
            ),
            title: Text(
              blocked ? 'Blocked time' : 'Working hours',
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
            subtitle: Text('$date  ${rule['startTime']} - ${rule['endTime']}'),
            trailing: IconButton(
              onPressed: saving ? null : () => onDelete(rule),
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Remove',
            ),
          );
        }).toList(),
      ),
    );
  }

  static String _formatDateText(String value) {
    final date = DateTime.parse(value).toLocal();
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _BookingQueue extends StatelessWidget {
  const _BookingQueue({
    required this.bookings,
    required this.onChanged,
  });

  final List<Map<String, dynamic>> bookings;
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
    required this.onChanged,
  });

  final String title;
  final List<Map<String, dynamic>> bookings;
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
              color: Color(0xFF756E80),
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        ...bookings.map(
          (booking) => _BookingCard(
            booking: booking,
            onChanged: onChanged,
            queueLabel: title,
          ),
        ),
      ],
    );
  }
}

String _dayName(int day) {
  const names = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];
  return names[day.clamp(0, 6)];
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
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
            label,
            style: TextStyle(
              color:
                  selected ? const Color(0xFF5B3DB8) : const Color(0xFF756E80),
              fontWeight: FontWeight.w900,
            ),
          ),
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
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
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
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF756E80),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.isIndependent,
    required this.canSetPrice,
    required this.saving,
    required this.price,
    required this.services,
    required this.homeServiceEnabled,
    required this.onHomeServiceChanged,
    required this.onEditPrice,
    required this.onAddService,
    required this.onEditService,
  });

  final bool isIndependent;
  final bool canSetPrice;
  final bool saving;
  final int price;
  final List<Map<String, dynamic>> services;
  final bool homeServiceEnabled;
  final ValueChanged<bool> onHomeServiceChanged;
  final VoidCallback onEditPrice;
  final VoidCallback onAddService;
  final ValueChanged<Map<String, dynamic>> onEditService;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _boxDecoration(),
      child: Column(
        children: [
          SwitchListTile(
            secondary: const Icon(Icons.home_outlined),
            title: const Text(
              'Home service',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
            subtitle: Text(
              isIndependent
                  ? 'Available for independent stylists'
                  : 'Salon exclusive',
            ),
            value: homeServiceEnabled,
            onChanged: saving || !isIndependent ? null : onHomeServiceChanged,
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.payments_outlined),
            title: const Text(
              'Base price',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
            subtitle: Text('Rs $price'),
            trailing: canSetPrice
                ? IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: saving ? null : onEditPrice,
                  )
                : const Text('Set by salon'),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Services & pricing',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: saving ? null : onAddService,
                  icon: const Icon(Icons.add),
                  tooltip: 'Add service',
                ),
              ],
            ),
          ),
          if (services.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F6FA),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'No services added yet. Add at least one service so customers can book the right treatment.',
                  style: TextStyle(
                    color: Color(0xFF756E80),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
          else
            ...services.map(
              (service) => _ServiceRow(
                service: service,
                canSetPrice: canSetPrice,
                onTap: () => onEditService(service),
              ),
            ),
        ],
      ),
    );
  }
}

class _ServiceRow extends StatelessWidget {
  const _ServiceRow({
    required this.service,
    required this.canSetPrice,
    required this.onTap,
  });

  final Map<String, dynamic> service;
  final bool canSetPrice;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final price = ((service['basePrice'] ?? 0) as int) ~/ 100;
    final duration = service['duration'] ?? 60;

    return ListTile(
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFFF0ECFF),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.spa_outlined, color: Color(0xFF5B3DB8)),
      ),
      title: Text(
        service['name'] ?? 'Service',
        style: const TextStyle(fontWeight: FontWeight.w900),
      ),
      subtitle: Text(
        '$duration min • ${canSetPrice ? 'Editable price' : 'Salon price'}',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Rs $price',
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.edit_outlined, size: 20),
        ],
      ),
      onTap: onTap,
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({
    required this.booking,
    required this.onChanged,
    required this.queueLabel,
  });

  final Map<String, dynamic> booking;
  final VoidCallback onChanged;
  final String queueLabel;

  @override
  Widget build(BuildContext context) {
    final service = booking['service']?['name'] ?? 'Service';
    final customer = booking['customer']?['name'] ?? 'Customer';
    final slot = DateTime.parse(booking['slotStart']);
    final payout = ((booking['stylistPayout'] ?? 0) as int) ~/ 100;
    final type =
        booking['serviceType'] == 'HOME_SERVICE' ? 'Home service' : 'In salon';
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
          Text(
            customer,
            style: const TextStyle(
              color: Color(0xFF756E80),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.schedule, size: 18, color: Color(0xFF5B3DB8)),
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
                  color: Color(0xFF0F8D58),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            type,
            style: const TextStyle(
              color: Color(0xFF756E80),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _queueHint(
              queueLabel: queueLabel,
              status: status,
              customerRequestedReschedule: customerRequestedReschedule,
            ),
            style: const TextStyle(
              color: Color(0xFF5B3DB8),
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
                IconButton.outlined(
                  onPressed: () => _reschedule(context),
                  icon: const Icon(Icons.schedule),
                  tooltip: 'Suggest new time',
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

  Future<void> _updateStatus(BuildContext context, String status) async {
    try {
      await Dio(
        BaseOptions(baseUrl: _DashboardScreenState.baseUrl),
      ).patch('/v2/bookings/${booking['id']}/status', data: {'status': status});
      onChanged();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Update failed: $e')));
      }
    }
  }

  Future<void> _reschedule(BuildContext context) async {
    final currentSlot = DateTime.parse(booking['slotStart']);
    final newTime = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _RescheduleSheet(
        currentSlot: currentSlot,
        stylistId: booking['stylistId'],
        serviceId: booking['serviceId'],
      ),
    );

    if (newTime == null) return;

    try {
      await Dio(BaseOptions(baseUrl: _DashboardScreenState.baseUrl)).patch(
        '/v2/bookings/${booking['id']}/reschedule',
        data: {
          'dateTime': newTime.toUtc().toIso8601String(),
          'proposedBy': 'STYLIST',
        },
      );
      onChanged();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Suggested next available slot')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Reschedule failed: $e')));
      }
    }
  }

  Future<void> _acceptReschedule(BuildContext context) async {
    try {
      await Dio(BaseOptions(baseUrl: _DashboardScreenState.baseUrl)).patch(
        '/v2/bookings/${booking['id']}/accept-reschedule',
        data: {'acceptedBy': 'STYLIST'},
      );
      onChanged();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Accept failed: $e')));
      }
    }
  }

  Future<void> _rejectReschedule(BuildContext context) async {
    try {
      await Dio(BaseOptions(baseUrl: _DashboardScreenState.baseUrl)).patch(
        '/v2/bookings/${booking['id']}/reject-reschedule',
        data: {'rejectedBy': 'STYLIST'},
      );
      onChanged();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Reject failed: $e')));
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

class _RescheduleSheet extends StatefulWidget {
  const _RescheduleSheet({
    required this.currentSlot,
    required this.stylistId,
    required this.serviceId,
  });

  final DateTime currentSlot;
  final String stylistId;
  final String serviceId;

  @override
  State<_RescheduleSheet> createState() => _RescheduleSheetState();
}

class _RescheduleSheetState extends State<_RescheduleSheet> {
  DateTime? _selectedSlot;
  List<DateTime> _slots = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadSlots();
  }

  Future<void> _loadSlots() async {
    setState(() {
      _loading = true;
      _error = null;
      _slots = [];
      _selectedSlot = null;
    });

    try {
      final date = _dateParam(widget.currentSlot);
      final res =
          await Dio(BaseOptions(baseUrl: _DashboardScreenState.baseUrl)).get(
        '/api/v2/stylists/${widget.stylistId}/availability',
        queryParameters: {'date': date, 'serviceId': widget.serviceId},
      );

      final slots = ((res.data['slots'] ?? []) as List)
          .map((slot) => DateTime.parse(slot['dateTime']).toLocal())
          .toList();

      setState(() {
        _slots = slots;
        _selectedSlot = slots.isNotEmpty ? slots.first : null;
        _error = slots.isEmpty ? 'No valid slots available.' : null;
      });
    } catch (e) {
      setState(() => _error = '$e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _dateParam(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '${date.year}-$month-$day';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Suggest new time',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 6),
            const Text(
              'Customer must accept this new time before booking is confirmed.',
              style: TextStyle(
                color: Color(0xFF756E80),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),
            if (_loading)
              const LinearProgressIndicator(minHeight: 3)
            else if (_error != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _error!,
                    style: const TextStyle(
                      color: Color(0xFFE06464),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
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
                children: _slots.map((slot) {
                  final selected = _selectedSlot != null &&
                      slot.isAtSameMomentAs(_selectedSlot!);
                  return ChoiceChip(
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
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _selectedSlot == null
                        ? null
                        : () => Navigator.pop(context, _selectedSlot),
                    icon: const Icon(Icons.schedule),
                    label: const Text('Send'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatSlot(DateTime slot) {
    final hour = slot.hour % 12 == 0 ? 12 : slot.hour % 12;
    final minute = slot.minute.toString().padLeft(2, '0');
    final suffix = slot.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $suffix';
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
        color: const Color(0xFFE8F7EF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Color(0xFF0F8D58),
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _EmptyBookings extends StatelessWidget {
  const _EmptyBookings();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _boxDecoration(),
      child: const Column(
        children: [
          Icon(Icons.event_busy_outlined, size: 40, color: Color(0xFF756E80)),
          SizedBox(height: 10),
          Text(
            'No bookings yet',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
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
        offset: const Offset(0, 8),
      ),
    ],
  );
}
