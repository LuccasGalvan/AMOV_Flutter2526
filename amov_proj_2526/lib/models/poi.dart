class Poi {
  final String id;
  final String name;
  final String shortDescription;
  final String description;
  final String image;       // relative path from JSON
  final String schedule;
  final double averagePrice;
  final String location;

  // Filtering
  final String category;

  const Poi({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.description,
    required this.image,
    required this.schedule,
    required this.averagePrice,
    required this.location,
    required this.category,
  });

  factory Poi.fromJson(Map<String, dynamic> json) {
    final avg = json['average_price'];

    return Poi(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      shortDescription: (json['short_description'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      image: (json['image'] ?? '').toString(),
      schedule: (json['schedule'] ?? '').toString(),
      averagePrice: avg is num ? avg.toDouble() : double.tryParse('$avg') ?? 0.0,
      location: (json['location'] ?? '').toString(),
      category: (json['category'] ?? '').toString(),
    );
  }
}
