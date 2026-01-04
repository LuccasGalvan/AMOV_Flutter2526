class Poi {
  final String id;
  final String name;
  final String shortDescription;
  final String description;
  final String image;
  final String schedule;
  final double averagePrice;
  final String location;

  // now supports multiple categories
  final List<String> categories;

  const Poi({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.description,
    required this.image,
    required this.schedule,
    required this.averagePrice,
    required this.location,
    required this.categories,
  });

  factory Poi.fromJson(Map<String, dynamic> json) {
    final avg = json['average_price'];

    // accept either "category": "X" or "categories": ["X","Y"]
    final rawCats = json['categories'];
    final rawCat = json['category'];

    final List<String> categories = (rawCats is List)
        ? rawCats.map((e) => e.toString()).where((s) => s.trim().isNotEmpty).toList()
        : (rawCat != null && rawCat.toString().trim().isNotEmpty)
        ? [rawCat.toString()]
        : const [];

    return Poi(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      shortDescription: (json['short_description'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      image: (json['image'] ?? '').toString(),
      schedule: (json['schedule'] ?? '').toString(),
      averagePrice: avg is num ? avg.toDouble() : double.tryParse('$avg') ?? 0.0,
      location: (json['location'] ?? '').toString(),
      categories: categories,
    );
  }
}
