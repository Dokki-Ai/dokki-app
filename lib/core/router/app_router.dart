import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Импорты экранов
import '../../features/auth/presentation/screens/auth_screen.dart';
import '../navigation/main_screen.dart';
import '../supabase/supabase_client.dart';
import '../../features/payment/presentation/screens/payment_screen.dart';
// ДОБАВЛЯЕМ ЭТОТ ИМПОРТ:
import '../../features/payment/presentation/screens/payment_success_screen.dart';
import '../../features/settings/presentation/screens/profile_screen.dart';
import '../../features/settings/presentation/screens/language_screen.dart';
import '../../features/settings/presentation/screens/notifications_screen.dart';
import '../../features/bot_management/presentation/screens/bot_management_screen.dart';
import '../../features/bot_management/presentation/screens/bot_config_screen.dart';
import '../../features/bot_management/presentation/screens/price_list_screen.dart';
import '../../features/bot_management/presentation/screens/product_edit_screen.dart';
import '../../features/catalog/presentation/screens/bot_detail_screen.dart';

// Импорты домена
import '../../features/bot_management/domain/business.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  final authListener = _AuthNotifier(supabase);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: authListener,
    redirect: (context, state) {
      final session = supabase.auth.currentSession;
      final isLoggedIn = session != null;
      final location = state.matchedLocation;

      // Список защищенных маршрутов
      final isProtectedRoute = location.startsWith('/profile') ||
          location.startsWith('/payment') ||
          location.startsWith('/payment-success') || // Добавили защиту сюда
          location.startsWith('/bot-config') ||
          location.startsWith('/bot-management') ||
          location.startsWith('/price-list') ||
          location.startsWith('/product-edit');

      final isAuthRoute = location == '/auth';

      if (!isLoggedIn && isProtectedRoute) {
        return '/auth';
      }

      if (isLoggedIn && isAuthRoute) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const MainScreen(),
      ),

      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthScreen(),
      ),

      // ЭКРАН УСПЕШНОЙ ОПЛАТЫ (Universal Link)
      GoRoute(
        path: '/payment-success',
        builder: (context, state) => const PaymentSuccessScreen(),
      ),

      // ЭКРАН ОТМЕНЫ ОПЛАТЫ (Universal Link)
      GoRoute(
        path: '/payment-cancel',
        builder: (context, state) =>
            const MainScreen(), // Или отдельный экран отмены
      ),

      GoRoute(
        path: '/bot-details/:category',
        builder: (context, state) {
          final category = state.pathParameters['category'] ?? 'admin';
          return BotDetailScreen(category: category);
        },
      ),

      GoRoute(
        path: '/profile',
        builder: (context, state) {
          final email = state.extra as String? ?? '';
          return ProfileScreen(currentEmail: email);
        },
      ),

      GoRoute(
        path: '/language',
        builder: (context, state) => const LanguageScreen(),
      ),

      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),

      GoRoute(
        path: '/payment',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return PaymentScreen(
            botId: extra['botId'] as String,
            botName: extra['botName'] as String,
            botDescription: extra['botDescription'] as String,
            priceMonthly: extra['priceMonthly'] as double,
            priceYearly: extra['priceYearly'] as double,
          );
        },
      ),

      GoRoute(
        path: '/bot-config/:botId/:botName/:botCategory',
        builder: (context, state) => BotConfigScreen(
          botId: state.pathParameters['botId']!,
          botName: state.pathParameters['botName']!,
          botCategory: state.pathParameters['botCategory']!,
        ),
      ),

      GoRoute(
        path: '/bot-management/:id',
        builder: (context, state) => BotManagementScreen(
          business: state.extra as Business,
        ),
      ),

      GoRoute(
        path: '/price-list',
        builder: (context, state) => PriceListScreen(
          business: state.extra as Business,
        ),
      ),

      GoRoute(
        path: '/product-edit',
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>;
          return ProductEditScreen(
            business: data['business'] as Business,
            product: data['product'] as Map<String, dynamic>?,
          );
        },
      ),
    ],
  );
});

class _AuthNotifier extends ChangeNotifier {
  _AuthNotifier(SupabaseClient supabase) {
    supabase.auth.onAuthStateChange.listen((data) {
      notifyListeners();
    });
  }
}
