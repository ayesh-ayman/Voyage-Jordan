class DestinationDetail {
  const DestinationDetail({
    required this.destinationId,
    required this.title,
    required this.heroImageUrl,
    required this.galleryImageUrls,
    required this.description,
    required this.bestTimeToVisit,
    required this.thingsToDo,
    required this.whereToStay,
    required this.diningOptions,
  });

  final String destinationId;
  final String title;
  final String heroImageUrl;
  final List<String> galleryImageUrls;
  final String description;
  final String bestTimeToVisit;
  final List<String> thingsToDo;
  final List<String> whereToStay;
  final List<String> diningOptions;
}
