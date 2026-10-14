import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voyage_jordan2/l10n/app_localizations.dart';
import 'package:voyage_jordan2/app/router.dart';
import 'package:voyage_jordan2/core/providers/language_provider.dart';
import 'package:voyage_jordan2/shared/theme/app_theme.dart';

class VoyageJordanApp extends ConsumerWidget {
  const VoyageJordanApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(languageProvider);
    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: appRouter,
    );
  }
}
