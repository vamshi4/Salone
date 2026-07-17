import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../screens/products_screen.dart';
import '../shell/dashboard_scope.dart';
import '../theme.dart';

/// Home card surfacing products at/below their low-stock threshold —
/// matches MorningBriefingCard's "surface urgent stuff on Home" pattern
/// rather than a badge on a tab (Products isn't a tab, and a badge on a
/// rarely-visited screen is easy to miss). Reads `salon['products']`
/// directly, already embedded in the shared /api/v2/salons payload — no
/// separate fetch needed, unlike MorningBriefingCard's at-risk section.
class LowStockCard extends StatelessWidget {
  const LowStockCard({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final data = DashboardScope.of(context);
    final salon = data.currentSalon;
    final products = List<Map<String, dynamic>>.from(salon?['products'] ?? []);
    final lowStock = products
        .where((p) => ((p['stockQty'] ?? 0) as int) <= ((p['lowStockThreshold'] ?? 0) as int))
        .toList();

    if (lowStock.isEmpty) return const SizedBox.shrink();

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ProductsScreen(data: data, onlyLowStock: true)),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: cardDecoration(borderColor: AppColors.danger),
        child: Row(
          children: [
            const Icon(Icons.inventory_2_outlined, color: AppColors.danger, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                t.lowStockCount(lowStock.length),
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.danger),
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.danger, size: 20),
          ],
        ),
      ),
    );
  }
}
