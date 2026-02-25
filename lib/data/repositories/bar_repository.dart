import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/bar.dart';
import '../services/asset_service.dart';
import '../services/overpass_service.dart';

final barRepositoryProvider = Provider<BarRepository>((ref) {
  return BarRepository(
    ref.watch(assetServiceProvider),
    ref.watch(overpassServiceProvider),
  );
});

class BarRepository {
  final AssetService _assetService;
  final OverpassService _overpassService;

  BarRepository(this._assetService, this._overpassService);

  /// Try Overpass API first, fall back to local JSON
  Future<List<Bar>> getBarsNear({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final bars = await _overpassService.fetchBarsNear(
        latitude: latitude,
        longitude: longitude,
      );
      if (bars.isNotEmpty) return bars;
    } catch (_) {
      // Overpass failed, fall through to local data
    }
    return _getLocalBarsNear(latitude, longitude);
  }

  Future<List<Bar>> _getLocalBarsNear(double lat, double lon) async {
    final jsonList =
        await _assetService.loadJsonList('assets/data/osm-fr-bars.json');
    final allBars = jsonList.map(Bar.fromOsmJson).toList();

    // Filter to bars within ~50km radius to avoid loading everything
    final filtered = allBars.where((bar) {
      final dLat = (bar.latitude - lat).abs();
      final dLon = (bar.longitude - lon).abs();
      return dLat < 0.5 && dLon < 0.5; // ~50km approximation
    }).toList();

    return filtered.isNotEmpty ? filtered : allBars.take(200).toList();
  }
}
