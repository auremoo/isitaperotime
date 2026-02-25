import 'package:flutter_test/flutter_test.dart';
import 'package:isitaperotime/data/models/bar.dart';

void main() {
  group('Bar', () {
    test('fromOsmJson parses OSM format correctly', () {
      final json = {
        'fields': {
          'name': 'Le Petit Bar',
          'phone': '+33 1 23 45 67 89',
        },
        'geometry': {
          'type': 'Point',
          'coordinates': [4.847331, 45.759060],
        },
      };

      final bar = Bar.fromOsmJson(json);

      expect(bar.name, 'Le Petit Bar');
      expect(bar.latitude, closeTo(45.759, 0.001));
      expect(bar.longitude, closeTo(4.847, 0.001));
      expect(bar.phone, '+33 1 23 45 67 89');
    });

    test('fromOsmJson handles missing name', () {
      final json = {
        'fields': {},
        'geometry': {
          'type': 'Point',
          'coordinates': [2.0, 48.0],
        },
      };

      final bar = Bar.fromOsmJson(json);
      expect(bar.name, 'Bar inconnu');
    });

    test('fromOverpassJson parses Overpass API format', () {
      final json = {
        'type': 'node',
        'id': 123456,
        'lat': 48.8566,
        'lon': 2.3522,
        'tags': {
          'name': 'Bar Parisien',
          'phone': '+33 1 11 22 33 44',
          'opening_hours': 'Mo-Fr 17:00-02:00',
        },
      };

      final bar = Bar.fromOverpassJson(json);

      expect(bar.name, 'Bar Parisien');
      expect(bar.latitude, closeTo(48.856, 0.001));
      expect(bar.longitude, closeTo(2.352, 0.001));
      expect(bar.openingHours, 'Mo-Fr 17:00-02:00');
    });

    test('latLng returns correct LatLng', () {
      const bar = Bar(
        name: 'Test',
        latitude: 45.0,
        longitude: 4.0,
      );

      expect(bar.latLng.latitude, 45.0);
      expect(bar.latLng.longitude, 4.0);
    });

    test('toJson roundtrip', () {
      const original = Bar(
        name: 'Test Bar',
        latitude: 48.5,
        longitude: 2.3,
        phone: '0123456789',
        openingHours: '10:00-22:00',
      );

      final json = original.toJson();
      final restored = Bar.fromJson(json);

      expect(restored.name, original.name);
      expect(restored.latitude, original.latitude);
      expect(restored.phone, original.phone);
    });
  });
}
