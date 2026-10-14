import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voyage_jordan2/models/trip_plan_build_result.dart';

class TripPlanSessionNotifier extends Notifier<TripPlanBuildResult?> {
  @override
  TripPlanBuildResult? build() => null;

  void setPlan(TripPlanBuildResult result) {
    state = result;
  }
}

final tripPlanSessionProvider = NotifierProvider<TripPlanSessionNotifier, TripPlanBuildResult?>(
  TripPlanSessionNotifier.new,
);
