import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/widgets/loading_widget.dart';
import '../../core/widgets/app_error_widget.dart';
import '../../data/services/location_service.dart';
import 'map_provider.dart';
import 'widgets/bar_map.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final barsAsync = ref.watch(barsProvider);
    final locationAsync = ref.watch(userLocationProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bars \u00e0 proximit\u00e9'),
      ),
      body: barsAsync.when(
        data: (bars) {
          final location = locationAsync.valueOrNull;
          final center = LatLng(
            location?.latitude ?? LocationService.defaultLatitude,
            location?.longitude ?? LocationService.defaultLongitude,
          );

          return BarMap(
            bars: bars,
            center: center,
            mapController: _mapController,
          );
        },
        loading: () =>
            const LoadingWidget(message: 'Recherche des bars...'),
        error: (error, _) => AppErrorWidget(
          message: 'Impossible de charger les bars',
          onRetry: () => ref.invalidate(barsProvider),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final location = locationAsync.valueOrNull;
          if (location != null) {
            _mapController.move(
              LatLng(location.latitude, location.longitude),
              14.0,
            );
          }
        },
        child: const Icon(Icons.my_location_rounded),
      ),
    );
  }
}
