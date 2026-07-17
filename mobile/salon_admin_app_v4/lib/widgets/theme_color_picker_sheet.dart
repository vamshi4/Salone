import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme.dart';

/// Bottom sheet for changing the accent color from Account -> Appearance.
/// Same 5 swatches offered at signup (see SignupFlow step 3); returns the
/// chosen [AppColorSeed] on pop, or null if dismissed without a change.
class ThemeColorPickerSheet extends StatefulWidget {
  const ThemeColorPickerSheet({super.key, required this.initial});

  final AppColorSeed initial;

  @override
  State<ThemeColorPickerSheet> createState() => _ThemeColorPickerSheetState();
}

class _ThemeColorPickerSheetState extends State<ThemeColorPickerSheet> {
  late AppColorSeed _selected = widget.initial;

  AppLocalizations get t => AppLocalizations.of(context)!;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom),
        child: Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(18),
          decoration: cardDecoration(radius: AppRadius.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t.themeColorTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [for (final seed in kAppColorSeeds) _swatch(seed)],
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(backgroundColor: _selected.color),
                  onPressed: () => Navigator.of(context).pop(_selected),
                  child: Text(t.save),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _swatch(AppColorSeed seed) {
    final selected = seed.id == _selected.id;
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _selected = seed),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: seed.color,
              shape: BoxShape.circle,
              border: selected ? Border.all(color: seed.color, width: 2) : null,
              boxShadow: selected
                  ? [BoxShadow(color: seed.color.withValues(alpha: 0.25), blurRadius: 0, spreadRadius: 3)]
                  : null,
            ),
            child: selected ? const Icon(Icons.check, color: Colors.white, size: 18) : null,
          ),
        ),
        const SizedBox(height: 6),
        Text(colorSeedLabel(t, seed.id), style: const TextStyle(fontSize: 10, color: AppColors.inkMuted)),
      ],
    );
  }
}
