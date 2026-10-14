import 'package:voyage_jordan2/features/ai_assistant/local_assistant_intent.dart';
import 'package:voyage_jordan2/features/ai_assistant/local_assistant_knowledge.dart';

class LocalAssistantRetriever {
  LocalAssistantRetriever._();

  static String retrieveAndCompose({
    required AssistantIntent intent,
    required bool arabic,
    required String originalText,
  }) {
    switch (intent.type) {
      case AssistantIntentType.destinationInfo:
        return _destinationInfo(intent.destinationIds, arabic);
      case AssistantIntentType.comparison:
        return _comparison(intent.comparisonKey, arabic);
      case AssistantIntentType.recommendation:
        return _recommend(intent.styleKey ?? 'mixed', intent.days ?? 5, arabic);
      case AssistantIntentType.tripStyle:
        return _tripStyle(intent.styleKey ?? 'mixed', intent.days ?? 5, arabic);
      case AssistantIntentType.budget:
        return _budget(originalText, arabic);
      case AssistantIntentType.transport:
        return _transport(arabic);
      case AssistantIntentType.appHelp:
        return _appHelp(intent.appHelpKey ?? 'what_ai_assistant_can_do', arabic);
      case AssistantIntentType.tripPlanning:
        return _tripPlanning(arabic);
      case AssistantIntentType.fallback:
        return _fallback(originalText, arabic);
    }
  }

  static String _destinationInfo(List<String> ids, bool ar) {
    final id = ids.first;
    final d = LocalAssistantKnowledgeBase.destinations[id];
    if (d == null) return _fallback('', ar);
    final activities = ar ? d.activitiesAr.join('، ') : d.activitiesEn.join(', ');
    final base = ar ? d.summaryAr : d.summaryEn;
    final bestFor = ar ? d.bestForAr : d.bestForEn;
    final season = ar ? d.seasonNotesAr : d.seasonNotesEn;
    final food = ar ? d.foodNotesAr : d.foodNotesEn;
    return ar
        ? '${d.nameAr}: $base\n\nالأنسب لـ: $bestFor\nأبرز الأنشطة: $activities\nموسمية: $season\nملاحظة طعام: $food'
        : '${d.nameEn}: $base\n\nBest for: $bestFor\nTop activities: $activities\nSeason notes: $season\nFood note: $food';
  }

  static String _comparison(String? key, bool ar) {
    if (key == null) return _fallback('', ar);
    final map = ar ? LocalAssistantKnowledgeBase.comparisonsAr : LocalAssistantKnowledgeBase.comparisonsEn;
    return map[key] ??
        (ar
            ? 'اذكر الوجهتين بوضوح (مثلاً: البتراء أم وادي رم) وسأعطيك مقارنة مباشرة.'
            : 'Name both places clearly (for example, Petra vs Wadi Rum) and I’ll give a direct comparison.');
  }

  static String _recommend(String style, int days, bool ar) {
    final ids = _rankedDestinations(style, days);
    final names = ids.map((id) => ar ? LocalAssistantKnowledgeBase.destinations[id]!.nameAr : LocalAssistantKnowledgeBase.destinations[id]!.nameEn).join(ar ? '، ' : ', ');
    final plan = _durationPlan(days, ar);
    return ar
        ? 'اقتراحي لك: $names.\n$plan\nإذا أردت، أعطني الميزانية ووسيلة النقل لأضبط الاقتراح أكثر.'
        : 'My recommendation: $names.\n$plan\nIf you want, share budget and transport preference and I’ll tighten the route.';
  }

  static String _tripStyle(String style, int days, bool ar) {
    final ids = _rankedDestinations(style, days);
    final names = ids.map((id) => ar ? LocalAssistantKnowledgeBase.destinations[id]!.nameAr : LocalAssistantKnowledgeBase.destinations[id]!.nameEn).join(ar ? ' + ' : ' + ');
    return ar
        ? 'لنمط ${_styleLabel(style, true)}: الأفضل عادة $names. ${_durationPlan(days, true)}'
        : 'For a ${_styleLabel(style, false)} style, a strong base is usually $names. ${_durationPlan(days, false)}';
  }

  static String _budget(String text, bool ar) {
    final hasMoney = RegExp(r'[\$€£]|\b\d[\d,]*\b').hasMatch(text.toLowerCase());
    if (hasMoney) {
      return ar
          ? 'إذا لديك مبلغ محدد، اعتبره مؤشر راحة: اقتصادي (أخف)، متوسط (متوازن)، فاخر (أعلى). في التطبيق التكاليف تقديرية للعرض.'
          : 'If you have a fixed amount, treat it as comfort guidance: economy (lean), moderate (balanced), luxury (higher comfort). App costs are demo estimates.';
    }
    return ar
        ? 'اختيار الميزانية يغير نبرة الخطة: اقتصادي، متوسط، فاخر. ابدأ بمتوسط إذا لم تكن متأكداً ثم قارن النتائج.'
        : 'Budget tier changes the plan tone: economy, moderate, luxury. Start with moderate if unsure, then compare outcomes.';
  }

  static String _transport(bool ar) {
    return ar
        ? 'مقارنة النقل: سائق خاص (راحة أعلى)، إيجار سيارة (حرية أكبر)، مواصلات عامة (أوفر لكن أبطأ)، جولة مرشد (تنظيم أعلى).'
        : 'Transport comparison: private driver (most comfort), rental car (most flexibility), public transport (cheaper but slower), guided tour (most structure).';
  }

  static String _appHelp(String key, bool ar) {
    final h = LocalAssistantKnowledgeBase.appHelp;
    return switch (key) {
      'how_to_generate' => ar ? h.howToGenerateAr : h.howToGenerateEn,
      'how_to_save' => ar ? h.howToSaveAr : h.howToSaveEn,
      'what_my_trip_does' => ar ? h.whatMyTripDoesAr : h.whatMyTripDoesEn,
      'what_destination_pages_show' => ar ? h.whatDestinationPagesShowAr : h.whatDestinationPagesShowEn,
      'what_ai_assistant_can_do' => ar ? h.whatAiAssistantCanDoAr : h.whatAiAssistantCanDoEn,
      _ => ar ? h.howToPlanAr : h.howToPlanEn,
    };
  }

  static String _tripPlanning(bool ar) {
    final h = LocalAssistantKnowledgeBase.appHelp;
    return ar
        ? '${h.howToPlanAr}\n${h.howToGenerateAr}\n${h.howToSaveAr}'
        : '${h.howToPlanEn}\n${h.howToGenerateEn}\n${h.howToSaveEn}';
  }

  static String _fallback(String text, bool ar) {
    if (RegExp(r'trip|travel|vacation|رحلة|سفر', caseSensitive: false).hasMatch(text)) {
      return ar
          ? 'لم أفهم التفاصيل بالكامل. أعطني 3 عناصر: عدد الأيام + الأسلوب (تاريخ/مغامرة/استرخاء) + الميزانية، وسأقترح لك مساراً واضحاً.'
          : 'I did not catch all details yet. Give me 3 items: days + style (history/adventure/relaxation) + budget, and I will suggest a clear route.';
    }
    return ar
        ? 'هل تريد مساعدة في: معلومات وجهة، مقارنة بين مكانين، تخطيط حسب عدد الأيام، أم استخدام التطبيق؟'
        : 'Do you want help with destination info, place comparison, planning by day count, or app usage?';
  }

  static List<String> _rankedDestinations(String style, int days) {
    final base = LocalAssistantKnowledgeBase.tripStyles[style] ?? LocalAssistantKnowledgeBase.tripStyles['mixed']!;
    final count = days <= 3
        ? 2
        : days <= 5
            ? 3
            : days <= 7
                ? 4
                : 5;
    return base.take(count).toList();
  }

  static String _durationPlan(int days, bool ar) {
    if (days <= 3) {
      return ar ? 'لـ 3 أيام: الأفضل محطتان كحد أقصى.' : 'For 3 days: keep it to two stops max.';
    }
    if (days <= 5) {
      return ar ? 'لـ 5 أيام: ثلاث محطات عادةً تعطي توازناً جيداً.' : 'For 5 days: three stops usually give good balance.';
    }
    return ar ? 'لـ 7 أيام أو أكثر: يمكنك توسيع المسار وإضافة محطة تاريخية أو بحرية.' : 'For 7+ days: you can broaden the route with an extra historical or sea stop.';
  }

  static String _styleLabel(String style, bool ar) {
    return switch (style) {
      'history' => ar ? 'تاريخي' : 'history',
      'adventure' => ar ? 'مغامرة' : 'adventure',
      'relaxation' => ar ? 'استرخاء' : 'relaxation',
      'family' => ar ? 'عائلي' : 'family',
      'romantic' => ar ? 'رومانسي' : 'romantic',
      'luxury' => ar ? 'فاخر' : 'luxury',
      _ => ar ? 'متوازن' : 'mixed',
    };
  }
}
