import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

class PaymentScreen extends StatefulWidget {
  final String botId;
  final String botName;
  final String botDescription;
  final double priceMonthly;
  final double priceYearly;

  const PaymentScreen({
    super.key,
    required this.botId,
    required this.botName,
    required this.botDescription,
    required this.priceMonthly,
    required this.priceYearly,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPlan = 'yearly';

  void _showPaymentSuccess() {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Оплата успешна'),
        content: const Text('Подписка активирована (тестовый режим)'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(c);
              // Переход через GoRouter для чистоты навигации
              context.pushReplacement(
                  '/connect-bot/${widget.botId}/${widget.botName}');
            },
            child: const Text('Продолжить'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double savings = (widget.priceMonthly * 12) - widget.priceYearly;
    final int savingsPercent =
        (((widget.priceMonthly * 12) - widget.priceYearly) /
                (widget.priceMonthly * 12) *
                100)
            .round();
    final double currentPrice =
        _selectedPlan == 'monthly' ? widget.priceMonthly : widget.priceYearly;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Подписка', style: Theme.of(context).textTheme.titleMedium),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: const BackButton(color: AppColors.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.botName,
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(widget.botDescription,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 32),
            _buildPlanCard(
              id: 'monthly',
              title: 'Месяц',
              price: '\$${widget.priceMonthly.toStringAsFixed(2)}',
              period: '/мес',
            ),
            const SizedBox(height: 16),
            _buildPlanCard(
              id: 'yearly',
              title: 'Год',
              price: '\$${widget.priceYearly.toStringAsFixed(2)}',
              period: '/год',
              subtitle: 'Экономия \$$savings ($savingsPercent%)',
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _showPaymentSuccess,
                child:
                    Text('ПОДКЛЮЧИТЬ ЗА \$${currentPrice.toStringAsFixed(2)}'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required String id,
    required String title,
    required String price,
    required String period,
    String? subtitle,
  }) {
    final bool isSelected = _selectedPlan == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedPlan = id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.border,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(price,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: AppColors.accent)),
                      Text(period,
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.green,
                            fontWeight: FontWeight.bold)),
                  ],
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.accent, size: 28)
            else
              const Icon(Icons.radio_button_off,
                  color: AppColors.border, size: 28),
          ],
        ),
      ),
    );
  }
}
