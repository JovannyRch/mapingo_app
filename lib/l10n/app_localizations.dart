import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Mapingo'**
  String get appName;

  /// No description provided for @exploreMexico.
  ///
  /// In en, this message translates to:
  /// **'Explore Mexico'**
  String get exploreMexico;

  /// No description provided for @tapStateToSeeDetails.
  ///
  /// In en, this message translates to:
  /// **'Tap any state to see its capital, region, and a fun fact.'**
  String get tapStateToSeeDetails;

  /// No description provided for @loadingMap.
  ///
  /// In en, this message translates to:
  /// **'Loading Mexico map...'**
  String get loadingMap;

  /// No description provided for @couldNotLoadMap.
  ///
  /// In en, this message translates to:
  /// **'Could not load the map'**
  String get couldNotLoadMap;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @noMapDataYet.
  ///
  /// In en, this message translates to:
  /// **'No map data yet'**
  String get noMapDataYet;

  /// No description provided for @statesWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Mexican states will appear here once content is ready.'**
  String get statesWillAppearHere;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @chooseStateOnMap.
  ///
  /// In en, this message translates to:
  /// **'Choose a state on the map.'**
  String get chooseStateOnMap;

  /// No description provided for @capital.
  ///
  /// In en, this message translates to:
  /// **'Capital'**
  String get capital;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @noPracticeYet.
  ///
  /// In en, this message translates to:
  /// **'No practice yet'**
  String get noPracticeYet;

  /// No description provided for @funFact.
  ///
  /// In en, this message translates to:
  /// **'Fun fact'**
  String get funFact;

  /// No description provided for @practice.
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get practice;

  /// No description provided for @preparingPractice.
  ///
  /// In en, this message translates to:
  /// **'Preparing practice...'**
  String get preparingPractice;

  /// No description provided for @couldNotLoadPractice.
  ///
  /// In en, this message translates to:
  /// **'Could not load practice'**
  String get couldNotLoadPractice;

  /// No description provided for @noMistakesToReview.
  ///
  /// In en, this message translates to:
  /// **'No mistakes to review'**
  String get noMistakesToReview;

  /// No description provided for @noPracticeYet2.
  ///
  /// In en, this message translates to:
  /// **'No practice yet'**
  String get noPracticeYet2;

  /// No description provided for @missedExercisesWillAppear.
  ///
  /// In en, this message translates to:
  /// **'Missed exercises will appear here after lessons.'**
  String get missedExercisesWillAppear;

  /// No description provided for @practiceQuestionsWillAppear.
  ///
  /// In en, this message translates to:
  /// **'Practice questions will appear here once content is ready.'**
  String get practiceQuestionsWillAppear;

  /// No description provided for @chooseAnotherMode.
  ///
  /// In en, this message translates to:
  /// **'Choose another mode'**
  String get chooseAnotherMode;

  /// No description provided for @choosePractice.
  ///
  /// In en, this message translates to:
  /// **'Choose practice'**
  String get choosePractice;

  /// No description provided for @shortSessionsHelpReinforce.
  ///
  /// In en, this message translates to:
  /// **'Short sessions help reinforce what you\'ve learned.'**
  String get shortSessionsHelpReinforce;

  /// No description provided for @practiceComplete.
  ///
  /// In en, this message translates to:
  /// **'Practice complete'**
  String get practiceComplete;

  /// No description provided for @practiceScoreSummary.
  ///
  /// In en, this message translates to:
  /// **'{correctCount} correct - {wrongCount} wrong'**
  String practiceScoreSummary(int correctCount, int wrongCount);

  /// No description provided for @youAnsweredEveryQuestion.
  ///
  /// In en, this message translates to:
  /// **'You answered all practice questions.'**
  String get youAnsweredEveryQuestion;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// Button text to continue
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// No description provided for @check.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get check;

  /// No description provided for @correctStateSelected.
  ///
  /// In en, this message translates to:
  /// **'Correct state selected.'**
  String get correctStateSelected;

  /// No description provided for @correctStateHighlighted.
  ///
  /// In en, this message translates to:
  /// **'The correct state is highlighted in green.'**
  String get correctStateHighlighted;

  /// No description provided for @tapStateOnMap.
  ///
  /// In en, this message translates to:
  /// **'Tap the state on the map.'**
  String get tapStateOnMap;

  /// No description provided for @correct.
  ///
  /// In en, this message translates to:
  /// **'Correct!'**
  String get correct;

  /// No description provided for @tryThisOneAgainLater.
  ///
  /// In en, this message translates to:
  /// **'Try this one later.'**
  String get tryThisOneAgainLater;

  /// No description provided for @mapExplorer.
  ///
  /// In en, this message translates to:
  /// **'Map Explorer'**
  String get mapExplorer;

  /// No description provided for @startingMapingo.
  ///
  /// In en, this message translates to:
  /// **'Starting Mapingo...'**
  String get startingMapingo;

  /// No description provided for @couldNotStartMapingo.
  ///
  /// In en, this message translates to:
  /// **'Could not start Mapingo'**
  String get couldNotStartMapingo;

  /// No description provided for @openingYourMap.
  ///
  /// In en, this message translates to:
  /// **'Opening your map...'**
  String get openingYourMap;

  /// No description provided for @anonymousSignInsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Anonymous sign-ins are disabled in Supabase. Enable Anonymous sign-ins in Authentication > Providers before starting Mapingo.'**
  String get anonymousSignInsDisabled;

  /// No description provided for @mapingoCouldNotReachSupabase.
  ///
  /// In en, this message translates to:
  /// **'Mapingo could not reach Supabase. Check your network connection and Supabase URL, then try again.'**
  String get mapingoCouldNotReachSupabase;

  /// No description provided for @supabaseNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Supabase is not configured for this build. Add SUPABASE_URL and SUPABASE_ANON_KEY when starting the app.'**
  String get supabaseNotConfigured;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong starting Mapingo. Please try again.'**
  String get somethingWentWrong;

  /// No description provided for @anonymousSignInDidNotReturnUser.
  ///
  /// In en, this message translates to:
  /// **'Anonymous sign-in did not return a user.'**
  String get anonymousSignInDidNotReturnUser;

  /// No description provided for @explorer.
  ///
  /// In en, this message translates to:
  /// **'Explorer'**
  String get explorer;

  /// No description provided for @practiceMode.
  ///
  /// In en, this message translates to:
  /// **'Practice Mode'**
  String get practiceMode;

  /// No description provided for @reviewMistakes.
  ///
  /// In en, this message translates to:
  /// **'Review Mistakes'**
  String get reviewMistakes;

  /// No description provided for @practiceCapitals.
  ///
  /// In en, this message translates to:
  /// **'Practice capitals'**
  String get practiceCapitals;

  /// No description provided for @practiceMap.
  ///
  /// In en, this message translates to:
  /// **'Practice map'**
  String get practiceMap;

  /// No description provided for @quickChallenge.
  ///
  /// In en, this message translates to:
  /// **'Quick challenge'**
  String get quickChallenge;

  /// No description provided for @lessonPractice.
  ///
  /// In en, this message translates to:
  /// **'Lesson Practice'**
  String get lessonPractice;

  /// No description provided for @mapPractice.
  ///
  /// In en, this message translates to:
  /// **'Map Practice'**
  String get mapPractice;

  /// No description provided for @matchPairs.
  ///
  /// In en, this message translates to:
  /// **'Match Pairs'**
  String get matchPairs;

  /// No description provided for @multipleChoice.
  ///
  /// In en, this message translates to:
  /// **'Multiple Choice'**
  String get multipleChoice;

  /// No description provided for @tapTheState.
  ///
  /// In en, this message translates to:
  /// **'Tap the State'**
  String get tapTheState;

  /// Label for true
  ///
  /// In en, this message translates to:
  /// **'True'**
  String get trueLabel;

  /// Label for false
  ///
  /// In en, this message translates to:
  /// **'False'**
  String get falseLabel;

  /// No description provided for @loadingMap2.
  ///
  /// In en, this message translates to:
  /// **'Loading map...'**
  String get loadingMap2;

  /// No description provided for @couldNotLoadMap2.
  ///
  /// In en, this message translates to:
  /// **'Could not load the map'**
  String get couldNotLoadMap2;

  /// No description provided for @correctStateSelected2.
  ///
  /// In en, this message translates to:
  /// **'Correct state selected.'**
  String get correctStateSelected2;

  /// No description provided for @correctStateHighlighted2.
  ///
  /// In en, this message translates to:
  /// **'The correct state is highlighted in green.'**
  String get correctStateHighlighted2;

  /// No description provided for @tapStateOnMap2.
  ///
  /// In en, this message translates to:
  /// **'Tap the state on the map.'**
  String get tapStateOnMap2;

  /// No description provided for @correct2.
  ///
  /// In en, this message translates to:
  /// **'Correct!'**
  String get correct2;

  /// No description provided for @tryAgainLater.
  ///
  /// In en, this message translates to:
  /// **'Try again later.'**
  String get tryAgainLater;

  /// No description provided for @practiceComplete2.
  ///
  /// In en, this message translates to:
  /// **'Practice complete'**
  String get practiceComplete2;

  /// No description provided for @chooseAnotherMode2.
  ///
  /// In en, this message translates to:
  /// **'Choose another mode'**
  String get chooseAnotherMode2;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @map.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @mapingo.
  ///
  /// In en, this message translates to:
  /// **'Mapingo'**
  String get mapingo;

  /// No description provided for @learnStatesOfMexico.
  ///
  /// In en, this message translates to:
  /// **'Learn the states of Mexico by playing.'**
  String get learnStatesOfMexico;

  /// No description provided for @dailyGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily goal'**
  String get dailyGoal;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// No description provided for @streak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get streak;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @xp.
  ///
  /// In en, this message translates to:
  /// **'XP'**
  String get xp;

  /// No description provided for @totalXp.
  ///
  /// In en, this message translates to:
  /// **'Total XP'**
  String get totalXp;

  /// No description provided for @lessonsCompleted.
  ///
  /// In en, this message translates to:
  /// **'Lessons completed'**
  String get lessonsCompleted;

  /// No description provided for @accuracy.
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get accuracy;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @onboarding.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Mapingo'**
  String get onboarding;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Learn the 32 states of Mexico the fun way'**
  String get onboardingSubtitle;

  /// No description provided for @setYourDailyGoal.
  ///
  /// In en, this message translates to:
  /// **'Set your daily goal'**
  String get setYourDailyGoal;

  /// No description provided for @minutesDescription.
  ///
  /// In en, this message translates to:
  /// **'minutes of practice per day'**
  String get minutesDescription;

  /// No description provided for @whatsYourName.
  ///
  /// In en, this message translates to:
  /// **'What\'s your name?'**
  String get whatsYourName;

  /// No description provided for @optionalUsername.
  ///
  /// In en, this message translates to:
  /// **'Optional - What should we call you?'**
  String get optionalUsername;

  /// No description provided for @startLearning.
  ///
  /// In en, this message translates to:
  /// **'Start Learning'**
  String get startLearning;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @letsStart.
  ///
  /// In en, this message translates to:
  /// **'Let\'s get started!'**
  String get letsStart;

  /// No description provided for @selectAnswer.
  ///
  /// In en, this message translates to:
  /// **'Select an answer'**
  String get selectAnswer;

  /// No description provided for @tapTheCorrectState.
  ///
  /// In en, this message translates to:
  /// **'Tap the correct state'**
  String get tapTheCorrectState;

  /// No description provided for @matchThePairs.
  ///
  /// In en, this message translates to:
  /// **'Match the pairs'**
  String get matchThePairs;

  /// No description provided for @isTheCapitalOf.
  ///
  /// In en, this message translates to:
  /// **'Is it the capital of {state}?'**
  String isTheCapitalOf(String state);

  /// No description provided for @whichStateIs.
  ///
  /// In en, this message translates to:
  /// **'Which state is {capital}?'**
  String whichStateIs(String capital);

  /// No description provided for @lessonComplete.
  ///
  /// In en, this message translates to:
  /// **'Lesson complete!'**
  String get lessonComplete;

  /// No description provided for @greatJob.
  ///
  /// In en, this message translates to:
  /// **'Great job!'**
  String get greatJob;

  /// No description provided for @youGotXPY.
  ///
  /// In en, this message translates to:
  /// **'You got {xp} XP'**
  String youGotXPY(int xp);

  /// No description provided for @correctAnswers.
  ///
  /// In en, this message translates to:
  /// **'Correct answers'**
  String get correctAnswers;

  /// No description provided for @timeSpent.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeSpent;

  /// No description provided for @continueToHome.
  ///
  /// In en, this message translates to:
  /// **'Continue to home'**
  String get continueToHome;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetConnection;

  /// No description provided for @checkYourConnection.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again.'**
  String get checkYourConnection;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server error'**
  String get serverError;

  /// No description provided for @somethingWentWrong2.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong.'**
  String get somethingWentWrong2;

  /// No description provided for @pleaseTryAgain.
  ///
  /// In en, this message translates to:
  /// **'Please try again.'**
  String get pleaseTryAgain;

  /// No description provided for @unitProgress.
  ///
  /// In en, this message translates to:
  /// **'Unit Progress'**
  String get unitProgress;

  /// No description provided for @lessonsInUnit.
  ///
  /// In en, this message translates to:
  /// **'{count} lessons'**
  String lessonsInUnit(int count);

  /// No description provided for @locked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get locked;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get inProgress;

  /// No description provided for @notStarted.
  ///
  /// In en, this message translates to:
  /// **'Not started'**
  String get notStarted;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// No description provided for @stateDetails.
  ///
  /// In en, this message translates to:
  /// **'State Details'**
  String get stateDetails;

  /// No description provided for @region.
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get region;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @noDescription.
  ///
  /// In en, this message translates to:
  /// **'No description'**
  String get noDescription;

  /// No description provided for @noFunFact.
  ///
  /// In en, this message translates to:
  /// **'No fun fact'**
  String get noFunFact;

  /// No description provided for @practiceMore.
  ///
  /// In en, this message translates to:
  /// **'Practice more'**
  String get practiceMore;

  /// No description provided for @goToMap.
  ///
  /// In en, this message translates to:
  /// **'Go to map'**
  String get goToMap;

  /// No description provided for @lesson.
  ///
  /// In en, this message translates to:
  /// **'Lesson'**
  String get lesson;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @northernMexico.
  ///
  /// In en, this message translates to:
  /// **'Northern Mexico'**
  String get northernMexico;

  /// No description provided for @centralMexico.
  ///
  /// In en, this message translates to:
  /// **'Central Mexico'**
  String get centralMexico;

  /// No description provided for @westernMexico.
  ///
  /// In en, this message translates to:
  /// **'Western Mexico'**
  String get westernMexico;

  /// No description provided for @southernMexico.
  ///
  /// In en, this message translates to:
  /// **'Southern Mexico'**
  String get southernMexico;

  /// No description provided for @southeastMexico.
  ///
  /// In en, this message translates to:
  /// **'Southeast Mexico'**
  String get southeastMexico;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
