import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../theme.dart';

/// Muted section heading used above a list (e.g. "Bookings", "Staff permissions").
class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title, this.trailing});

  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        if (trailing != null)
          Text(trailing!, style: const TextStyle(color: AppColors.inkMuted, fontSize: 13)),
      ],
    );
  }
}

/// Compact stat tile: muted label above, bold number/value below. Used in
/// the 2- and 3-up stat rows on Home, Bookings, Staff, and Insights.
class StatTile extends StatelessWidget {
  const StatTile({super.key, required this.label, required this.value, this.helper});

  final String label;
  final String value;
  final String? helper;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.surfaceAlt, borderRadius: BorderRadius.circular(AppRadius.md)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.inkMuted, fontSize: 12)),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 17)),
              if (helper != null) ...[
                const SizedBox(width: 4),
                Text(helper!, style: const TextStyle(color: AppColors.inkMuted, fontSize: 12)),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// A pill-shaped status/plan label, e.g. "Confirmed", "Repeat".
class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.label, this.color, this.background});

  final String label;
  final Color? color;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final fg = color ?? AppColors.accent;
    final bg = background ?? AppColors.accentSoft;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(AppRadius.pill)),
      child: Text(label, style: TextStyle(color: fg, fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }
}

/// Empty-state card with an icon, message, and optional action button.
class EmptyCard extends StatelessWidget {
  const EmptyCard({super.key, required this.text, this.actionLabel, this.actionKey, this.onAction});

  final String text;
  final String? actionLabel;
  final Key? actionKey;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: cardDecoration(),
      child: Column(
        children: [
          const Icon(Icons.inbox_outlined, size: 40, color: AppColors.inkFaint),
          const SizedBox(height: 10),
          Text(text, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w800)),
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

/// Full-width filled "New booking" call to action — the main action on
/// both Home and Bookings, kept as one shared widget so it always looks
/// and behaves the same everywhere it appears.
class NewBookingButton extends StatelessWidget {
  const NewBookingButton({super.key, required this.onPressed, this.compact = false});

  final VoidCallback onPressed;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    if (compact) {
      return FilledButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.add, size: 18),
        label: Text(t.newLabel),
      );
    }
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.add),
        label: Text(t.newBooking),
      ),
    );
  }
}
