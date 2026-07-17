import 'package:flutter/material.dart';

import '../theme.dart';

/// Generic bottom-sheet list picker used for country/language choices in
/// both the signup flow and the Account screen (so there's one shared
/// implementation instead of two copies).
class OptionPickerSheet<T> extends StatelessWidget {
  const OptionPickerSheet({
    super.key,
    required this.title,
    required this.options,
    required this.labelOf,
    required this.isSelected,
  });

  final String title;
  final List<T> options;
  final String Function(T) labelOf;
  final bool Function(T) isSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom),
        child: Container(
          margin: const EdgeInsets.all(12),
          decoration: cardDecoration(radius: AppRadius.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    return Material(
                      color: Colors.transparent,
                      child: ListTile(
                        title: Text(labelOf(option)),
                        trailing: isSelected(option) ? Icon(Icons.check, color: AppColors.accent) : null,
                        onTap: () => Navigator.of(context).pop(option),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
