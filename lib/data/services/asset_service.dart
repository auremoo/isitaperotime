import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final assetServiceProvider = Provider<AssetService>((ref) => AssetService());

class AssetService {
  Future<List<Map<String, dynamic>>> loadJsonList(String assetPath) async {
    final jsonString = await rootBundle.loadString(assetPath);
    final decoded = json.decode(jsonString) as List;
    return decoded.cast<Map<String, dynamic>>();
  }
}
