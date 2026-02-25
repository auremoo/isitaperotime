import 'package:json_annotation/json_annotation.dart';
import 'package:latlong2/latlong.dart';

part 'bar.g.dart';

@JsonSerializable()
class Bar {
  final String name;
  final double latitude;
  final double longitude;
  @JsonKey(defaultValue: '')
  final String phone;
  @JsonKey(name: 'opening_hours', defaultValue: '')
  final String openingHours;

  const Bar({
    required this.name,
    required this.latitude,
    required this.longitude,
    this.phone = '',
    this.openingHours = '',
  });

  LatLng get latLng => LatLng(latitude, longitude);

  /// Parse from the existing osm-fr-bars.json format
  factory Bar.fromOsmJson(Map<String, dynamic> json) {
    final fieldsRaw = json['fields'];
    final fields = fieldsRaw is Map ? Map<String, dynamic>.from(fieldsRaw) : <String, dynamic>{};
    final geometryRaw = json['geometry'];
    final geometry = geometryRaw is Map ? Map<String, dynamic>.from(geometryRaw) : <String, dynamic>{};
    final coords = geometry['coordinates'] as List?;
    return Bar(
      name: (fields['name'] as String?) ?? 'Bar inconnu',
      latitude: coords != null ? (coords[1] as num).toDouble() : 0.0,
      longitude: coords != null ? (coords[0] as num).toDouble() : 0.0,
      phone: (fields['phone'] as String?) ?? '',
    );
  }

  /// Parse from Overpass API response
  factory Bar.fromOverpassJson(Map<String, dynamic> json) {
    final tags = json['tags'] as Map<String, dynamic>? ?? {};
    return Bar(
      name: (tags['name'] as String?) ?? 'Bar',
      latitude: (json['lat'] as num).toDouble(),
      longitude: (json['lon'] as num).toDouble(),
      phone: (tags['phone'] as String?) ?? '',
      openingHours: (tags['opening_hours'] as String?) ?? '',
    );
  }

  factory Bar.fromJson(Map<String, dynamic> json) => _$BarFromJson(json);
  Map<String, dynamic> toJson() => _$BarToJson(this);
}
