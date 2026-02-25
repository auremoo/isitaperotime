import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/utils/time_utils.dart';
import '../../core/widgets/alcohol_disclaimer.dart';
import '../../data/services/email_service.dart';
import 'home_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeAsync = ref.watch(currentTimeProvider);
    final recommendation = ref.watch(drinkRecommendationProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Is it Ap\u00e9ro Time ?"),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const Spacer(flex: 2),
                // Clock
                timeAsync.when(
                  data: (now) => Text(
                    '${TimeUtils.formatTime(now.hour)} : ${TimeUtils.formatTime(now.minute)}',
                    style: theme.textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                      fontSize: 72,
                    ),
                  ).animate(onPlay: (c) => c.repeat()).shimmer(
                        duration: 3000.ms,
                        color: theme.colorScheme.tertiary.withValues(alpha: 0.3),
                      ),
                  loading: () => const CircularProgressIndicator(),
                  error: (_, __) => const Text('--:--'),
                ),
                const SizedBox(height: 24),
                // Recommendation card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 20.0,
                    ),
                    child: Text(
                      recommendation,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: 0.2, end: 0),
                const Spacer(flex: 2),
                // IBA button
                FilledButton.tonal(
                  onPressed: () {
                    ref
                        .read(emailServiceProvider)
                        .openUrl('https://iba-world.com');
                  },
                  child: const Text(
                    'IBA - International Bartenders Association',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(height: 8),
                const AlcoholDisclaimer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
