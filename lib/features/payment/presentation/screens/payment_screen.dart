import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/localization/language_provider.dart';
import '../../../../core/localization/app_strings.dart';

class PaymentScreen extends ConsumerStatefulWidget {
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
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  String _selectedPlan = 'yearly';
  late AppStrings _s;

  void _showPaymentSuccess() {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(_s.paySuccessTitle, 
            style: const TextStyle(color: AppColors.textPrimary)),
        content: Text(_s.paySuccessBody, 
            style: const TextStyle(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(c);
              context.pushReplacement(
                  '/connect-bot/${widget.botId}/${widget.botName}');
            },
            child: Text(_s.payContinue, 
                style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppStrings s = ref.watch(stringsProvider);
    _s = s;

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
        title: Text(s.paySubscription, style: Theme.of(context).textTheme.titleMedium),
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
              title: s.payMonth[0].toUpperCase() + s.payMonth.substring(1),
              price: '\$${widget.priceMonthly.toStringAsFixed(2)}',
              period: '/${s.payMonth}',
              s: s,
            ),
            const SizedBox(height: 16),
            _buildPlanCard(
              id: 'yearly',
              title: s.payYear[0].toUpperCase() + s.payYear.substring(1),
              price: '\$${widget.priceYearly.toStringAsFixed(2)}',
              period: '/${s.payYear}',
              subtitle: 'Экономия \$$savings ($savingsPercent%)',
              s: s,
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _showPaymentSuccess,
                child:
                    Text('${s.payAction} \$${currentPrice.toStringAsFixed(2)}'),
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
    required AppStrings s,
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
                            color: AppColors.success,
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
