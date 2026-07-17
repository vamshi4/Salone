import 'package:flutter/material.dart';

import '../core/format.dart';
import '../l10n/app_localizations.dart';
import '../shell/dashboard_data.dart';
import '../sheets/product_sheet.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// Retail inventory catalog — structurally mirrors services_screen.dart
/// (search + category chips + grouped list + add/edit via one sheet), but
/// reached as a pushed screen rather than a bottom-nav tab: inventory is
/// checked far less often than the 5 daily-use tabs, so it doesn't earn tab
/// real estate — same "not everything is a tab" precedent Account already
/// set. Filters to only low-stock items when opened from the Home
/// LowStockCard via [onlyLowStock].
class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key, required this.data, this.onlyLowStock = false});

  final DashboardData data;
  final bool onlyLowStock;

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  String _query = '';
  String? _category;
  late bool _lowStockOnly = widget.onlyLowStock;

  Future<void> _openSheet({
    Map<String, dynamic>? product,
    required String salonId,
    required List<String> categories,
    required DashboardData data,
  }) async {
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProductSheet(salonId: salonId, product: product, categories: categories),
    );
    if (saved == true) await data.load();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.data,
      builder: (context, _) => _buildScaffold(context),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final data = widget.data;
    final salon = data.currentSalon!;
    final salonId = '${salon['id']}';
    final allProducts = List<Map<String, dynamic>>.from(salon['products'] ?? []);
    final categories = allProducts.map((p) => '${p['category']}').toSet().toList()..sort();

    bool isLowStock(Map<String, dynamic> p) =>
        ((p['stockQty'] ?? 0) as int) <= ((p['lowStockThreshold'] ?? 0) as int);

    final filtered = allProducts.where((p) {
      final matchesCategory = _category == null || '${p['category']}' == _category;
      final matchesQuery =
          _query.trim().isEmpty || '${p['name']}'.toLowerCase().contains(_query.trim().toLowerCase());
      final matchesLowStock = !_lowStockOnly || isLowStock(p);
      return matchesCategory && matchesQuery && matchesLowStock;
    }).toList();

    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final p in filtered) {
      grouped.putIfAbsent('${p['category']}', () => []).add(p);
    }
    final sortedCategories = grouped.keys.toList()..sort();

    return Scaffold(
      appBar: AppBar(title: Text(t.productsTitle)),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: data.load,
          child: ListView(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 24 + MediaQuery.of(context).padding.bottom),
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (v) => setState(() => _query = v),
                      decoration: InputDecoration(
                        hintText: t.searchProductsHint,
                        prefixIcon: const Icon(Icons.search),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  FilledButton.icon(
                    onPressed: () => _openSheet(salonId: salonId, categories: categories, data: data),
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(t.addProductTitle),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _chip(t.filterAllCategories, !_lowStockOnly && _category == null,
                        () => setState(() {
                              _category = null;
                              _lowStockOnly = false;
                            })),
                    const SizedBox(width: 8),
                    _chip(t.filterLowStock, _lowStockOnly, () => setState(() => _lowStockOnly = !_lowStockOnly)),
                    for (final c in categories) ...[
                      const SizedBox(width: 8),
                      _chip(c, !_lowStockOnly && _category == c, () => setState(() {
                            _category = c;
                            _lowStockOnly = false;
                          })),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (filtered.isEmpty)
                EmptyCard(
                  text: _lowStockOnly ? t.noLowStockProducts : t.noProductsInCatalog,
                  actionLabel: t.addProductTitle,
                  onAction: () => _openSheet(salonId: salonId, categories: categories, data: data),
                )
              else
                for (final category in sortedCategories) ...[
                  SectionTitle(title: category),
                  const SizedBox(height: 8),
                  ...grouped[category]!.map((p) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _ProductCard(
                          product: p,
                          lowStock: isLowStock(p),
                          onTap: () => _openSheet(product: p, salonId: salonId, categories: categories, data: data),
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

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product, required this.onTap, required this.lowStock});

  final Map<String, dynamic> product;
  final VoidCallback onTap;
  final bool lowStock;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final price = (product['retailPrice'] ?? 0) as int;
    final stock = (product['stockQty'] ?? 0) as int;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: cardDecoration(borderColor: lowStock ? AppColors.danger : AppColors.border),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: AppColors.accentSoft, borderRadius: BorderRadius.circular(AppRadius.sm)),
              child: Icon(Icons.inventory_2_outlined, color: AppColors.accent, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${product['name']}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(t.stockCount(stock), style: const TextStyle(color: AppColors.inkMuted, fontSize: 12)),
                      if (lowStock) ...[
                        const SizedBox(width: 6),
                        StatusPill(label: t.lowStockLabel, color: AppColors.danger, background: AppColors.dangerSoft),
                      ],
                    ],
                  ),
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
