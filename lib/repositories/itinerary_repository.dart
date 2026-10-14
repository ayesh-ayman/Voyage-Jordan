import 'package:voyage_jordan2/models/itinerary_activity_slot.dart';
import 'package:voyage_jordan2/models/itinerary_day.dart';
import 'package:voyage_jordan2/models/trip_plan_cost_summary.dart';

class ItineraryRepository {
  TripPlanCostSummary getDemoCostSummary() {
    return const TripPlanCostSummary(
      totalUsd: 1850,
      accommodationUsd: 650,
      mealsUsd: 400,
      transportUsd: 350,
      activitiesUsd: 450,
    );
  }

  List<ItineraryDay> getDemoTrip() {
    return const [
      ItineraryDay(
        dayNumber: 1,
        locationId: 'aqaba',
        serviceDestinationId: 'aqaba',
        activities: [
          ItineraryActivitySlot(time: '3:00 PM', activityItemId: 'Check-in resort'),
          ItineraryActivitySlot(time: '6:30 PM', activityItemId: 'Sunset marina walk'),
          ItineraryActivitySlot(time: '8:30 PM', activityItemId: 'Seafood dinner'),
        ],
      ),
      ItineraryDay(
        dayNumber: 2,
        locationId: 'wadi-rum',
        serviceDestinationId: 'wadi-rum',
        activities: [
          ItineraryActivitySlot(time: '9:00 AM', activityItemId: 'Desert jeep tour'),
          ItineraryActivitySlot(time: '1:00 PM', activityItemId: 'Bedouin lunch'),
          ItineraryActivitySlot(time: '8:00 PM', activityItemId: 'Night camp stargazing'),
        ],
      ),
      ItineraryDay(
        dayNumber: 3,
        locationId: 'petra',
        serviceDestinationId: 'petra',
        activities: [
          ItineraryActivitySlot(time: '8:00 AM', activityItemId: 'The Treasury visit'),
          ItineraryActivitySlot(time: '12:00 PM', activityItemId: 'Monastery hike'),
          ItineraryActivitySlot(time: '4:00 PM', activityItemId: 'Cultural market stop'),
        ],
      ),
    ];
  }
}
