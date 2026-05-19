import '../datasources/map_explorer_datasource.dart';
import '../models/map_state_model.dart';

class MapExplorerRepository {
  final MapExplorerDatasource _datasource;

  const MapExplorerRepository(this._datasource);

  Future<MapExplorerContent> fetchMapContent(String userId) async {
    final states = await _datasource.fetchStates();
    final attempts = await _datasource.fetchExerciseAttemptsForProgress(userId);
    final progressByMapKey = _buildProgress(attempts);

    return MapExplorerContent(
      states: states,
      progressByMapKey: progressByMapKey,
    );
  }

  Map<String, MapStateProgressModel> _buildProgress(
    List<Map<String, dynamic>> attempts,
  ) {
    final totals = <String, _ProgressCounter>{};

    for (final attempt in attempts) {
      final exercise = _parseJsonMap(attempt['exercises']);
      final metadata = _parseJsonMap(exercise?['metadata']);
      final mapKey =
          metadata?['mapKey'] as String? ??
          metadata?['targetStateKey'] as String?;

      if (mapKey == null || mapKey.isEmpty) continue;

      final counter = totals.putIfAbsent(mapKey, _ProgressCounter.new);
      counter.attempts += 1;
      if (attempt['is_correct'] == true) {
        counter.correctAttempts += 1;
      }
    }

    return {
      for (final entry in totals.entries)
        entry.key: MapStateProgressModel(
          mapKey: entry.key,
          attempts: entry.value.attempts,
          correctAttempts: entry.value.correctAttempts,
        ),
    };
  }

  Map<String, dynamic>? _parseJsonMap(Object? value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }
}

class _ProgressCounter {
  int attempts = 0;
  int correctAttempts = 0;
}
