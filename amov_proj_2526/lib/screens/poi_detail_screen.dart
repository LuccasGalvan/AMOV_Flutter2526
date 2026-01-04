import 'package:flutter/material.dart';
import '../models/poi.dart';
import '../services/favorites_service.dart';
import '../services/poi_repository.dart';

class PoiDetailScreen extends StatefulWidget {
  final Poi poi;
  const PoiDetailScreen({super.key, required this.poi});

  @override
  State<PoiDetailScreen> createState() => _PoiDetailScreenState();
}

class _PoiDetailScreenState extends State<PoiDetailScreen> {
  final _favorites = FavoritesService();

  bool _loadingFav = true;
  bool _isFav = false;

  @override
  void initState() {
    super.initState();
    _loadFav();
  }

  Future<void> _loadFav() async {
    final isFav = await _favorites.isFavorite(widget.poi.id);
    if (!mounted) return;
    setState(() {
      _isFav = isFav;
      _loadingFav = false;
    });
  }

  Future<void> _toggleFav() async {
    setState(() => _loadingFav = true);
    final ids = await _favorites.toggleFavorite(widget.poi.id);
    if (!mounted) return;
    setState(() {
      _isFav = ids.contains(widget.poi.id);
      _loadingFav = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFav ? 'Added to favorites' : 'Removed from favorites'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final poi = widget.poi;
    final imgPath = PoiRepository.toAssetImagePath(poi.image);

    return Scaffold(
      appBar: AppBar(title: const Text('POI Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(poi.name, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),

            Text(poi.shortDescription),
            const SizedBox(height: 12),

            if (imgPath.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imgPath,
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
              onPressed: _loadingFav ? null : _toggleFav,
              icon: _loadingFav
                  ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : Icon(_isFav ? Icons.favorite : Icons.favorite_border),
              label: Text(_isFav ? 'Remove from favorites' : 'Add to favorites'),
            ),
          ],
        ),
      ),
    );
  }
}
