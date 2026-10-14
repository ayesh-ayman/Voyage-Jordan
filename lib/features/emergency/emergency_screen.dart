import 'package:flutter/material.dart';
import 'package:voyage_jordan2/l10n/app_localizations.dart';
import 'package:voyage_jordan2/shared/theme/app_colors.dart';
import 'package:voyage_jordan2/shared/widgets/premium_card.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.emergency)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.quickHelp, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                _EmergencyTile(label: l10n.jordanEmergency, number: '911'),
                _EmergencyTile(label: l10n.touristPolice, number: '+962 6 460 4444'),
                _EmergencyTile(label: l10n.nearestHospital, number: '+962 6 500 8080'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmergencyTile extends StatelessWidget {
  const _EmergencyTile({required this.label, required this.number});

  final String label;
  final String number;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.local_phone_rounded, color: AppColors.danger),
      title: Text(label),
      subtitle: Text(number),
    );
  }
}
