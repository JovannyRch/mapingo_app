
# Mapingo - Database Design

## Overview

This document defines the database structure for Mapingo.

Mapingo uses Supabase with PostgreSQL as the main backend database.

The database should support:

- Anonymous and registered users
- User profiles
- Mexican states
- Geographic regions
- Learning units
- Lessons
- Exercises
- User progress
- Mistake review
- XP
- Streaks
- Achievements

The MVP database should be simple, scalable, and easy to extend.

---

# Database Principles

## 1. Keep Public Learning Data Separate

Learning content such as states, regions, lessons, and exercises should be public readable.

Examples:

- States
- Regions
- Units
- Lessons
- Exercises
- Achievements

## 2. Keep User Data Protected

User-specific data must only be accessible by the authenticated user.

Examples:

- Profile
- Progress
- Mistakes
- Streaks
- User achievements

## 3. Use Row Level Security

All tables should have Row Level Security enabled.

Public learning data can allow read access to all authenticated or anonymous users.

User data must be restricted by `auth.uid()`.

## 4. Use UUIDs

All main tables should use UUID primary keys.

## 5. Use Timestamps

All tables should include:

- `created_at`
- `updated_at` when needed

---

# Entity Relationship Summary

```txt
auth.users
  └── profiles

regions
  └── states
  └── units

units
  └── lessons

lessons
  └── exercises

auth.users
  └── user_lesson_progress
  └── user_exercise_attempts
  └── user_mistakes
  └── user_achievements
  └── user_daily_activity

achievements
  └── user_achievements
````

---

# Tables

---

## 1. profiles

Stores user profile data.

```sql
create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  username text,
  avatar_url text,
  total_xp integer not null default 0,
  current_streak integer not null default 0,
  longest_streak integer not null default 0,
  last_activity_date date,
  onboarding_completed boolean not null default false,
  daily_goal_minutes integer not null default 5,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
```

### Notes

* `id` must match `auth.users.id`.
* Anonymous users can also have profiles.
* `daily_goal_minutes` stores the selected learning goal.
* `last_activity_date` helps calculate streaks.

---

## 2. regions

Stores Mexican geographic regions.

```sql
create table public.regions (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  description text,
  order_index integer not null default 0,
  created_at timestamptz not null default now()
);
```

### Example Regions

```txt
Northern Mexico
Western Mexico
Central Mexico
Southern Mexico
Southeast Mexico
Full Mexico Review
```

---

## 3. states

Stores the 32 Mexican states.

```sql
create table public.states (
  id uuid primary key default gen_random_uuid(),
  region_id uuid references public.regions(id) on delete set null,
  name text not null unique,
  capital text not null,
  abbreviation text not null unique,
  description text,
  fun_fact text,
  map_key text not null unique,
  silhouette_asset text,
  color_hex text,
  order_index integer not null default 0,
  created_at timestamptz not null default now()
);
```

### Notes

* `map_key` must match the SVG or map identifier used in Flutter.
* `silhouette_asset` can reference a local asset path or Supabase Storage path.
* `color_hex` can be used for map visualization.

---

## 4. units

Stores learning units.

```sql
create table public.units (
  id uuid primary key default gen_random_uuid(),
  region_id uuid references public.regions(id) on delete set null,
  title text not null,
  description text,
  order_index integer not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);
```

### Example Units

```txt
Unit 1: Northern Mexico
Unit 2: Western Mexico
Unit 3: Central Mexico
Unit 4: Southern Mexico
Unit 5: Southeast Mexico
Unit 6: Full Mexico Review
```

---

## 5. lessons

Stores lessons inside units.

```sql
create table public.lessons (
  id uuid primary key default gen_random_uuid(),
  unit_id uuid not null references public.units(id) on delete cascade,
  title text not null,
  description text,
  lesson_type text not null default 'standard',
  order_index integer not null default 0,
  xp_reward integer not null default 10,
  required_lesson_id uuid references public.lessons(id) on delete set null,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);
```

### Lesson Types

```txt
standard
review
challenge
map_practice
capital_practice
```

---

## 6. exercises

Stores questions used inside lessons.

```sql
create table public.exercises (
  id uuid primary key default gen_random_uuid(),
  lesson_id uuid not null references public.lessons(id) on delete cascade,
  exercise_type text not null,
  question text not null,
  correct_answer text not null,
  options jsonb,
  metadata jsonb,
  explanation text,
  difficulty integer not null default 1,
  order_index integer not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);
```

### Exercise Types

```txt
multiple_choice_state
multiple_choice_capital
map_tap
match_pairs
silhouette
true_false
```

### Options Example

```json
[
  "Jalisco",
  "Colima",
  "Nayarit",
  "Michoacán"
]
```

### Metadata Example For Map Tap

```json
{
  "targetStateKey": "jalisco"
}
```

### Metadata Example For Match Pairs

```json
{
  "pairs": [
    {
      "left": "Jalisco",
      "right": "Guadalajara"
    },
    {
      "left": "Nuevo León",
      "right": "Monterrey"
    }
  ]
}
```

---

# User Progress Tables

---

## 7. user_lesson_progress

Tracks lesson progress per user.

```sql
create table public.user_lesson_progress (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  lesson_id uuid not null references public.lessons(id) on delete cascade,
  completed boolean not null default false,
  score integer not null default 0,
  accuracy numeric(5,2) not null default 0,
  correct_answers integer not null default 0,
  wrong_answers integer not null default 0,
  xp_earned integer not null default 0,
  completed_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(user_id, lesson_id)
);
```

---

## 8. user_exercise_attempts

Stores every exercise attempt.

```sql
create table public.user_exercise_attempts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  exercise_id uuid not null references public.exercises(id) on delete cascade,
  selected_answer text,
  is_correct boolean not null,
  time_spent_seconds integer,
  created_at timestamptz not null default now()
);
```

### Notes

This table is useful for:

* Analytics
* Accuracy
* Adaptive practice
* Detecting difficult questions

---

## 9. user_mistakes

Stores summarized mistakes for review mode.

```sql
create table public.user_mistakes (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  exercise_id uuid not null references public.exercises(id) on delete cascade,
  mistake_count integer not null default 1,
  last_wrong_at timestamptz not null default now(),
  last_reviewed_at timestamptz,
  resolved boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(user_id, exercise_id)
);
```

### Mistake Review Logic

When a user answers incorrectly:

* If the mistake does not exist, create it.
* If it exists, increment `mistake_count`.
* Mark `resolved = false`.

When a user answers correctly during review:

* Update `last_reviewed_at`.
* Optionally mark `resolved = true`.

---

## 10. user_daily_activity

Tracks daily usage and streaks.

```sql
create table public.user_daily_activity (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  activity_date date not null,
  xp_earned integer not null default 0,
  lessons_completed integer not null default 0,
  exercises_completed integer not null default 0,
  minutes_practiced integer not null default 0,
  created_at timestamptz not null default now(),
  unique(user_id, activity_date)
);
```

### Notes

This table helps calculate:

* Daily streak
* XP per day
* Engagement
* Daily goal completion

---

# Achievement Tables

---

## 11. achievements

Stores achievement definitions.

```sql
create table public.achievements (
  id uuid primary key default gen_random_uuid(),
  code text not null unique,
  title text not null,
  description text not null,
  icon text,
  xp_reward integer not null default 0,
  condition_type text not null,
  condition_value integer not null default 1,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);
```

### Example Achievement Codes

```txt
first_lesson_completed
five_day_streak
ten_capitals_mastered
northern_mexico_completed
perfect_lesson
```

---

## 12. user_achievements

Stores unlocked achievements per user.

```sql
create table public.user_achievements (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  achievement_id uuid not null references public.achievements(id) on delete cascade,
  unlocked_at timestamptz not null default now(),
  unique(user_id, achievement_id)
);
```

---

# Optional Tables For Later

These are not required for the MVP.

---

## leaderboards

Not recommended for MVP.

```sql
create table public.leaderboards (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  period text not null,
  xp integer not null default 0,
  rank integer,
  created_at timestamptz not null default now()
);
```

---

## classrooms

Not recommended for MVP.

```sql
create table public.classrooms (
  id uuid primary key default gen_random_uuid(),
  teacher_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  code text not null unique,
  created_at timestamptz not null default now()
);
```

---

## classroom_students

Not recommended for MVP.

```sql
create table public.classroom_students (
  id uuid primary key default gen_random_uuid(),
  classroom_id uuid not null references public.classrooms(id) on delete cascade,
  student_id uuid not null references auth.users(id) on delete cascade,
  joined_at timestamptz not null default now(),
  unique(classroom_id, student_id)
);
```

---

# Indexes

Recommended indexes:

```sql
create index idx_states_region_id on public.states(region_id);
create index idx_units_region_id on public.units(region_id);
create index idx_lessons_unit_id on public.lessons(unit_id);
create index idx_exercises_lesson_id on public.exercises(lesson_id);

create index idx_user_lesson_progress_user_id on public.user_lesson_progress(user_id);
create index idx_user_lesson_progress_lesson_id on public.user_lesson_progress(lesson_id);

create index idx_user_exercise_attempts_user_id on public.user_exercise_attempts(user_id);
create index idx_user_exercise_attempts_exercise_id on public.user_exercise_attempts(exercise_id);

create index idx_user_mistakes_user_id on public.user_mistakes(user_id);
create index idx_user_mistakes_exercise_id on public.user_mistakes(exercise_id);

create index idx_user_daily_activity_user_id on public.user_daily_activity(user_id);
create index idx_user_daily_activity_date on public.user_daily_activity(activity_date);

create index idx_user_achievements_user_id on public.user_achievements(user_id);
```

---

# Updated At Trigger

Use a reusable trigger to update `updated_at`.

```sql
create or replace function public.set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;
```

Apply it to tables with `updated_at`:

```sql
create trigger set_profiles_updated_at
before update on public.profiles
for each row
execute function public.set_updated_at();

create trigger set_user_lesson_progress_updated_at
before update on public.user_lesson_progress
for each row
execute function public.set_updated_at();

create trigger set_user_mistakes_updated_at
before update on public.user_mistakes
for each row
execute function public.set_updated_at();
```

---

# Profile Creation Trigger

Automatically create a profile when a new user is created.

```sql
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, username)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'username', 'Explorer')
  );

  return new;
end;
$$ language plpgsql security definer;
```

```sql
create trigger on_auth_user_created
after insert on auth.users
for each row
execute function public.handle_new_user();
```

---

# Row Level Security

Enable RLS:

```sql
alter table public.profiles enable row level security;
alter table public.regions enable row level security;
alter table public.states enable row level security;
alter table public.units enable row level security;
alter table public.lessons enable row level security;
alter table public.exercises enable row level security;
alter table public.user_lesson_progress enable row level security;
alter table public.user_exercise_attempts enable row level security;
alter table public.user_mistakes enable row level security;
alter table public.user_daily_activity enable row level security;
alter table public.achievements enable row level security;
alter table public.user_achievements enable row level security;
```

---

# RLS Policy Recommendations

## Public Read Tables

These tables should be readable by all users:

* regions
* states
* units
* lessons
* exercises
* achievements

Example:

```sql
create policy "Allow public read access"
on public.states
for select
using (true);
```

Apply similar policies to:

```txt
regions
states
units
lessons
exercises
achievements
```

---

## Profiles

```sql
create policy "Users can read their own profile"
on public.profiles
for select
using (auth.uid() = id);

create policy "Users can update their own profile"
on public.profiles
for update
using (auth.uid() = id);

create policy "Users can insert their own profile"
on public.profiles
for insert
with check (auth.uid() = id);
```

---

## User Lesson Progress

```sql
create policy "Users can read their own lesson progress"
on public.user_lesson_progress
for select
using (auth.uid() = user_id);

create policy "Users can insert their own lesson progress"
on public.user_lesson_progress
for insert
with check (auth.uid() = user_id);

create policy "Users can update their own lesson progress"
on public.user_lesson_progress
for update
using (auth.uid() = user_id);
```

---

## User Exercise Attempts

```sql
create policy "Users can read their own exercise attempts"
on public.user_exercise_attempts
for select
using (auth.uid() = user_id);

create policy "Users can insert their own exercise attempts"
on public.user_exercise_attempts
for insert
with check (auth.uid() = user_id);
```

---

## User Mistakes

```sql
create policy "Users can read their own mistakes"
on public.user_mistakes
for select
using (auth.uid() = user_id);

create policy "Users can insert their own mistakes"
on public.user_mistakes
for insert
with check (auth.uid() = user_id);

create policy "Users can update their own mistakes"
on public.user_mistakes
for update
using (auth.uid() = user_id);
```

---

## User Daily Activity

```sql
create policy "Users can read their own daily activity"
on public.user_daily_activity
for select
using (auth.uid() = user_id);

create policy "Users can insert their own daily activity"
on public.user_daily_activity
for insert
with check (auth.uid() = user_id);

create policy "Users can update their own daily activity"
on public.user_daily_activity
for update
using (auth.uid() = user_id);
```

---

## User Achievements

```sql
create policy "Users can read their own achievements"
on public.user_achievements
for select
using (auth.uid() = user_id);

create policy "Users can insert their own achievements"
on public.user_achievements
for insert
with check (auth.uid() = user_id);
```

---

# Seed Data Strategy

The MVP should seed:

* Regions
* 32 Mexican states
* Units
* Lessons
* Exercises
* Achievements

Seed data should be stored in SQL migration files.

Recommended folder:

```txt
supabase/
  migrations/
  seed/
```

---

# Initial Seed Requirements

## Regions

Seed at least:

```txt
Northern Mexico
Western Mexico
Central Mexico
Southern Mexico
Southeast Mexico
Full Mexico Review
```

## States

Seed all 32 states with:

* Name
* Capital
* Region
* Abbreviation
* Description
* Fun fact
* Map key

## Lessons

For MVP, create:

* 1 introductory lesson per region
* 1 capital lesson per region
* 1 map practice lesson per region
* 1 review lesson

## Exercises

For MVP, each lesson should contain 8 to 12 exercises.

---

# MVP Database Scope

The MVP must include:

```txt
profiles
regions
states
units
lessons
exercises
user_lesson_progress
user_exercise_attempts
user_mistakes
user_daily_activity
achievements
user_achievements
```

The MVP should not include:

```txt
leaderboards
classrooms
classroom_students
payments
subscriptions
social_posts
chat
```

---

# Supabase MCP Instructions

When using Supabase MCP, the agent should:

1. Create all required tables.
2. Add indexes.
3. Enable RLS.
4. Create RLS policies.
5. Create triggers.
6. Seed initial content.
7. Validate schema with test queries.
8. Avoid destructive changes unless explicitly requested.

---

# Data Validation Rules

## Profiles

* `daily_goal_minutes` should be greater than 0.
* `total_xp` should never be negative.
* `current_streak` should never be negative.

## Lessons

* `order_index` must be unique within the same unit when possible.
* `xp_reward` should be greater than 0.

## Exercises

* `exercise_type` should be one of the allowed types.
* `options` must be valid JSON when used.
* `correct_answer` must not be empty.

## User Progress

* `accuracy` should be between 0 and 100.
* `correct_answers` and `wrong_answers` should not be negative.
* `xp_earned` should not be negative.

---

# Recommended Constraints

```sql
alter table public.profiles
add constraint profiles_total_xp_check check (total_xp >= 0),
add constraint profiles_current_streak_check check (current_streak >= 0),
add constraint profiles_longest_streak_check check (longest_streak >= 0),
add constraint profiles_daily_goal_minutes_check check (daily_goal_minutes > 0);

alter table public.lessons
add constraint lessons_xp_reward_check check (xp_reward > 0);

alter table public.exercises
add constraint exercises_difficulty_check check (difficulty between 1 and 5);

alter table public.user_lesson_progress
add constraint user_lesson_progress_accuracy_check check (accuracy >= 0 and accuracy <= 100),
add constraint user_lesson_progress_score_check check (score >= 0),
add constraint user_lesson_progress_xp_earned_check check (xp_earned >= 0);
```

---

# Future Expansion

The database should allow future features such as:

* Other countries
* World capitals
* Flags
* Teacher mode
* Classrooms
* School groups
* Subscription plans
* Leaderboards
* Seasonal challenges
* Personalized learning paths

Do not implement these in the MVP unless explicitly requested.
