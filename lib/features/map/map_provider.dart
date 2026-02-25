import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../../data/models/bar.dart';
import '../../data/repositories/bar_repository.dart';
import '../../data/services/location_service.dart';

final userLocationProvider = FutureProvider<Position?>((ref) async {
  return ref.watch(locationServiceProvider).getCurrentPosition();
});

final barsProvider = FutureProvider<List<Bar>>((ref) async {
  final location = await ref.watch(userLocationProvider.future);
  final lat = location?.latitude ?? LocationService.defaultLatitude;
  final lon = location?.longitude ?? LocationService.defaultLongitude;
  return ref.watch(barRepositoryProvider).getBarsNear(
        latitude: lat,
        longitude: lon,
      );
});
