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

/// Compact stat tile: muted label above, bold number/value below, on a
/// white [cardDecoration] surface. [accentColor], when given, adds a 3px
/// top border (the prototype's `.stat-card.accent/.success/.amber` — a
/// quick color-coded read without needing to read the label first).
class StatTile extends StatelessWidget {
  const StatTile({super.key, required this.label, required this.value, this.helper, this.accentColor});

  final String label;
  final String value;
  final String? helper;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    // BoxDecoration can't combine a borderRadius with a Border whose sides
    // have different colors (Flutter throws "A borderRadius can only be
    // given on borders with uniform colors") — so the accent top-bar has to
    // be a separate layer inside a ClipRRect, not a mixed-color Border.
    final radius = BorderRadius.circular(AppRadius.md);
    final content = Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.inkMuted, fontSize: 11, fontWeight: FontWeight.w600)),
          const SizedBox(height: 5),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 19)),
              if (helper != null) ...[
                const SizedBox(width: 4),
                Text(helper!, style: const TextStyle(color: AppColors.inkMuted, fontSize: 12)),
              ],
            ],
          ),
        ],
      ),
    );

    // Shadow lives on this outer, unclipped box; the inner ClipRRect only
    // clips the accent bar + white body to the rounded corners (clipping
    // the shadow itself would cut it off at the corners).
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [BoxShadow(color: AppColors.ink.withValues(alpha: 0.04), blurRadius: 14, offset: const Offset(0, 4))],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (accentColor != null) Container(height: 3, color: accentColor),
            content,
          ],
        ),
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

/// Shown instead of a tab's real content when viewing "All branches" — this
/// tab's data (services, products, retention/earnings) is inherently
/// per-salon and merging it correctly is out of scope, so we ask the owner
/// to pick one branch rather than showing something subtly wrong.
class PickBranchPlaceholder extends StatelessWidget {
  const PickBranchPlaceholder({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.storefront_outlined, size: 42, color: AppColors.inkFaint),
            const SizedBox(height: 12),
            Text(text, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
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

/// One icon+label button in a horizontal quick-actions row (Home screen).
/// Every quick action must map to a real flow — no decorative buttons that
/// only show a toast (the "Open Design" prototype this pattern is drawn
/// from has a couple of those; v4 only keeps the ones backed by a real
/// screen/sheet).
class QuickAction extends StatelessWidget {
  const QuickAction({super.key, required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        constraints: const BoxConstraints(minWidth: 80),
        decoration: cardDecoration(radius: AppRadius.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.accent, size: 26),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.inkMuted)),
          ],
        ),
      ),
    );
  }
}

/// Staggered fade+slide-up entrance for list items (stat cards, quick
/// actions, booking rows) — a lightweight, idiomatic-Flutter stand-in for
/// the "Open Design" prototype's CSS `fadeInUp` keyframe stagger, using
/// implicit animations instead of porting the JS timing code.
class EntranceFade extends StatefulWidget {
  const EntranceFade({super.key, required this.child, this.index = 0, this.delayStep = const Duration(milliseconds: 60)});

  final Widget child;
  final int index;
  final Duration delayStep;

  @override
  State<EntranceFade> createState() => _EntranceFadeState();
}

class _EntranceFadeState extends State<EntranceFade> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delayStep * widget.index, () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1 : 0,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOut,
      child: AnimatedSlide(
        offset: _visible ? Offset.zero : const Offset(0, 0.08),
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

/// Animates an integer value counting up from 0 on first build — used for
/// stat card numbers (Home/Insights), mirroring the prototype's count-up
/// effect via [TweenAnimationBuilder] instead of a manual `requestAnimationFrame`
/// loop. [formatter] renders the current interpolated value, e.g. as money.
class CountUpNumber extends StatelessWidget {
  const CountUpNumber({super.key, required this.value, required this.formatter, this.style});

  final int value;
  final String Function(int) formatter;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: value),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      builder: (context, animatedValue, _) => Text(formatter(animatedValue), style: style),
    );
  }
}
