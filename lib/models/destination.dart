class Destination {
  const Destination({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.description,
    required this.rating,
    required this.priceLevel,
    required this.imageUrl,
  });

  final String id;
  final String name;
  final String subtitle;
  final String description;
  final double rating;
  final String priceLevel;
  final String imageUrl;
}
