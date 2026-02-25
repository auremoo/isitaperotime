import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/bar.dart';

final overpassServiceProvider =
    Provider<OverpassService>((ref) => OverpassService());

class OverpassService {
  static const String _baseUrl = 'https://overpass-api.de/api/interpreter';

  Future<List<Bar>> fetchBarsNear({
    required double latitude,
    required double longitude,
    int radiusMeters = 5000,
  }) async {
    final query = '''
[out:json][timeout:25];
(
  node["amenity"="bar"](around:$radiusMeters,$latitude,$longitude);
  node["amenity"="pub"](around:$radiusMeters,$latitude,$longitude);
);
out body;
''';

    final response = await http
        .post(
          Uri.parse(_baseUrl),
          body: {'data': query},
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode != 200) {
      throw Exception('Overpass API error: ${response.statusCode}');
    }

    final data = json.decode(response.body) as Map<String, dynamic>;
    final elements = data['elements'] as List;
    return elements
        .map((e) => Bar.fromOverpassJson(e as Map<String, dynamic>))
        .toList();
  }
}
