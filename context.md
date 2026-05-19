# Mapingo - Project Context

## Product Name

Mapingo

## Slogan

"Learn the states of Mexico by playing."

## Product Vision

Mapingo is a gamified educational mobile application designed to help students learn the 32 states of Mexico, their capitals, geographic locations, regions, and basic cultural facts through short, interactive lessons.

The app should feel fun, friendly, motivating, and easy to use, inspired by successful learning apps such as Duolingo, but with its own original identity focused on Mexican geography.

## Target Users

The main users are students who need to learn Mexican geography in a simple, visual, and entertaining way.

Primary audience:

- Elementary school students
- Middle school students
- High school students
- Teachers who want to recommend a simple practice tool
- Parents who want their children to practice geography

## Main Learning Goals

Users should be able to:

- Identify the 32 states of Mexico.
- Match each state with its capital.
- Locate states on a map.
- Recognize states by their shape.
- Learn states grouped by region.
- Practice mistakes through repetition.
- Build a daily learning habit.

## MVP Goal

The MVP should validate whether users enjoy learning Mexican states through short gamified lessons.

The MVP should focus on functionality, retention, and learning value rather than advanced features.

## Core MVP Features

### 1. Onboarding

The app should introduce Mapingo in a friendly way.

The onboarding flow should include:

- Welcome screen.
- Short explanation of the app.
- Daily learning goal selection.
- Optional user name input.
- Start button.

Authentication is optional for the MVP. The app should allow guest mode.

### 2. Learning Path

The home screen should show a visual learning path with lessons grouped by units.

Suggested units:

- Unit 1: Northern Mexico
- Unit 2: Central Mexico
- Unit 3: Western Mexico
- Unit 4: Southern Mexico
- Unit 5: Southeast Mexico
- Unit 6: Full Mexico Review

Each unit should contain several lessons.

Lessons should be locked until previous ones are completed.

### 3. Lessons

Each lesson should contain between 8 and 12 exercises.

A lesson should take around 3 to 5 minutes.

Exercise types for the MVP:

- Multiple choice: identify the correct state.
- Multiple choice: identify the correct capital.
- Match state with capital.
- Tap the correct state on the map.
- Identify the state by its silhouette.
- True or false.

### 4. Map Game

The app should include an interactive map of Mexico.

Users should be asked to tap the correct state.

The map should provide visual feedback:

- Correct answer: green highlight.
- Wrong answer: red highlight.
- Correct state reveal after a wrong answer.

### 5. Progress System

The app should track:

- Completed lessons.
- XP earned.
- Daily streak.
- Correct answers.
- Mistakes.
- Progress by region.
- Progress by state.

### 6. Mistake Review

When users answer incorrectly, the app should save the mistake.

The user should later be able to practice mistakes in a review mode.

### 7. Gamification

The MVP should include:

- XP points.
- Daily streak.
- Lesson completion screen.
- Encouraging feedback.
- Simple badges or achievements.
- Progress bar per lesson.
- Hearts or energy system, optional for MVP.

### 8. Profile Screen

The profile screen should show:

- User name.
- Total XP.
- Current streak.
- Completed lessons.
- Accuracy percentage.
- Achievements.

### 9. Data Content

The app should include a local or Supabase-based database with all 32 Mexican states.

Each state should include:

- State name.
- Capital.
- Region.
- Abbreviation.
- Short description.
- Fun fact.
- SVG path or map identifier.
- Optional silhouette image.
- Optional color metadata.

Example:

```json
{
  "name": "Jalisco",
  "capital": "Guadalajara",
  "region": "Western Mexico",
  "abbreviation": "JAL",
  "description": "Jalisco is a western Mexican state known for mariachi, tequila, and rich cultural traditions.",
  "funFact": "Jalisco is considered the birthplace of mariachi music.",
  "mapKey": "jalisco"
}
````

## Backend

The backend will use Supabase.

Supabase should manage:

* Users
* Profiles
* States
* Regions
* Lessons
* Exercises
* User progress
* Mistakes
* Achievements
* Daily streaks

## Tech Stack

### Mobile App

* Flutter
* Dart
* Riverpod or Bloc for state management
* GoRouter for navigation
* Supabase Flutter SDK
* SVG support for maps and state shapes

### Backend

* Supabase
* PostgreSQL
* Row Level Security
* Supabase Auth
* Supabase Storage if image assets are needed
* Edge Functions only if necessary

## MVP Constraints

The MVP should avoid unnecessary complexity.

Do not include in the first version:

* Multiplayer
* Global ranking
* Teacher dashboard
* AI-generated lessons
* Voice recognition
* Paid subscriptions
* Social features
* Complex avatars
* Store system

## Success Criteria

The MVP should be considered successful if:

* Users complete their first lesson.
* Users understand how to use the app without explanation.
* Users return the next day.
* Users improve their correct answer rate.
* Users can identify more states after using the app.
* Teachers or parents consider it useful.

## Product Personality

Mapingo should feel:

* Friendly
* Motivating
* Playful
* Educational
* Colorful
* Simple
* Fast
* Safe for students

## Main User Experience Principle

Every learning session should feel short, rewarding, and easy to continue.

