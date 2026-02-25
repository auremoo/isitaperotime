import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/time_utils.dart';

final currentTimeProvider = StreamProvider<DateTime>((ref) {
  return Stream.periodic(
    const Duration(seconds: 1),
    (_) => DateTime.now(),
  );
});

final drinkRecommendationProvider = Provider<String>((ref) {
  final timeAsync = ref.watch(currentTimeProvider);
  return timeAsync.when(
    data: (now) => TimeUtils.whatToDo(now.hour, now.minute),
    loading: () => '...',
    error: (_, __) => 'Erreur',
  );
});
