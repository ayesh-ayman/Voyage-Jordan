import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:voyage_jordan2/app/router.dart';
import 'package:voyage_jordan2/core/providers/app_providers.dart';
import 'package:voyage_jordan2/l10n/app_localizations.dart';
import 'package:voyage_jordan2/models/itinerary_day.dart';
import 'package:voyage_jordan2/models/trip_plan_cost_summary.dart';
import 'package:voyage_jordan2/shared/theme/app_colors.dart';

class ItineraryScreen extends ConsumerWidget {
  const ItineraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final days = ref.watch(itineraryProvider);
    final cost = ref.watch(tripPlanCostProvider);
    final planCtx = ref.watch(tripPlanUiContextProvider);
    final budgetTier = planCtx?.budgetTier ?? 1;
    final transportMode = planCtx?.transportMode ?? 1;
    final currency = NumberFormat.currency(locale: 'en_US', symbol: r'$', decimalDigits: 0);

    return ColoredBox(
      color: AppColors.background,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border(
                  bottom: BorderSide(color: AppColors.primaryGold.withValues(alpha: 0.35), width: 1),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(12, 8, 20, 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: AppColors.primaryGold.withValues(alpha: 0.14),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 18,
                      onPressed: () {
                        if (context.canPop()) {
                          context.pop();
                        } else {
                          context.go(AppRoutes.home);
                        }
                      },
                      icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.tripPlanTitle,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l10n.tripPlanDaysInJordan(days.length),
                          style: const TextStyle(
                            color: AppColors.primaryGold,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 24,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
                        children: [
                          _CostSummaryCard(
                            l10n: l10n,
                            cost: cost,
                            formatUsd: currency.format,
                            navy: AppColors.textPrimary,
                            gold: AppColors.primaryGold,
                            muted: AppColors.textSecondary,
                          ),
                          const SizedBox(height: 28),
                          Text(
                            l10n.tripPlanDailyItinerary,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...days.map(
                            (day) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _DayPlanCard(
                                day: day,
                                l10n: l10n,
                                navy: AppColors.textPrimary,
                                gold: AppColors.primaryGold,
                                cream: AppColors.accentSoft,
                                muted: AppColors.textSecondary,
                                divider: AppColors.borderSubtle,
                                cardBg: AppColors.surface,
                                budgetTier: budgetTier,
                                transportMode: transportMode,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ColoredBox(
                      color: AppColors.surface,
                      child: SafeArea(
                        top: false,
                        minimum: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => context.push(AppRoutes.tripPlanner),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.primaryGold,
                                  side: const BorderSide(color: AppColors.primaryGold, width: 1.2),
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: Text(
                                  l10n.tripPlanModifyPlan,
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: FilledButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(l10n.tripPlanSavedMessage),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                  Future<void>.delayed(const Duration(milliseconds: 400), () {
                                    if (context.mounted) {
                                      context.go(AppRoutes.home);
                                    }
                                  });
                                },
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.primaryGold,
                                  foregroundColor: AppColors.onPrimaryGold,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  l10n.tripPlanSavePlan,
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CostSummaryCard extends StatelessWidget {
  const _CostSummaryCard({
    required this.l10n,
    required this.cost,
    required this.formatUsd,
    required this.navy,
    required this.gold,
    required this.muted,
  });

  final AppLocalizations l10n;
  final TripPlanCostSummary cost;
  final String Function(num) formatUsd;
  final Color navy;
  final Color gold;
  final Color muted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderGoldLight),
        boxShadow: const [
          BoxShadow(color: Color(0x0C000000), blurRadius: 20, offset: Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.attach_money_rounded, size: 22, color: gold.withValues(alpha: 0.95)),
              const SizedBox(width: 8),
              Text(
                l10n.tripPlanTotalEstimatedCost,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: navy,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            formatUsd(cost.totalUsd),
            style: TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.w300,
              color: navy,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 18),
          _costRow(l10n.tripPlanCostLineAccommodation, cost.accommodationUsd),
          const SizedBox(height: 10),
          _costRow(l10n.tripPlanCostLineMeals, cost.mealsUsd),
          const SizedBox(height: 10),
          _costRow(l10n.tripPlanCostLineTransport, cost.transportUsd),
          const SizedBox(height: 10),
          _costRow(l10n.tripPlanCostLineActivities, cost.activitiesUsd),
        ],
      ),
    );
  }

  Widget _costRow(String label, int amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: muted),
          ),
        ),
        Text(
          formatUsd(amount),
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: muted),
        ),
      ],
    );
  }
}

class _DayPlanCard extends StatelessWidget {
  const _DayPlanCard({
    required this.day,
    required this.l10n,
    required this.navy,
    required this.gold,
    required this.cream,
    required this.muted,
    required this.divider,
    required this.cardBg,
    required this.budgetTier,
    required this.transportMode,
  });

  final ItineraryDay day;
  final AppLocalizations l10n;
  final Color navy;
  final Color gold;
  final Color cream;
  final Color muted;
  final Color divider;
  final Color cardBg;
  final int budgetTier;
  final int transportMode;

  @override
  Widget build(BuildContext context) {
    final details = _dayDetailsForDay(l10n, day, budgetTier, transportMode);

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderGoldLight),
        boxShadow: const [
          BoxShadow(color: Color(0x08000000), blurRadius: 16, offset: Offset(0, 4)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            color: cream,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.calendar_today_outlined, size: 18, color: gold.withValues(alpha: 0.9)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.dayLabel(day.dayNumber),
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: navy,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _locationTitle(l10n, day.locationId),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: gold.withValues(alpha: 0.95),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 6),
            child: _SectionBlock(
              icon: Icons.location_on_outlined,
              title: l10n.tripPlanSectionActivities,
              navy: navy,
              child: Column(
                children: [
                  for (var i = 0; i < day.activities.length; i++) ...[
                    if (i > 0) const SizedBox(height: 14),
                    _ActivityRow(
                      time: day.activities[i].time,
                      description: _activityLabel(l10n, day.activities[i].activityItemId),
                      gold: gold,
                      navy: navy,
                    ),
                  ],
                ],
              ),
            ),
          ),
          Divider(height: 1, thickness: 1, color: divider, indent: 16, endIndent: 16),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
            child: _SectionBlock(
              icon: Icons.apartment_outlined,
              title: l10n.tripPlanSectionAccommodation,
              navy: navy,
              child: Text(
                details.accommodation,
                style: TextStyle(fontSize: 15, height: 1.35, color: muted, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Divider(height: 1, thickness: 1, color: divider, indent: 16, endIndent: 16),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
            child: _SectionBlock(
              icon: Icons.restaurant_outlined,
              title: l10n.tripPlanSectionMeals,
              navy: navy,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: details.meals
                    .map(
                      (m) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          '• $m',
                          style: TextStyle(fontSize: 15, height: 1.35, color: muted, fontWeight: FontWeight.w500),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          Divider(height: 1, thickness: 1, color: divider, indent: 16, endIndent: 16),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
            child: _SectionBlock(
              icon: Icons.directions_car_outlined,
              title: l10n.tripPlanSectionTransport,
              navy: navy,
              child: Text(
                details.transport,
                style: TextStyle(fontSize: 15, height: 1.35, color: muted, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DayDetails {
  const _DayDetails({required this.accommodation, required this.transport, required this.meals});
  final String accommodation;
  final String transport;
  final List<String> meals;
}

String _locationTitle(AppLocalizations l10n, String locationId) {
  return switch (locationId) {
    'aqaba' => l10n.destinationAqaba,
    'wadi-rum' => l10n.destinationWadiRum,
    'petra' => l10n.destinationPetra,
    'dead-sea' => l10n.destinationDeadSea,
    'jerash' => l10n.destinationJerash,
    _ => locationId,
  };
}

_DayDetails _dayDetailsForDay(
  AppLocalizations l10n,
  ItineraryDay day,
  int budgetTier,
  int transportMode,
) {
  final tier = budgetTier.clamp(0, 2);
  final sid = day.serviceDestinationId;
  return _DayDetails(
    accommodation: _stayFor(l10n, sid, tier),
    transport: _transportLine(l10n, transportMode.clamp(0, 3), tier),
    meals: _mealsFor(l10n, sid, tier),
  );
}

String _stayFor(AppLocalizations l10n, String dest, int tier) {
  return switch (dest) {
    'petra' => [l10n.stayPetra1, l10n.stayPetra2, l10n.stayPetra3][tier],
    'wadi-rum' => [l10n.stayWadi1, l10n.stayWadi2, l10n.stayWadi3][tier],
    'dead-sea' => [l10n.stayDead1, l10n.stayDead2, l10n.stayDead3][tier],
    'aqaba' => [l10n.stayAqaba1, l10n.stayAqaba2, l10n.stayAqaba3][tier],
    'jerash' => [l10n.stayJerash1, l10n.stayJerash2, l10n.stayJerash3][tier],
    _ => '',
  };
}

List<String> _mealsFor(AppLocalizations l10n, String dest, int tier) {
  switch (dest) {
    case 'petra':
      return tier == 2
          ? [l10n.dinePetra2, l10n.dinePetra1]
          : [l10n.dinePetra1, l10n.dinePetra2];
    case 'wadi-rum':
      return tier == 2
          ? [l10n.dineWadi2, l10n.dineWadi1]
          : [l10n.dineWadi1, l10n.dineWadi2];
    case 'dead-sea':
      return tier == 2
          ? [l10n.dineDead2, l10n.dineDead1]
          : [l10n.dineDead1, l10n.dineDead2];
    case 'aqaba':
      return tier == 2
          ? [l10n.dineAqaba2, l10n.dineAqaba1]
          : [l10n.dineAqaba1, l10n.dineAqaba2];
    case 'jerash':
      return tier == 2
          ? [l10n.dineJerash2, l10n.dineJerash1]
          : [l10n.dineJerash1, l10n.dineJerash2];
    default:
      return const [];
  }
}

String _transportLine(AppLocalizations l10n, int mode, int tier) {
  return switch (mode) {
    0 => [l10n.tripPlanTransRent0, l10n.tripPlanTransRent1, l10n.tripPlanTransRent2][tier],
    1 => [l10n.tripPlanTransDriver0, l10n.tripPlanTransDriver1, l10n.tripPlanTransDriver2][tier],
    2 => [l10n.tripPlanTransPublic0, l10n.tripPlanTransPublic1, l10n.tripPlanTransPublic2][tier],
    _ => [l10n.tripPlanTransGuide0, l10n.tripPlanTransGuide1, l10n.tripPlanTransGuide2][tier],
  };
}

String _activityLabel(AppLocalizations l10n, String id) {
  if (id.startsWith('TRAVEL:')) {
    final destId = id.substring(7);
    return l10n.tripPlanTravelToward(_locationTitle(l10n, destId));
  }
  return switch (id) {
    'todoPetra1' => l10n.todoPetra1,
    'todoPetra2' => l10n.todoPetra2,
    'todoPetra3' => l10n.todoPetra3,
    'todoPetra4' => l10n.todoPetra4,
    'todoPetra5' => l10n.todoPetra5,
    'todoWadi1' => l10n.todoWadi1,
    'todoWadi2' => l10n.todoWadi2,
    'todoWadi3' => l10n.todoWadi3,
    'todoWadi4' => l10n.todoWadi4,
    'todoWadi5' => l10n.todoWadi5,
    'todoDead1' => l10n.todoDead1,
    'todoDead2' => l10n.todoDead2,
    'todoDead3' => l10n.todoDead3,
    'todoDead4' => l10n.todoDead4,
    'todoDead5' => l10n.todoDead5,
    'todoAqaba1' => l10n.todoAqaba1,
    'todoAqaba2' => l10n.todoAqaba2,
    'todoAqaba3' => l10n.todoAqaba3,
    'todoAqaba4' => l10n.todoAqaba4,
    'todoAqaba5' => l10n.todoAqaba5,
    'todoJerash1' => l10n.todoJerash1,
    'todoJerash2' => l10n.todoJerash2,
    'todoJerash3' => l10n.todoJerash3,
    'todoJerash4' => l10n.todoJerash4,
    'todoJerash5' => l10n.todoJerash5,
    'Check-in resort' => l10n.itineraryItemCheckInResort,
    'Sunset marina walk' => l10n.itineraryItemSunsetMarinaWalk,
    'Seafood dinner' => l10n.itineraryItemSeafoodDinner,
    'Desert jeep tour' => l10n.itineraryItemDesertJeepTour,
    'Bedouin lunch' => l10n.itineraryItemBedouinLunch,
    'Night camp stargazing' => l10n.itineraryItemNightCampStargazing,
    'The Treasury visit' => l10n.itineraryItemTreasuryVisit,
    'Monastery hike' => l10n.itineraryItemMonasteryHike,
    'Cultural market stop' => l10n.itineraryItemCulturalMarketStop,
    _ => id,
  };
}

class _SectionBlock extends StatelessWidget {
  const _SectionBlock({
    required this.icon,
    required this.title,
    required this.navy,
    required this.child,
  });

  final IconData icon;
  final String title;
  final Color navy;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: navy),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: navy,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 26),
          child: child,
        ),
      ],
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({
    required this.time,
    required this.description,
    required this.gold,
    required this.navy,
  });

  final String time;
  final String description;
  final Color gold;
  final Color navy;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 72,
          child: Text(
            time,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: gold,
              height: 1.3,
            ),
          ),
        ),
        Expanded(
          child: Text(
            description,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: navy,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}
