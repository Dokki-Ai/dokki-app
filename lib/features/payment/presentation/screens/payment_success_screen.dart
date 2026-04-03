import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/supabase/supabase_client.dart';

class PaymentSuccessScreen extends ConsumerStatefulWidget {
  const PaymentSuccessScreen({super.key});

  @override
  ConsumerState<PaymentSuccessScreen> createState() =>
      _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends ConsumerState<PaymentSuccessScreen> {
  @override
  void initState() {
    super.initState();
    _handlePaymentSuccess();
  }

  Future<void> _handlePaymentSuccess() async {
    try {
      final supabase = ref.read(supabaseClientProvider);
      final user = supabase.auth.currentUser;

      if (user == null) throw 'Пользователь не авторизован';

      Map<String, dynamic>? subscription;
      int attempts = 0;
      const maxAttempts = 5;

      debugPrint('=== SUCCESS LANDING: Waiting for subscription ===');

      while (attempts < maxAttempts) {
        final response = await supabase
            .from('subscriptions')
            .select()
            .eq('user_id', user.id)
            .eq('status', 'active')
            .maybeSingle();

        if (response != null) {
          subscription = response;
          debugPrint('✅ Subscription verified!');
          break;
        }

        attempts++;
        debugPrint('⏳ Attempt $attempts: Webhook not arrived yet...');
        await Future.delayed(const Duration(seconds: 2));
      }

      if (subscription == null) throw 'Подписка еще не активирована сервером';

      final existing = await supabase
          .from('businesses')
          .select()
          .eq('user_id', user.id)
          .eq('bot_id', 'admin_basic')
          .maybeSingle();

      if (existing == null) {
        debugPrint('🚀 Creating business record...');
        await supabase.from('businesses').insert({
          'user_id': user.id,
          'bot_id': 'admin_basic',
          'status': 'active',
        });
      }

      if (!mounted) return;
      context.go('/bot-config/admin_basic/Dokki Admin/admin');
    } catch (e) {
      debugPrint('❌ Error in Success Screen: $e');
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e'), backgroundColor: AppColors.error),
      );

      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        context.go('/');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.accent),
            SizedBox(height: 32),
            Text(
              'Оплата получена!',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary),
            ),
            SizedBox(height: 12),
            Text(
              'Активируем вашего бота, подождите...',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
