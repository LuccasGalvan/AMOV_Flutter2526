import 'package:flutter/material.dart';

import '../models/poi.dart';
import '../services/favorites_service.dart';
import '../services/poi_repository.dart';
import 'poi_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final _favorites = FavoritesService();
  final _repo = PoiRepository();

  late Future<List<Poi>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<Poi>> _load() async {
    final ids = await _favorites.loadFavoriteIds();
    final pois = await _repo.loadPois();
    return pois.where((p) => ids.contains(p.id)).toList();
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Poi>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Failed to load favorites: ${snapshot.error}'));
        }

        final favs = snapshot.data ?? const [];
        if (favs.isEmpty) {
          return const Center(
            child: Text(
              'No favorites yet.\n\nOpen a POI and tap “Add to favorites”.',
              textAlign: TextAlign.center,
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: favs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final poi = favs[index];
              return Card(
                child: ListTile(
                  title: Text(poi.name),
                  subtitle: Text(poi.shortDescription),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => PoiDetailScreen(poi: poi)),
                    );
                    // When coming back, refresh list (because favorite state may change)
                    _refresh();
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
