import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voyage_jordan2/core/providers/trip_plan_session_provider.dart';
import 'package:voyage_jordan2/models/trip_plan_cost_summary.dart';
import 'package:voyage_jordan2/repositories/destinations_repository.dart';
import 'package:voyage_jordan2/repositories/itinerary_repository.dart';

final destinationsRepositoryProvider = Provider((ref) => DestinationsRepository());
final itineraryRepositoryProvider = Provider((ref) => ItineraryRepository());

final destinationsProvider = Provider((ref) {
  return ref.watch(destinationsRepositoryProvider).getAll();
});

final destinationDetailProvider = Provider.family((ref, String destinationId) {
  return ref.watch(destinationsRepositoryProvider).getDetailById(destinationId);
});

final itineraryProvider = Provider((ref) {
  final session = ref.watch(tripPlanSessionProvider);
  if (session != null) return session.days;
  return ref.watch(itineraryRepositoryProvider).getDemoTrip();
});

final tripPlanCostProvider = Provider<TripPlanCostSummary>((ref) {
  final session = ref.watch(tripPlanSessionProvider);
  if (session != null) return session.cost;
  return ref.watch(itineraryRepositoryProvider).getDemoCostSummary();
});

final tripPlanUiContextProvider = Provider<TripPlanUiContext?>((ref) {
  final session = ref.watch(tripPlanSessionProvider);
  if (session == null) return null;
  return TripPlanUiContext(budgetTier: session.budgetTier, transportMode: session.transportMode);
});

class TripPlanUiContext {
  const TripPlanUiContext({required this.budgetTier, required this.transportMode});
  final int budgetTier;
  final int transportMode;
}
