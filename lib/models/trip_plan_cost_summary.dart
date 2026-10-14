class TripPlanCostSummary {
  const TripPlanCostSummary({
    required this.totalUsd,
    required this.accommodationUsd,
    required this.mealsUsd,
    required this.transportUsd,
    required this.activitiesUsd,
  });

  final int totalUsd;
  final int accommodationUsd;
  final int mealsUsd;
  final int transportUsd;
  final int activitiesUsd;
}
