enum AssistantIntentType {
  destinationInfo,
  comparison,
  recommendation,
  tripStyle,
  budget,
  transport,
  appHelp,
  tripPlanning,
  fallback,
}

class AssistantIntent {
  const AssistantIntent({
    required this.type,
    this.destinationIds = const [],
    this.comparisonKey,
    this.styleKey,
    this.appHelpKey,
    this.days,
  });

  final AssistantIntentType type;
  final List<String> destinationIds;
  final String? comparisonKey;
  final String? styleKey;
  final String? appHelpKey;
  final int? days;
}

class LocalAssistantIntentLayer {
  LocalAssistantIntentLayer._();

  static final RegExp _daysEn = RegExp(r'(\d+)\s*(?:day|days|night|nights)\b', caseSensitive: false);
  static final RegExp _daysAr = RegExp(r'([0-9٠-٩]+)\s*(?:يوم|أيام)');
  static final RegExp _money = RegExp(r'[\$€£]\s*\d[\d,]*|\d[\d,]*\s*(?:usd|eur|gbp|dollars?|euros?)', caseSensitive: false);

  static AssistantIntent detect({
    required String text,
    required String lower,
    required List<String> matchedDestinationIds,
  }) {
    final comparisonKey = _comparisonKey(matchedDestinationIds);
    if (comparisonKey != null && _hasAny(lower, text, const ['vs', 'versus', 'compare', 'better', 'or', 'أيهما', 'أفضل', 'مقارنة', 'أو'])) {
      return AssistantIntent(type: AssistantIntentType.comparison, comparisonKey: comparisonKey, destinationIds: matchedDestinationIds);
    }

    if (_hasAny(lower, text, const ['how do i plan', 'plan my trip', 'start planning', 'خطوات التخطيط', 'كيف أخطط', 'كيف اخطط'])) {
      return AssistantIntent(type: AssistantIntentType.tripPlanning);
    }
    if (_hasAny(lower, text, const ['how to generate', 'generate trip', 'generate plan', 'إنشاء خطة', 'كيف أنشئ', 'كيف انشئ'])) {
      return const AssistantIntent(type: AssistantIntentType.appHelp, appHelpKey: 'how_to_generate');
    }
    if (_hasAny(lower, text, const ['how to save', 'save trip', 'حفظ الرحلة', 'كيف أحفظ', 'كيف احفظ'])) {
      return const AssistantIntent(type: AssistantIntentType.appHelp, appHelpKey: 'how_to_save');
    }
    if (_hasAny(lower, text, const ['my trip', 'رحلتي'])) {
      return const AssistantIntent(type: AssistantIntentType.appHelp, appHelpKey: 'what_my_trip_does');
    }
    if (_hasAny(lower, text, const ['destination page', 'destination pages', 'صفحات الوجهات', 'صفحة الوجهة'])) {
      return const AssistantIntent(type: AssistantIntentType.appHelp, appHelpKey: 'what_destination_pages_show');
    }
    if (_hasAny(lower, text, const ['what can you do', 'assistant can do', 'ماذا يمكنك', 'بماذا تساعد'])) {
      return const AssistantIntent(type: AssistantIntentType.appHelp, appHelpKey: 'what_ai_assistant_can_do');
    }

    if (matchedDestinationIds.isNotEmpty) {
      return AssistantIntent(type: AssistantIntentType.destinationInfo, destinationIds: matchedDestinationIds);
    }

    if (_money.hasMatch(lower) ||
        _hasAny(lower, text, const ['budget', 'cost', 'enough', 'economy', 'moderate', 'luxury', 'ميزانية', 'تكلفة', 'يكفي'])) {
      return const AssistantIntent(type: AssistantIntentType.budget);
    }

    if (_hasAny(lower, text, const ['transport', 'rental', 'driver', 'public', 'guided', 'car', 'نقل', 'سائق', 'إيجار', 'مواصلات'])) {
      return const AssistantIntent(type: AssistantIntentType.transport);
    }

    final style = _styleKey(lower, text);
    if (style != null) {
      return AssistantIntent(type: AssistantIntentType.tripStyle, styleKey: style, days: _extractDays(lower, text));
    }

    if (_hasAny(lower, text, const [
      'recommend',
      'where to go',
      'what should i choose',
      'for me',
      'i do not know where to go',
      'smart plan',
      'اقترح',
      'محتار',
      'ماذا أختار'
    ])) {
      return AssistantIntent(type: AssistantIntentType.recommendation, styleKey: style ?? 'mixed', days: _extractDays(lower, text));
    }

    if (_hasAny(lower, text, const ['trip', 'travel', 'vacation', 'رحلة', 'سفر'])) {
      return AssistantIntent(type: AssistantIntentType.recommendation, styleKey: style ?? 'mixed', days: _extractDays(lower, text));
    }

    return AssistantIntent(type: AssistantIntentType.fallback, days: _extractDays(lower, text));
  }

  static String? _comparisonKey(List<String> ids) {
    if (ids.contains('petra') && ids.contains('wadi-rum')) return 'petra|wadi-rum';
    if (ids.contains('aqaba') && ids.contains('dead-sea')) return 'aqaba|dead-sea';
    if (ids.contains('jerash') && ids.contains('petra')) return 'jerash|petra';
    return null;
  }

  static String? _styleKey(String lower, String original) {
    if (_hasAny(lower, original, const ['history', 'culture', 'roman', 'تاريخ', 'ثقافة', 'روماني'])) return 'history';
    if (_hasAny(lower, original, const ['adventure', 'desert', 'مغامرة', 'صحراء'])) return 'adventure';
    if (_hasAny(lower, original, const ['relax', 'wellness', 'calm', 'استرخاء', 'هدوء'])) return 'relaxation';
    if (_hasAny(lower, original, const ['family', 'kids', 'children', 'عائلة', 'أطفال'])) return 'family';
    if (_hasAny(lower, original, const ['romantic', 'honeymoon', 'رومانسي', 'شهر عسل'])) return 'romantic';
    if (_hasAny(lower, original, const ['luxury', 'premium', 'فاخر', 'فخمة'])) return 'luxury';
    if (_hasAny(lower, original, const ['nature', 'photography', 'sea', 'beach', 'طبيعة', 'تصوير', 'بحر'])) return 'mixed';
    return null;
  }

  static int _extractDays(String lower, String original) {
    final m = _daysEn.firstMatch(lower);
    if (m != null) return int.tryParse(m.group(1) ?? '') ?? 5;
    final ar = _daysAr.firstMatch(original);
    if (ar == null) return 5;
    final raw = ar.group(1)!;
    const digits = '٠١٢٣٤٥٦٧٨٩';
    final normalized = raw.runes.map((r) {
      final c = String.fromCharCode(r);
      final i = digits.indexOf(c);
      return i >= 0 ? '$i' : c;
    }).join();
    return int.tryParse(normalized) ?? 5;
  }

  static bool _hasAny(String lower, String original, List<String> keys) {
    for (final k in keys) {
      if (lower.contains(k.toLowerCase()) || original.contains(k)) return true;
    }
    return false;
  }
}
