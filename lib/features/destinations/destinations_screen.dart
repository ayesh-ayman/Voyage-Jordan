import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voyage_jordan2/app/router.dart';
import 'package:voyage_jordan2/core/providers/app_providers.dart';
import 'package:voyage_jordan2/l10n/app_localizations.dart';
import 'package:voyage_jordan2/l10n/destination_localizer.dart';
import 'package:voyage_jordan2/shared/theme/app_colors.dart';

class DestinationsScreen extends ConsumerWidget {
  const DestinationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final destinations = ref.watch(destinationsProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
          children: [
            Text(
              l10n.mustVisit,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.exploreJordan,
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 14),
            ...destinations.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: GestureDetector(
                    onTap: () => context.push('${AppRoutes.destinationDetail}/${item.id}'),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: SizedBox(
                        height: 188,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              item.imageUrl,
                              fit: BoxFit.cover,
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Color(0x1A000000), Color(0xBF000000)],
                                ),
                              ),
                            ),
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    localizedDestinationName(context, item.id, item.name),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    localizedDestinationCardDescription(context, item.id, item.description),
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
                                    localizedDestinationSubtitle(context, item.id, item.subtitle),
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
                )),
          ],
        ),
      ),
    );
  }
}
