import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Voyage Jordan'**
  String get appTitle;

  /// No description provided for @startPlanning.
  ///
  /// In en, this message translates to:
  /// **'Start Planning Your Trip'**
  String get startPlanning;

  /// No description provided for @aiAssistant.
  ///
  /// In en, this message translates to:
  /// **'AI Trip Assistant'**
  String get aiAssistant;

  /// No description provided for @mustVisit.
  ///
  /// In en, this message translates to:
  /// **'Must-Visit Places'**
  String get mustVisit;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All ->'**
  String get viewAll;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About Voyage Jordan'**
  String get about;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @destinations.
  ///
  /// In en, this message translates to:
  /// **'Destinations'**
  String get destinations;

  /// No description provided for @planner.
  ///
  /// In en, this message translates to:
  /// **'Planner'**
  String get planner;

  /// No description provided for @trip.
  ///
  /// In en, this message translates to:
  /// **'Trip'**
  String get trip;

  /// No description provided for @myTrip.
  ///
  /// In en, this message translates to:
  /// **'My Trip'**
  String get myTrip;

  /// No description provided for @myTripNoPlanYet.
  ///
  /// In en, this message translates to:
  /// **'No trip planned yet'**
  String get myTripNoPlanYet;

  /// No description provided for @myTripNoPlanHint.
  ///
  /// In en, this message translates to:
  /// **'Plan your Jordan journey in a few quick steps.'**
  String get myTripNoPlanHint;

  /// No description provided for @myTripViewFullPlan.
  ///
  /// In en, this message translates to:
  /// **'View full trip plan'**
  String get myTripViewFullPlan;

  /// No description provided for @myTripStartsIn.
  ///
  /// In en, this message translates to:
  /// **'Starts in 3 days'**
  String get myTripStartsIn;

  /// No description provided for @myTripStatusReady.
  ///
  /// In en, this message translates to:
  /// **'Your itinerary is ready'**
  String get myTripStatusReady;

  /// No description provided for @myTripOverview.
  ///
  /// In en, this message translates to:
  /// **'Trip overview'**
  String get myTripOverview;

  /// No description provided for @myTripDestinations.
  ///
  /// In en, this message translates to:
  /// **'Destinations'**
  String get myTripDestinations;

  /// No description provided for @myTripTripLength.
  ///
  /// In en, this message translates to:
  /// **'Trip length'**
  String get myTripTripLength;

  /// No description provided for @discoverKingdom.
  ///
  /// In en, this message translates to:
  /// **'Discover the Kingdom of Wonders'**
  String get discoverKingdom;

  /// No description provided for @experienceLine.
  ///
  /// In en, this message translates to:
  /// **'Experience ancient history, breathtaking landscapes, and\n timeless culture'**
  String get experienceLine;

  /// No description provided for @aiPlanSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Let AI plan your perfect journey'**
  String get aiPlanSubtitle;

  /// No description provided for @exploreJordan.
  ///
  /// In en, this message translates to:
  /// **'Explore Jordan\'s iconic destinations'**
  String get exploreJordan;

  /// No description provided for @emergencyContacts.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contacts'**
  String get emergencyContacts;

  /// No description provided for @aboutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Competition demo app'**
  String get aboutSubtitle;

  /// No description provided for @themeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Premium Dark'**
  String get themeSubtitle;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @tripPlanner.
  ///
  /// In en, this message translates to:
  /// **'Trip Planner'**
  String get tripPlanner;

  /// No description provided for @buildCustomTrip.
  ///
  /// In en, this message translates to:
  /// **'Build Your Trip'**
  String get buildCustomTrip;

  /// No description provided for @howManyDays.
  ///
  /// In en, this message translates to:
  /// **'How many days?'**
  String get howManyDays;

  /// No description provided for @budgetLevelHint.
  ///
  /// In en, this message translates to:
  /// **'Budget level (Economy / Medium / Luxury)'**
  String get budgetLevelHint;

  /// No description provided for @preferredDestinations.
  ///
  /// In en, this message translates to:
  /// **'Preferred destinations'**
  String get preferredDestinations;

  /// No description provided for @generateMockPlan.
  ///
  /// In en, this message translates to:
  /// **'Generate mock plan'**
  String get generateMockPlan;

  /// No description provided for @plannerSelectDestinations.
  ///
  /// In en, this message translates to:
  /// **'Select Destinations'**
  String get plannerSelectDestinations;

  /// No description provided for @plannerChoosePlaces.
  ///
  /// In en, this message translates to:
  /// **'Choose the places you want to visit'**
  String get plannerChoosePlaces;

  /// No description provided for @plannerContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get plannerContinue;

  /// No description provided for @plannerTripDuration.
  ///
  /// In en, this message translates to:
  /// **'Trip Duration'**
  String get plannerTripDuration;

  /// No description provided for @plannerHowManyDaysStay.
  ///
  /// In en, this message translates to:
  /// **'How many days will you stay?'**
  String get plannerHowManyDaysStay;

  /// No description provided for @plannerDays.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get plannerDays;

  /// No description provided for @plannerSelectBudget.
  ///
  /// In en, this message translates to:
  /// **'Select Budget'**
  String get plannerSelectBudget;

  /// No description provided for @plannerChooseBudgetRange.
  ///
  /// In en, this message translates to:
  /// **'Choose your budget range'**
  String get plannerChooseBudgetRange;

  /// No description provided for @plannerBudget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get plannerBudget;

  /// No description provided for @plannerModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get plannerModerate;

  /// No description provided for @plannerLuxury.
  ///
  /// In en, this message translates to:
  /// **'Luxury'**
  String get plannerLuxury;

  /// No description provided for @plannerBudgetRange1.
  ///
  /// In en, this message translates to:
  /// **'\$50-100/day'**
  String get plannerBudgetRange1;

  /// No description provided for @plannerBudgetRange2.
  ///
  /// In en, this message translates to:
  /// **'\$100-200/day'**
  String get plannerBudgetRange2;

  /// No description provided for @plannerBudgetRange3.
  ///
  /// In en, this message translates to:
  /// **'\$200+/day'**
  String get plannerBudgetRange3;

  /// No description provided for @plannerTransportation.
  ///
  /// In en, this message translates to:
  /// **'Transportation'**
  String get plannerTransportation;

  /// No description provided for @plannerHowGetAround.
  ///
  /// In en, this message translates to:
  /// **'How will you get around?'**
  String get plannerHowGetAround;

  /// No description provided for @plannerRentalCar.
  ///
  /// In en, this message translates to:
  /// **'Rental Car'**
  String get plannerRentalCar;

  /// No description provided for @plannerPrivateDriver.
  ///
  /// In en, this message translates to:
  /// **'Private Driver'**
  String get plannerPrivateDriver;

  /// No description provided for @plannerPublicTransport.
  ///
  /// In en, this message translates to:
  /// **'Public Transport'**
  String get plannerPublicTransport;

  /// No description provided for @plannerGuidedTour.
  ///
  /// In en, this message translates to:
  /// **'Guided Tour'**
  String get plannerGuidedTour;

  /// No description provided for @plannerGenerateTripPlan.
  ///
  /// In en, this message translates to:
  /// **'Generate Trip Plan'**
  String get plannerGenerateTripPlan;

  /// No description provided for @plannerMinDays.
  ///
  /// In en, this message translates to:
  /// **'1 day'**
  String get plannerMinDays;

  /// No description provided for @plannerMaxDays.
  ///
  /// In en, this message translates to:
  /// **'14 days'**
  String get plannerMaxDays;

  /// No description provided for @yourItinerary.
  ///
  /// In en, this message translates to:
  /// **'Your Itinerary'**
  String get yourItinerary;

  /// No description provided for @emergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get emergency;

  /// No description provided for @quickHelp.
  ///
  /// In en, this message translates to:
  /// **'Quick Help'**
  String get quickHelp;

  /// No description provided for @jordanEmergency.
  ///
  /// In en, this message translates to:
  /// **'Jordan Emergency'**
  String get jordanEmergency;

  /// No description provided for @touristPolice.
  ///
  /// In en, this message translates to:
  /// **'Tourist Police'**
  String get touristPolice;

  /// No description provided for @nearestHospital.
  ///
  /// In en, this message translates to:
  /// **'Nearest Hospital'**
  String get nearestHospital;

  /// No description provided for @askVoyageAi.
  ///
  /// In en, this message translates to:
  /// **'Ask Voyage AI'**
  String get askVoyageAi;

  /// No description provided for @aiDemoInfo.
  ///
  /// In en, this message translates to:
  /// **'This is a demo assistant UI. It uses mock responses and no live AI backend.'**
  String get aiDemoInfo;

  /// No description provided for @aiPromptSample.
  ///
  /// In en, this message translates to:
  /// **'I want a 5-day historical trip in Jordan'**
  String get aiPromptSample;

  /// No description provided for @aiResponseSample.
  ///
  /// In en, this message translates to:
  /// **'Great choice. I suggest Petra + Jerash + Dead Sea with medium budget.'**
  String get aiResponseSample;

  /// No description provided for @aiAssistantWelcome.
  ///
  /// In en, this message translates to:
  /// **'I\'m your Voyage Jordan guide. Ask about destinations, budgets, or getting around—or say \"Build a trip with me\" for a step-by-step chat itinerary outline (demo, stays in this chat). No live AI yet.'**
  String get aiAssistantWelcome;

  /// No description provided for @aiChatInputHint.
  ///
  /// In en, this message translates to:
  /// **'Ask about Jordan…'**
  String get aiChatInputHint;

  /// No description provided for @aiChipPlanTrip.
  ///
  /// In en, this message translates to:
  /// **'How do I plan a trip?'**
  String get aiChipPlanTrip;

  /// No description provided for @aiChipBuildTrip.
  ///
  /// In en, this message translates to:
  /// **'Build a trip with me'**
  String get aiChipBuildTrip;

  /// No description provided for @aiTripBuilderTitle.
  ///
  /// In en, this message translates to:
  /// **'AI Trip Builder'**
  String get aiTripBuilderTitle;

  /// No description provided for @aiTripBuilderHint.
  ///
  /// In en, this message translates to:
  /// **'Tap an option to continue — no typing needed.'**
  String get aiTripBuilderHint;

  /// No description provided for @aiTripBuilderDoneHint.
  ///
  /// In en, this message translates to:
  /// **'Your outline is ready.'**
  String get aiTripBuilderDoneHint;

  /// No description provided for @aiTripBuilderCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get aiTripBuilderCancel;

  /// No description provided for @aiTripBuilderStartOver.
  ///
  /// In en, this message translates to:
  /// **'Start Over'**
  String get aiTripBuilderStartOver;

  /// No description provided for @aiTripBuilderContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get aiTripBuilderContinue;

  /// No description provided for @aiTripBuilderBackHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get aiTripBuilderBackHome;

  /// No description provided for @aiTbDays3.
  ///
  /// In en, this message translates to:
  /// **'3 days'**
  String get aiTbDays3;

  /// No description provided for @aiTbDays5.
  ///
  /// In en, this message translates to:
  /// **'5 days'**
  String get aiTbDays5;

  /// No description provided for @aiTbDays7.
  ///
  /// In en, this message translates to:
  /// **'7 days'**
  String get aiTbDays7;

  /// No description provided for @aiTbDays10.
  ///
  /// In en, this message translates to:
  /// **'10 days'**
  String get aiTbDays10;

  /// No description provided for @aiTbStyleHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get aiTbStyleHistory;

  /// No description provided for @aiTbStyleAdventure.
  ///
  /// In en, this message translates to:
  /// **'Adventure'**
  String get aiTbStyleAdventure;

  /// No description provided for @aiTbStyleRelaxation.
  ///
  /// In en, this message translates to:
  /// **'Relaxation'**
  String get aiTbStyleRelaxation;

  /// No description provided for @aiTbStyleFamily.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get aiTbStyleFamily;

  /// No description provided for @aiTbStyleMixed.
  ///
  /// In en, this message translates to:
  /// **'Mixed'**
  String get aiTbStyleMixed;

  /// No description provided for @aiTbBudgetEconomy.
  ///
  /// In en, this message translates to:
  /// **'Economy'**
  String get aiTbBudgetEconomy;

  /// No description provided for @aiTbBudgetModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get aiTbBudgetModerate;

  /// No description provided for @aiTbBudgetLuxury.
  ///
  /// In en, this message translates to:
  /// **'Luxury'**
  String get aiTbBudgetLuxury;

  /// No description provided for @aiTbTransportRental.
  ///
  /// In en, this message translates to:
  /// **'Rental Car'**
  String get aiTbTransportRental;

  /// No description provided for @aiTbTransportDriver.
  ///
  /// In en, this message translates to:
  /// **'Private Driver'**
  String get aiTbTransportDriver;

  /// No description provided for @aiTbTransportPublic.
  ///
  /// In en, this message translates to:
  /// **'Public Transport'**
  String get aiTbTransportPublic;

  /// No description provided for @aiTbTransportGuided.
  ///
  /// In en, this message translates to:
  /// **'Guided Tour'**
  String get aiTbTransportGuided;

  /// No description provided for @aiTbDestPetra.
  ///
  /// In en, this message translates to:
  /// **'Petra'**
  String get aiTbDestPetra;

  /// No description provided for @aiTbDestWadiRum.
  ///
  /// In en, this message translates to:
  /// **'Wadi Rum'**
  String get aiTbDestWadiRum;

  /// No description provided for @aiTbDestAqaba.
  ///
  /// In en, this message translates to:
  /// **'Aqaba'**
  String get aiTbDestAqaba;

  /// No description provided for @aiTbDestDeadSea.
  ///
  /// In en, this message translates to:
  /// **'Dead Sea'**
  String get aiTbDestDeadSea;

  /// No description provided for @aiTbDestJerash.
  ///
  /// In en, this message translates to:
  /// **'Jerash'**
  String get aiTbDestJerash;

  /// No description provided for @aiTbDestNone.
  ///
  /// In en, this message translates to:
  /// **'No must-see'**
  String get aiTbDestNone;

  /// No description provided for @aiTbPaceCalm.
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get aiTbPaceCalm;

  /// No description provided for @aiTbPaceActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get aiTbPaceActive;

  /// No description provided for @aiTbPaceBalanced.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get aiTbPaceBalanced;

  /// No description provided for @aiTbExperienceHistory.
  ///
  /// In en, this message translates to:
  /// **'History & culture'**
  String get aiTbExperienceHistory;

  /// No description provided for @aiTbExperienceAdventure.
  ///
  /// In en, this message translates to:
  /// **'Adventure'**
  String get aiTbExperienceAdventure;

  /// No description provided for @aiTbExperienceRelax.
  ///
  /// In en, this message translates to:
  /// **'Relaxation'**
  String get aiTbExperienceRelax;

  /// No description provided for @aiTbExperienceFamily.
  ///
  /// In en, this message translates to:
  /// **'Family-friendly'**
  String get aiTbExperienceFamily;

  /// No description provided for @aiTbExperienceMixed.
  ///
  /// In en, this message translates to:
  /// **'Mixed'**
  String get aiTbExperienceMixed;

  /// No description provided for @aiTbPlacesHistorical.
  ///
  /// In en, this message translates to:
  /// **'Historical places'**
  String get aiTbPlacesHistorical;

  /// No description provided for @aiTbPlacesNature.
  ///
  /// In en, this message translates to:
  /// **'Nature'**
  String get aiTbPlacesNature;

  /// No description provided for @aiTbPlacesSea.
  ///
  /// In en, this message translates to:
  /// **'Sea'**
  String get aiTbPlacesSea;

  /// No description provided for @aiTbPlacesDesert.
  ///
  /// In en, this message translates to:
  /// **'Desert'**
  String get aiTbPlacesDesert;

  /// No description provided for @aiTbPlacesMixed.
  ///
  /// In en, this message translates to:
  /// **'Mixed'**
  String get aiTbPlacesMixed;

  /// No description provided for @aiTbSpecialNone.
  ///
  /// In en, this message translates to:
  /// **'No preference'**
  String get aiTbSpecialNone;

  /// No description provided for @aiTbSpecialCrowds.
  ///
  /// In en, this message translates to:
  /// **'Avoid crowds'**
  String get aiTbSpecialCrowds;

  /// No description provided for @aiTbSpecialHeat.
  ///
  /// In en, this message translates to:
  /// **'Heat sensitive'**
  String get aiTbSpecialHeat;

  /// No description provided for @aiTbSpecialWalks.
  ///
  /// In en, this message translates to:
  /// **'Shorter walks'**
  String get aiTbSpecialWalks;

  /// No description provided for @aiAssistantSaveTrip.
  ///
  /// In en, this message translates to:
  /// **'Save Trip'**
  String get aiAssistantSaveTrip;

  /// No description provided for @aiAssistantModifyTrip.
  ///
  /// In en, this message translates to:
  /// **'Modify Trip'**
  String get aiAssistantModifyTrip;

  /// No description provided for @aiChipPetra.
  ///
  /// In en, this message translates to:
  /// **'Tell me about Petra'**
  String get aiChipPetra;

  /// No description provided for @aiChipAdventure.
  ///
  /// In en, this message translates to:
  /// **'Where for adventure?'**
  String get aiChipAdventure;

  /// No description provided for @aiChipBudget.
  ///
  /// In en, this message translates to:
  /// **'Budget tips'**
  String get aiChipBudget;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'Smart tourism planning for Jordan'**
  String get appTagline;

  /// No description provided for @destinationNotFound.
  ///
  /// In en, this message translates to:
  /// **'Destination not found'**
  String get destinationNotFound;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @bestTimeToVisit.
  ///
  /// In en, this message translates to:
  /// **'Best Time to Visit'**
  String get bestTimeToVisit;

  /// No description provided for @thingsToDo.
  ///
  /// In en, this message translates to:
  /// **'Things to Do'**
  String get thingsToDo;

  /// No description provided for @whereToStay.
  ///
  /// In en, this message translates to:
  /// **'Where to Stay'**
  String get whereToStay;

  /// No description provided for @diningOptions.
  ///
  /// In en, this message translates to:
  /// **'Dining Options'**
  String get diningOptions;

  /// No description provided for @petraBlurb.
  ///
  /// In en, this message translates to:
  /// **'The Rose-Red City carved into ancient cliffs'**
  String get petraBlurb;

  /// No description provided for @wadiRumBlurb.
  ///
  /// In en, this message translates to:
  /// **'Valley of the Moon\'s dramatic desert landscape'**
  String get wadiRumBlurb;

  /// No description provided for @deadSeaBlurb.
  ///
  /// In en, this message translates to:
  /// **'Earth\'s lowest point with healing waters'**
  String get deadSeaBlurb;

  /// No description provided for @petraLocation.
  ///
  /// In en, this message translates to:
  /// **'Ma\'an Governorate'**
  String get petraLocation;

  /// No description provided for @wadiRumLocation.
  ///
  /// In en, this message translates to:
  /// **'Aqaba Governorate'**
  String get wadiRumLocation;

  /// No description provided for @deadSeaLocation.
  ///
  /// In en, this message translates to:
  /// **'Jordan Valley'**
  String get deadSeaLocation;

  /// No description provided for @aboutDialogDescription.
  ///
  /// In en, this message translates to:
  /// **'Voyage Jordan is a smart tourism planning app for Jordan that helps tourists explore destinations, plan trips, discover hotels, restaurants, and activities, and organize their journey in one simple app.'**
  String get aboutDialogDescription;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @destinationPetra.
  ///
  /// In en, this message translates to:
  /// **'Petra'**
  String get destinationPetra;

  /// No description provided for @destinationWadiRum.
  ///
  /// In en, this message translates to:
  /// **'Wadi Rum'**
  String get destinationWadiRum;

  /// No description provided for @destinationDeadSea.
  ///
  /// In en, this message translates to:
  /// **'Dead Sea'**
  String get destinationDeadSea;

  /// No description provided for @destinationAqaba.
  ///
  /// In en, this message translates to:
  /// **'Aqaba'**
  String get destinationAqaba;

  /// No description provided for @destinationJerash.
  ///
  /// In en, this message translates to:
  /// **'Jerash'**
  String get destinationJerash;

  /// No description provided for @subtitleAqaba.
  ///
  /// In en, this message translates to:
  /// **'Red Sea Escape'**
  String get subtitleAqaba;

  /// No description provided for @subtitleWadiRum.
  ///
  /// In en, this message translates to:
  /// **'Desert Adventure'**
  String get subtitleWadiRum;

  /// No description provided for @subtitlePetra.
  ///
  /// In en, this message translates to:
  /// **'Ancient Wonder'**
  String get subtitlePetra;

  /// No description provided for @subtitleJerash.
  ///
  /// In en, this message translates to:
  /// **'Roman Heritage'**
  String get subtitleJerash;

  /// No description provided for @subtitleDeadSea.
  ///
  /// In en, this message translates to:
  /// **'Relaxation Retreat'**
  String get subtitleDeadSea;

  /// No description provided for @dayLabel.
  ///
  /// In en, this message translates to:
  /// **'Day {day}'**
  String dayLabel(int day);

  /// No description provided for @itineraryTitle1.
  ///
  /// In en, this message translates to:
  /// **'Arrival in Aqaba'**
  String get itineraryTitle1;

  /// No description provided for @itineraryTitle2.
  ///
  /// In en, this message translates to:
  /// **'Wadi Rum Experience'**
  String get itineraryTitle2;

  /// No description provided for @itineraryTitle3.
  ///
  /// In en, this message translates to:
  /// **'Petra Highlights'**
  String get itineraryTitle3;

  /// No description provided for @itineraryItemCheckInResort.
  ///
  /// In en, this message translates to:
  /// **'Check-in resort'**
  String get itineraryItemCheckInResort;

  /// No description provided for @itineraryItemSunsetMarinaWalk.
  ///
  /// In en, this message translates to:
  /// **'Sunset marina walk'**
  String get itineraryItemSunsetMarinaWalk;

  /// No description provided for @itineraryItemSeafoodDinner.
  ///
  /// In en, this message translates to:
  /// **'Seafood dinner'**
  String get itineraryItemSeafoodDinner;

  /// No description provided for @itineraryItemDesertJeepTour.
  ///
  /// In en, this message translates to:
  /// **'Desert jeep tour'**
  String get itineraryItemDesertJeepTour;

  /// No description provided for @itineraryItemBedouinLunch.
  ///
  /// In en, this message translates to:
  /// **'Bedouin lunch'**
  String get itineraryItemBedouinLunch;

  /// No description provided for @itineraryItemNightCampStargazing.
  ///
  /// In en, this message translates to:
  /// **'Night camp stargazing'**
  String get itineraryItemNightCampStargazing;

  /// No description provided for @itineraryItemTreasuryVisit.
  ///
  /// In en, this message translates to:
  /// **'The Treasury visit'**
  String get itineraryItemTreasuryVisit;

  /// No description provided for @itineraryItemMonasteryHike.
  ///
  /// In en, this message translates to:
  /// **'Monastery hike'**
  String get itineraryItemMonasteryHike;

  /// No description provided for @itineraryItemCulturalMarketStop.
  ///
  /// In en, this message translates to:
  /// **'Cultural market stop'**
  String get itineraryItemCulturalMarketStop;

  /// No description provided for @tripPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Trip Plan'**
  String get tripPlanTitle;

  /// No description provided for @tripPlanDaysInJordan.
  ///
  /// In en, this message translates to:
  /// **'{count} days in Jordan'**
  String tripPlanDaysInJordan(int count);

  /// No description provided for @tripPlanDailyItinerary.
  ///
  /// In en, this message translates to:
  /// **'Daily Itinerary'**
  String get tripPlanDailyItinerary;

  /// No description provided for @tripPlanSectionActivities.
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get tripPlanSectionActivities;

  /// No description provided for @tripPlanSectionAccommodation.
  ///
  /// In en, this message translates to:
  /// **'Accommodation'**
  String get tripPlanSectionAccommodation;

  /// No description provided for @tripPlanSectionMeals.
  ///
  /// In en, this message translates to:
  /// **'Meals'**
  String get tripPlanSectionMeals;

  /// No description provided for @tripPlanSectionTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get tripPlanSectionTransport;

  /// No description provided for @tripPlanTotalEstimatedCost.
  ///
  /// In en, this message translates to:
  /// **'Total Estimated Cost'**
  String get tripPlanTotalEstimatedCost;

  /// No description provided for @tripPlanCostLineAccommodation.
  ///
  /// In en, this message translates to:
  /// **'Accommodation'**
  String get tripPlanCostLineAccommodation;

  /// No description provided for @tripPlanCostLineMeals.
  ///
  /// In en, this message translates to:
  /// **'Meals'**
  String get tripPlanCostLineMeals;

  /// No description provided for @tripPlanCostLineTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get tripPlanCostLineTransport;

  /// No description provided for @tripPlanCostLineActivities.
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get tripPlanCostLineActivities;

  /// No description provided for @tripPlanModifyPlan.
  ///
  /// In en, this message translates to:
  /// **'Modify Plan'**
  String get tripPlanModifyPlan;

  /// No description provided for @tripPlanSavePlan.
  ///
  /// In en, this message translates to:
  /// **'Save Plan'**
  String get tripPlanSavePlan;

  /// No description provided for @tripPlanSavedMessage.
  ///
  /// In en, this message translates to:
  /// **'Trip saved successfully'**
  String get tripPlanSavedMessage;

  /// No description provided for @tripPlanDetailAccommodation1.
  ///
  /// In en, this message translates to:
  /// **'Waterfront resort, Aqaba'**
  String get tripPlanDetailAccommodation1;

  /// No description provided for @tripPlanDetailTransport1.
  ///
  /// In en, this message translates to:
  /// **'Private car pickup from airport'**
  String get tripPlanDetailTransport1;

  /// No description provided for @tripPlanDetailMeal1a.
  ///
  /// In en, this message translates to:
  /// **'Marina seafood restaurant'**
  String get tripPlanDetailMeal1a;

  /// No description provided for @tripPlanDetailMeal1b.
  ///
  /// In en, this message translates to:
  /// **'Resort dining'**
  String get tripPlanDetailMeal1b;

  /// No description provided for @tripPlanDetailAccommodation2.
  ///
  /// In en, this message translates to:
  /// **'Wadi Rum luxury desert camp'**
  String get tripPlanDetailAccommodation2;

  /// No description provided for @tripPlanDetailTransport2.
  ///
  /// In en, this message translates to:
  /// **'4x4 camp transfer'**
  String get tripPlanDetailTransport2;

  /// No description provided for @tripPlanDetailMeal2a.
  ///
  /// In en, this message translates to:
  /// **'Bedouin lunch experience'**
  String get tripPlanDetailMeal2a;

  /// No description provided for @tripPlanDetailMeal2b.
  ///
  /// In en, this message translates to:
  /// **'Camp dinner under the stars'**
  String get tripPlanDetailMeal2b;

  /// No description provided for @tripPlanDetailAccommodation3.
  ///
  /// In en, this message translates to:
  /// **'Mövenpick Resort Petra'**
  String get tripPlanDetailAccommodation3;

  /// No description provided for @tripPlanDetailTransport3.
  ///
  /// In en, this message translates to:
  /// **'Private driver'**
  String get tripPlanDetailTransport3;

  /// No description provided for @tripPlanDetailMeal3a.
  ///
  /// In en, this message translates to:
  /// **'The Basin Restaurant'**
  String get tripPlanDetailMeal3a;

  /// No description provided for @tripPlanDetailMeal3b.
  ///
  /// In en, this message translates to:
  /// **'Hotel dining'**
  String get tripPlanDetailMeal3b;

  /// No description provided for @tripPlanTravelToward.
  ///
  /// In en, this message translates to:
  /// **'Road transfer toward {destination}'**
  String tripPlanTravelToward(String destination);

  /// No description provided for @tripPlanTransRent0.
  ///
  /// In en, this message translates to:
  /// **'Economy rental car — self-drive between your stops'**
  String get tripPlanTransRent0;

  /// No description provided for @tripPlanTransRent1.
  ///
  /// In en, this message translates to:
  /// **'Mid-range rental with GPS and full insurance'**
  String get tripPlanTransRent1;

  /// No description provided for @tripPlanTransRent2.
  ///
  /// In en, this message translates to:
  /// **'Premium rental with upgrades and full coverage'**
  String get tripPlanTransRent2;

  /// No description provided for @tripPlanTransDriver0.
  ///
  /// In en, this message translates to:
  /// **'Private driver in a standard vehicle'**
  String get tripPlanTransDriver0;

  /// No description provided for @tripPlanTransDriver1.
  ///
  /// In en, this message translates to:
  /// **'Private driver with hotel door-to-door transfers'**
  String get tripPlanTransDriver1;

  /// No description provided for @tripPlanTransDriver2.
  ///
  /// In en, this message translates to:
  /// **'Chauffeured luxury vehicle for the whole route'**
  String get tripPlanTransDriver2;

  /// No description provided for @tripPlanTransPublic0.
  ///
  /// In en, this message translates to:
  /// **'Public buses and shared shuttles where practical'**
  String get tripPlanTransPublic0;

  /// No description provided for @tripPlanTransPublic1.
  ///
  /// In en, this message translates to:
  /// **'JETT coaches plus taxis for shorter legs'**
  String get tripPlanTransPublic1;

  /// No description provided for @tripPlanTransPublic2.
  ///
  /// In en, this message translates to:
  /// **'Comfort coaches and private taxis on long transfers'**
  String get tripPlanTransPublic2;

  /// No description provided for @tripPlanTransGuide0.
  ///
  /// In en, this message translates to:
  /// **'Guided tour transport in a small group vehicle'**
  String get tripPlanTransGuide0;

  /// No description provided for @tripPlanTransGuide1.
  ///
  /// In en, this message translates to:
  /// **'Private tour van with a dedicated guide'**
  String get tripPlanTransGuide1;

  /// No description provided for @tripPlanTransGuide2.
  ///
  /// In en, this message translates to:
  /// **'Premium private guided vehicle throughout'**
  String get tripPlanTransGuide2;

  /// No description provided for @destCardDescAqaba.
  ///
  /// In en, this message translates to:
  /// **'Diving, beach resorts, and waterfront dining.'**
  String get destCardDescAqaba;

  /// No description provided for @destCardDescWadiRum.
  ///
  /// In en, this message translates to:
  /// **'Jeep tours, stargazing, and Bedouin camps.'**
  String get destCardDescWadiRum;

  /// No description provided for @destCardDescPetra.
  ///
  /// In en, this message translates to:
  /// **'Explore The Treasury, Monastery, and canyons.'**
  String get destCardDescPetra;

  /// No description provided for @destCardDescJerash.
  ///
  /// In en, this message translates to:
  /// **'Archaeological city with remarkable ruins.'**
  String get destCardDescJerash;

  /// No description provided for @destCardDescDeadSea.
  ///
  /// In en, this message translates to:
  /// **'Floating experience, mineral mud, and wellness.'**
  String get destCardDescDeadSea;

  /// No description provided for @detailDescPetra.
  ///
  /// In en, this message translates to:
  /// **'Petra is a historical and archaeological city in southern Jordan. Famous for its rock-cut architecture and water conduit system, Petra is also known as the \'Rose City\' due to the color of the stone from which it is carved.'**
  String get detailDescPetra;

  /// No description provided for @detailDescWadiRum.
  ///
  /// In en, this message translates to:
  /// **'Wadi Rum is Jordan\'s dramatic desert valley known for sandstone mountains, red dunes, and cinematic landscapes.'**
  String get detailDescWadiRum;

  /// No description provided for @detailDescDeadSea.
  ///
  /// In en, this message translates to:
  /// **'The Dead Sea is Earth\'s lowest point, famous for salt-rich water, mineral mud, and relaxing wellness resorts.'**
  String get detailDescDeadSea;

  /// No description provided for @detailDescAqaba.
  ///
  /// In en, this message translates to:
  /// **'Aqaba is Jordan\'s Red Sea city known for beaches, diving, coral reefs, and vibrant waterfront experiences.'**
  String get detailDescAqaba;

  /// No description provided for @detailDescJerash.
  ///
  /// In en, this message translates to:
  /// **'Jerash is one of the world\'s best-preserved Roman provincial cities, filled with colonnaded streets and theaters.'**
  String get detailDescJerash;

  /// No description provided for @bestTimePetra.
  ///
  /// In en, this message translates to:
  /// **'March to May, September to November'**
  String get bestTimePetra;

  /// No description provided for @bestTimeWadiRum.
  ///
  /// In en, this message translates to:
  /// **'October to April'**
  String get bestTimeWadiRum;

  /// No description provided for @bestTimeDeadSea.
  ///
  /// In en, this message translates to:
  /// **'October to May'**
  String get bestTimeDeadSea;

  /// No description provided for @bestTimeAqaba.
  ///
  /// In en, this message translates to:
  /// **'March to May, October to November'**
  String get bestTimeAqaba;

  /// No description provided for @bestTimeJerash.
  ///
  /// In en, this message translates to:
  /// **'April to June, September to November'**
  String get bestTimeJerash;

  /// No description provided for @todoPetra1.
  ///
  /// In en, this message translates to:
  /// **'Explore the Treasury'**
  String get todoPetra1;

  /// No description provided for @todoPetra2.
  ///
  /// In en, this message translates to:
  /// **'Hike to the Monastery'**
  String get todoPetra2;

  /// No description provided for @todoPetra3.
  ///
  /// In en, this message translates to:
  /// **'Visit the Royal Tombs'**
  String get todoPetra3;

  /// No description provided for @todoPetra4.
  ///
  /// In en, this message translates to:
  /// **'Walk through the Siq'**
  String get todoPetra4;

  /// No description provided for @todoPetra5.
  ///
  /// In en, this message translates to:
  /// **'Petra by Night show'**
  String get todoPetra5;

  /// No description provided for @todoWadi1.
  ///
  /// In en, this message translates to:
  /// **'4x4 desert jeep tour'**
  String get todoWadi1;

  /// No description provided for @todoWadi2.
  ///
  /// In en, this message translates to:
  /// **'Sunset viewpoint stop'**
  String get todoWadi2;

  /// No description provided for @todoWadi3.
  ///
  /// In en, this message translates to:
  /// **'Camel ride experience'**
  String get todoWadi3;

  /// No description provided for @todoWadi4.
  ///
  /// In en, this message translates to:
  /// **'Stargazing camp night'**
  String get todoWadi4;

  /// No description provided for @todoWadi5.
  ///
  /// In en, this message translates to:
  /// **'Bedouin tea session'**
  String get todoWadi5;

  /// No description provided for @todoDead1.
  ///
  /// In en, this message translates to:
  /// **'Float in the Dead Sea'**
  String get todoDead1;

  /// No description provided for @todoDead2.
  ///
  /// In en, this message translates to:
  /// **'Mud bath and spa treatment'**
  String get todoDead2;

  /// No description provided for @todoDead3.
  ///
  /// In en, this message translates to:
  /// **'Sunset viewing'**
  String get todoDead3;

  /// No description provided for @todoDead4.
  ///
  /// In en, this message translates to:
  /// **'Beach relaxation'**
  String get todoDead4;

  /// No description provided for @todoDead5.
  ///
  /// In en, this message translates to:
  /// **'Wellness therapy session'**
  String get todoDead5;

  /// No description provided for @todoAqaba1.
  ///
  /// In en, this message translates to:
  /// **'Snorkeling and diving'**
  String get todoAqaba1;

  /// No description provided for @todoAqaba2.
  ///
  /// In en, this message translates to:
  /// **'Aqaba fort visit'**
  String get todoAqaba2;

  /// No description provided for @todoAqaba3.
  ///
  /// In en, this message translates to:
  /// **'Marina promenade walk'**
  String get todoAqaba3;

  /// No description provided for @todoAqaba4.
  ///
  /// In en, this message translates to:
  /// **'Glass boat tour'**
  String get todoAqaba4;

  /// No description provided for @todoAqaba5.
  ///
  /// In en, this message translates to:
  /// **'Evening seafood dinner'**
  String get todoAqaba5;

  /// No description provided for @todoJerash1.
  ///
  /// In en, this message translates to:
  /// **'Oval Plaza exploration'**
  String get todoJerash1;

  /// No description provided for @todoJerash2.
  ///
  /// In en, this message translates to:
  /// **'South Theater visit'**
  String get todoJerash2;

  /// No description provided for @todoJerash3.
  ///
  /// In en, this message translates to:
  /// **'Hadrian\'s Arch walk'**
  String get todoJerash3;

  /// No description provided for @todoJerash4.
  ///
  /// In en, this message translates to:
  /// **'Archaeological museum tour'**
  String get todoJerash4;

  /// No description provided for @todoJerash5.
  ///
  /// In en, this message translates to:
  /// **'Jerash festival area'**
  String get todoJerash5;

  /// No description provided for @stayPetra1.
  ///
  /// In en, this message translates to:
  /// **'Movenpick Resort Petra'**
  String get stayPetra1;

  /// No description provided for @stayPetra2.
  ///
  /// In en, this message translates to:
  /// **'Petra Marriott Hotel'**
  String get stayPetra2;

  /// No description provided for @stayPetra3.
  ///
  /// In en, this message translates to:
  /// **'Old Village Hotel & Resort'**
  String get stayPetra3;

  /// No description provided for @stayWadi1.
  ///
  /// In en, this message translates to:
  /// **'Wadi Rum Night Luxury Camp'**
  String get stayWadi1;

  /// No description provided for @stayWadi2.
  ///
  /// In en, this message translates to:
  /// **'Memories Aicha Camp'**
  String get stayWadi2;

  /// No description provided for @stayWadi3.
  ///
  /// In en, this message translates to:
  /// **'Sun City Camp'**
  String get stayWadi3;

  /// No description provided for @stayDead1.
  ///
  /// In en, this message translates to:
  /// **'Kempinski Hotel Ishtar Dead Sea'**
  String get stayDead1;

  /// No description provided for @stayDead2.
  ///
  /// In en, this message translates to:
  /// **'Movenpick Resort & Spa Dead Sea'**
  String get stayDead2;

  /// No description provided for @stayDead3.
  ///
  /// In en, this message translates to:
  /// **'Hilton Dead Sea Resort & Spa'**
  String get stayDead3;

  /// No description provided for @stayAqaba1.
  ///
  /// In en, this message translates to:
  /// **'Hyatt Regency Aqaba'**
  String get stayAqaba1;

  /// No description provided for @stayAqaba2.
  ///
  /// In en, this message translates to:
  /// **'InterContinental Aqaba'**
  String get stayAqaba2;

  /// No description provided for @stayAqaba3.
  ///
  /// In en, this message translates to:
  /// **'Kempinski Aqaba'**
  String get stayAqaba3;

  /// No description provided for @stayJerash1.
  ///
  /// In en, this message translates to:
  /// **'Olive Branch Hotel'**
  String get stayJerash1;

  /// No description provided for @stayJerash2.
  ///
  /// In en, this message translates to:
  /// **'Lijam Hotel'**
  String get stayJerash2;

  /// No description provided for @stayJerash3.
  ///
  /// In en, this message translates to:
  /// **'Haddad Tourism Village'**
  String get stayJerash3;

  /// No description provided for @dinePetra1.
  ///
  /// In en, this message translates to:
  /// **'The Cave Bar'**
  String get dinePetra1;

  /// No description provided for @dinePetra2.
  ///
  /// In en, this message translates to:
  /// **'Al Qantarah Restaurant'**
  String get dinePetra2;

  /// No description provided for @dineWadi1.
  ///
  /// In en, this message translates to:
  /// **'Camp Bedouin buffet'**
  String get dineWadi1;

  /// No description provided for @dineWadi2.
  ///
  /// In en, this message translates to:
  /// **'Wadi Rum Rest House'**
  String get dineWadi2;

  /// No description provided for @dineDead1.
  ///
  /// In en, this message translates to:
  /// **'Resort dining'**
  String get dineDead1;

  /// No description provided for @dineDead2.
  ///
  /// In en, this message translates to:
  /// **'Poolside grill'**
  String get dineDead2;

  /// No description provided for @dineAqaba1.
  ///
  /// In en, this message translates to:
  /// **'Ali Baba Restaurant'**
  String get dineAqaba1;

  /// No description provided for @dineAqaba2.
  ///
  /// In en, this message translates to:
  /// **'Captain\'s Restaurant'**
  String get dineAqaba2;

  /// No description provided for @dineJerash1.
  ///
  /// In en, this message translates to:
  /// **'Lebanese House'**
  String get dineJerash1;

  /// No description provided for @dineJerash2.
  ///
  /// In en, this message translates to:
  /// **'Jerash Rest Restaurant'**
  String get dineJerash2;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
