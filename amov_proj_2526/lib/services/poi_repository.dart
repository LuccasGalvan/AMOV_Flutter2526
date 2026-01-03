import 'dart:convert';
import 'package:flutter/services.dart';

import '../models/poi.dart';
import '../utils/app_constants.dart';

class PoiRepository {
  Future<List<Poi>> loadPois() async {
    final raw = await rootBundle.loadString(AppConstants.poiJsonAssetPath);
    final decoded = jsonDecode(raw);

    // Supports either:
    // 1) [ {poi}, {poi} ]
    // 2) { "pois": [ {poi}, {poi} ] }
    final List list;
    if (decoded is List) {
      list = decoded;
    } else if (decoded is Map<String, dynamic> && decoded['pois'] is List) {
      list = decoded['pois'] as List;
    } else {
      return const [];
    }

    return list
        .whereType<Map<String, dynamic>>()
        .map(Poi.fromJson)
        .toList();
  }

  Future<List<String>> loadCategories() async {
    final pois = await loadPois();

    final set = <String>{};
    for (final p in pois) {
      final c = p.category.trim();
      if (c.isNotEmpty) set.add(c);
    }

    final list = set.toList();
    list.sort();
    return list;
  }

  Future<List<Poi>> loadPoisByCategory(String category) async {
    final pois = await loadPois();
    return pois.where((p) => p.category == category).toList();
  }

  /// Normalize the image path (JSON gives relative path)
  /// Example JSON: "images/jeronimos.jpg" or "jeronimos.jpg"
  static String toAssetImagePath(String relative) {
    final r = relative.trim();
    if (r.isEmpty) return '';
    if (r.startsWith('assets/')) return r;
    if (r.startsWith('images/')) return 'assets/$r';
    return 'assets/images/$r';
  }
}
