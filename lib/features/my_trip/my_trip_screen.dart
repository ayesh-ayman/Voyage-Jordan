import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voyage_jordan2/app/router.dart';
import 'package:voyage_jordan2/core/providers/trip_plan_session_provider.dart';
import 'package:voyage_jordan2/l10n/app_localizations.dart';
import 'package:voyage_jordan2/models/trip_plan_build_result.dart';
import 'package:voyage_jordan2/shared/theme/app_colors.dart';
import 'package:voyage_jordan2/shared/widgets/premium_card.dart';

class MyTripScreen extends ConsumerWidget {
  const MyTripScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final trip = ref.watch(tripPlanSessionProvider);
    final hasPlan = trip != null && trip.days.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Text(
              l10n.myTrip,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 18),
            if (!hasPlan) ...[
              PremiumCard(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
                child: Column(
                  children: [
                    Icon(Icons.map_outlined, size: 48, color: AppColors.primaryGold.withValues(alpha: 0.85)),
                    const SizedBox(height: 16),
                    Text(
                      l10n.myTripNoPlanYet,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.myTripNoPlanHint,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.4,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 22),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => context.push(AppRoutes.tripPlanner),
                        child: Text(l10n.startPlanning),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              ..._plannedTripSection(context, l10n, trip),
            ],
          ],
        ),
      ),
    );
  }
}

List<Widget> _plannedTripSection(
  BuildContext context,
  AppLocalizations l10n,
  TripPlanBuildResult trip,
) {
  return [
    PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.check_circle_outline, color: AppColors.primaryGold, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.myTripStatusReady,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            l10n.myTripStartsIn,
            style: TextStyle(
              fontSize: 15,
              color: AppColors.primaryGold,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
    const SizedBox(height: 16),
    PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.myTripOverview,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _SummaryRow(
            label: l10n.myTripDestinations,
            value: trip.orderedDestinationIds.map((id) => _destinationName(l10n, id)).join(' · '),
          ),
          const SizedBox(height: 14),
          _SummaryRow(
            label: l10n.myTripTripLength,
            value: '${trip.tripDays} ${l10n.plannerDays}',
          ),
          const SizedBox(height: 14),
          _SummaryRow(
            label: l10n.plannerSelectBudget,
            value: _budgetLabel(l10n, trip.budgetTier),
          ),
          const SizedBox(height: 14),
          _SummaryRow(
            label: l10n.plannerTransportation,
            value: _transportLabel(l10n, trip.transportMode),
          ),
        ],
      ),
    ),
    const SizedBox(height: 20),
    SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: () => context.push(AppRoutes.itinerary),
        child: Text(l10n.myTripViewFullPlan),
      ),
    ),
  ];
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}

String _destinationName(AppLocalizations l10n, String id) {
  return switch (id) {
    'petra' => l10n.destinationPetra,
    'wadi-rum' => l10n.destinationWadiRum,
    'aqaba' => l10n.destinationAqaba,
    'dead-sea' => l10n.destinationDeadSea,
    'jerash' => l10n.destinationJerash,
    _ => id,
  };
}

String _budgetLabel(AppLocalizations l10n, int tier) {
  return switch (tier.clamp(0, 2)) {
    0 => l10n.plannerBudget,
    1 => l10n.plannerModerate,
    _ => l10n.plannerLuxury,
  };
}

String _transportLabel(AppLocalizations l10n, int mode) {
  return switch (mode.clamp(0, 3)) {
    0 => l10n.plannerRentalCar,
    1 => l10n.plannerPrivateDriver,
    2 => l10n.plannerPublicTransport,
    _ => l10n.plannerGuidedTour,
  };
}
