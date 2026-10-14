import 'package:voyage_jordan2/core/trip_plan/trip_plan_generator.dart';
import 'package:voyage_jordan2/features/ai_assistant/trip_build_profile.dart';
import 'package:voyage_jordan2/models/itinerary_day.dart';
import 'package:voyage_jordan2/models/trip_plan_build_result.dart';

/// Deterministic plan: infers destinations from preferences, builds [TripPlanBuildResult], formats chat copy.
class AssistantPlanOutcome {
  AssistantPlanOutcome({required this.chatText, required this.buildResult});
  final String chatText;
  final TripPlanBuildResult buildResult;
}

class TripRecommendationEngine {
  TripRecommendationEngine._();

  static const _allIds = <String>['jerash', 'dead-sea', 'petra', 'wadi-rum', 'aqaba'];

  static AssistantPlanOutcome compose(TripBuildProfile p, {required bool arabic}) {
    final selected = _inferDestinationIds(p);
    final buildResult = TripPlanGenerator.build(
      selectedDestinations: selected,
      tripDays: p.days,
      budgetTier: p.budgetTierInt,
      transportMode: p.transportModeInt,
    );
    final chatText = arabic ? _formatChatAr(p, buildResult, selected) : _formatChatEn(p, buildResult, selected);
    return AssistantPlanOutcome(chatText: chatText, buildResult: buildResult);
  }

  /// Public for tests / tooling — same set passed to [TripPlanGenerator].
  static Set<String> inferDestinationIdsForProfile(TripBuildProfile p) => _inferDestinationIds(p);

  static Set<String> _inferDestinationIds(TripBuildProfile p) {
    final scores = <String, int>{for (final id in _allIds) id: 0};
    void add(String id, int v) {
      scores[id] = (scores[id] ?? 0) + v;
    }

    switch (p.experience) {
      case ExperienceKind.historyCulture:
        add('petra', 5);
        add('jerash', 5);
        add('dead-sea', 2);
      case ExperienceKind.adventure:
        add('wadi-rum', 5);
        add('aqaba', 4);
        add('petra', 3);
      case ExperienceKind.relaxation:
        add('dead-sea', 5);
        add('aqaba', 4);
        add('petra', 1);
      case ExperienceKind.familyFriendly:
        add('dead-sea', 4);
        add('aqaba', 4);
        add('petra', 3);
        add('jerash', 1);
      case ExperienceKind.mixed:
        add('petra', 3);
        add('wadi-rum', 3);
        add('dead-sea', 3);
        add('aqaba', 2);
        add('jerash', 2);
    }

    switch (p.places) {
      case PlaceKind.historical:
        add('petra', 4);
        add('jerash', 4);
      case PlaceKind.nature:
        add('wadi-rum', 3);
        add('dead-sea', 3);
        add('petra', 2);
      case PlaceKind.sea:
        add('aqaba', 6);
        add('petra', 1);
      case PlaceKind.desert:
        add('wadi-rum', 6);
        add('petra', 2);
      case PlaceKind.mixed:
        for (final id in _allIds) {
          add(id, 1);
        }
    }

    switch (p.special) {
      case SpecialPreference.none:
        break;
      case SpecialPreference.avoidCrowds:
        add('jerash', -3);
        add('petra', -1);
        add('dead-sea', 2);
        add('wadi-rum', -1);
      case SpecialPreference.heatSensitive:
        add('wadi-rum', -2);
        add('dead-sea', 3);
        add('aqaba', 2);
      case SpecialPreference.shorterWalks:
        add('petra', -3);
        add('jerash', -2);
        add('dead-sea', 4);
        add('aqaba', 2);
    }

    for (final id in _allIds) {
      scores[id] = (scores[id] ?? 0).clamp(0, 99);
    }

    final maxStops = _maxStops(p.days, p.pace);
    final ranked = TripPlanGenerator.jordanFlowOrder
        .map((id) => (id, scores[id] ?? 0))
        .where((e) => e.$2 > 0)
        .toList()
      ..sort((a, b) {
        final c = b.$2.compareTo(a.$2);
        if (c != 0) return c;
        return TripPlanGenerator.jordanFlowOrder.indexOf(a.$1).compareTo(TripPlanGenerator.jordanFlowOrder.indexOf(b.$1));
      });

    var pick = ranked.take(maxStops).map((e) => e.$1).toSet();
    if (pick.isEmpty) {
      pick = {'petra', 'wadi-rum'};
    }
    return pick;
  }

  static int _maxStops(int days, PaceKind pace) {
    var m = switch (days) {
      <= 3 => 2,
      <= 5 => 3,
      <= 7 => 4,
      _ => 5,
    };
    switch (pace) {
      case PaceKind.calm:
        return m.clamp(2, 3);
      case PaceKind.active:
        return (m + 1).clamp(2, 5);
      case PaceKind.balanced:
        return m;
    }
  }

  static String _locName(String id, bool ar) {
    if (ar) {
      return switch (id) {
        'petra' => 'البتراء',
        'wadi-rum' => 'وادي رم',
        'aqaba' => 'العقبة',
        'jerash' => 'جرش',
        'dead-sea' => 'البحر الميت',
        _ => id,
      };
    }
    return switch (id) {
      'petra' => 'Petra',
      'wadi-rum' => 'Wadi Rum',
      'aqaba' => 'Aqaba',
      'jerash' => 'Jerash',
      'dead-sea' => 'Dead Sea',
      _ => id,
    };
  }

  static String _dayTheme(String id, bool ar) {
    if (ar) {
      return switch (id) {
        'petra' => 'مشي في الموقع والمعالم الأبرز.',
        'wadi-rum' => 'صحراء وجولات مفتوحة.',
        'aqaba' => 'بحر ووقت سهل على الشاطئ.',
        'jerash' => 'جولة أثرية مركزة.',
        'dead-sea' => 'استرخاء ومنتجع.',
        _ => 'أنشطة وفق خطتك.',
      };
    }
    return switch (id) {
      'petra' => 'On-site walking and signature ruins.',
      'wadi-rum' => 'Open desert scenery and camp-style pacing.',
      'aqaba' => 'Sea breeze and easy waterfront time.',
      'jerash' => 'Focused classical ruins loop.',
      'dead-sea' => 'Resort-style recovery and floating time.',
      _ => 'Activities matched to this stop.',
    };
  }

  static Map<String, int> _nightsPerStop(TripPlanBuildResult r) {
    final m = <String, int>{};
    for (final d in r.days) {
      m[d.locationId] = (m[d.locationId] ?? 0) + 1;
    }
    return m;
  }

  static String _prefsSummary(TripBuildProfile p, bool ar) {
    if (ar) {
      return 'ملخص تفضيلاتك: ${p.days} يوماً، تجربة ${_expAr(p.experience)}، ميزانية ${_budAr(p.budget)}، إيقاع ${_paceAr(p.pace)}، تفضيل أماكن ${_placeAr(p.places)}، نقل ${_trAr(p.transport)}${_specLineAr(p)}';
    }
    return 'Your preferences: ${p.days} days, ${_expEn(p.experience)} experience, ${_budEn(p.budget)} budget, ${_paceEn(p.pace)} pace, ${_placeEn(p.places)} places, ${_trEn(p.transport)} transport${_specLineEn(p)}';
  }

  static String _specLineEn(TripBuildProfile p) => switch (p.special) {
        SpecialPreference.none => '',
        SpecialPreference.avoidCrowds => ', quieter pacing where possible',
        SpecialPreference.heatSensitive => ', heat-aware routing',
        SpecialPreference.shorterWalks => ', shorter walking blocks',
      };

  static String _specLineAr(TripBuildProfile p) => switch (p.special) {
        SpecialPreference.none => '',
        SpecialPreference.avoidCrowds => '، مع تهدئة الزحام حيث أمكن',
        SpecialPreference.heatSensitive => '، مع مراعاة الحرارة',
        SpecialPreference.shorterWalks => '، مع مشي أقصر',
      };

  static String _expEn(ExperienceKind e) => switch (e) {
        ExperienceKind.historyCulture => 'history & culture',
        ExperienceKind.adventure => 'adventure',
        ExperienceKind.relaxation => 'relaxation',
        ExperienceKind.familyFriendly => 'family-friendly',
        ExperienceKind.mixed => 'mixed',
      };
  static String _expAr(ExperienceKind e) => switch (e) {
        ExperienceKind.historyCulture => 'تاريخ وثقافة',
        ExperienceKind.adventure => 'مغامرة',
        ExperienceKind.relaxation => 'استرخاء',
        ExperienceKind.familyFriendly => 'عائلي',
        ExperienceKind.mixed => 'مزيج',
      };
  static String _budEn(BudgetAnswer b) => switch (b) {
        BudgetAnswer.economy => 'economy',
        BudgetAnswer.moderate => 'moderate',
        BudgetAnswer.luxury => 'luxury',
      };
  static String _budAr(BudgetAnswer b) => switch (b) {
        BudgetAnswer.economy => 'اقتصادي',
        BudgetAnswer.moderate => 'متوسط',
        BudgetAnswer.luxury => 'فاخر',
      };
  static String _paceEn(PaceKind p) => switch (p) {
        PaceKind.calm => 'calm',
        PaceKind.active => 'active',
        PaceKind.balanced => 'balanced',
      };
  static String _paceAr(PaceKind p) => switch (p) {
        PaceKind.calm => 'هادئ',
        PaceKind.active => 'نشيط',
        PaceKind.balanced => 'متوازن',
      };
  static String _placeEn(PlaceKind p) => switch (p) {
        PlaceKind.historical => 'historical',
        PlaceKind.nature => 'nature',
        PlaceKind.sea => 'sea',
        PlaceKind.desert => 'desert',
        PlaceKind.mixed => 'mixed',
      };
  static String _placeAr(PlaceKind p) => switch (p) {
        PlaceKind.historical => 'تاريخية',
        PlaceKind.nature => 'طبيعة',
        PlaceKind.sea => 'بحر',
        PlaceKind.desert => 'صحراء',
        PlaceKind.mixed => 'مزيج',
      };
  static String _trEn(TransportAnswer t) => switch (t) {
        TransportAnswer.rentalCar => 'rental car',
        TransportAnswer.privateDriver => 'private driver',
        TransportAnswer.publicTransport => 'public transport',
        TransportAnswer.guidedTour => 'guided tour',
      };
  static String _trAr(TransportAnswer t) => switch (t) {
        TransportAnswer.rentalCar => 'إيجار سيارة',
        TransportAnswer.privateDriver => 'سائق خاص',
        TransportAnswer.publicTransport => 'مواصلات عامة',
        TransportAnswer.guidedTour => 'جولة مع مرشد',
      };

  static String _whyChosen(TripBuildProfile p, Set<String> chosen, bool ar) {
    if (ar) {
      return 'اخترنا لك هذه الوجهات لأنها تطابق ما يحبه المسافرون الذين يفضلون ${_expAr(p.experience)} مع ${_placeAr(p.places)}—دون أن تحتاج لمعرفة أسماء كل مدينة مسبقاً. تم ترتيبها بمسار منطقي جنوباً قدر الإمكان.';
    }
    return 'We picked these stops for you because they match travelers who enjoy ${_expEn(p.experience)} time with ${_placeEn(p.places)} highlights—you do not need to know Jordan’s map by heart. Order follows a sensible southbound flow when possible.';
  }

  static String _budgetLine(TripBuildProfile p, bool ar) {
    if (ar) {
      return switch (p.budget) {
        BudgetAnswer.economy => 'أسلوب الميزانية: اقتصادي—إقامات أوضح وتنقل أوفر في الصياغة.',
        BudgetAnswer.moderate => 'أسلوب الميزانية: متوسط—توازن بين الراحة والتكلفة.',
        BudgetAnswer.luxury => 'أسلوب الميزانية: فاخر—وقت أطول في المحطات ونبرة أرقى في الخطة.',
      };
    }
    return switch (p.budget) {
      BudgetAnswer.economy => 'Budget style: economy—leaner stays and cost-conscious moves in this outline.',
      BudgetAnswer.moderate => 'Budget style: moderate—balanced comfort and spend.',
      BudgetAnswer.luxury => 'Budget style: luxury—more time per stop and premium pacing in the wording.',
    };
  }

  static String _dayByDay(TripPlanBuildResult r, bool ar) {
    final buf = StringBuffer();
    if (ar) {
      buf.writeln('مخطط يومي مختصر:');
    } else {
      buf.writeln('Short day-by-day outline:');
    }
    for (final ItineraryDay d in r.days) {
      final name = _locName(d.locationId, ar);
      final theme = _dayTheme(d.locationId, ar);
      buf.writeln('${ar ? 'اليوم' : 'Day'} ${d.dayNumber}: $name — $theme');
    }
    return buf.toString().trimRight();
  }

  static String _formatChatEn(TripBuildProfile p, TripPlanBuildResult r, Set<String> chosen) {
    final nights = _nightsPerStop(r);
    final order = TripPlanGenerator.jordanFlowOrder.where(chosen.contains).toList();
    final destLine = order.map((id) => '${_locName(id, false)} (${nights[id] ?? 1} d)').join(', ');
    return 'Your personalized Jordan plan\n\n'
        '${_prefsSummary(p, false)}\n\n'
        'Recommended destinations (chosen for you)\n'
        '$destLine\n\n'
        '${_whyChosen(p, chosen, false)}\n\n'
        '${_budgetLine(p, false)}\n'
        'Suggested transport: ${_trEn(p.transport)}.\n\n'
        '${_dayByDay(r, false)}\n\n'
        'Use Save Trip to store this in My Trip (demo), or Modify Trip to adjust your answers.';
  }

  static String _formatChatAr(TripBuildProfile p, TripPlanBuildResult r, Set<String> chosen) {
    final nights = _nightsPerStop(r);
    final order = TripPlanGenerator.jordanFlowOrder.where(chosen.contains).toList();
    final destLine = order.map((id) => '${_locName(id, true)} (${nights[id] ?? 1} يوم)').join('، ');
    return 'خطتك المخصصة للأردن\n\n'
        '${_prefsSummary(p, true)}\n\n'
        'الوجهات المقترحة (تم اختيارها لك)\n'
        '$destLine\n\n'
        '${_whyChosen(p, chosen, true)}\n\n'
        '${_budgetLine(p, true)}\n'
        'النقل المقترح: ${_trAr(p.transport)}.\n\n'
        '${_dayByDay(r, true)}\n\n'
        'استخدم «حفظ الرحلة» لحفظها في رحلتي (تجريبي)، أو «تعديل الرحلة» لتعديل إجاباتك.';
  }
}
