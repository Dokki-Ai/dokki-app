import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

class PaymentCancelScreen extends StatelessWidget {
  const PaymentCancelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cancel_outlined,
                  size: 100, color: AppColors.error),
              const SizedBox(height: 32),
              const Text('Оплата отменена',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 12),
              const Text('Вы отменили процесс оплаты. Средства не списаны.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 48),
              TextButton(
                onPressed: () => context.go('/'),
                child: const Text('Вернуться к тарифам',
                    style: TextStyle(color: AppColors.accent, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
