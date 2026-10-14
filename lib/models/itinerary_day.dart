import 'package:voyage_jordan2/models/itinerary_activity_slot.dart';

class ItineraryDay {
  const ItineraryDay({
    required this.dayNumber,
    required this.locationId,
    required this.activities,
    required this.serviceDestinationId,
  });

  final int dayNumber;
  final String locationId;
  final List<ItineraryActivitySlot> activities;

  /// Stays and meals follow this destination (usually the overnight stop).
  final String serviceDestinationId;
}
