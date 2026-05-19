import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

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
  static const List<Locale> supportedLocales = <Locale>[Locale('es')];

  /// No description provided for @appName.
  ///
  /// In es, this message translates to:
  /// **'Mapingo'**
  String get appName;

  /// No description provided for @exploreMexico.
  ///
  /// In es, this message translates to:
  /// **'Explora México'**
  String get exploreMexico;

  /// No description provided for @tapStateToSeeDetails.
  ///
  /// In es, this message translates to:
  /// **'Toca cualquier estado para ver su capital, región y un dato curioso.'**
  String get tapStateToSeeDetails;

  /// No description provided for @loadingMap.
  ///
  /// In es, this message translates to:
  /// **'Cargando mapa de México...'**
  String get loadingMap;

  /// No description provided for @couldNotLoadMap.
  ///
  /// In es, this message translates to:
  /// **'No se pudo cargar el mapa'**
  String get couldNotLoadMap;

  /// No description provided for @tryAgain.
  ///
  /// In es, this message translates to:
  /// **'Intentar de nuevo'**
  String get tryAgain;

  /// No description provided for @noMapDataYet.
  ///
  /// In es, this message translates to:
  /// **'Aún no hay datos del mapa'**
  String get noMapDataYet;

  /// No description provided for @statesWillAppearHere.
  ///
  /// In es, this message translates to:
  /// **'Los estados mexicanos aparecerán aquí cuando el contenido esté listo.'**
  String get statesWillAppearHere;

  /// No description provided for @refresh.
  ///
  /// In es, this message translates to:
  /// **'Actualizar'**
  String get refresh;

  /// No description provided for @chooseStateOnMap.
  ///
  /// In es, this message translates to:
  /// **'Elige un estado en el mapa.'**
  String get chooseStateOnMap;

  /// No description provided for @capital.
  ///
  /// In es, this message translates to:
  /// **'Capital'**
  String get capital;

  /// No description provided for @progress.
  ///
  /// In es, this message translates to:
  /// **'Progreso'**
  String get progress;

  /// No description provided for @noPracticeYet.
  ///
  /// In es, this message translates to:
  /// **'Sin práctica aún'**
  String get noPracticeYet;

  /// No description provided for @funFact.
  ///
  /// In es, this message translates to:
  /// **'Dato curioso'**
  String get funFact;

  /// No description provided for @practice.
  ///
  /// In es, this message translates to:
  /// **'Práctica'**
  String get practice;

  /// No description provided for @preparingPractice.
  ///
  /// In es, this message translates to:
  /// **'Preparando práctica...'**
  String get preparingPractice;

  /// No description provided for @couldNotLoadPractice.
  ///
  /// In es, this message translates to:
  /// **'No se pudo cargar la práctica'**
  String get couldNotLoadPractice;

  /// No description provided for @noMistakesToReview.
  ///
  /// In es, this message translates to:
  /// **'Sin errores para repasar'**
  String get noMistakesToReview;

  /// No description provided for @noPracticeYet2.
  ///
  /// In es, this message translates to:
  /// **'Sin práctica aún'**
  String get noPracticeYet2;

  /// No description provided for @missedExercisesWillAppear.
  ///
  /// In es, this message translates to:
  /// **'Los ejercicios fallados aparecerán aquí después de las lecciones.'**
  String get missedExercisesWillAppear;

  /// No description provided for @practiceQuestionsWillAppear.
  ///
  /// In es, this message translates to:
  /// **'Las preguntas de práctica aparecerán aquí cuando el contenido esté listo.'**
  String get practiceQuestionsWillAppear;

  /// No description provided for @chooseAnotherMode.
  ///
  /// In es, this message translates to:
  /// **'Elegir otro modo'**
  String get chooseAnotherMode;

  /// No description provided for @choosePractice.
  ///
  /// In es, this message translates to:
  /// **'Elegir práctica'**
  String get choosePractice;

  /// No description provided for @shortSessionsHelpReinforce.
  ///
  /// In es, this message translates to:
  /// **'Las sesiones cortas ayudan a reforzar lo que has aprendido.'**
  String get shortSessionsHelpReinforce;

  /// No description provided for @practiceComplete.
  ///
  /// In es, this message translates to:
  /// **'Práctica completa'**
  String get practiceComplete;

  /// No description provided for @youAnsweredEveryQuestion.
  ///
  /// In es, this message translates to:
  /// **'Respondiste todas las preguntas de práctica.'**
  String get youAnsweredEveryQuestion;

  /// No description provided for @finish.
  ///
  /// In es, this message translates to:
  /// **'Terminar'**
  String get finish;

  /// Button text to continue
  ///
  /// In es, this message translates to:
  /// **'Continuar'**
  String get continueAction;

  /// No description provided for @check.
  ///
  /// In es, this message translates to:
  /// **'Verificar'**
  String get check;

  /// No description provided for @correctStateSelected.
  ///
  /// In es, this message translates to:
  /// **'Estado correcto seleccionado.'**
  String get correctStateSelected;

  /// No description provided for @correctStateHighlighted.
  ///
  /// In es, this message translates to:
  /// **'El estado correcto está resaltado en verde.'**
  String get correctStateHighlighted;

  /// No description provided for @tapStateOnMap.
  ///
  /// In es, this message translates to:
  /// **'Toca el estado en el mapa.'**
  String get tapStateOnMap;

  /// No description provided for @correct.
  ///
  /// In es, this message translates to:
  /// **'¡Correcto!'**
  String get correct;

  /// No description provided for @tryThisOneAgainLater.
  ///
  /// In es, this message translates to:
  /// **'Intenta este después.'**
  String get tryThisOneAgainLater;

  /// No description provided for @mapExplorer.
  ///
  /// In es, this message translates to:
  /// **'Explorador de Mapas'**
  String get mapExplorer;

  /// No description provided for @startingMapingo.
  ///
  /// In es, this message translates to:
  /// **'Iniciando Mapingo...'**
  String get startingMapingo;

  /// No description provided for @couldNotStartMapingo.
  ///
  /// In es, this message translates to:
  /// **'No se pudo iniciar Mapingo'**
  String get couldNotStartMapingo;

  /// No description provided for @openingYourMap.
  ///
  /// In es, this message translates to:
  /// **'Abriendo tu mapa...'**
  String get openingYourMap;

  /// No description provided for @anonymousSignInsDisabled.
  ///
  /// In es, this message translates to:
  /// **'Los ingresos anónimos están deshabilitados en Supabase. Habilita los ingresos anónimos en Authentication > Providers antes de iniciar Mapingo.'**
  String get anonymousSignInsDisabled;

  /// No description provided for @mapingoCouldNotReachSupabase.
  ///
  /// In es, this message translates to:
  /// **'Mapingo no pudo alcanzar a Supabase. Verifica la conexión de red y la URL de Supabase, luego intenta de nuevo.'**
  String get mapingoCouldNotReachSupabase;

  /// No description provided for @supabaseNotConfigured.
  ///
  /// In es, this message translates to:
  /// **'Supabase no está configurado para esta compilación. Agrega SUPABASE_URL y SUPABASE_ANON_KEY al iniciar la app.'**
  String get supabaseNotConfigured;

  /// No description provided for @somethingWentWrong.
  ///
  /// In es, this message translates to:
  /// **'Algo salió mal al iniciar Mapingo. Por favor intenta de nuevo.'**
  String get somethingWentWrong;

  /// No description provided for @anonymousSignInDidNotReturnUser.
  ///
  /// In es, this message translates to:
  /// **'El ingreso anónimo no devolvió un usuario.'**
  String get anonymousSignInDidNotReturnUser;

  /// No description provided for @explorer.
  ///
  /// In es, this message translates to:
  /// **'Explorador'**
  String get explorer;

  /// No description provided for @practiceMode.
  ///
  /// In es, this message translates to:
  /// **'Modo de Práctica'**
  String get practiceMode;

  /// No description provided for @reviewMistakes.
  ///
  /// In es, this message translates to:
  /// **'Repasar Errores'**
  String get reviewMistakes;

  /// No description provided for @lessonPractice.
  ///
  /// In es, this message translates to:
  /// **'Práctica de Lección'**
  String get lessonPractice;

  /// No description provided for @mapPractice.
  ///
  /// In es, this message translates to:
  /// **'Práctica en el Mapa'**
  String get mapPractice;

  /// No description provided for @matchPairs.
  ///
  /// In es, this message translates to:
  /// **'Emparejar Pares'**
  String get matchPairs;

  /// No description provided for @multipleChoice.
  ///
  /// In es, this message translates to:
  /// **'Opción Múltiple'**
  String get multipleChoice;

  /// No description provided for @tapTheState.
  ///
  /// In es, this message translates to:
  /// **'Toca el Estado'**
  String get tapTheState;

  /// Label for true
  ///
  /// In es, this message translates to:
  /// **'Verdadero'**
  String get trueLabel;

  /// Label for false
  ///
  /// In es, this message translates to:
  /// **'Falso'**
  String get falseLabel;

  /// No description provided for @loadingMap2.
  ///
  /// In es, this message translates to:
  /// **'Cargando mapa...'**
  String get loadingMap2;

  /// No description provided for @couldNotLoadMap2.
  ///
  /// In es, this message translates to:
  /// **'No se pudo cargar el mapa'**
  String get couldNotLoadMap2;

  /// No description provided for @correctStateSelected2.
  ///
  /// In es, this message translates to:
  /// **'Estado correcto seleccionado.'**
  String get correctStateSelected2;

  /// No description provided for @correctStateHighlighted2.
  ///
  /// In es, this message translates to:
  /// **'El estado correcto está resaltado en verde.'**
  String get correctStateHighlighted2;

  /// No description provided for @tapStateOnMap2.
  ///
  /// In es, this message translates to:
  /// **'Toca el estado en el mapa.'**
  String get tapStateOnMap2;

  /// No description provided for @correct2.
  ///
  /// In es, this message translates to:
  /// **'¡Correcto!'**
  String get correct2;

  /// No description provided for @tryAgainLater.
  ///
  /// In es, this message translates to:
  /// **'Intenta más tarde.'**
  String get tryAgainLater;

  /// No description provided for @practiceComplete2.
  ///
  /// In es, this message translates to:
  /// **'Práctica completa'**
  String get practiceComplete2;

  /// No description provided for @chooseAnotherMode2.
  ///
  /// In es, this message translates to:
  /// **'Elegir otro modo'**
  String get chooseAnotherMode2;

  /// No description provided for @home.
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get home;

  /// No description provided for @profile.
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In es, this message translates to:
  /// **'Configuración'**
  String get settings;

  /// No description provided for @mapingo.
  ///
  /// In es, this message translates to:
  /// **'Mapingo'**
  String get mapingo;

  /// No description provided for @learnStatesOfMexico.
  ///
  /// In es, this message translates to:
  /// **'Aprende los estados de México jugando.'**
  String get learnStatesOfMexico;

  /// No description provided for @dailyGoal.
  ///
  /// In es, this message translates to:
  /// **'Meta diaria'**
  String get dailyGoal;

  /// No description provided for @minutes.
  ///
  /// In es, this message translates to:
  /// **'minutos'**
  String get minutes;

  /// No description provided for @streak.
  ///
  /// In es, this message translates to:
  /// **'Racha'**
  String get streak;

  /// No description provided for @days.
  ///
  /// In es, this message translates to:
  /// **'días'**
  String get days;

  /// No description provided for @xp.
  ///
  /// In es, this message translates to:
  /// **'XP'**
  String get xp;

  /// No description provided for @totalXp.
  ///
  /// In es, this message translates to:
  /// **'XP Total'**
  String get totalXp;

  /// No description provided for @lessonsCompleted.
  ///
  /// In es, this message translates to:
  /// **'Lecciones completadas'**
  String get lessonsCompleted;

  /// No description provided for @accuracy.
  ///
  /// In es, this message translates to:
  /// **'Precisión'**
  String get accuracy;

  /// No description provided for @achievements.
  ///
  /// In es, this message translates to:
  /// **'Logros'**
  String get achievements;

  /// No description provided for @onboarding.
  ///
  /// In es, this message translates to:
  /// **'Bienvenido a Mapingo'**
  String get onboarding;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In es, this message translates to:
  /// **'Aprende los 32 estados de México de forma divertida'**
  String get onboardingSubtitle;

  /// No description provided for @setYourDailyGoal.
  ///
  /// In es, this message translates to:
  /// **'Configura tu meta diaria'**
  String get setYourDailyGoal;

  /// No description provided for @minutesDescription.
  ///
  /// In es, this message translates to:
  /// **'minutes of practice per day'**
  String get minutesDescription;

  /// No description provided for @whatsYourName.
  ///
  /// In es, this message translates to:
  /// **'¿Cómo te llamas?'**
  String get whatsYourName;

  /// No description provided for @optionalUsername.
  ///
  /// In es, this message translates to:
  /// **'Opcional - ¿Cómo quieres que te llamemos?'**
  String get optionalUsername;

  /// No description provided for @startLearning.
  ///
  /// In es, this message translates to:
  /// **'Comenzar a Aprender'**
  String get startLearning;

  /// No description provided for @skip.
  ///
  /// In es, this message translates to:
  /// **'Omitir'**
  String get skip;

  /// No description provided for @continueText.
  ///
  /// In es, this message translates to:
  /// **'Continuar'**
  String get continueText;

  /// No description provided for @welcome.
  ///
  /// In es, this message translates to:
  /// **'Bienvenido'**
  String get welcome;

  /// No description provided for @letsStart.
  ///
  /// In es, this message translates to:
  /// **'¡Vamos a comenzar!'**
  String get letsStart;

  /// No description provided for @selectAnswer.
  ///
  /// In es, this message translates to:
  /// **'Selecciona una respuesta'**
  String get selectAnswer;

  /// No description provided for @tapTheCorrectState.
  ///
  /// In es, this message translates to:
  /// **'Toca el estado correcto'**
  String get tapTheCorrectState;

  /// No description provided for @matchThePairs.
  ///
  /// In es, this message translates to:
  /// **'Empareja los pares'**
  String get matchThePairs;

  /// No description provided for @isTheCapitalOf.
  ///
  /// In es, this message translates to:
  /// **'¿Es la capital de {state}?'**
  String isTheCapitalOf(String state);

  /// No description provided for @whichStateIs.
  ///
  /// In es, this message translates to:
  /// **'¿Qué estado es {capital}?'**
  String whichStateIs(String capital);

  /// No description provided for @lessonComplete.
  ///
  /// In es, this message translates to:
  /// **'¡Lección completa!'**
  String get lessonComplete;

  /// No description provided for @greatJob.
  ///
  /// In es, this message translates to:
  /// **'¡Buen trabajo!'**
  String get greatJob;

  /// No description provided for @youGotXPY.
  ///
  /// In es, this message translates to:
  /// **'Obtuviste {xp} XP'**
  String youGotXPY(int xp);

  /// No description provided for @correctAnswers.
  ///
  /// In es, this message translates to:
  /// **'Respuestas correctas'**
  String get correctAnswers;

  /// No description provided for @timeSpent.
  ///
  /// In es, this message translates to:
  /// **'Tiempo'**
  String get timeSpent;

  /// No description provided for @continueToHome.
  ///
  /// In es, this message translates to:
  /// **'Continuar al inicio'**
  String get continueToHome;

  /// No description provided for @next.
  ///
  /// In es, this message translates to:
  /// **'Siguiente'**
  String get next;

  /// No description provided for @back.
  ///
  /// In es, this message translates to:
  /// **'Atrás'**
  String get back;

  /// No description provided for @exit.
  ///
  /// In es, this message translates to:
  /// **'Salir'**
  String get exit;

  /// No description provided for @cancel.
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In es, this message translates to:
  /// **'Aceptar'**
  String get ok;

  /// No description provided for @yes.
  ///
  /// In es, this message translates to:
  /// **'Sí'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In es, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @loading.
  ///
  /// In es, this message translates to:
  /// **'Cargando...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In es, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In es, this message translates to:
  /// **'Éxito'**
  String get success;

  /// No description provided for @warning.
  ///
  /// In es, this message translates to:
  /// **'Advertencia'**
  String get warning;

  /// No description provided for @info.
  ///
  /// In es, this message translates to:
  /// **'Información'**
  String get info;

  /// No description provided for @noInternetConnection.
  ///
  /// In es, this message translates to:
  /// **'Sin conexión a internet'**
  String get noInternetConnection;

  /// No description provided for @checkYourConnection.
  ///
  /// In es, this message translates to:
  /// **'Verifica tu conexión y vuelve a intentar.'**
  String get checkYourConnection;

  /// No description provided for @serverError.
  ///
  /// In es, this message translates to:
  /// **'Error del servidor'**
  String get serverError;

  /// No description provided for @somethingWentWrong2.
  ///
  /// In es, this message translates to:
  /// **'Algo salió mal.'**
  String get somethingWentWrong2;

  /// No description provided for @pleaseTryAgain.
  ///
  /// In es, this message translates to:
  /// **'Por favor intenta de nuevo.'**
  String get pleaseTryAgain;

  /// No description provided for @unitProgress.
  ///
  /// In es, this message translates to:
  /// **'Progreso de Unidad'**
  String get unitProgress;

  /// No description provided for @lessonsInUnit.
  ///
  /// In es, this message translates to:
  /// **'{count} lecciones'**
  String lessonsInUnit(int count);

  /// No description provided for @locked.
  ///
  /// In es, this message translates to:
  /// **'Bloqueado'**
  String get locked;

  /// No description provided for @completed.
  ///
  /// In es, this message translates to:
  /// **'Completado'**
  String get completed;

  /// No description provided for @inProgress.
  ///
  /// In es, this message translates to:
  /// **'En progreso'**
  String get inProgress;

  /// No description provided for @notStarted.
  ///
  /// In es, this message translates to:
  /// **'No iniciado'**
  String get notStarted;

  /// No description provided for @start.
  ///
  /// In es, this message translates to:
  /// **'Iniciar'**
  String get start;

  /// No description provided for @resume.
  ///
  /// In es, this message translates to:
  /// **'Continuar'**
  String get resume;

  /// No description provided for @review.
  ///
  /// In es, this message translates to:
  /// **'Repasar'**
  String get review;

  /// No description provided for @stateDetails.
  ///
  /// In es, this message translates to:
  /// **'Detalles del Estado'**
  String get stateDetails;

  /// No description provided for @region.
  ///
  /// In es, this message translates to:
  /// **'Región'**
  String get region;

  /// No description provided for @description.
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get description;

  /// No description provided for @noDescription.
  ///
  /// In es, this message translates to:
  /// **'Sin descripción'**
  String get noDescription;

  /// No description provided for @noFunFact.
  ///
  /// In es, this message translates to:
  /// **'Sin dato curioso'**
  String get noFunFact;

  /// No description provided for @practiceMore.
  ///
  /// In es, this message translates to:
  /// **'Practicar más'**
  String get practiceMore;

  /// No description provided for @goToMap.
  ///
  /// In es, this message translates to:
  /// **'Ir al mapa'**
  String get goToMap;

  /// No description provided for @lesson.
  ///
  /// In es, this message translates to:
  /// **'Lección'**
  String get lesson;

  /// No description provided for @unit.
  ///
  /// In es, this message translates to:
  /// **'Unidad'**
  String get unit;

  /// No description provided for @northernMexico.
  ///
  /// In es, this message translates to:
  /// **'México Norte'**
  String get northernMexico;

  /// No description provided for @centralMexico.
  ///
  /// In es, this message translates to:
  /// **'México Central'**
  String get centralMexico;

  /// No description provided for @westernMexico.
  ///
  /// In es, this message translates to:
  /// **'México Oeste'**
  String get westernMexico;

  /// No description provided for @southernMexico.
  ///
  /// In es, this message translates to:
  /// **'México Sur'**
  String get southernMexico;

  /// No description provided for @southeastMexico.
  ///
  /// In es, this message translates to:
  /// **'México Sureste'**
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
      <String>['es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
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
