// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Mapingo';

  @override
  String get exploreMexico => 'Explora México';

  @override
  String get tapStateToSeeDetails =>
      'Toca cualquier estado para ver su capital, región y un dato curioso.';

  @override
  String get loadingMap => 'Cargando mapa de México...';

  @override
  String get couldNotLoadMap => 'No se pudo cargar el mapa';

  @override
  String get tryAgain => 'Intentar de nuevo';

  @override
  String get noMapDataYet => 'Aún no hay datos del mapa';

  @override
  String get statesWillAppearHere =>
      'Los estados mexicanos aparecerán aquí cuando el contenido esté listo.';

  @override
  String get refresh => 'Actualizar';

  @override
  String get chooseStateOnMap => 'Elige un estado en el mapa.';

  @override
  String get capital => 'Capital';

  @override
  String get progress => 'Progreso';

  @override
  String get noPracticeYet => 'Sin práctica aún';

  @override
  String get funFact => 'Dato curioso';

  @override
  String get practice => 'Práctica';

  @override
  String get preparingPractice => 'Preparando práctica...';

  @override
  String get couldNotLoadPractice => 'No se pudo cargar la práctica';

  @override
  String get noMistakesToReview => 'Sin errores para repasar';

  @override
  String get noPracticeYet2 => 'Sin práctica aún';

  @override
  String get missedExercisesWillAppear =>
      'Los ejercicios fallados aparecerán aquí después de las lecciones.';

  @override
  String get practiceQuestionsWillAppear =>
      'Las preguntas de práctica aparecerán aquí cuando el contenido esté listo.';

  @override
  String get chooseAnotherMode => 'Elegir otro modo';

  @override
  String get choosePractice => 'Elegir práctica';

  @override
  String get shortSessionsHelpReinforce =>
      'Las sesiones cortas ayudan a reforzar lo que has aprendido.';

  @override
  String get practiceComplete => 'Práctica completa';

  @override
  String practiceScoreSummary(int correctCount, int wrongCount) {
    return '$correctCount correctas - $wrongCount incorrectas';
  }

  @override
  String get youAnsweredEveryQuestion =>
      'Respondiste todas las preguntas de práctica.';

  @override
  String get finish => 'Terminar';

  @override
  String get continueAction => 'Continuar';

  @override
  String get check => 'Verificar';

  @override
  String get correctStateSelected => 'Estado correcto seleccionado.';

  @override
  String get correctStateHighlighted =>
      'El estado correcto está resaltado en verde.';

  @override
  String get tapStateOnMap => 'Toca el estado en el mapa.';

  @override
  String get correct => '¡Correcto!';

  @override
  String get tryThisOneAgainLater => 'Intenta este después.';

  @override
  String get mapExplorer => 'Explorador de Mapas';

  @override
  String get startingMapingo => 'Iniciando Mapingo...';

  @override
  String get couldNotStartMapingo => 'No se pudo iniciar Mapingo';

  @override
  String get openingYourMap => 'Abriendo tu mapa...';

  @override
  String get anonymousSignInsDisabled =>
      'Los ingresos anónimos están deshabilitados en Supabase. Habilita los ingresos anónimos en Authentication > Providers antes de iniciar Mapingo.';

  @override
  String get mapingoCouldNotReachSupabase =>
      'Mapingo no pudo alcanzar a Supabase. Verifica la conexión de red y la URL de Supabase, luego intenta de nuevo.';

  @override
  String get supabaseNotConfigured =>
      'Supabase no está configurado para esta compilación. Agrega SUPABASE_URL y SUPABASE_ANON_KEY al iniciar la app.';

  @override
  String get somethingWentWrong =>
      'Algo salió mal al iniciar Mapingo. Por favor intenta de nuevo.';

  @override
  String get anonymousSignInDidNotReturnUser =>
      'El ingreso anónimo no devolvió un usuario.';

  @override
  String get explorer => 'Explorador';

  @override
  String get practiceMode => 'Modo de Práctica';

  @override
  String get reviewMistakes => 'Repasar Errores';

  @override
  String get practiceCapitals => 'Practicar capitales';

  @override
  String get practiceMap => 'Practicar mapa';

  @override
  String get quickChallenge => 'Reto rápido';

  @override
  String get lessonPractice => 'Práctica de Lección';

  @override
  String get mapPractice => 'Práctica en el Mapa';

  @override
  String get matchPairs => 'Emparejar Pares';

  @override
  String get multipleChoice => 'Opción Múltiple';

  @override
  String get tapTheState => 'Toca el Estado';

  @override
  String get trueLabel => 'Verdadero';

  @override
  String get falseLabel => 'Falso';

  @override
  String get loadingMap2 => 'Cargando mapa...';

  @override
  String get couldNotLoadMap2 => 'No se pudo cargar el mapa';

  @override
  String get correctStateSelected2 => 'Estado correcto seleccionado.';

  @override
  String get correctStateHighlighted2 =>
      'El estado correcto está resaltado en verde.';

  @override
  String get tapStateOnMap2 => 'Toca el estado en el mapa.';

  @override
  String get correct2 => '¡Correcto!';

  @override
  String get tryAgainLater => 'Intenta esto después.';

  @override
  String get practiceComplete2 => 'Práctica completa';

  @override
  String get chooseAnotherMode2 => 'Elegir otro modo';

  @override
  String get home => 'Inicio';

  @override
  String get map => 'Mapa';

  @override
  String get profile => 'Perfil';

  @override
  String get settings => 'Configuración';

  @override
  String get mapingo => 'Mapingo';

  @override
  String get learnStatesOfMexico => 'Aprende los estados de México jugando.';

  @override
  String get dailyGoal => 'Meta diaria';

  @override
  String get minutes => 'minutos';

  @override
  String get streak => 'Racha';

  @override
  String get days => 'días';

  @override
  String get xp => 'XP';

  @override
  String get totalXp => 'XP Total';

  @override
  String get lessonsCompleted => 'Lecciones completadas';

  @override
  String get accuracy => 'Precisión';

  @override
  String get achievements => 'Logros';

  @override
  String get onboarding => 'Bienvenido a Mapingo';

  @override
  String get onboardingSubtitle =>
      'Aprende los 32 estados de México de forma divertida';

  @override
  String get setYourDailyGoal => 'Configura tu meta diaria';

  @override
  String get minutesDescription => 'minutos de práctica al día';

  @override
  String get whatsYourName => '¿Cómo te llamas?';

  @override
  String get optionalUsername => 'Opcional - ¿Cómo quieres que te llamemos?';

  @override
  String get startLearning => 'Comenzar a Aprender';

  @override
  String get skip => 'Omitir';

  @override
  String get continueText => 'Continuar';

  @override
  String get welcome => 'Bienvenido';

  @override
  String get letsStart => '¡Vamos a comenzar!';

  @override
  String get selectAnswer => 'Selecciona una respuesta';

  @override
  String get tapTheCorrectState => 'Toca el estado correcto';

  @override
  String get matchThePairs => 'Empareja los pares';

  @override
  String isTheCapitalOf(String state) {
    return '¿Es la capital de $state?';
  }

  @override
  String whichStateIs(String capital) {
    return '¿Qué estado es $capital?';
  }

  @override
  String get lessonComplete => '¡Lección completa!';

  @override
  String get greatJob => '¡Buen trabajo!';

  @override
  String youGotXPY(int xp) {
    return 'Obtuviste $xp XP';
  }

  @override
  String get correctAnswers => 'Respuestas correctas';

  @override
  String get timeSpent => 'Tiempo';

  @override
  String get continueToHome => 'Continuar al inicio';

  @override
  String get next => 'Siguiente';

  @override
  String get back => 'Atrás';

  @override
  String get exit => 'Salir';

  @override
  String get cancel => 'Cancelar';

  @override
  String get ok => 'Aceptar';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get loading => 'Cargando...';

  @override
  String get error => 'Error';

  @override
  String get success => 'Éxito';

  @override
  String get warning => 'Advertencia';

  @override
  String get info => 'Información';

  @override
  String get noInternetConnection => 'Sin conexión a internet';

  @override
  String get checkYourConnection => 'Verifica tu conexión y vuelve a intentar.';

  @override
  String get serverError => 'Error del servidor';

  @override
  String get somethingWentWrong2 => 'Algo salió mal.';

  @override
  String get pleaseTryAgain => 'Por favor intenta de nuevo.';

  @override
  String get unitProgress => 'Progreso de Unidad';

  @override
  String lessonsInUnit(int count) {
    return '$count lecciones';
  }

  @override
  String get locked => 'Bloqueado';

  @override
  String get completed => 'Completado';

  @override
  String get inProgress => 'En progreso';

  @override
  String get notStarted => 'No iniciado';

  @override
  String get start => 'Iniciar';

  @override
  String get resume => 'Continuar';

  @override
  String get review => 'Repasar';

  @override
  String get stateDetails => 'Detalles del Estado';

  @override
  String get region => 'Región';

  @override
  String get description => 'Descripción';

  @override
  String get noDescription => 'Sin descripción';

  @override
  String get noFunFact => 'Sin dato curioso';

  @override
  String get practiceMore => 'Practicar más';

  @override
  String get goToMap => 'Ir al mapa';

  @override
  String get lesson => 'Lección';

  @override
  String get unit => 'Unidad';

  @override
  String get northernMexico => 'México Norte';

  @override
  String get centralMexico => 'México Central';

  @override
  String get westernMexico => 'México Oeste';

  @override
  String get southernMexico => 'México Sur';

  @override
  String get southeastMexico => 'México Sureste';
}
