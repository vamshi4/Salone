import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/stylist_provider.dart';
import 'stylist_profile_screen.dart';

class StylistsTab extends ConsumerWidget {
  const StylistsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stylistsAsync = ref.watch(stylistsProvider);

    return stylistsAsync.when(
      data: (stylists) {
        if (stylists.isEmpty) {
          return const _EmptyState();
        }

        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(stylistsProvider),
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            itemCount: stylists.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final stylist = stylists[index];
              final isExclusive = stylist.registrationType == 'SALON_EXCLUSIVE';
              final canBookHome = !isExclusive && stylist.homeServiceEnabled;

              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border:
                      Border.all(color: Colors.black.withValues(alpha: 0.07)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: stylist.avatarUrl,
                            width: 76,
                            height: 76,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => const _AvatarFallback(),
                            errorWidget: (_, __, ___) =>
                                const _AvatarFallback(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                stylist.displayName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.25,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF17121F),
                                ),
                              ),
                              const SizedBox(height: 7),
                              Row(
                                children: [
                                  const Icon(Icons.star_rounded,
                                      size: 18, color: Color(0xFFFFB000)),
                                  const SizedBox(width: 4),
                                  Text(
                                    stylist.rating.toStringAsFixed(1),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w800),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${stylist.totalReviews} reviews',
                                    style: const TextStyle(
                                      color: Color(0xFF756E80),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                stylist.priceText,
                                style: const TextStyle(
                                  color: Color(0xFF0F8D58),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (isExclusive)
                          const _StatusPill(
                            icon: Icons.storefront,
                            text: 'In-salon only',
                            color: Color(0xFF5B3DB8),
                            background: Color(0xFFF0ECFF),
                          ),
                        if (canBookHome)
                          const _StatusPill(
                            icon: Icons.home_outlined,
                            text: 'Home service',
                            color: Color(0xFF008F7A),
                            background: Color(0xFFE5F6F2),
                          ),
                        const _StatusPill(
                          icon: Icons.verified_outlined,
                          text: 'Verified',
                          color: Color(0xFF5E6572),
                          background: Color(0xFFF0F2F5),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon:
                                const Icon(Icons.chat_bubble_outline, size: 18),
                            label: const Text('Message'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      StylistProfileScreen(stylist: stylist)),
                            ),
                            icon: const Icon(Icons.calendar_month_outlined,
                                size: 18),
                            label: const Text('View profile'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
      loading: () => const _LoadingState(),
      error: (error, _) => _ErrorState(
        message: '$error',
        onRetry: () => ref.invalidate(stylistsProvider),
      ),
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  const _AvatarFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 76,
      height: 76,
      color: const Color(0xFFF0ECFF),
      child: const Icon(Icons.person_outline, color: Color(0xFF5B3DB8)),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.icon,
    required this.text,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final String text;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
                color: color, fontWeight: FontWeight.w800, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => Container(
        height: 176,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black.withValues(alpha: 0.07)),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No stylists available right now',
        style: TextStyle(fontWeight: FontWeight.w800, color: Color(0xFF756E80)),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined,
                size: 40, color: Color(0xFFE06464)),
            const SizedBox(height: 12),
            const Text(
              'Could not load stylists',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Color(0xFF756E80), fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
