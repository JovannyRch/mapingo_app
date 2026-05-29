-- ============================================================
-- Mapingo Spanish seed content (es-MX)
-- Intended for fresh/local Supabase databases.
--
-- This resets public learning content and the user progress tables
-- that depend on it. Do not run directly in production with real users.
-- ============================================================

begin;

delete from public.user_achievements;
delete from public.user_mistakes;
delete from public.user_exercise_attempts;
delete from public.user_lesson_progress;
delete from public.exercises;
delete from public.lessons;
delete from public.units;
delete from public.states;
delete from public.achievements;
delete from public.regions;

create temp table seed_regions (
  name text primary key,
  description text not null,
  order_index integer not null
) on commit drop;

insert into seed_regions (name, description, order_index) values
  ('Norte de México', 'Estados del norte con desiertos, sierras, frontera y ciudades industriales.', 1),
  ('Occidente de México', 'Región del Pacífico y el Bajío con gran fuerza cultural, agrícola y turística.', 2),
  ('Centro de México', 'Corazón histórico y político del país, con valles, volcanes y grandes ciudades.', 3),
  ('Sur de México', 'Región de montañas, costas del Pacífico y enorme diversidad cultural.', 4),
  ('Sureste de México', 'Zona maya, selvas, península de Yucatán y costas del Caribe y el Golfo.', 5);

insert into public.regions (name, description, order_index)
select name, description, order_index
from seed_regions
order by order_index;

create temp table seed_states (
  region_name text not null references seed_regions(name),
  name text primary key,
  capital text not null,
  abbreviation text not null,
  description text not null,
  fun_fact text not null,
  map_key text not null,
  color_hex text not null,
  order_index integer not null
) on commit drop;

insert into seed_states
  (region_name, name, capital, abbreviation, description, fun_fact, map_key, color_hex, order_index)
values
  ('Norte de México', 'Baja California', 'Mexicali', 'BC', 'Estado fronterizo del noroeste, famoso por sus valles, playas y la península bajacaliforniana.', 'En Ensenada se encuentra La Bufadora, un géiser marino muy visitado.', 'baja_california', '#3B82F6', 1),
  ('Norte de México', 'Baja California Sur', 'La Paz', 'BS', 'Estado peninsular con desiertos, oasis y costas sobre el Pacífico y el Golfo de California.', 'El Arco de Cabo San Lucas es uno de los paisajes más reconocibles de México.', 'baja_california_sur', '#60A5FA', 2),
  ('Norte de México', 'Sonora', 'Hermosillo', 'SO', 'Estado grande del noroeste, conocido por el desierto, la ganadería y su frontera con Estados Unidos.', 'El desierto de Sonora es uno de los ecosistemas áridos con mayor biodiversidad del mundo.', 'sonora', '#F59E0B', 3),
  ('Norte de México', 'Chihuahua', 'Chihuahua', 'CH', 'El estado más extenso del país, con sierras, desiertos y una historia minera importante.', 'Las Barrancas del Cobre son un sistema de cañones más amplio que el Gran Cañón.', 'chihuahua', '#D97706', 4),
  ('Norte de México', 'Coahuila', 'Saltillo', 'CO', 'Estado del noreste con zonas desérticas, industria, viñedos y riqueza paleontológica.', 'En Coahuila se han encontrado fósiles de dinosaurios muy importantes para la ciencia.', 'coahuila', '#B45309', 5),
  ('Norte de México', 'Nuevo León', 'Monterrey', 'NL', 'Estado industrial y urbano del noreste, rodeado por montañas icónicas.', 'El Cerro de la Silla es un símbolo de Monterrey y de Nuevo León.', 'nuevo_leon', '#2563EB', 6),
  ('Norte de México', 'Tamaulipas', 'Ciudad Victoria', 'TM', 'Estado del noreste con frontera, costa del Golfo de México y actividad portuaria.', 'Tampico y Altamira forman una de las zonas portuarias más relevantes del Golfo.', 'tamaulipas', '#0891B2', 7),
  ('Norte de México', 'Durango', 'Victoria de Durango', 'DG', 'Estado del norte con sierras, bosques y paisajes usados en muchas películas del oeste.', 'Durango es conocido como la tierra del cine por sus locaciones naturales.', 'durango', '#92400E', 8),
  ('Norte de México', 'Sinaloa', 'Culiacán', 'SI', 'Estado del noroeste con agricultura, costa del Pacífico y una fuerte tradición musical.', 'Mazatlán es uno de los puertos turísticos más antiguos del Pacífico mexicano.', 'sinaloa', '#10B981', 9),
  ('Occidente de México', 'Nayarit', 'Tepic', 'NA', 'Estado del Pacífico con playas, sierras y comunidades indígenas wixárikas.', 'Las Islas Marietas son un área natural protegida frente a la costa nayarita.', 'nayarit', '#14B8A6', 10),
  ('Occidente de México', 'Jalisco', 'Guadalajara', 'JA', 'Estado occidental reconocido por el mariachi, el tequila y una gran actividad económica.', 'El tequila tiene denominación de origen y su paisaje agavero es Patrimonio Mundial.', 'jalisco', '#22C55E', 11),
  ('Occidente de México', 'Colima', 'Colima', 'CL', 'Pequeño estado del occidente con costa, volcanes y producción agrícola.', 'El Volcán de Fuego de Colima es uno de los volcanes más activos de México.', 'colima', '#84CC16', 12),
  ('Occidente de México', 'Michoacán', 'Morelia', 'MI', 'Estado del occidente con ciudades coloniales, lagos, bosques y tradiciones purépechas.', 'La mariposa monarca llega cada invierno a los bosques de Michoacán.', 'michoacan', '#16A34A', 13),
  ('Occidente de México', 'Aguascalientes', 'Aguascalientes', 'AG', 'Estado del Bajío conocido por su feria nacional, industria y ubicación estratégica.', 'La Feria Nacional de San Marcos es una de las ferias más famosas del país.', 'aguascalientes', '#A3E635', 14),
  ('Occidente de México', 'Zacatecas', 'Zacatecas', 'ZA', 'Estado del centro-norte con pasado minero, arquitectura colonial y paisajes semidesérticos.', 'El centro histórico de Zacatecas es Patrimonio Mundial por su arquitectura minera.', 'zacatecas', '#CA8A04', 15),
  ('Centro de México', 'Guanajuato', 'Guanajuato', 'GJ', 'Estado del Bajío con ciudades coloniales, actividad industrial y fuerte vida cultural.', 'El Festival Internacional Cervantino se celebra cada año en Guanajuato.', 'guanajuato', '#F97316', 16),
  ('Centro de México', 'Querétaro', 'Santiago de Querétaro', 'QT', 'Estado del centro con crecimiento industrial, viñedos y un centro histórico colonial.', 'El acueducto de Querétaro tiene 74 arcos y es un símbolo de la ciudad.', 'queretaro', '#FB923C', 17),
  ('Centro de México', 'San Luis Potosí', 'San Luis Potosí', 'SL', 'Estado de transición entre norte, centro y Huasteca, con gran variedad de paisajes.', 'La Huasteca Potosina es famosa por sus cascadas, ríos y parajes naturales.', 'san_luis_potosi', '#65A30D', 18),
  ('Centro de México', 'Hidalgo', 'Pachuca', 'HG', 'Estado del centro con zonas mineras, pueblos mágicos y tradición gastronómica.', 'Pachuca es conocida como la Bella Airosa por sus fuertes vientos.', 'hidalgo', '#0EA5E9', 19),
  ('Centro de México', 'Estado de México', 'Toluca', 'MX', 'Estado que rodea gran parte de la Ciudad de México y combina zonas urbanas, volcanes y pueblos históricos.', 'El Nevado de Toluca es uno de los volcanes más visitados del centro del país.', 'estado_de_mexico', '#6366F1', 20),
  ('Centro de México', 'Ciudad de México', 'Ciudad de México', 'DF', 'Capital del país y entidad federativa con enorme importancia política, cultural y económica.', 'La Ciudad de México fue construida sobre la antigua México-Tenochtitlan.', 'ciudad_de_mexico', '#8B5CF6', 21),
  ('Centro de México', 'Morelos', 'Cuernavaca', 'MO', 'Estado pequeño del centro, conocido por su clima cálido, jardines y sitios históricos.', 'Cuernavaca es llamada la ciudad de la eterna primavera.', 'morelos', '#EC4899', 22),
  ('Centro de México', 'Tlaxcala', 'Tlaxcala', 'TL', 'El estado más pequeño de México, con historia prehispánica, haciendas y tradiciones textiles.', 'Tlaxcala conserva zonas arqueológicas como Cacaxtla y Xochitécatl.', 'tlaxcala', '#A855F7', 23),
  ('Centro de México', 'Puebla', 'Puebla', 'PU', 'Estado del centro-oriente famoso por su gastronomía, volcanes y arquitectura colonial.', 'El mole poblano es uno de los platillos más representativos de México.', 'puebla', '#EF4444', 24),
  ('Sur de México', 'Guerrero', 'Chilpancingo', 'GR', 'Estado del sur con costa del Pacífico, montañas y destinos turísticos históricos.', 'Acapulco fue uno de los primeros grandes destinos de playa de México.', 'guerrero', '#F43F5E', 25),
  ('Sur de México', 'Oaxaca', 'Oaxaca de Juárez', 'OA', 'Estado del sur con gran diversidad cultural, lenguas originarias, gastronomía y costas.', 'Oaxaca es uno de los estados con mayor diversidad lingüística del país.', 'oaxaca', '#DC2626', 26),
  ('Sur de México', 'Chiapas', 'Tuxtla Gutiérrez', 'CS', 'Estado del sur con selvas, montañas, zonas arqueológicas y gran diversidad natural.', 'El Cañón del Sumidero tiene paredes que superan los mil metros de altura.', 'chiapas', '#15803D', 27),
  ('Sur de México', 'Veracruz', 'Xalapa', 'VE', 'Estado alargado sobre el Golfo de México, con puertos, montañas y tradición musical.', 'El puerto de Veracruz es uno de los más antiguos e importantes del país.', 'veracruz', '#0284C7', 28),
  ('Sureste de México', 'Tabasco', 'Villahermosa', 'TB', 'Estado del sureste con ríos, selvas, cacao y llanuras del Golfo.', 'Tabasco es una de las cunas históricas del cacao en México.', 'tabasco', '#059669', 29),
  ('Sureste de México', 'Campeche', 'San Francisco de Campeche', 'CM', 'Estado peninsular con murallas históricas, selvas y costa del Golfo de México.', 'La ciudad de Campeche conserva murallas construidas para protegerse de piratas.', 'campeche', '#0F766E', 30),
  ('Sureste de México', 'Yucatán', 'Mérida', 'YU', 'Estado de la península de Yucatán con cenotes, cultura maya y ciudades coloniales.', 'Chichén Itzá es una de las zonas arqueológicas más visitadas de México.', 'yucatan', '#06B6D4', 31),
  ('Sureste de México', 'Quintana Roo', 'Chetumal', 'QR', 'Estado caribeño con playas, arrecifes, selvas y destinos turísticos internacionales.', 'El arrecife mesoamericano pasa frente a las costas de Quintana Roo.', 'quintana_roo', '#38BDF8', 32);

insert into public.states
  (region_id, name, capital, abbreviation, description, fun_fact, map_key, color_hex, order_index)
select
  r.id,
  s.name,
  s.capital,
  s.abbreviation,
  s.description,
  s.fun_fact,
  s.map_key,
  s.color_hex,
  s.order_index
from seed_states s
join public.regions r on r.name = s.region_name
order by s.order_index;

insert into public.units (region_id, title, description, order_index)
select r.id, r.name, r.description, r.order_index
from public.regions r
union all
select null, 'Repaso de México', 'Practica estados, capitales y ubicación de todo el país.', 6;

insert into public.lessons
  (unit_id, title, description, lesson_type, order_index, xp_reward)
select
  u.id,
  v.title,
  v.description,
  v.lesson_type,
  v.order_index,
  v.xp_reward
from public.units u
cross join lateral (
  values
    ('Conoce ' || lower(u.title), 'Identifica los estados principales de esta región.', 'standard', 1, 10),
    ('Capitales de ' || lower(u.title), 'Relaciona cada estado con su capital.', 'capital_practice', 2, 15),
    ('Mapa de ' || lower(u.title), 'Ubica los estados directamente en el mapa.', 'map_practice', 3, 20)
) as v(title, description, lesson_type, order_index, xp_reward)
where u.title <> 'Repaso de México';

insert into public.lessons
  (unit_id, title, description, lesson_type, order_index, xp_reward)
select
  u.id,
  v.title,
  v.description,
  v.lesson_type,
  v.order_index,
  v.xp_reward
from public.units u
cross join lateral (
  values
    ('Capitales de México', 'Repasa capitales de todos los estados.', 'capital_practice', 1, 25),
    ('Mapa nacional', 'Practica la ubicación de estados de todo México.', 'map_practice', 2, 25),
    ('Reto final de México', 'Combina capitales y estados en una ronda final.', 'standard', 3, 30)
) as v(title, description, lesson_type, order_index, xp_reward)
where u.title = 'Repaso de México';

insert into public.exercises
  (lesson_id, exercise_type, question, correct_answer, options, metadata, explanation, difficulty, order_index)
select
  l.id,
  'multiple_choice_state',
  format('¿Qué estado tiene como capital %s?', s.capital),
  s.name,
  options.option_values,
  jsonb_build_object('state', s.name, 'capital', s.capital, 'mapKey', s.map_key, 'targetStateKey', s.map_key),
  format('%s es la capital de %s.', s.capital, s.name),
  1,
  s.order_index
from seed_states s
join public.units u on u.title = s.region_name
join public.lessons l on l.unit_id = u.id and l.lesson_type = 'standard'
cross join lateral (
  select jsonb_agg(name order by sort_order) as option_values
  from (
    select other.name, case when other.name = s.name then 0 else 1 end as sort_order
    from seed_states other
    where other.region_name = s.region_name
    order by sort_order, md5(s.name || other.name)
    limit 4
  ) picked
) options;

insert into public.exercises
  (lesson_id, exercise_type, question, correct_answer, options, metadata, explanation, difficulty, order_index)
select
  l.id,
  'multiple_choice_capital',
  format('¿Cuál es la capital de %s?', s.name),
  s.capital,
  options.option_values,
  jsonb_build_object('state', s.name, 'capital', s.capital, 'mapKey', s.map_key, 'targetStateKey', s.map_key),
  format('La capital de %s es %s.', s.name, s.capital),
  2,
  s.order_index
from seed_states s
join public.units u on u.title = s.region_name
join public.lessons l on l.unit_id = u.id and l.lesson_type = 'capital_practice'
cross join lateral (
  select jsonb_agg(capital order by sort_order) as option_values
  from (
    select other.capital, case when other.capital = s.capital then 0 else 1 end as sort_order
    from seed_states other
    where other.region_name = s.region_name
    order by sort_order, md5(s.capital || other.capital)
    limit 4
  ) picked
) options;

insert into public.exercises
  (lesson_id, exercise_type, question, correct_answer, metadata, explanation, difficulty, order_index)
select
  l.id,
  'map_tap',
  format('Toca %s en el mapa.', s.name),
  s.map_key,
  jsonb_build_object('state', s.name, 'capital', s.capital, 'mapKey', s.map_key, 'targetStateKey', s.map_key),
  format('%s pertenece a %s y su capital es %s.', s.name, s.region_name, s.capital),
  2,
  s.order_index
from seed_states s
join public.units u on u.title = s.region_name
join public.lessons l on l.unit_id = u.id and l.lesson_type = 'map_practice';

insert into public.exercises
  (lesson_id, exercise_type, question, correct_answer, options, metadata, explanation, difficulty, order_index)
select
  l.id,
  'multiple_choice_capital',
  format('¿Cuál es la capital de %s?', s.name),
  s.capital,
  options.option_values,
  jsonb_build_object('state', s.name, 'capital', s.capital, 'mapKey', s.map_key, 'targetStateKey', s.map_key),
  format('La capital de %s es %s.', s.name, s.capital),
  3,
  s.order_index
from seed_states s
join public.units u on u.title = 'Repaso de México'
join public.lessons l on l.unit_id = u.id and l.title = 'Capitales de México'
cross join lateral (
  select jsonb_agg(capital order by sort_order) as option_values
  from (
    select other.capital, case when other.capital = s.capital then 0 else 1 end as sort_order
    from seed_states other
    order by sort_order, md5(s.capital || other.capital)
    limit 4
  ) picked
) options;

insert into public.exercises
  (lesson_id, exercise_type, question, correct_answer, metadata, explanation, difficulty, order_index)
select
  l.id,
  'map_tap',
  format('Ubica %s en el mapa nacional.', s.name),
  s.map_key,
  jsonb_build_object('state', s.name, 'capital', s.capital, 'mapKey', s.map_key, 'targetStateKey', s.map_key),
  format('%s está en la región %s.', s.name, s.region_name),
  3,
  s.order_index
from seed_states s
join public.units u on u.title = 'Repaso de México'
join public.lessons l on l.unit_id = u.id and l.title = 'Mapa nacional';

insert into public.exercises
  (lesson_id, exercise_type, question, correct_answer, options, metadata, explanation, difficulty, order_index)
select
  l.id,
  'multiple_choice_state',
  format('¿Qué estado tiene como capital %s?', s.capital),
  s.name,
  options.option_values,
  jsonb_build_object('state', s.name, 'capital', s.capital, 'mapKey', s.map_key, 'targetStateKey', s.map_key),
  format('La capital de %s es %s.', s.name, s.capital),
  3,
  s.order_index
from seed_states s
join public.units u on u.title = 'Repaso de México'
join public.lessons l on l.unit_id = u.id and l.title = 'Reto final de México'
cross join lateral (
  select jsonb_agg(name order by sort_order) as option_values
  from (
    select other.name, case when other.name = s.name then 0 else 1 end as sort_order
    from seed_states other
    order by sort_order, md5(s.name || other.name)
    limit 4
  ) picked
) options;

insert into public.achievements
  (code, title, description, icon, xp_reward, condition_type, condition_value)
values
  ('first_lesson_completed', 'Primer paso', 'Completa tu primera lección de Mapingo.', 'flag', 10, 'lessons_completed', 1),
  ('five_lessons_completed', 'Buen ritmo', 'Completa 5 lecciones.', 'route', 25, 'lessons_completed', 5),
  ('ten_capitals_mastered', 'Capitalero', 'Responde correctamente 10 preguntas de capitales.', 'school', 30, 'capital_questions_correct', 10),
  ('perfect_lesson', 'Sin fallas', 'Completa una lección con 100% de aciertos.', 'sparkles', 20, 'perfect_lessons', 1),
  ('three_day_streak', 'Racha de tres', 'Practica durante 3 días seguidos.', 'flame', 30, 'streak_days', 3),
  ('map_explorer', 'Explorador del mapa', 'Acierta 10 ejercicios de ubicación en el mapa.', 'map', 35, 'map_tap_correct', 10),
  ('xp_100', 'Cien de experiencia', 'Gana 100 XP en total.', 'zap', 20, 'total_xp', 100),
  ('mexico_review_ready', 'Listo para el reto nacional', 'Completa 12 lecciones.', 'trophy', 50, 'lessons_completed', 12);

commit;
