// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Mapingo';

  @override
  String get exploreMexico => 'Explore Mexico';

  @override
  String get tapStateToSeeDetails =>
      'Tap any state to see its capital, region, and a fun fact.';

  @override
  String get loadingMap => 'Loading Mexico map...';

  @override
  String get couldNotLoadMap => 'Could not load the map';

  @override
  String get tryAgain => 'Try again';

  @override
  String get noMapDataYet => 'No map data yet';

  @override
  String get statesWillAppearHere =>
      'Mexican states will appear here once content is ready.';

  @override
  String get refresh => 'Refresh';

  @override
  String get chooseStateOnMap => 'Choose a state on the map.';

  @override
  String get capital => 'Capital';

  @override
  String get progress => 'Progress';

  @override
  String get noPracticeYet => 'No practice yet';

  @override
  String get funFact => 'Fun fact';

  @override
  String get practice => 'Practice';

  @override
  String get preparingPractice => 'Preparing practice...';

  @override
  String get couldNotLoadPractice => 'Could not load practice';

  @override
  String get noMistakesToReview => 'No mistakes to review';

  @override
  String get noPracticeYet2 => 'No practice yet';

  @override
  String get missedExercisesWillAppear =>
      'Missed exercises will appear here after lessons.';

  @override
  String get practiceQuestionsWillAppear =>
      'Practice questions will appear here once content is ready.';

  @override
  String get chooseAnotherMode => 'Choose another mode';

  @override
  String get choosePractice => 'Choose practice';

  @override
  String get shortSessionsHelpReinforce =>
      'Short sessions help reinforce what you\'ve learned.';

  @override
  String get practiceComplete => 'Practice complete';

  @override
  String practiceScoreSummary(int correctCount, int wrongCount) {
    return '$correctCount correct - $wrongCount wrong';
  }

  @override
  String get youAnsweredEveryQuestion => 'You answered all practice questions.';

  @override
  String get finish => 'Finish';

  @override
  String get continueAction => 'Continue';

  @override
  String get check => 'Check';

  @override
  String get correctStateSelected => 'Correct state selected.';

  @override
  String get correctStateHighlighted =>
      'The correct state is highlighted in green.';

  @override
  String get tapStateOnMap => 'Tap the state on the map.';

  @override
  String get correct => 'Correct!';

  @override
  String get tryThisOneAgainLater => 'Try this one later.';

  @override
  String get mapExplorer => 'Map Explorer';

  @override
  String get startingMapingo => 'Starting Mapingo...';

  @override
  String get couldNotStartMapingo => 'Could not start Mapingo';

  @override
  String get openingYourMap => 'Opening your map...';

  @override
  String get anonymousSignInsDisabled =>
      'Anonymous sign-ins are disabled in Supabase. Enable Anonymous sign-ins in Authentication > Providers before starting Mapingo.';

  @override
  String get mapingoCouldNotReachSupabase =>
      'Mapingo could not reach Supabase. Check your network connection and Supabase URL, then try again.';

  @override
  String get supabaseNotConfigured =>
      'Supabase is not configured for this build. Add SUPABASE_URL and SUPABASE_ANON_KEY when starting the app.';

  @override
  String get somethingWentWrong =>
      'Something went wrong starting Mapingo. Please try again.';

  @override
  String get anonymousSignInDidNotReturnUser =>
      'Anonymous sign-in did not return a user.';

  @override
  String get explorer => 'Explorer';

  @override
  String get practiceMode => 'Practice Mode';

  @override
  String get reviewMistakes => 'Review Mistakes';

  @override
  String get practiceCapitals => 'Practice capitals';

  @override
  String get practiceMap => 'Practice map';

  @override
  String get quickChallenge => 'Quick challenge';

  @override
  String get lessonPractice => 'Lesson Practice';

  @override
  String get mapPractice => 'Map Practice';

  @override
  String get matchPairs => 'Match Pairs';

  @override
  String get multipleChoice => 'Multiple Choice';

  @override
  String get tapTheState => 'Tap the State';

  @override
  String get trueLabel => 'True';

  @override
  String get falseLabel => 'False';

  @override
  String get loadingMap2 => 'Loading map...';

  @override
  String get couldNotLoadMap2 => 'Could not load the map';

  @override
  String get correctStateSelected2 => 'Correct state selected.';

  @override
  String get correctStateHighlighted2 =>
      'The correct state is highlighted in green.';

  @override
  String get tapStateOnMap2 => 'Tap the state on the map.';

  @override
  String get correct2 => 'Correct!';

  @override
  String get tryAgainLater => 'Try again later.';

  @override
  String get practiceComplete2 => 'Practice complete';

  @override
  String get chooseAnotherMode2 => 'Choose another mode';

  @override
  String get home => 'Home';

  @override
  String get map => 'Map';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get mapingo => 'Mapingo';

  @override
  String get learnStatesOfMexico => 'Learn the states of Mexico by playing.';

  @override
  String get dailyGoal => 'Daily goal';

  @override
  String get minutes => 'minutes';

  @override
  String get streak => 'Streak';

  @override
  String get days => 'days';

  @override
  String get xp => 'XP';

  @override
  String get totalXp => 'Total XP';

  @override
  String get lessonsCompleted => 'Lessons completed';

  @override
  String get accuracy => 'Accuracy';

  @override
  String get achievements => 'Achievements';

  @override
  String get onboarding => 'Welcome to Mapingo';

  @override
  String get onboardingSubtitle => 'Learn the 32 states of Mexico the fun way';

  @override
  String get setYourDailyGoal => 'Set your daily goal';

  @override
  String get minutesDescription => 'minutes of practice per day';

  @override
  String get whatsYourName => 'What\'s your name?';

  @override
  String get optionalUsername => 'Optional - What should we call you?';

  @override
  String get startLearning => 'Start Learning';

  @override
  String get skip => 'Skip';

  @override
  String get continueText => 'Continue';

  @override
  String get welcome => 'Welcome';

  @override
  String get letsStart => 'Let\'s get started!';

  @override
  String get selectAnswer => 'Select an answer';

  @override
  String get tapTheCorrectState => 'Tap the correct state';

  @override
  String get matchThePairs => 'Match the pairs';

  @override
  String isTheCapitalOf(String state) {
    return 'Is it the capital of $state?';
  }

  @override
  String whichStateIs(String capital) {
    return 'Which state is $capital?';
  }

  @override
  String get lessonComplete => 'Lesson complete!';

  @override
  String get greatJob => 'Great job!';

  @override
  String youGotXPY(int xp) {
    return 'You got $xp XP';
  }

  @override
  String get correctAnswers => 'Correct answers';

  @override
  String get timeSpent => 'Time';

  @override
  String get continueToHome => 'Continue to home';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get exit => 'Exit';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get warning => 'Warning';

  @override
  String get info => 'Info';

  @override
  String get noInternetConnection => 'No internet connection';

  @override
  String get checkYourConnection => 'Check your connection and try again.';

  @override
  String get serverError => 'Server error';

  @override
  String get somethingWentWrong2 => 'Something went wrong.';

  @override
  String get pleaseTryAgain => 'Please try again.';

  @override
  String get unitProgress => 'Unit Progress';

  @override
  String lessonsInUnit(int count) {
    return '$count lessons';
  }

  @override
  String get locked => 'Locked';

  @override
  String get completed => 'Completed';

  @override
  String get inProgress => 'In progress';

  @override
  String get notStarted => 'Not started';

  @override
  String get start => 'Start';

  @override
  String get resume => 'Resume';

  @override
  String get review => 'Review';

  @override
  String get stateDetails => 'State Details';

  @override
  String get region => 'Region';

  @override
  String get description => 'Description';

  @override
  String get noDescription => 'No description';

  @override
  String get noFunFact => 'No fun fact';

  @override
  String get practiceMore => 'Practice more';

  @override
  String get goToMap => 'Go to map';

  @override
  String get lesson => 'Lesson';

  @override
  String get unit => 'Unit';

  @override
  String get northernMexico => 'Northern Mexico';

  @override
  String get centralMexico => 'Central Mexico';

  @override
  String get westernMexico => 'Western Mexico';

  @override
  String get southernMexico => 'Southern Mexico';

  @override
  String get southeastMexico => 'Southeast Mexico';
}
