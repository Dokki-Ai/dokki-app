import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/supabase/supabase_client.dart';
import '../../../../core/localization/language_provider.dart';
import '../../../../core/localization/app_strings.dart';
import '../../domain/bot.dart';
import '../../providers/catalog_providers.dart';

class BotDetailScreen extends ConsumerStatefulWidget {
  final String category; // 'admin', 'sales', 'support'

  const BotDetailScreen({super.key, required this.category});

  @override
  ConsumerState<BotDetailScreen> createState() => _BotDetailScreenState();
}

class _BotDetailScreenState extends ConsumerState<BotDetailScreen> {
  String selectedTier = 'basic'; // State для выбранного уровня

  @override
  Widget build(BuildContext context) {
    final AppStrings s = ref.watch(stringsProvider);
    final botsAsync = ref.watch(botsByCategoryProvider(widget.category));

    return botsAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const BackButton(color: AppColors.textPrimary),
        ),
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
      ),
      error: (err, stack) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const BackButton(color: AppColors.textPrimary),
        ),
        body: Center(
          child: Text(
            'Ошибка: $err',
            style: const TextStyle(color: AppColors.error),
          ),
        ),
      ),
      data: (bots) {
        if (bots.isEmpty) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: const BackButton(color: AppColors.textPrimary),
            ),
            body: const Center(
              child: Text('Нет доступных тарифов'),
            ),
          );
        }

        // Находим выбранный бот по tier
        final selectedBot = bots.firstWhere(
          (b) => b.tier == selectedTier,
          orElse: () => bots.first,
        );

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: const BackButton(color: AppColors.textPrimary),
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Большое изображение бота
                      Container(
                        width: double.infinity,
                        height: 280,
                        color: AppColors.surface,
                        child: CachedNetworkImage(
                          imageUrl: selectedBot.imageUrl ?? '',
                          fit: BoxFit.fitWidth,
                          alignment: Alignment.topCenter,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(
                                color: AppColors.accent),
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.smart_toy_outlined,
                            size: 64,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Название бота
                            Text(
                              selectedBot.name,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 12),
                            const Divider(color: AppColors.border),
                            const SizedBox(height: 12),

                            // ВЫБЕРИТЕ ТАРИФ
                            Text(
                              'ВЫБЕРИТЕ ТАРИФ',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                            const SizedBox(height: 16),

                            // Плашки выбора тарифа
                            ...bots.map((bot) => _buildTierCard(
                                  context: context,
                                  bot: bot,
                                  isSelected: bot.tier == selectedTier,
                                  onTap: () {
                                    setState(() {
                                      selectedTier = bot.tier;
                                    });
                                  },
                                  s: s,
                                )),

                            const SizedBox(height: 12),
                            const Divider(color: AppColors.border),
                            const SizedBox(height: 12),

                            // Описание
                            if (selectedBot.description.isNotEmpty) ...[
                              Text(
                                s.catDescription.toUpperCase(),
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                selectedBot.description,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(height: 1.6),
                              ),
                              const SizedBox(height: 24),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Кнопка подключить
              Container(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 16,
                  bottom: MediaQuery.of(context).padding.bottom + 16,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  border: Border(top: BorderSide(color: AppColors.border)),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      final session =
                          ref.read(supabaseClientProvider).auth.currentSession;

                      if (session == null) {
                        context.push('/auth');
                      } else {
                        context.push('/payment', extra: {
                          'botId': selectedBot.id,
                          'botName': selectedBot.name,
                          'botDescription': selectedBot.shortDescription,
                          'priceMonthly': selectedBot.priceMonthly ?? 0.0,
                          'priceYearly': selectedBot.priceYearly ?? 0.0,
                        });
                      }
                    },
                    child: Text(
                        '${s.botConnect} - \$${selectedBot.priceMonthly?.toStringAsFixed(0)}/${s.payMonth}'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTierCard({
    required BuildContext context,
    required Bot bot,
    required bool isSelected,
    required VoidCallback onTap,
    required AppStrings s,
  }) {
    // Капитализация первой буквы tier
    final tierName = bot.tier[0].toUpperCase() + bot.tier.substring(1);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.border,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tierName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    fontFamily: 'Inter',
                  ),
                ),
                Text(
                  '\$${bot.priceMonthly?.toStringAsFixed(0)}/${s.payMonth}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accent,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (bot.features != null && bot.features!.isNotEmpty)
              ...bot.features!.map((feature) => Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.check,
                            size: 16, color: AppColors.accent),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            feature,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}
