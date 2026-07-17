import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/api.dart';
import '../core/format.dart';
import '../l10n/app_localizations.dart';
import '../shell/dashboard_data.dart';
import '../shell/dashboard_scope.dart';
import '../sheets/service_sheet.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// A starter set of common salon services an owner can add in one tap
/// instead of typing each one — shown only when the catalog is completely
/// empty. Prices/durations are reasonable India-market defaults (₹, minutes)
/// the owner can edit immediately after; matches the categories already
/// used in seed data (`backend/prisma/seed-demo.ts`).
const _kStarterServices = <(String name, String category, int duration, int priceRupees)>[
  ('Haircut', 'Hair', 30, 300),
  ('Hair Colour', 'Hair', 60, 1200),
  ('Hair Spa', 'Hair', 45, 900),
  ('Manicure', 'Nails', 30, 400),
  ('Pedicure', 'Nails', 40, 500),
  ('Facial', 'Skin', 45, 800),
  ('Beard Trim', 'Grooming', 20, 200),
];

/// Maps a service category to a representative icon — every service showed
/// the same scissor icon before regardless of category, which made the
/// catalog list harder to scan at a glance.
IconData categoryIcon(String category) {
  final c = category.toLowerCase();
  if (c.contains('nail')) return Icons.back_hand_outlined;
  if (c.contains('skin') || c.contains('facial')) return Icons.face_retouching_natural_outlined;
  if (c.contains('makeup')) return Icons.brush_outlined;
  if (c.contains('groom') || c.contains('beard') || c.contains('shave')) return Icons.face_outlined;
  if (c.contains('spa') || c.contains('massage')) return Icons.spa_outlined;
  if (c.contains('wax')) return Icons.water_drop_outlined;
  if (c.contains('hair')) return Icons.content_cut;
  return Icons.content_cut;
}

/// The salon-wide service catalog (v4 — new, replaces Account in the
/// bottom-nav tab bar). Reads from `salon['services']` — already included
/// in the `/api/v2/salons` payload `DashboardData.load()` fetches, so no
/// separate GET is needed here — and writes through the new
/// `/api/v2/salons/:salonId/services` endpoints via [ServiceSheet].
class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  String _query = '';
  String? _category; // null = all categories
  bool _addingStarterSet = false;

  Future<void> _addStarterServices(String salonId, DashboardData data) async {
    setState(() => _addingStarterSet = true);
    try {
      await Future.wait(_kStarterServices.map((s) => api().post('/api/v2/salons/$salonId/services', data: {
            'name': s.$1,
            'category': s.$2,
            'duration': s.$3,
            'basePrice': s.$4 * 100,
          })));
      await data.load();
    } catch (e) {
      if (kDebugMode) debugPrint('Starter services add failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.couldNotSaveService)));
      }
    } finally {
      if (mounted) setState(() => _addingStarterSet = false);
    }
  }

  Future<void> _openSheet({
    Map<String, dynamic>? service,
    required String salonId,
    required List<String> categories,
    required DashboardData data,
  }) async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ServiceSheet(
        salonId: salonId,
        service: service,
        categories: categories,
        staffRelations: data.staffRelations,
      ),
    );
    if (saved == true) await data.load();
  }

  /// `salon['services']` (from the shared `/api/v2/salons` payload) only has
  /// the flat `stylistId`, not a nested stylist name — cross-reference
  /// against the already-loaded staff list rather than a separate fetch.
  String? _stylistNameFor(String? stylistId, List<Map<String, dynamic>> staffRelations) {
    if (stylistId == null) return null;
    final match = staffRelations
        .map((r) => r['stylist'])
        .whereType<Map<String, dynamic>>()
        .where((s) => '${s['id']}' == stylistId);
    return match.isEmpty ? null : '${match.first['user']?['name'] ?? ''}';
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final data = DashboardScope.of(context);
    final salon = data.salon!;
    final salonId = '${salon['id']}';
    final allServices = List<Map<String, dynamic>>.from(salon['services'] ?? []);
    final categories = allServices.map((s) => '${s['category']}').toSet().toList()..sort();

    final filtered = allServices.where((s) {
      final matchesCategory = _category == null || '${s['category']}' == _category;
      final matchesQuery = _query.trim().isEmpty ||
          '${s['name']}'.toLowerCase().contains(_query.trim().toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();

    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final s in filtered) {
      grouped.putIfAbsent('${s['category']}', () => []).add(s);
    }
    final sortedCategories = grouped.keys.toList()..sort();

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: data.load,
          child: ListView(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 24 + MediaQuery.of(context).padding.bottom),
            children: [
              Row(
                children: [
                  Expanded(child: Text(t.statServices, style: Theme.of(context).textTheme.headlineSmall)),
                  FilledButton.icon(
                    onPressed: () => _openSheet(salonId: salonId, categories: categories, data: data),
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(t.addServiceTitle),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              TextField(
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: t.searchServicesHint,
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _chip(t.filterAllCategories, _category == null, () => setState(() => _category = null)),
                    for (final c in categories) ...[
                      const SizedBox(width: 8),
                      _chip(c, _category == c, () => setState(() => _category = c)),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (filtered.isEmpty) ...[
                EmptyCard(
                  text: t.noServicesInCatalog,
                  actionLabel: t.addServiceTitle,
                  onAction: () => _openSheet(salonId: salonId, categories: categories, data: data),
                ),
                if (allServices.isEmpty) ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _addingStarterSet ? null : () => _addStarterServices(salonId, data),
                      icon: _addingStarterSet
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.auto_awesome_outlined, size: 18),
                      label: Text(t.addStarterServicesButton),
                    ),
                  ),
                ],
              ] else
                for (final category in sortedCategories) ...[
                  SectionTitle(title: category),
                  const SizedBox(height: 8),
                  ...grouped[category]!.map((s) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _ServiceCard(
                          service: s,
                          staffName: _stylistNameFor(s['stylistId'] as String?, data.staffRelations),
                          onTap: () => _openSheet(service: s, salonId: salonId, categories: categories, data: data),
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

  Widget _chip(String label, bool selected, VoidCallback onTap) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      showCheckmark: false,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.accent,
      backgroundColor: AppColors.surface,
      labelStyle: TextStyle(
        color: selected ? Colors.white : AppColors.inkMuted,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.service, required this.onTap, this.staffName});

  final Map<String, dynamic> service;
  final VoidCallback onTap;
  final String? staffName;

  @override
  Widget build(BuildContext context) {
    final duration = (service['duration'] ?? 0) as int;
    final price = (service['basePrice'] ?? 0) as int;
    final meta = staffName == null || staffName!.isEmpty ? '$duration min' : '$duration min · $staffName';
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: cardDecoration(),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: AppColors.accentSoft, borderRadius: BorderRadius.circular(AppRadius.sm)),
              child: Icon(categoryIcon('${service['category']}'), color: AppColors.accent, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${service['name']}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(meta, style: const TextStyle(color: AppColors.inkMuted, fontSize: 12)),
                ],
              ),
            ),
            Text(formatMoney(price), style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          ],
        ),
      ),
    );
  }
}
