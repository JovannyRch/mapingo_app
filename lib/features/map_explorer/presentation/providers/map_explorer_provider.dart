import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/map_explorer_datasource.dart';
import '../../data/models/map_state_model.dart';
import '../../data/repositories/map_explorer_repository.dart';

final mapExplorerDatasourceProvider = Provider<MapExplorerDatasource>((ref) {
  return MapExplorerDatasource(ref.watch(supabaseClientProvider));
});

final mapExplorerRepositoryProvider = Provider<MapExplorerRepository>((ref) {
  return MapExplorerRepository(ref.watch(mapExplorerDatasourceProvider));
});

final mapExplorerContentProvider = FutureProvider<MapExplorerContent>((
  ref,
) async {
  final session = await ref.watch(startupAuthProvider.future);
  return ref
      .watch(mapExplorerRepositoryProvider)
      .fetchMapContent(session.user.id);
});

final selectedMapKeyProvider = StateProvider<String?>((ref) => null);
