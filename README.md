# Mapingo

Mapingo es una app Flutter para aprender los 32 estados de Mexico jugando. El producto esta pensado para usuarios de Mexico, con contenido en espanol, practica por mapa, capitales, progreso, XP, rachas, logros y repaso de errores.

## Stack

- Flutter + Dart
- Riverpod para estado
- GoRouter para navegacion
- Supabase Auth anonimo + Postgres
- SharedPreferences para preferencias locales
- Localizacion Flutter `en` / `es`
- Mapa de Mexico renderizado con `CustomPainter` a partir de paths SVG

## Requisitos

- Flutter estable instalado
- Android Studio/Xcode segun la plataforma que quieras correr
- Supabase CLI si vas a aplicar migraciones o seed
- Un proyecto Supabase con Anonymous Sign-ins habilitado

Revisa tu ambiente con:

```bash
flutter doctor
flutter pub get
```

## Configuracion

La app lee las credenciales de Supabase con `--dart-define`:

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://tu-proyecto.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=tu_anon_key
```

El codigo tiene valores por defecto para desarrollo local de este workspace, pero para otros ambientes conviene pasar siempre los `dart-define`.

## Ejecutar la app

Android/emulador:

```bash
flutter devices
flutter run -d emulator-5554
```

iOS/simulador:

```bash
flutter devices
flutter run -d <device-id>
```

Web, si necesitas una revision rapida:

```bash
flutter run -d chrome
```

## Base de datos

Los archivos de Supabase viven en:

```txt
supabase/
├── migrations/001_initial_schema.sql
└── seed.sql
```

El schema crea tablas para perfiles, regiones, estados, unidades, lecciones, ejercicios, progreso, intentos, errores, actividad diaria y logros. El seed carga contenido en espanol para Mexico.

Comandos utiles:

```bash
supabase login
supabase link --project-ref <project-ref>
supabase db push
supabase db query < supabase/seed.sql
```

Si cambias el contenido educativo, actualiza `supabase/seed.sql` y verifica que los conteos esperados sigan teniendo sentido.

## Estructura del proyecto

```txt
lib/
├── app/                  # Router, app root y rutas
├── core/                 # Config, tema, providers y utilidades
├── data/                 # Servicios compartidos como Supabase
├── features/
│   ├── achievements/
│   ├── auth/
│   ├── home/
│   ├── lessons/
│   ├── map_explorer/
│   ├── onboarding/
│   ├── practice/
│   ├── profile/
│   └── settings/
├── l10n/                 # ARB y localizaciones generadas
└── shared/               # Componentes reutilizables
```

Cada feature sigue el patron:

```txt
feature/
├── data/
├── presentation/
└── providers/ o repositories segun aplique
```

## Localizacion

El target principal es espanol. Las cadenas editables estan en:

```txt
lib/l10n/app_en.arb
lib/l10n/app_es.arb
```

Despues de cambiar un ARB, regenera:

```bash
flutter gen-l10n
dart format lib/l10n
```

Evita hardcodear texto visible en widgets nuevos; usa `AppLocalizations.of(context)!`.

## Mapa de Mexico

El mapa se renderiza con:

```txt
lib/features/map_explorer/data/models/mexico_state_paths.dart
lib/features/map_explorer/presentation/widgets/mexico_svg_map.dart
lib/features/map_explorer/presentation/widgets/mexico_map_view.dart
```

`MexicoSvgMap` normaliza bounds, dibuja cada estado, maneja taps y resalta respuestas correctas/incorrectas. Si cambias paths, valida visualmente en emulador porque un `flutter analyze` no detecta problemas de escala o geometria.

## Comandos de calidad

```bash
dart format lib test
flutter analyze
flutter test
```

Para una validacion visual rapida:

```bash
flutter run -d emulator-5554
```

Flujos que conviene revisar despues de tocar navegacion, practica o contenido:

- Onboarding hasta Home
- Home -> Lesson -> Lesson Result -> Home
- Practice capitals
- Practice map
- Map Explorer
- Profile -> Settings -> Back
- Reset local cache y reset guest session

## Documentacion adicional

El repo incluye notas de producto y arquitectura:

- `context.md`
- `architecture.md`
- `database.md`
- `design.md`

Usalas como referencia antes de cambios grandes de producto, datos o UX.
