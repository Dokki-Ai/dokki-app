import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final supabase = Supabase.instance.client;

  return GoRouter(
    initialLocation: '/',
    // Защита маршрутов: перенаправляем на /auth, если сессия отсутствует
    redirect: (context, state) {
      final isLoggedIn = supabase.auth.currentSession != null;
      final isAuthRoute = state.matchedLocation == '/auth';

      if (!isLoggedIn && !isAuthRoute) return '/auth';
      if (isLoggedIn && isAuthRoute) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Catalog (Marketplace)')),
        ),
      ),
      GoRoute(
        path: '/auth',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Auth Screen (Login/Register)')),
        ),
      ),
      GoRoute(
        path: '/bot-management',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Bot Management (TomatoAdmin)')),
        ),
      ),
    ],
  );
});
