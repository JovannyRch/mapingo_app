import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/map_state_model.dart';

class MapExplorerDatasource {
  final SupabaseClient _client;

  const MapExplorerDatasource(this._client);

  Future<List<MapStateModel>> fetchStates() async {
    final response = await _client
        .from('states')
        .select('*, regions(name)')
        .order('order_index');

    return response.map(MapStateModel.fromJson).toList();
  }

  Future<List<Map<String, dynamic>>> fetchExerciseAttemptsForProgress(
    String userId,
  ) async {
    final response = await _client
        .from('user_exercise_attempts')
        .select('is_correct, exercises(metadata)')
        .eq('user_id', userId);

    return response.map((row) => Map<String, dynamic>.from(row)).toList();
  }
}
