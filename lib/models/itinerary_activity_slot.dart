class ItineraryActivitySlot {
  const ItineraryActivitySlot({
    required this.time,
    required this.activityItemId,
  });

  /// Display time (e.g. "9:00 AM") — kept locale-neutral for the demo dataset.
  final String time;

  /// Matches legacy item ids for localization (`itineraryItem*`).
  final String activityItemId;
}
