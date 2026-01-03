import 'package:flutter/material.dart';
import '../models/poi.dart';
import '../services/poi_repository.dart';

class PoiDetailScreen extends StatelessWidget {
  final Poi poi;
  const PoiDetailScreen({super.key, required this.poi});

  @override
  Widget build(BuildContext context) {
    final imgPath = PoiRepository.toAssetImagePath(poi.image); // img normalized

    return Scaffold(
      appBar: AppBar(title: const Text('POI Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(poi.name, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),

            if (imgPath.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imgPath, // ✅ use normalized path
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Image not found.\nCheck assets/images + pubspec.yaml + JSON path.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 12),
            Text(poi.description),

            const SizedBox(height: 16),
            Text('Schedule: ${poi.schedule}'),
            const SizedBox(height: 6),
            Text('Average price: €${poi.averagePrice.toStringAsFixed(2)}'),
            const SizedBox(height: 6),
            Text('Location: ${poi.location}'),

            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Favorites logic comes in Step 4')),
                );
              },
              icon: const Icon(Icons.favorite_border),
              label: const Text('Add to favorites'),
            ),
          ],
        ),
      ),
    );
  }
}
