import 'package:voyage_jordan2/features/ai_assistant/trip_build_profile.dart';
import 'package:voyage_jordan2/features/ai_assistant/trip_recommendation_engine.dart';
import 'package:voyage_jordan2/models/trip_plan_build_result.dart';

/// Which step the UI shows (preference-first; destinations are inferred later).
enum TripBuilderActiveStep {
  none,
  days,
  experience,
  budget,
  pace,
  places,
  transport,
  special,
  awaitingApproval,
}

/// Detect if user wants the guided chat trip-builder.
class TripBuilderIntent {
  TripBuilderIntent._();

  static bool shouldStart(String raw) {
    final lower = raw.trim().toLowerCase();
    final o = raw.trim();
    if (lower.isEmpty) return false;
    if (_cancel(lower, o)) return false;

    if (_match(lower, o, const [
          'build me a trip', 'build us a trip', 'build my trip', 'build a trip with me', 'trip with me',
          'help me plan a trip', 'help me build a trip', 'plan me a trip', 'plan my trip through chat',
          'trip through chat', 'chat trip', 'assistant trip', 'walk me through a trip', 'step by step trip',
          'interactive trip', 'help me build', 'create a trip with you', 'design my itinerary',
          'ابن لي رحلة', 'ابنِ لي رحلة', 'ابن رحلة معي', 'ابني رحلة', 'خطط لي رحلة', 'ساعدني أبني رحلة',
          'رحلة تفاعلية', 'خطوة بخطوة', 'بناء رحلة', 'أريد رحلة مخصصة',
        ])) {
      return true;
    }
    if ((lower.contains('build') || lower.contains('create') || lower.contains('design')) &&
        (lower.contains('trip') || lower.contains('itinerary') || lower.contains('vacation')) &&
        (lower.contains('you') ||
            lower.contains('with you') ||
            lower.contains('with me') ||
            lower.contains('assistant') ||
            lower.contains('chat'))) {
      return true;
    }
    if (_match(lower, o, const ['أريد', 'ابغى', 'بدي']) &&
        _match(lower, o, const ['رحلة', 'برنامج']) &&
        _match(lower, o, const ['تسأل', 'اسأل', 'خطوة', 'معك', 'مخصص'])) {
      return true;
    }
    return false;
  }

  static bool isCancel(String raw) {
    final lower = raw.trim().toLowerCase();
    return _cancel(lower, raw.trim());
  }

  static bool _cancel(String lower, String o) {
    return _match(lower, o, const [
      'cancel', 'stop', 'never mind', 'nevermind', 'exit', 'quit', 'later',
      'الغاء', 'إلغاء', 'وقف', 'بعدين', 'لا تكمل',
    ]);
  }

  static bool _match(String lower, String original, List<String> keys) {
    for (final k in keys) {
      final kk = k.trim().toLowerCase();
      if (kk.isEmpty) continue;
      if (lower.contains(kk)) return true;
      if (original.contains(k)) return true;
    }
    return false;
  }
}

enum _Collect {
  days,
  experience,
  budget,
  pace,
  places,
  transport,
  special,
  awaitingApproval,
  finished,
}

/// Stateful preference interview → inferred plan → awaiting Save / Modify.
class TripBuilderChatFlow {
  TripBuilderChatFlow();

  _Collect _step = _Collect.finished;
  int? _days;
  ExperienceKind? _experience;
  BudgetAnswer? _budget;
  PaceKind? _pace;
  PlaceKind? _places;
  TransportAnswer? _transport;

  TripPlanBuildResult? _pendingResult;
  TripBuildProfile? _profile;

  bool get isActive => _step != _Collect.finished;

  bool get awaitingApproval => _step == _Collect.awaitingApproval;

  TripPlanBuildResult? get pendingBuildResult => _pendingResult;

  TripBuilderActiveStep get activeUiStep {
    switch (_step) {
      case _Collect.days:
        return TripBuilderActiveStep.days;
      case _Collect.experience:
        return TripBuilderActiveStep.experience;
      case _Collect.budget:
        return TripBuilderActiveStep.budget;
      case _Collect.pace:
        return TripBuilderActiveStep.pace;
      case _Collect.places:
        return TripBuilderActiveStep.places;
      case _Collect.transport:
        return TripBuilderActiveStep.transport;
      case _Collect.special:
        return TripBuilderActiveStep.special;
      case _Collect.awaitingApproval:
        return TripBuilderActiveStep.awaitingApproval;
      case _Collect.finished:
        return TripBuilderActiveStep.none;
    }
  }

  void markSaved() {
    _step = _Collect.finished;
    _pendingResult = null;
    _profile = null;
  }

  /// Clears interview state and returns the opening message for a fresh run.
  String restartInterview(bool arabic) {
    _step = _Collect.days;
    _days = null;
    _experience = null;
    _budget = null;
    _pace = null;
    _places = null;
    _transport = null;
    _pendingResult = null;
    _profile = null;
    return start(arabic);
  }

  String start(bool arabic) {
    _step = _Collect.days;
    _days = null;
    _experience = null;
    _budget = null;
    _pace = null;
    _places = null;
    _transport = null;
    _pendingResult = null;
    _profile = null;
    if (arabic) {
      return 'لنخطط معاً رحلتك في الأردن—سأطرح عليك أسئلة عن تفضيلاتك، ثم أقترح الوجهات والمسار المناسبين لك (تجريبي).\n\n'
          'السؤال ١ من ٧: كم يوماً لديك للرحلة؟ اختر أحد الخيارات أدناه.';
    }
    return 'Let’s shape a Jordan trip around you—I’ll ask about your style and pace first, then I’ll pick destinations and a route that fit (demo).\n\n'
        'Question 1 of 7: How many days do you have? Choose an option below.';
  }

  String? consume(String raw, bool arabic) {
    final t = raw.trim();
    if (t.isEmpty) {
      return arabic ? 'اختر إجابة من الأزرار أدناه.' : 'Pick an answer from the buttons below.';
    }
    if (_step == _Collect.awaitingApproval) {
      if (TripBuilderIntent.isCancel(t)) {
        _step = _Collect.finished;
        _pendingResult = null;
        _profile = null;
        return arabic ? 'ألغينا الخطة المعلقة. يمكنك البدء من جديد متى شئت.' : 'Pending plan dismissed. Start again whenever you like.';
      }
      return null;
    }

    if (TripBuilderIntent.isCancel(t)) {
      _step = _Collect.finished;
      return arabic
          ? 'أوقفت التخطيط. يمكنك البدء مجدداً بطلب مثل: «ساعدني أبني رحلة».'
          : 'Planning cancelled. Say “help me plan a trip” anytime to start again.';
    }

    switch (_step) {
      case _Collect.days:
        final d = _parseDays(t);
        if (d == null) {
          return arabic ? 'اختر ٣ أو ٥ أو ٧ أو ١٠ أيام من الأزرار.' : 'Please pick 3, 5, 7, or 10 days from the buttons.';
        }
        _days = d.clamp(1, 14);
        _step = _Collect.experience;
        return arabic ? _qExperienceAr : _qExperienceEn;

      case _Collect.experience:
        final e = _parseExperience(t);
        if (e == null) return arabic ? _repExperienceAr : _repExperienceEn;
        _experience = e;
        _step = _Collect.budget;
        return arabic ? _qBudgetAr : _qBudgetEn;

      case _Collect.budget:
        final b = _parseBudget(t);
        if (b == null) return arabic ? _repBudgetAr : _repBudgetEn;
        _budget = b;
        _step = _Collect.pace;
        return arabic ? _qPaceAr : _qPaceEn;

      case _Collect.pace:
        final p = _parsePace(t);
        if (p == null) return arabic ? _repPaceAr : _repPaceEn;
        _pace = p;
        _step = _Collect.places;
        return arabic ? _qPlacesAr : _qPlacesEn;

      case _Collect.places:
        final pl = _parsePlaces(t);
        if (pl == null) return arabic ? _repPlacesAr : _repPlacesEn;
        _places = pl;
        _step = _Collect.transport;
        return arabic ? _qTransportAr : _qTransportEn;

      case _Collect.transport:
        final tr = _parseTransport(t);
        if (tr == null) return arabic ? _repTransportAr : _repTransportEn;
        _transport = tr;
        _step = _Collect.special;
        return arabic ? _qSpecialAr : _qSpecialEn;

      case _Collect.special:
        final sp = _parseSpecial(t);
        if (sp == null) return arabic ? _repSpecialAr : _repSpecialEn;
        _profile = TripBuildProfile(
          days: _days ?? 5,
          experience: _experience ?? ExperienceKind.mixed,
          budget: _budget ?? BudgetAnswer.moderate,
          pace: _pace ?? PaceKind.balanced,
          places: _places ?? PlaceKind.mixed,
          transport: _transport ?? TransportAnswer.privateDriver,
          special: sp,
        );
        final outcome = TripRecommendationEngine.compose(_profile!, arabic: arabic);
        _pendingResult = outcome.buildResult;
        _step = _Collect.awaitingApproval;
        return outcome.chatText;

      case _Collect.awaitingApproval:
      case _Collect.finished:
        return null;
    }
  }

  static final RegExp _digits = RegExp(r'(\d+)');

  static int? _parseDays(String t) {
    final lower = t.toLowerCase();
    final m = _digits.firstMatch(lower);
    if (m != null) return int.tryParse(m.group(1)!);
    if (lower.contains('three') || t.contains('ثلاث')) return 3;
    if (lower.contains('five') || t.contains('خمس')) return 5;
    if (lower.contains('seven') || t.contains('سبع')) return 7;
    if (lower.contains('ten') || t.contains('عشر')) return 10;
    return null;
  }

  static ExperienceKind? _parseExperience(String t) {
    final lower = t.toLowerCase();
    if (_match(lower, t, const ['history culture', 'history', 'culture', 'ثقافة', 'تاريخ'])) {
      return ExperienceKind.historyCulture;
    }
    if (_match(lower, t, const ['adventure', 'مغامرة'])) return ExperienceKind.adventure;
    if (_match(lower, t, const ['relaxation', 'relax', 'استرخاء'])) return ExperienceKind.relaxation;
    if (_match(lower, t, const ['family', 'عائلة', 'عائلي'])) return ExperienceKind.familyFriendly;
    if (_match(lower, t, const ['mixed', 'مزيج'])) return ExperienceKind.mixed;
    return null;
  }

  static BudgetAnswer? _parseBudget(String t) {
    final lower = t.toLowerCase();
    if (_match(lower, t, const ['economy', 'cheap', 'اقتصادي'])) return BudgetAnswer.economy;
    if (_match(lower, t, const ['luxury', 'premium', 'فاخر'])) return BudgetAnswer.luxury;
    if (_match(lower, t, const ['moderate', 'medium', 'متوسط'])) return BudgetAnswer.moderate;
    return null;
  }

  static PaceKind? _parsePace(String t) {
    final lower = t.toLowerCase();
    if (_match(lower, t, const ['calm', 'slow', 'هادئ'])) return PaceKind.calm;
    if (_match(lower, t, const ['active', 'busy', 'نشيط'])) return PaceKind.active;
    if (_match(lower, t, const ['balanced', 'balance', 'متوازن'])) return PaceKind.balanced;
    return null;
  }

  static PlaceKind? _parsePlaces(String t) {
    final lower = t.toLowerCase();
    if (_match(lower, t, const ['historical', 'history places', 'آثار', 'تاريخية'])) return PlaceKind.historical;
    if (_match(lower, t, const ['nature', 'natural', 'طبيعة'])) return PlaceKind.nature;
    if (_match(lower, t, const ['sea', 'beach', 'بحر'])) return PlaceKind.sea;
    if (_match(lower, t, const ['desert', 'صحراء'])) return PlaceKind.desert;
    if (_match(lower, t, const ['mixed', 'مزيج'])) return PlaceKind.mixed;
    return null;
  }

  static TransportAnswer? _parseTransport(String t) {
    final lower = t.toLowerCase();
    if (_match(lower, t, const ['rental', 'rental car', 'إيجار'])) return TransportAnswer.rentalCar;
    if (_match(lower, t, const ['private driver', 'driver', 'سائق'])) return TransportAnswer.privateDriver;
    if (_match(lower, t, const ['public', 'bus', 'عامة'])) return TransportAnswer.publicTransport;
    if (_match(lower, t, const ['guided', 'tour', 'مرشد'])) return TransportAnswer.guidedTour;
    return null;
  }

  static SpecialPreference? _parseSpecial(String t) {
    final lower = t.toLowerCase();
    if (_match(lower, t, const ['none', 'no preference', 'لا', 'لا يوجد', 'بدون'])) {
      return SpecialPreference.none;
    }
    if (_match(lower, t, const ['crowd', 'زحام', 'ازدحام'])) return SpecialPreference.avoidCrowds;
    if (_match(lower, t, const ['heat', 'sun', 'حر', 'شمس'])) return SpecialPreference.heatSensitive;
    if (_match(lower, t, const ['walk', 'walking', 'مشي', 'مشي طويل'])) {
      return SpecialPreference.shorterWalks;
    }
    return null;
  }

  static bool _match(String lower, String original, List<String> keys) {
    for (final k in keys) {
      final kk = k.trim().toLowerCase();
      if (kk.isEmpty) continue;
      if (lower.contains(kk)) return true;
      if (original.contains(k)) return true;
    }
    return false;
  }

  static const _qExperienceEn =
      'Question 2 of 7: What kind of experience do you enjoy most?\nChoose an option below.';
  static const _qExperienceAr =
      'السؤال ٢ من ٧: ما نوع التجربة التي تستمتع بها أكثر؟\nاختر أدناه.';
  static const _repExperienceEn = 'Pick one: history & culture, adventure, relaxation, family-friendly, or mixed.';
  static const _repExperienceAr = 'اختر: تاريخ وثقافة، مغامرة، استرخاء، عائلي، أو مزيج.';

  static const _qBudgetEn = 'Question 3 of 7: What budget level do you prefer?\nChoose an option below.';
  static const _qBudgetAr = 'السؤال ٣ من ٧: ما مستوى الميزانية الذي تفضله؟\nاختر أدناه.';
  static const _repBudgetEn = 'Pick economy, moderate, or luxury.';
  static const _repBudgetAr = 'اختر: اقتصادي، متوسط، أو فاخر.';

  static const _qPaceEn =
      'Question 4 of 7: What travel pace do you prefer?\nChoose calm, active, or balanced.';
  static const _qPaceAr =
      'السؤال ٤ من ٧: ما إيقاع السفر الذي تفضله؟\nاختر: هادئ، نشيط، أو متوازن.';
  static const _repPaceEn = 'Pick calm, active, or balanced.';
  static const _repPaceAr = 'اختر: هادئ، نشيط، أو متوازن.';

  static const _qPlacesEn =
      'Question 5 of 7: What type of places do you enjoy most?\nChoose historical, nature, sea, desert, or mixed.';
  static const _qPlacesAr =
      'السؤال ٥ من ٧: ما نوع الأماكن التي تستمتع بها أكثر؟\nاختر: تاريخية، طبيعة، بحر، صحراء، أو مزيج.';
  static const _repPlacesEn = 'Pick historical, nature, sea, desert, or mixed.';
  static const _repPlacesAr = 'اختر: تاريخية، طبيعة، بحر، صحراء، أو مزيج.';

  static const _qTransportEn =
      'Question 6 of 7: Do you prefer a private or flexible transport style?\nChoose an option below.';
  static const _qTransportAr =
      'السؤال ٦ من ٧: ما أسلوب النقل الأنسب لك؟\nاختر أدناه.';
  static const _repTransportEn = 'Pick rental car, private driver, guided tour, or public transport.';
  static const _repTransportAr = 'اختر: إيجار سيارة، سائق خاص، جولة مع مرشد، أو مواصلات عامة.';

  static const _qSpecialEn =
      'Question 7 of 7 (optional): Any must-avoid or special preference?\nChoose one, or “No preference”.';
  static const _qSpecialAr =
      'السؤال ٧ من ٧ (اختياري): أي تفضيل خاص أو تجنب؟\nاختر واحداً، أو «بدون تفضيل خاص».';
  static const _repSpecialEn = 'Pick no preference, avoid crowds, heat-sensitive, or shorter walks.';
  static const _repSpecialAr = 'اختر: بدون، تجنب الزحام، حساسية حرارة، أو مشي أقصر.';
}
