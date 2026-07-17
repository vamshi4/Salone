import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/api.dart';
import '../core/format.dart';
import '../l10n/app_localizations.dart';
import '../theme.dart';

/// Add/edit a retail inventory item. Structurally mirrors service_sheet.dart
/// (same salon-scoped CRUD shape, same sheet chrome) but simpler — Product
/// has no staff-assignment concept, so no staff picker.
class ProductSheet extends StatefulWidget {
  const ProductSheet({
    super.key,
    required this.salonId,
    this.product,
    this.categories = const [],
  });

  final String salonId;
  final Map<String, dynamic>? product;
  final List<String> categories;

  @override
  State<ProductSheet> createState() => _ProductSheetState();
}

class _ProductSheetState extends State<ProductSheet> {
  late final _nameController = TextEditingController(text: '${widget.product?['name'] ?? ''}');
  late final _categoryController = TextEditingController(
      text: '${widget.product?['category'] ?? (widget.categories.isNotEmpty ? widget.categories.first : 'Retail')}');
  late final _skuController = TextEditingController(text: '${widget.product?['sku'] ?? ''}');
  late final _priceController = TextEditingController(
      text: widget.product == null ? '' : (((widget.product!['retailPrice'] ?? 0) as int) / 100).toStringAsFixed(0));
  late final _stockController = TextEditingController(text: '${widget.product?['stockQty'] ?? 0}');
  late final _lowStockController = TextEditingController(text: '${widget.product?['lowStockThreshold'] ?? 5}');

  bool _saving = false;
  bool _deleting = false;
  String? _error;

  bool get _isEdit => widget.product != null;

  AppLocalizations get t => AppLocalizations.of(context)!;

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _skuController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _lowStockController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    final category = _categoryController.text.trim();
    final priceMajor = double.tryParse(_priceController.text.trim());
    final stockQty = int.tryParse(_stockController.text.trim());
    final lowStockThreshold = int.tryParse(_lowStockController.text.trim());

    if (name.length < 2 ||
        category.isEmpty ||
        priceMajor == null ||
        priceMajor < 0 ||
        stockQty == null ||
        stockQty < 0 ||
        lowStockThreshold == null ||
        lowStockThreshold < 0) {
      setState(() => _error = t.fillProductFields);
      return;
    }

    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final body = {
        'name': name,
        'category': category,
        'sku': _skuController.text.trim().isEmpty ? null : _skuController.text.trim(),
        'retailPrice': (priceMajor * 100).round(),
        'stockQty': stockQty,
        'lowStockThreshold': lowStockThreshold,
      };
      if (_isEdit) {
        await api().patch('/api/v2/salons/${widget.salonId}/products/${widget.product!['id']}', data: body);
      } else {
        await api().post('/api/v2/salons/${widget.salonId}/products', data: body);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (kDebugMode) debugPrint('Product save failed: $e');
      if (mounted) setState(() => _error = t.couldNotSaveProduct);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
    setState(() {
      _deleting = true;
      _error = null;
    });
    try {
      await api().delete('/api/v2/salons/${widget.salonId}/products/${widget.product!['id']}');
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (kDebugMode) debugPrint('Product delete failed: $e');
      if (mounted) setState(() => _error = t.couldNotSaveProduct);
    } finally {
      if (mounted) setState(() => _deleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 12, 20, 24 + MediaQuery.of(context).viewPadding.bottom),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              Text(_isEdit ? t.editProductTitle : t.addProductTitle, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: t.productNameLabel),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _categoryController,
                      decoration: InputDecoration(labelText: t.categoryLabel),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _skuController,
                      decoration: InputDecoration(labelText: t.skuLabel),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: t.priceLabel, prefixText: '${CurrencyController.instance.symbol} '),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _stockController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: t.stockQtyLabel),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _lowStockController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: t.lowStockThresholdLabel),
                    ),
                  ),
                ],
              ),
              if (_error != null) ...[
                const SizedBox(height: 10),
                Text(_error!, style: const TextStyle(color: AppColors.danger, fontSize: 13, fontWeight: FontWeight.w600)),
              ],
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _saving || _deleting ? null : _save,
                  child: _saving
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text(_isEdit ? t.saveDetailsButton : t.addProductTitle),
                ),
              ),
              if (_isEdit) ...[
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _saving || _deleting ? null : _delete,
                    style: OutlinedButton.styleFrom(foregroundColor: AppColors.danger, side: const BorderSide(color: Color(0xFFE8B4AC))),
                    child: _deleting
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : Text(t.deleteProductButton),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
