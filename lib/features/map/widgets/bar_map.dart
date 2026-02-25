import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import '../../../data/models/bar.dart';

class BarMap extends StatelessWidget {
  final List<Bar> bars;
  final LatLng center;
  final MapController mapController;

  const BarMap({
    super.key,
    required this.bars,
    required this.center,
    required this.mapController,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FlutterMap(
      mapController: mapController,
      options: MapOptions(
        initialCenter: center,
        initialZoom: 13.0,
        minZoom: 3.0,
        maxZoom: 18.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.moo.isitaperotime',
        ),
        MarkerClusterLayerWidget(
          options: MarkerClusterLayerOptions(
            maxClusterRadius: 120,
            disableClusteringAtZoom: 16,
            size: const Size(50, 50),
            markers: bars.map((bar) {
              return Marker(
                point: bar.latLng,
                width: 40,
                height: 40,
                child: GestureDetector(
                  onTap: () => _showBarInfo(context, bar),
                  child: Icon(
                    Icons.local_bar_rounded,
                    color: theme.colorScheme.primary,
                    size: 32,
                  ),
                ),
              );
            }).toList(),
            builder: (context, markers) {
              return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Text(
                  '${markers.length}',
                  style: TextStyle(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showBarInfo(BuildContext context, Bar bar) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_bar_rounded,
                    color: theme.colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    bar.name,
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            if (bar.phone.isNotEmpty) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.phone_rounded, size: 18),
                  const SizedBox(width: 8),
                  Text(bar.phone),
                ],
              ),
            ],
            if (bar.openingHours.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.access_time_rounded, size: 18),
                  const SizedBox(width: 8),
                  Expanded(child: Text(bar.openingHours)),
                ],
              ),
            ],
            const SizedBox(height: 8),
            Text(
              '${bar.latitude.toStringAsFixed(5)}, ${bar.longitude.toStringAsFixed(5)}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
