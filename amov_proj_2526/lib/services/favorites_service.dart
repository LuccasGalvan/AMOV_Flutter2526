import 'package:shared_preferences/shared_preferences.dart';

class FavoritesService {
  static const _key = 'favorite_poi_ids';

  Future<Set<String>> loadFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? const [];
    return list.toSet();
  }

  Future<bool> isFavorite(String poiId) async {
    final ids = await loadFavoriteIds();
    return ids.contains(poiId);
  }

  Future<Set<String>> toggleFavorite(String poiId) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = (prefs.getStringList(_key) ?? const []).toSet();

    if (ids.contains(poiId)) {
      ids.remove(poiId);
    } else {
      ids.add(poiId);
    }

    await prefs.setStringList(_key, ids.toList());
    return ids;
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
