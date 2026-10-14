import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voyage_jordan2/app/router.dart';
import 'package:voyage_jordan2/core/providers/app_providers.dart';
import 'package:voyage_jordan2/l10n/app_localizations.dart';
import 'package:voyage_jordan2/l10n/destination_localizer.dart';
import 'package:voyage_jordan2/shared/theme/app_colors.dart';

class DestinationDetailScreen extends ConsumerStatefulWidget {
  const DestinationDetailScreen({super.key, required this.destinationId});

  final String destinationId;

  @override
  ConsumerState<DestinationDetailScreen> createState() => _DestinationDetailScreenState();
}

class _DestinationDetailScreenState extends ConsumerState<DestinationDetailScreen> {
  final PageController _galleryController = PageController();
  int _galleryIndex = 0;

  @override
  void dispose() {
    _galleryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final detail = ref.watch(destinationDetailProvider(widget.destinationId));
    if (detail == null) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.destinationNotFound),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => context.go(AppRoutes.home),
                  child: Text(l10n.backToHome),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final mainCardImage = switch (detail.destinationId) {
      'aqaba' => 'assets/images/aqaba.jpg',
      'petra' => 'assets/images/petra.jpg',
      'wadi-rum' => 'assets/images/wadi_rum.jpg',
      'jerash' => 'assets/images/jerash.webp',
      'dead-sea' => 'assets/images/dead_sea.jpg',
      _ => detail.heroImageUrl,
    };
    final topGalleryImages = [mainCardImage, detail.heroImageUrl, ...detail.galleryImageUrls];
    final localizedThings = localizedThingsToDo(context, detail.destinationId, detail.thingsToDo);
    final localizedStay = localizedWhereToStay(context, detail.destinationId, detail.whereToStay);
    final localizedDining = localizedDiningOptions(context, detail.destinationId, detail.diningOptions);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: 300,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    PageView.builder(
                      controller: _galleryController,
                      itemCount: topGalleryImages.length,
                      onPageChanged: (index) => setState(() => _galleryIndex = index),
                      itemBuilder: (context, index) {
                        return Image.asset(
                          topGalleryImages[index],
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                    IgnorePointer(
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0x12000000), Color(0x8A000000)],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 14,
                      left: 14,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: const Color(0x66FFFFFF),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 16,
                          onPressed: () {
                            if (context.canPop()) {
                              context.pop();
                            } else {
                              context.go(AppRoutes.home);
                            }
                          },
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 18,
                      right: 18,
                      bottom: 34,
                      child: IgnorePointer(
                        child: Text(
                          localizedDestinationName(context, detail.destinationId, detail.title),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 44,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 12,
                      child: IgnorePointer(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            topGalleryImages.length,
                            (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: index == _galleryIndex
                                    ? AppColors.primaryGold
                                    : const Color(0xFFD0D0D0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _InfoCard(
                    child: Text(
                      localizedDetailDescription(context, detail.destinationId, detail.description),
                      style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, height: 1.45),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _InfoCard(
                    backgroundColor: AppColors.accentSoft,
                    borderColor: AppColors.borderGoldLight,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.calendar_today_outlined, color: AppColors.primaryGold, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.bestTimeToVisit,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                localizedBestTime(context, detail.destinationId, detail.bestTimeToVisit),
                                style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _SectionHeader(title: l10n.thingsToDo, icon: Icons.place_outlined),
                  const SizedBox(height: 10),
                  ...localizedThings.asMap().entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _NumberedRow(index: entry.key + 1, text: entry.value),
                        ),
                      ),
                  const SizedBox(height: 10),
                  _SectionHeader(title: l10n.whereToStay, icon: Icons.apartment_outlined),
                  const SizedBox(height: 10),
                  ...localizedStay.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _TextRow(text: item),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _SectionHeader(title: l10n.diningOptions, icon: Icons.restaurant_outlined),
                  const SizedBox(height: 10),
                  ...localizedDining.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _TextRow(text: item),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.child,
    this.backgroundColor = Colors.white,
    this.borderColor = AppColors.borderSubtle,
  });

  final Widget child;
  final Color backgroundColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 2))],
      ),
      child: child,
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: AppColors.primaryGold.withValues(alpha: 0.12),
          child: Icon(icon, size: 16, color: AppColors.primaryGold),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ),
      ],
    );
  }
}

class _NumberedRow extends StatelessWidget {
  const _NumberedRow({required this.index, required this.text});

  final int index;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 13,
            backgroundColor: AppColors.surfaceSoft,
            child: Text(
              '$index',
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class _TextRow extends StatelessWidget {
  const _TextRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 15, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
      ),
    );
  }
}
