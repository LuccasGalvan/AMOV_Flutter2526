import 'package:flutter/material.dart';

import '../services/poi_repository.dart';
import 'poi_list_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = PoiRepository();

    return FutureBuilder<List<String>>(
      future: repo.loadCategories(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Failed to load categories: ${snapshot.error}'));
        }

        final categories = snapshot.data ?? const [];
        if (categories.isEmpty) {
          return const Center(child: Text('No categories found in poi.json'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: categories.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final cat = categories[index];
            return Card(
              child: ListTile(
                title: Text(cat),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => PoiListScreen(category: cat),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
