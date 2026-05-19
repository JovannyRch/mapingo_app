import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';
import 'core/config/env.dart';
import 'data/services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Env.isConfigured) {
    await SupabaseService.init();
  } else {
    debugPrint('Running without Supabase connection.');
  }

  runApp(
    const ProviderScope(
      child: MapingoApp(),
    ),
  );
}