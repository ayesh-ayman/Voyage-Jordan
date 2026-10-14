class DestinationKnowledge {
  const DestinationKnowledge({
    required this.id,
    required this.aliases,
    required this.nameEn,
    required this.nameAr,
    required this.summaryEn,
    required this.summaryAr,
    required this.bestForEn,
    required this.bestForAr,
    required this.activitiesEn,
    required this.activitiesAr,
    required this.styleTags,
    required this.seasonNotesEn,
    required this.seasonNotesAr,
    required this.familyFit,
    required this.relaxationFit,
    required this.adventureFit,
    required this.historyFit,
    required this.photographyFit,
    required this.comparisonNotesEn,
    required this.comparisonNotesAr,
    required this.foodNotesEn,
    required this.foodNotesAr,
  });

  final String id;
  final List<String> aliases;
  final String nameEn;
  final String nameAr;
  final String summaryEn;
  final String summaryAr;
  final String bestForEn;
  final String bestForAr;
  final List<String> activitiesEn;
  final List<String> activitiesAr;
  final List<String> styleTags;
  final String seasonNotesEn;
  final String seasonNotesAr;
  final int familyFit;
  final int relaxationFit;
  final int adventureFit;
  final int historyFit;
  final int photographyFit;
  final String comparisonNotesEn;
  final String comparisonNotesAr;
  final String foodNotesEn;
  final String foodNotesAr;
}

class AppHelpKnowledge {
  const AppHelpKnowledge({
    required this.howToPlanEn,
    required this.howToPlanAr,
    required this.howToGenerateEn,
    required this.howToGenerateAr,
    required this.howToSaveEn,
    required this.howToSaveAr,
    required this.whatMyTripDoesEn,
    required this.whatMyTripDoesAr,
    required this.whatDestinationPagesShowEn,
    required this.whatDestinationPagesShowAr,
    required this.whatAiAssistantCanDoEn,
    required this.whatAiAssistantCanDoAr,
  });

  final String howToPlanEn;
  final String howToPlanAr;
  final String howToGenerateEn;
  final String howToGenerateAr;
  final String howToSaveEn;
  final String howToSaveAr;
  final String whatMyTripDoesEn;
  final String whatMyTripDoesAr;
  final String whatDestinationPagesShowEn;
  final String whatDestinationPagesShowAr;
  final String whatAiAssistantCanDoEn;
  final String whatAiAssistantCanDoAr;
}

class LocalAssistantKnowledgeBase {
  LocalAssistantKnowledgeBase._();

  static const Map<String, DestinationKnowledge> destinations = {
    'petra': DestinationKnowledge(
      id: 'petra',
      aliases: ['petra', 'البتراء', 'بتراء'],
      nameEn: 'Petra',
      nameAr: 'البتراء',
      summaryEn: 'Rock-carved Nabataean city with iconic canyons and monuments.',
      summaryAr: 'مدينة نبطية منحوتة في الصخر بمعالم وأودية أيقونية.',
      bestForEn: 'History, culture, photography, and classic first-time Jordan trips.',
      bestForAr: 'التاريخ والثقافة والتصوير والزيارة الأولى للأردن.',
      activitiesEn: ['Siq walk', 'Treasury viewpoint', 'Monastery trail'],
      activitiesAr: ['المشي في السيق', 'إطلالة الخزنة', 'مسار الدير'],
      styleTags: ['history', 'culture', 'photography', 'walking'],
      seasonNotesEn: 'Spring and autumn are usually most comfortable for walking.',
      seasonNotesAr: 'الربيع والخريف غالباً الأفضل للمشي.',
      familyFit: 3,
      relaxationFit: 2,
      adventureFit: 3,
      historyFit: 5,
      photographyFit: 5,
      comparisonNotesEn: 'Larger and more iconic than Jerash; more walking intensity.',
      comparisonNotesAr: 'أوسع وأكثر شهرة من جرش لكن يحتاج مشياً أكثر.',
      foodNotesEn: 'Nearby towns have traditional Jordanian grills and mezze.',
      foodNotesAr: 'المدن القريبة تقدم مشاوي ومقبلات أردنية تقليدية.',
    ),
    'wadi-rum': DestinationKnowledge(
      id: 'wadi-rum',
      aliases: ['wadi rum', 'wadirum', 'وادي رم'],
      nameEn: 'Wadi Rum',
      nameAr: 'وادي رم',
      summaryEn: 'Desert valley known for red dunes, rock formations, and stargazing.',
      summaryAr: 'وادٍ صحراوي مشهور بالكثبان الحمراء والتكوينات الصخرية والنجوم.',
      bestForEn: 'Adventure seekers, desert lovers, and landscape photography.',
      bestForAr: 'عشاق المغامرة والصحراء والتصوير الطبيعي.',
      activitiesEn: ['Jeep tour', 'Bedouin camp', 'Stargazing'],
      activitiesAr: ['جولة جيب', 'مخيم بدوي', 'رصد النجوم'],
      styleTags: ['adventure', 'desert', 'nature', 'photography'],
      seasonNotesEn: 'Shoulder seasons are easier; summer afternoons can be very hot.',
      seasonNotesAr: 'المواسم المعتدلة أسهل، وصيف الظهيرة قد يكون حاراً جداً.',
      familyFit: 3,
      relaxationFit: 2,
      adventureFit: 5,
      historyFit: 2,
      photographyFit: 5,
      comparisonNotesEn: 'More adventure/desert than Petra, less archaeology depth.',
      comparisonNotesAr: 'أكثر مغامرة وصحراء من البتراء وأقل عمقاً أثرياً.',
      foodNotesEn: 'Camp meals are often Bedouin-style and simple.',
      foodNotesAr: 'وجبات المخيم غالباً بدوية وبسيطة.',
    ),
    'aqaba': DestinationKnowledge(
      id: 'aqaba',
      aliases: ['aqaba', 'العقبة', 'عقبة'],
      nameEn: 'Aqaba',
      nameAr: 'العقبة',
      summaryEn: 'Jordan’s Red Sea city with beaches, diving, and resort stays.',
      summaryAr: 'مدينة البحر الأحمر في الأردن بشواطئ وغوص وإقامة منتجعية.',
      bestForEn: 'Sea activities, relaxed evenings, and family-friendly beach days.',
      bestForAr: 'الأنشطة البحرية والأمسيات الهادئة وأيام الشاطئ العائلية.',
      activitiesEn: ['Snorkeling', 'Diving', 'Marina walk'],
      activitiesAr: ['سنوركل', 'غوص', 'المشي على المارينا'],
      styleTags: ['sea', 'relaxation', 'family', 'adventure'],
      seasonNotesEn: 'Good almost year-round; summers can be hot but water remains popular.',
      seasonNotesAr: 'مناسبة معظم السنة؛ الصيف حار لكن البحر يبقى جذاباً.',
      familyFit: 4,
      relaxationFit: 4,
      adventureFit: 4,
      historyFit: 1,
      photographyFit: 4,
      comparisonNotesEn: 'More active sea vibe than the Dead Sea’s wellness focus.',
      comparisonNotesAr: 'أكثر نشاطاً بحرياً من طابع الاسترخاء في البحر الميت.',
      foodNotesEn: 'Strong seafood options plus casual waterfront dining.',
      foodNotesAr: 'خيارات بحرية جيدة ومطاعم واجهة بحرية.',
    ),
    'jerash': DestinationKnowledge(
      id: 'jerash',
      aliases: ['jerash', 'جرش'],
      nameEn: 'Jerash',
      nameAr: 'جرش',
      summaryEn: 'Well-preserved Roman ruins with colonnades, theaters, and plazas.',
      summaryAr: 'آثار رومانية محفوظة جيداً بساحات ومسارح وشوارع أعمدة.',
      bestForEn: 'Roman history lovers and culture-focused day trips.',
      bestForAr: 'عشاق التاريخ الروماني والرحلات الثقافية القصيرة.',
      activitiesEn: ['Oval plaza visit', 'Theater walk', 'Roman street circuit'],
      activitiesAr: ['زيارة الساحة البيضاوية', 'جولة المسارح', 'مسار الشارع الروماني'],
      styleTags: ['history', 'culture', 'short-trip'],
      seasonNotesEn: 'Comfortable in mild months; easy to pair with Amman.',
      seasonNotesAr: 'مريحة في الأجواء المعتدلة وسهلة الدمج مع عمّان.',
      familyFit: 3,
      relaxationFit: 2,
      adventureFit: 1,
      historyFit: 5,
      photographyFit: 4,
      comparisonNotesEn: 'More compact and easier than Petra; less dramatic geology.',
      comparisonNotesAr: 'أكثر اختصاراً وأسهل من البتراء لكن أقل درامية جيولوجياً.',
      foodNotesEn: 'Local grills and sweets are easy to find nearby.',
      foodNotesAr: 'تتوفر مشاوي وحلويات محلية بسهولة قرب الموقع.',
    ),
    'dead-sea': DestinationKnowledge(
      id: 'dead-sea',
      aliases: ['dead sea', 'deadsea', 'البحر الميت', 'بحر ميت'],
      nameEn: 'Dead Sea',
      nameAr: 'البحر الميت',
      summaryEn: 'Lowest point on Earth, famous for floating, mud, and spa resorts.',
      summaryAr: 'أخفض نقطة على سطح الأرض، مشهورة بالطفو والطين والمنتجعات الصحية.',
      bestForEn: 'Relaxation, wellness, couples, and low-effort recovery days.',
      bestForAr: 'الاسترخاء والعافية والأزواج وأيام التعافي الهادئة.',
      activitiesEn: ['Floating experience', 'Mud/spa', 'Resort downtime'],
      activitiesAr: ['تجربة الطفو', 'طين وسبا', 'وقت منتجعي هادئ'],
      styleTags: ['relaxation', 'wellness', 'romantic', 'family'],
      seasonNotesEn: 'Comfortable outside peak summer heat.',
      seasonNotesAr: 'أكثر راحة خارج ذروة حر الصيف.',
      familyFit: 4,
      relaxationFit: 5,
      adventureFit: 1,
      historyFit: 1,
      photographyFit: 3,
      comparisonNotesEn: 'More wellness-focused than Aqaba’s sea-activity profile.',
      comparisonNotesAr: 'يميل للعافية والاسترخاء أكثر من نشاطات العقبة البحرية.',
      foodNotesEn: 'Resort dining dominates; quality depends on property tier.',
      foodNotesAr: 'الطعام غالباً منتجعي ويتفاوت حسب مستوى الإقامة.',
    ),
  };

  static const Map<String, List<String>> tripStyles = {
    'history': ['petra', 'jerash', 'dead-sea'],
    'adventure': ['wadi-rum', 'aqaba', 'petra'],
    'relaxation': ['dead-sea', 'aqaba', 'petra'],
    'family': ['aqaba', 'dead-sea', 'petra'],
    'romantic': ['dead-sea', 'aqaba', 'petra'],
    'luxury': ['petra', 'dead-sea', 'aqaba'],
    'mixed': ['petra', 'wadi-rum', 'dead-sea', 'aqaba'],
    'short-trip': ['petra', 'wadi-rum'],
    'long-trip': ['petra', 'wadi-rum', 'dead-sea', 'aqaba', 'jerash'],
  };

  static const Map<String, String> comparisonsEn = {
    'petra|wadi-rum':
        'Petra is stronger for archaeology/history and iconic architecture; Wadi Rum is stronger for desert adventure, camps, and open landscapes.',
    'aqaba|dead-sea':
        'Aqaba fits sea activity and diving; Dead Sea fits wellness and calm resort recovery.',
    'jerash|petra':
        'Jerash is compact Roman history; Petra is larger, more iconic, and usually a heavier walking day.',
  };
  static const Map<String, String> comparisonsAr = {
    'petra|wadi-rum':
        'البتراء أقوى للتاريخ والآثار، بينما وادي رم أقوى للمغامرة الصحراوية والمخيمات والمناظر المفتوحة.',
    'aqaba|dead-sea':
        'العقبة أنسب للنشاط البحري والغوص، والبحر الميت أنسب للعافية والاسترخاء.',
    'jerash|petra':
        'جرش تاريخ روماني مختصر، والبتراء أوسع وأكثر أيقونية وغالباً تتطلب مشياً أكثر.',
  };

  static const Map<String, String> tourismFaqEn = {
    'best_for_history': 'For history, start with Petra + Jerash.',
    'best_for_adventure': 'For adventure, prioritize Wadi Rum + Aqaba.',
    'best_for_relaxation': 'For relaxation, prioritize Dead Sea + Aqaba.',
    'best_for_family': 'For family-friendly pacing, combine Aqaba/Dead Sea with one highlight day in Petra.',
    'best_for_sea': 'For sea focus, Aqaba is your strongest base.',
    'best_for_nature': 'For nature and photography, Wadi Rum plus Aqaba (and Petra if time allows) works very well.',
  };
  static const Map<String, String> tourismFaqAr = {
    'best_for_history': 'للتاريخ: ابدأ بالبتراء + جرش.',
    'best_for_adventure': 'للمغامرة: ركّز على وادي رم + العقبة.',
    'best_for_relaxation': 'للاسترخاء: ركّز على البحر الميت + العقبة.',
    'best_for_family': 'للإيقاع العائلي: اجمع العقبة/البحر الميت مع يوم مميز في البتراء.',
    'best_for_sea': 'للبحر: العقبة هي القاعدة الأقوى.',
    'best_for_nature': 'للطبيعة والتصوير: وادي رم مع العقبة (ومع البتراء إن سمح الوقت) ممتاز.',
  };

  static const AppHelpKnowledge appHelp = AppHelpKnowledge(
    howToPlanEn:
        'Home → Start Planning Your Trip → choose destinations, days, budget, and transport.',
    howToPlanAr:
        'الرئيسية → ابدأ التخطيط لرحلتك → اختر الوجهات والأيام والميزانية والنقل.',
    howToGenerateEn:
        'After setting choices, tap Generate Trip Plan to produce the itinerary.',
    howToGenerateAr:
        'بعد تحديد الاختيارات اضغط إنشاء خطة الرحلة لتوليد البرنامج.',
    howToSaveEn:
        'Open itinerary and tap Save Plan. The latest saved summary appears in My Trip.',
    howToSaveAr:
        'افتح برنامج الرحلة واضغط حفظ الخطة. سيظهر آخر ملخص محفوظ في رحلتي.',
    whatMyTripDoesEn:
        'My Trip stores your latest saved trip summary and links to full itinerary details.',
    whatMyTripDoesAr:
        'رحلتي تحفظ ملخص آخر رحلة محفوظة وتوفر الوصول للتفاصيل الكاملة.',
    whatDestinationPagesShowEn:
        'Destination pages show highlights, activities, stay ideas, and dining context.',
    whatDestinationPagesShowAr:
        'صفحات الوجهات تعرض أبرز المعالم والأنشطة وأفكار الإقامة والطعام.',
    whatAiAssistantCanDoEn:
        'The assistant compares places, suggests routes by style/days, and explains app steps.',
    whatAiAssistantCanDoAr:
        'المساعد يقارن الوجهات ويقترح مسارات حسب الأسلوب/الأيام ويشرح خطوات التطبيق.',
  );
}
