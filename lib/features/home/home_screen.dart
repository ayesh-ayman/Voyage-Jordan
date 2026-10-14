import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voyage_jordan2/app/router.dart';
import 'package:voyage_jordan2/core/providers/app_providers.dart';
import 'package:voyage_jordan2/l10n/app_localizations.dart';
import 'package:voyage_jordan2/l10n/destination_localizer.dart';
import 'package:voyage_jordan2/shared/theme/app_colors.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final destinations = ref.watch(destinationsProvider);
    final featuredIds = ['petra', 'wadi-rum', 'dead-sea'];
    final featuredDestinations = featuredIds
        .map((id) => destinations.where((d) => d.id == id).first)
        .toList();
    final width = MediaQuery.sizeOf(context).width;
    final heroTitleSize = width < 380 ? 30.0 : 36.0;
    final headingSize = width < 380 ? 34.0 : 40.0;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 390,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/hero.jpg',
                      fit: BoxFit.cover,
                    ),
                    Container(color: Colors.black.withValues(alpha: 0.24)),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18, 20, 18, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.appTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: heroTitleSize,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            l10n.discoverKingdom,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: headingSize,
                              height: 1.05,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            l10n.experienceLine,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Color(0xFFEAEAEA),
                              fontSize: 15,
                              height: 1.3,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryGold,
                                foregroundColor: AppColors.onPrimaryGold,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              onPressed: () => context.push(AppRoutes.tripPlanner),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      l10n.startPlanning,
                                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(width: 10),
                                    const Icon(Icons.arrow_forward, size: 22),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.surface,
                                foregroundColor: AppColors.primaryGold,
                                side: const BorderSide(color: AppColors.primaryGold, width: 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                              ),
                              onPressed: () => context.push(AppRoutes.aiAssistant),
                              child: Row(
                                children: [
                                  Icon(Icons.auto_awesome_outlined, size: 18, color: AppColors.primaryGold),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          l10n.aiAssistant,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                                        ),
                                        Text(
                                          l10n.aiPlanSubtitle,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    l10n.mustVisit,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => context.push(AppRoutes.destinations),
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      l10n.viewAll,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primaryGold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(18, 0, 18, 14),
            child: Text(
              l10n.exploreJordan,
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
            ),
          ),
          ...featuredDestinations.map(
            (destination) => Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 14),
              child: GestureDetector(
                onTap: () => context.push('${AppRoutes.destinationDetail}/${destination.id}'),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: SizedBox(
                    height: 188,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          destination.imageUrl,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0x14000000), Color(0x9A000000)],
                            ),
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                localizedDestinationName(context, destination.id, destination.name),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                switch (destination.id) {
                                  'petra' => l10n.petraBlurb,
                                  'wadi-rum' => l10n.wadiRumBlurb,
                                  'dead-sea' => l10n.deadSeaBlurb,
                                  _ => destination.description,
                                },
                                style: const TextStyle(
                                  color: Color(0xFFF3F3F3),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const Positioned(
                          right: 14,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Color(0x5A868686),
                              child: Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 14,
                          bottom: 10,
                          child: Row(
                            children: [
                              const Icon(Icons.location_on, size: 12, color: AppColors.primaryGold),
                              const SizedBox(width: 4),
                              Text(
                                switch (destination.id) {
                                  'petra' => l10n.petraLocation,
                                  'wadi-rum' => l10n.wadiRumLocation,
                                  'dead-sea' => l10n.deadSeaLocation,
                                  _ => localizedDestinationSubtitle(
                                    context,
                                    destination.id,
                                    destination.subtitle,
                                  ),
                                },
                                style: const TextStyle(
                                  color: AppColors.primaryGold,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: SizedBox(
              width: double.infinity,
              height: 58,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.surface,
                  foregroundColor: AppColors.danger,
                  side: BorderSide(color: AppColors.danger.withValues(alpha: 0.35)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => context.push(AppRoutes.emergency),
                icon: const Icon(Icons.phone_in_talk_outlined, size: 18),
                label: Text(
                  l10n.emergencyContacts,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
            ],
          ),
        ),
      ),
    );
  }
}
