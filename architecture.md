# Mapingo - Architecture Guide

## Overview

Mapingo is a Flutter-based mobile application powered by Supabase.

The architecture should prioritize:

- Scalability
- Clean separation of concerns
- Fast MVP development
- Maintainability
- Offline-friendly patterns when possible
- Easy integration with Supabase

The project should follow a feature-first modular architecture.

---

# Tech Stack

## Mobile App

### Framework

- Flutter

### Language

- Dart

### State Management

Preferred:

- Riverpod

Alternative:

- Bloc

Riverpod is recommended for the MVP because it is simpler, scalable, testable, and modern.

### Navigation

- GoRouter

### Backend SDK

- Supabase Flutter SDK

### Local Storage

- SharedPreferences
- Hive (optional later)
- Secure storage for auth tokens

### Map Rendering

- flutter_svg
- CustomPainter if necessary

### Animations

- Flutter built-in animations
- Lottie (optional)

---

# Backend Architecture

## Backend Provider

- Supabase

## Services Used

### Supabase Auth

Used for:

- Anonymous authentication
- Optional email authentication
- User accounts

### PostgreSQL Database

Used for:

- User data
- Lessons
- Exercises
- Progress
- Mistakes
- Achievements
- Streaks

### Row Level Security (RLS)

Must be enabled for all user-sensitive tables.

### Supabase Storage

Optional for:

- Mascot assets
- Dynamic images
- Future downloadable content

### Edge Functions

Avoid unless truly necessary for the MVP.

---

# Application Architecture

The app should follow:

```txt
Presentation Layer
Business Logic Layer
Data Layer
Backend Layer
````

---

# Folder Structure

Recommended Flutter structure:

```txt
lib/
│
├── app/
│   ├── app.dart
│   ├── router.dart
│   ├── theme/
│   └── constants/
│
├── core/
│   ├── errors/
│   ├── services/
│   ├── utils/
│   ├── extensions/
│   ├── widgets/
│   └── models/
│
├── features/
│   ├── onboarding/
│   ├── auth/
│   ├── home/
│   ├── lessons/
│   ├── exercises/
│   ├── map_game/
│   ├── practice/
│   ├── profile/
│   ├── achievements/
│   └── progress/
│
├── data/
│   ├── repositories/
│   ├── datasources/
│   └── models/
│
├── shared/
│   ├── widgets/
│   ├── components/
│   └── animations/
│
└── main.dart
```

---

# Feature Module Structure

Each feature should contain:

```txt
feature/
│
├── presentation/
│   ├── screens/
│   ├── widgets/
│   └── providers/
│
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
│
├── data/
│   ├── models/
│   ├── repositories/
│   └── datasources/
│
└── feature.dart
```

This separation helps scale the project later.

---

# State Management Strategy

## Riverpod

Use Riverpod providers for:

* Authentication state
* Lesson progress
* User profile
* Current exercise
* XP updates
* Streak tracking
* Achievement unlocking

Recommended provider types:

### FutureProvider

For async fetches:

* Lessons
* States
* User profile

### StateNotifierProvider

For mutable business state:

* Current lesson
* XP system
* Practice session

### StreamProvider

Optional for real-time features later.

---

# Navigation Structure

Use GoRouter.

## Main Routes

```txt
/
├── splash
├── onboarding
├── auth
├── home
├── lesson/:id
├── map-game
├── practice
├── profile
├── achievements
└── settings
```

---

# Authentication Strategy

## MVP Authentication

Recommended:

### Anonymous Authentication

Advantages:

* Faster onboarding
* No friction
* Students can start instantly

Optional later:

* Email/password
* Google login
* Apple login

## User Flow

```txt
Open app
→ anonymous sign in
→ create profile
→ start learning
```

---

# Database Architecture

# Main Tables

---

## profiles

Stores user information.

```sql
profiles
```

Columns:

```txt
id UUID PK
username TEXT
avatar_url TEXT
xp INTEGER
streak INTEGER
created_at TIMESTAMP
updated_at TIMESTAMP
```

---

## states

Stores Mexican states.

```sql
states
```

Columns:

```txt
id UUID PK
name TEXT
capital TEXT
region TEXT
abbreviation TEXT
description TEXT
fun_fact TEXT
map_key TEXT
created_at TIMESTAMP
```

---

## units

Learning units.

```sql
units
```

Columns:

```txt
id UUID PK
title TEXT
description TEXT
order_index INTEGER
created_at TIMESTAMP
```

Example:

* Northern Mexico
* Central Mexico
* Southern Mexico

---

## lessons

Lessons inside units.

```sql
lessons
```

Columns:

```txt
id UUID PK
unit_id UUID FK
title TEXT
description TEXT
order_index INTEGER
xp_reward INTEGER
created_at TIMESTAMP
```

---

## exercises

Questions inside lessons.

```sql
exercises
```

Columns:

```txt
id UUID PK
lesson_id UUID FK
type TEXT
question TEXT
correct_answer TEXT
options JSONB
metadata JSONB
created_at TIMESTAMP
```

## Exercise Types

Possible values:

```txt
multiple_choice
map_tap
match_pairs
silhouette
true_false
```

---

## user_progress

Tracks lesson completion.

```sql
user_progress
```

Columns:

```txt
id UUID PK
user_id UUID FK
lesson_id UUID FK
completed BOOLEAN
score INTEGER
accuracy DECIMAL
completed_at TIMESTAMP
```

---

## user_mistakes

Tracks wrong answers.

```sql
user_mistakes
```

Columns:

```txt
id UUID PK
user_id UUID FK
exercise_id UUID FK
mistake_count INTEGER
last_attempt TIMESTAMP
```

---

## achievements

Achievement definitions.

```sql
achievements
```

Columns:

```txt
id UUID PK
title TEXT
description TEXT
icon TEXT
xp_reward INTEGER
```

---

## user_achievements

Unlocked achievements.

```sql
user_achievements
```

Columns:

```txt
id UUID PK
user_id UUID FK
achievement_id UUID FK
unlocked_at TIMESTAMP
```

---

# RLS Policies

Enable RLS on all user-sensitive tables.

Users should only access:

* Their own profile
* Their own progress
* Their own mistakes
* Their own achievements

Public readable tables:

* states
* units
* lessons
* exercises
* achievements

---

# Data Fetching Strategy

## Public Data

Cache aggressively:

* States
* Lessons
* Units
* Achievements

These rarely change.

## User Data

Fetch on startup:

* Profile
* Progress
* Streak
* XP

---

# Offline Strategy

The MVP should support limited offline functionality.

Recommended:

* Cache lessons locally
* Cache states locally
* Sync progress when online

Offline-first is not required for MVP but architecture should allow it later.

---

# Lesson Engine Architecture

The lesson system should be modular.

## Base Exercise Model

All exercise types should inherit from a common structure.

Example:

```txt
Exercise
├── MultipleChoiceExercise
├── MapTapExercise
├── MatchPairsExercise
├── SilhouetteExercise
└── TrueFalseExercise
```

This allows scalable future exercise types.

---

# Exercise Rendering System

Each exercise type should have:

* Dedicated widget
* Dedicated validation logic
* Shared lesson controller

Example:

```txt
ExerciseRenderer
├── MultipleChoiceWidget
├── MapTapWidget
├── MatchPairsWidget
└── SilhouetteWidget
```

---

# XP System

XP should be calculated client-side for MVP.

Example:

```txt
Correct answer: +2 XP
Lesson completion: +10 XP
Perfect lesson bonus: +5 XP
Daily streak bonus: +5 XP
```

Later this can move server-side.

---

# Streak System

Simple streak logic:

```txt
If user practices today:
    continue streak

If user misses one day:
    reset streak
```

Store:

```txt
last_activity_date
current_streak
```

---

# Error Review System

Mistakes should feed future practice.

When user answers incorrectly:

1. Save mistake.
2. Increase mistake count.
3. Add to practice queue.

Practice mode should prioritize:

* Frequently missed questions
* Recently missed questions

---

# Map System

The Mexico map should use SVG.

Recommended:

* One SVG per state
* Interactive regions
* Tap detection

Possible structure:

```txt
assets/maps/
├── mexico_map.svg
├── states/
│   ├── jalisco.svg
│   ├── sonora.svg
│   └── ...
```

---

# Theming System

Use centralized theming.

```txt
app/theme/
├── colors.dart
├── typography.dart
├── spacing.dart
├── app_theme.dart
```

Do not hardcode colors across widgets.

---

# Error Handling

Use centralized error handling.

Common error types:

* Network errors
* Auth errors
* Database errors
* Validation errors

Show user-friendly messages.

Avoid technical errors in UI.

---

# Logging

Use structured logging.

Recommended:

* logger package

Track:

* Lesson completion
* Failed exercises
* App crashes
* Navigation errors

---

# Analytics

Optional for MVP.

Recommended later:

* Firebase Analytics
* PostHog
* Supabase analytics events

Track:

* Retention
* Lesson completion
* Most failed states
* Daily active users

---

# Testing Strategy

## Unit Tests

Test:

* XP logic
* Streak logic
* Lesson validation

## Widget Tests

Test:

* Exercise widgets
* Navigation
* Progress bar

## Integration Tests

Test:

* Lesson flow
* Auth flow
* Progress sync

---

# Performance Guidelines

The app should feel fast.

Recommendations:

* Lazy load lessons
* Cache SVGs
* Avoid rebuilding entire screens
* Minimize unnecessary providers
* Use const widgets whenever possible

---

# Security Guidelines

Never trust the client for sensitive operations later.

For MVP:

* Client-side validation is acceptable.
* RLS must still be enabled.
* Do not expose service role keys.
* Store Supabase keys securely.

---

# Scalability Considerations

The architecture should allow future additions:

* Countries mode
* Flags mode
* Teacher dashboard
* Multiplayer
* Seasonal events
* Classroom mode
* AI-generated practice
* Leaderboards
* Localization

The MVP should remain simple, but the architecture should not block future growth.

---

# Development Philosophy

The MVP should prioritize:

1. Functional learning experience
2. Smooth UX
3. Fast iteration
4. Easy maintainability
5. Simple architecture
6. Gamified engagement

Avoid premature optimization or overengineering.

Ship fast.
Validate quickly.
Improve continuously.
