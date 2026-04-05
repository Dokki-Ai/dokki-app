import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_web_plugins/url_strategy.dart'; // Добавлено для Path Strategy
import 'core/env/env.dart';
import 'core/localization/language_provider.dart';
import 'app.dart';

void main() async {
  // 1. Инициализация движка Flutter
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Включаем Path URL Strategy (убирает /#/ из адреса)
  // Важно вызвать до инициализации Supabase и запуска приложения
  usePathUrlStrategy();

  // 3. Предварительная загрузка SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // 4. Инициализация Supabase
  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnonKey,
  );

  runApp(
    ProviderScope(
      overrides: [
        // 5. Внедряем инициализированный экземпляр SharedPreferences
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const DokkiApp(),
    ),
  );
}
