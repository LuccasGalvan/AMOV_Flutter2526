import 'package:flutter/material.dart';
import '../models/poi.dart';

class PoiCard extends StatelessWidget {
  final Poi poi;
  final VoidCallback onTap;

  const PoiCard({super.key, required this.poi, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(poi.name),
        subtitle: Text(
          poi.shortDescription,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
