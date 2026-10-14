import 'package:flutter/widgets.dart';
import 'package:voyage_jordan2/l10n/app_localizations.dart';

String localizedDestinationName(BuildContext context, String id, String fallback) {
  final l10n = AppLocalizations.of(context)!;
  return switch (id) {
    'petra' => l10n.destinationPetra,
    'wadi-rum' => l10n.destinationWadiRum,
    'dead-sea' => l10n.destinationDeadSea,
    'aqaba' => l10n.destinationAqaba,
    'jerash' => l10n.destinationJerash,
    _ => fallback,
  };
}

String localizedDestinationSubtitle(BuildContext context, String id, String fallback) {
  final l10n = AppLocalizations.of(context)!;
  return switch (id) {
    'aqaba' => l10n.subtitleAqaba,
    'wadi-rum' => l10n.subtitleWadiRum,
    'petra' => l10n.subtitlePetra,
    'jerash' => l10n.subtitleJerash,
    'dead-sea' => l10n.subtitleDeadSea,
    _ => fallback,
  };
}

String localizedDestinationCardDescription(BuildContext context, String id, String fallback) {
  final l10n = AppLocalizations.of(context)!;
  return switch (id) {
    'aqaba' => l10n.destCardDescAqaba,
    'wadi-rum' => l10n.destCardDescWadiRum,
    'petra' => l10n.destCardDescPetra,
    'jerash' => l10n.destCardDescJerash,
    'dead-sea' => l10n.destCardDescDeadSea,
    _ => fallback,
  };
}

String localizedDetailDescription(BuildContext context, String id, String fallback) {
  final l10n = AppLocalizations.of(context)!;
  return switch (id) {
    'petra' => l10n.detailDescPetra,
    'wadi-rum' => l10n.detailDescWadiRum,
    'dead-sea' => l10n.detailDescDeadSea,
    'aqaba' => l10n.detailDescAqaba,
    'jerash' => l10n.detailDescJerash,
    _ => fallback,
  };
}

String localizedBestTime(BuildContext context, String id, String fallback) {
  final l10n = AppLocalizations.of(context)!;
  return switch (id) {
    'petra' => l10n.bestTimePetra,
    'wadi-rum' => l10n.bestTimeWadiRum,
    'dead-sea' => l10n.bestTimeDeadSea,
    'aqaba' => l10n.bestTimeAqaba,
    'jerash' => l10n.bestTimeJerash,
    _ => fallback,
  };
}

List<String> localizedThingsToDo(BuildContext context, String id, List<String> fallback) {
  final l10n = AppLocalizations.of(context)!;
  return switch (id) {
    'petra' => [l10n.todoPetra1, l10n.todoPetra2, l10n.todoPetra3, l10n.todoPetra4, l10n.todoPetra5],
    'wadi-rum' => [l10n.todoWadi1, l10n.todoWadi2, l10n.todoWadi3, l10n.todoWadi4, l10n.todoWadi5],
    'dead-sea' => [l10n.todoDead1, l10n.todoDead2, l10n.todoDead3, l10n.todoDead4, l10n.todoDead5],
    'aqaba' => [l10n.todoAqaba1, l10n.todoAqaba2, l10n.todoAqaba3, l10n.todoAqaba4, l10n.todoAqaba5],
    'jerash' => [l10n.todoJerash1, l10n.todoJerash2, l10n.todoJerash3, l10n.todoJerash4, l10n.todoJerash5],
    _ => fallback,
  };
}

List<String> localizedWhereToStay(BuildContext context, String id, List<String> fallback) {
  final l10n = AppLocalizations.of(context)!;
  return switch (id) {
    'petra' => [l10n.stayPetra1, l10n.stayPetra2, l10n.stayPetra3],
    'wadi-rum' => [l10n.stayWadi1, l10n.stayWadi2, l10n.stayWadi3],
    'dead-sea' => [l10n.stayDead1, l10n.stayDead2, l10n.stayDead3],
    'aqaba' => [l10n.stayAqaba1, l10n.stayAqaba2, l10n.stayAqaba3],
    'jerash' => [l10n.stayJerash1, l10n.stayJerash2, l10n.stayJerash3],
    _ => fallback,
  };
}

List<String> localizedDiningOptions(BuildContext context, String id, List<String> fallback) {
  final l10n = AppLocalizations.of(context)!;
  return switch (id) {
    'petra' => [l10n.dinePetra1, l10n.dinePetra2],
    'wadi-rum' => [l10n.dineWadi1, l10n.dineWadi2],
    'dead-sea' => [l10n.dineDead1, l10n.dineDead2],
    'aqaba' => [l10n.dineAqaba1, l10n.dineAqaba2],
    'jerash' => [l10n.dineJerash1, l10n.dineJerash2],
    _ => fallback,
  };
}
