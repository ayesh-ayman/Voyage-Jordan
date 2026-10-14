import 'package:voyage_jordan2/models/itinerary_day.dart';
import 'package:voyage_jordan2/models/trip_plan_cost_summary.dart';

class TripPlanBuildResult {
  const TripPlanBuildResult({
    required this.days,
    required this.cost,
    required this.budgetTier,
    required this.transportMode,
    required this.orderedDestinationIds,
    required this.tripDays,
  });

  final List<ItineraryDay> days;
  final TripPlanCostSummary cost;
  final int budgetTier;
  final int transportMode;

  /// Canonical route order used for the build (subset of user selection).
  final List<String> orderedDestinationIds;

  /// Total trip length in days from the planner.
  final int tripDays;
}
