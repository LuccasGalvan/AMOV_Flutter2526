import 'package:flutter/material.dart';

import '../models/poi.dart';
import '../services/poi_repository.dart';
import 'poi_detail_screen.dart';

class PoiListScreen extends StatelessWidget {
  final String category;
  const PoiListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final repo = PoiRepository();

    return Scaffold(
      appBar: AppBar(title: Text('POIs — $category')),
      body: FutureBuilder<List<Poi>>(
        future: repo.loadPoisByCategory(category),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Failed to load POIs: ${snapshot.error}'));
          }

          final pois = snapshot.data ?? const [];
          if (pois.isEmpty) {
            return const Center(child: Text('No POIs for this category.'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: pois.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final poi = pois[index];
              return Card(
                child: ListTile(
                  title: Text(poi.name),
                  subtitle: Text(poi.shortDescription),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PoiDetailScreen(poi: poi),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
