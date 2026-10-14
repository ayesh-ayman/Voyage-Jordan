import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voyage_jordan2/l10n/app_localizations.dart';
import 'package:voyage_jordan2/features/ai_assistant/ai_assistant_screen.dart';
import 'package:voyage_jordan2/features/destinations/destination_detail_screen.dart';
import 'package:voyage_jordan2/features/destinations/destinations_screen.dart';
import 'package:voyage_jordan2/features/emergency/emergency_screen.dart';
import 'package:voyage_jordan2/features/home/home_screen.dart';
import 'package:voyage_jordan2/features/itinerary/itinerary_screen.dart';
import 'package:voyage_jordan2/features/my_trip/my_trip_screen.dart';
import 'package:voyage_jordan2/features/settings/settings_screen.dart';
import 'package:voyage_jordan2/features/splash/splash_screen.dart';
import 'package:voyage_jordan2/features/trip_planner/trip_planner_screen.dart';
import 'package:voyage_jordan2/shared/theme/app_colors.dart';

class AppRoutes {
  static const splash = '/';
  static const home = '/home';
  static const destinations = '/destinations';
  static const destinationDetail = '/destination';
  static const tripPlanner = '/trip-planner';
  static const aiAssistant = '/ai-assistant';
  static const itinerary = '/itinerary';
  static const myTrip = '/my-trip';
  static const emergency = '/emergency';
  static const settings = '/settings';
}

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(path: AppRoutes.splash, builder: (_, state) => const SplashScreen()),
    ShellRoute(
      builder: (context, state, child) => _MainShell(child: child),
      routes: [
        GoRoute(path: AppRoutes.home, builder: (_, state) => const HomeScreen()),
        GoRoute(
          path: '${AppRoutes.destinationDetail}/:id',
          builder: (_, state) => DestinationDetailScreen(
            destinationId: state.pathParameters['id'] ?? '',
          ),
        ),
        GoRoute(path: AppRoutes.destinations, builder: (_, state) => const DestinationsScreen()),
        GoRoute(path: AppRoutes.tripPlanner, builder: (_, state) => const TripPlannerScreen()),
        GoRoute(path: AppRoutes.itinerary, builder: (_, state) => const ItineraryScreen()),
        GoRoute(path: AppRoutes.myTrip, builder: (_, state) => const MyTripScreen()),
        GoRoute(path: AppRoutes.settings, builder: (_, state) => const SettingsScreen()),
      ],
    ),
    GoRoute(path: AppRoutes.aiAssistant, builder: (_, state) => const AiAssistantScreen()),
    GoRoute(path: AppRoutes.emergency, builder: (_, state) => const EmergencyScreen()),
  ],
);

class _MainShell extends StatelessWidget {
  const _MainShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final location = GoRouterState.of(context).uri.toString();
    final int index = location == AppRoutes.settings
        ? 2
        : (location == AppRoutes.myTrip ||
                location == AppRoutes.tripPlanner ||
                location == AppRoutes.itinerary)
            ? 1
            : 0;

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (value) {
          switch (value) {
            case 0:
              context.go(AppRoutes.home);
            case 1:
              context.go(AppRoutes.myTrip);
            case _:
              context.go(AppRoutes.settings);
          }
        },
        indicatorColor: AppColors.primaryGold.withValues(alpha: 0.15),
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home_outlined), label: l10n.home),
          NavigationDestination(icon: const Icon(Icons.luggage_outlined), label: l10n.myTrip),
          NavigationDestination(icon: const Icon(Icons.settings_outlined), label: l10n.settings),
        ],
      ),
    );
  }
}
