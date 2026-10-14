import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voyage_jordan2/app/router.dart';
import 'package:voyage_jordan2/core/providers/trip_plan_session_provider.dart';
import 'package:voyage_jordan2/core/trip_plan/trip_plan_generator.dart';
import 'package:voyage_jordan2/l10n/app_localizations.dart';
import 'package:voyage_jordan2/shared/theme/app_colors.dart';

class TripPlannerScreen extends ConsumerStatefulWidget {
  const TripPlannerScreen({super.key});

  @override
  ConsumerState<TripPlannerScreen> createState() => _TripPlannerScreenState();
}

class _TripPlannerScreenState extends ConsumerState<TripPlannerScreen> {
  int _stepIndex = 0;
  final Set<String> _selectedDestinations = {};
  int? _selectedBudget;
  int? _selectedTransport;
  double _tripDays = 7;

  void _onBack(BuildContext context) {
    if (_stepIndex > 0) {
      setState(() => _stepIndex -= 1);
      return;
    }
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.home);
    }
  }

  void _onPrimaryPressed(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);

    if (_stepIndex == 0) {
      if (_selectedDestinations.isEmpty) {
        messenger.showSnackBar(SnackBar(content: Text(l10n.plannerChoosePlaces)));
        return;
      }
      setState(() => _stepIndex = 1);
      return;
    }
    if (_stepIndex == 1) {
      setState(() => _stepIndex = 2);
      return;
    }
    if (_stepIndex == 2) {
      if (_selectedBudget == null) {
        messenger.showSnackBar(SnackBar(content: Text(l10n.plannerChooseBudgetRange)));
        return;
      }
      setState(() => _stepIndex = 3);
      return;
    }
    if (_selectedTransport == null) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.plannerHowGetAround)));
      return;
    }
    final plan = TripPlanGenerator.build(
      selectedDestinations: Set<String>.from(_selectedDestinations),
      tripDays: _tripDays.round(),
      budgetTier: _selectedBudget!,
      transportMode: _selectedTransport!,
    );
    ref.read(tripPlanSessionProvider.notifier).setPlan(plan);
    context.go(AppRoutes.itinerary);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final destinationOptions = [
      ('petra', l10n.destinationPetra),
      ('wadi-rum', l10n.destinationWadiRum),
      ('aqaba', l10n.destinationAqaba),
      ('dead-sea', l10n.destinationDeadSea),
      ('jerash', l10n.destinationJerash),
    ];
    final budgetOptions = [
      (l10n.plannerBudget, l10n.plannerBudgetRange1),
      (l10n.plannerModerate, l10n.plannerBudgetRange2),
      (l10n.plannerLuxury, l10n.plannerBudgetRange3),
    ];
    final transportOptions = [
      l10n.plannerRentalCar,
      l10n.plannerPrivateDriver,
      l10n.plannerPublicTransport,
      l10n.plannerGuidedTour,
    ];

    return ColoredBox(
      color: AppColors.background,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border(
                  bottom: BorderSide(color: AppColors.primaryGold.withValues(alpha: 0.35), width: 1),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: AppColors.primaryGold.withValues(alpha: 0.14),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 15,
                      onPressed: () => _onBack(context),
                      icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    l10n.buildCustomTrip,
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 28, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Row(
                children: List.generate(
                  4,
                  (index) => Expanded(
                    child: Container(
                      height: 3,
                      margin: EdgeInsets.only(right: index == 3 ? 0 : 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        color: index <= _stepIndex ? AppColors.primaryGold : const Color(0xFFE0E0E0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                ),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 20),
                  children: [
                    if (_stepIndex == 0) ...[
                      _SectionTitle(title: l10n.plannerSelectDestinations, subtitle: l10n.plannerChoosePlaces),
                      const SizedBox(height: 14),
                      ...destinationOptions.map((option) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _SelectableTile(
                              title: option.$2,
                              selected: _selectedDestinations.contains(option.$1),
                              onTap: () {
                                setState(() {
                                  if (_selectedDestinations.contains(option.$1)) {
                                    _selectedDestinations.remove(option.$1);
                                  } else {
                                    _selectedDestinations.add(option.$1);
                                  }
                                });
                              },
                            ),
                          )),
                    ] else if (_stepIndex == 1) ...[
                      _SectionTitle(title: l10n.plannerTripDuration, subtitle: l10n.plannerHowManyDaysStay),
                      const SizedBox(height: 14),
                      _DurationCard(
                        days: _tripDays,
                        daysLabel: l10n.plannerDays,
                        minDaysLabel: l10n.plannerMinDays,
                        maxDaysLabel: l10n.plannerMaxDays,
                        onChanged: (value) => setState(() => _tripDays = value),
                      ),
                    ] else if (_stepIndex == 2) ...[
                      _SectionTitle(title: l10n.plannerSelectBudget, subtitle: l10n.plannerChooseBudgetRange),
                      const SizedBox(height: 14),
                      ...budgetOptions.asMap().entries.map((entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _SelectableTile(
                              title: entry.value.$1,
                              subtitle: entry.value.$2,
                              selected: _selectedBudget != null && _selectedBudget == entry.key,
                              onTap: () => setState(() => _selectedBudget = entry.key),
                            ),
                          )),
                    ] else ...[
                      _SectionTitle(title: l10n.plannerTransportation, subtitle: l10n.plannerHowGetAround),
                      const SizedBox(height: 14),
                      ...transportOptions.asMap().entries.map((entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _SelectableTile(
                              title: entry.value,
                              selected: _selectedTransport != null && _selectedTransport == entry.key,
                              onTap: () => setState(() => _selectedTransport = entry.key),
                            ),
                          )),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              child: _PlannerCTA(
                label: _stepIndex == 3 ? l10n.plannerGenerateTripPlan : l10n.plannerContinue,
                backgroundColor: AppColors.primaryGold,
                foregroundColor: AppColors.onPrimaryGold,
                onPressed: () => _onPrimaryPressed(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlannerCTA extends StatelessWidget {
  const _PlannerCTA({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onPressed,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: const StadiumBorder(),
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _SelectableTile extends StatelessWidget {
  const _SelectableTile({
    required this.title,
    required this.selected,
    required this.onTap,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: selected ? AppColors.primaryGold.withValues(alpha: 0.12) : AppColors.surfaceSoft,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? AppColors.primaryGold : AppColors.borderSubtle,
            ),
            boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 10, offset: Offset(0, 2))],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (selected)
                const CircleAvatar(
                  radius: 10,
                  backgroundColor: AppColors.primaryGold,
                  child: Icon(Icons.check, color: AppColors.onPrimaryGold, size: 12),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DurationCard extends StatelessWidget {
  const _DurationCard({
    required this.days,
    required this.daysLabel,
    required this.minDaysLabel,
    required this.maxDaysLabel,
    required this.onChanged,
  });

  final double days;
  final String daysLabel;
  final String minDaysLabel;
  final String maxDaysLabel;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceSoft,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderSubtle),
        boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 10, offset: Offset(0, 2))],
      ),
      child: Column(
        children: [
          Text(
            days.toInt().toString(),
            style: const TextStyle(fontSize: 56, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
          ),
          Text(daysLabel, style: const TextStyle(fontSize: 20, color: AppColors.textSecondary)),
          const SizedBox(height: 12),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              activeTrackColor: AppColors.primaryGold,
              inactiveTrackColor: Color(0xFFF0EBE3),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              thumbColor: AppColors.primaryGold,
              overlayShape: SliderComponentShape.noOverlay,
            ),
            child: Slider(
              value: days,
              min: 1,
              max: 14,
              divisions: 13,
              onChanged: onChanged,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(minDaysLabel, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              Text(maxDaysLabel, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }
}
