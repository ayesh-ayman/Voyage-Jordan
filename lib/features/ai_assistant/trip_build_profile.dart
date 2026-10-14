/// Answers collected by the AI Trip Builder interview (preference-first; destinations are inferred).
enum ExperienceKind { historyCulture, adventure, relaxation, familyFriendly, mixed }

enum BudgetAnswer { economy, moderate, luxury }

enum PaceKind { calm, active, balanced }

enum PlaceKind { historical, nature, sea, desert, mixed }

enum TransportAnswer { rentalCar, privateDriver, publicTransport, guidedTour }

enum SpecialPreference { none, avoidCrowds, heatSensitive, shorterWalks }

/// Full preference profile used to infer destinations and build the demo plan.
class TripBuildProfile {
  const TripBuildProfile({
    required this.days,
    required this.experience,
    required this.budget,
    required this.pace,
    required this.places,
    required this.transport,
    required this.special,
  });

  final int days;
  final ExperienceKind experience;
  final BudgetAnswer budget;
  final PaceKind pace;
  final PlaceKind places;
  final TransportAnswer transport;
  final SpecialPreference special;

  int get budgetTierInt => switch (budget) {
        BudgetAnswer.economy => 0,
        BudgetAnswer.moderate => 1,
        BudgetAnswer.luxury => 2,
      };

  int get transportModeInt => switch (transport) {
        TransportAnswer.rentalCar => 0,
        TransportAnswer.privateDriver => 1,
        TransportAnswer.publicTransport => 2,
        TransportAnswer.guidedTour => 3,
      };
}
