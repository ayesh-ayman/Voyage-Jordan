import 'package:flutter/material.dart';
import 'package:voyage_jordan2/l10n/app_localizations.dart';
import 'package:voyage_jordan2/shared/theme/app_colors.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    this.trailing,
  });

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        trailing ??
            Text(
              l10n.seeAll,
              style: TextStyle(color: AppColors.accentSoft, fontWeight: FontWeight.w600),
            ),
      ],
    );
  }
}
