import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/business.dart';
import 'appointments_screen.dart';
import 'bot_config_screen.dart';

class BotManagementScreen extends ConsumerWidget {
  final Business business;

  const BotManagementScreen({
    super.key,
    required this.business,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isActivated = business.telegramGroupId != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Управление ботом'),
        backgroundColor: AppColors.background, // Исправлено для светлой темы
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: GoogleFonts.nunito().fontFamily,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Карточка статуса бота
            _buildStatusCard(isActivated),
            const SizedBox(height: 32),

            // Основные действия
            Text(
              'ДЕЙСТВИЯ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: AppColors.textSecondary,
                letterSpacing: 1.2,
                fontFamily: GoogleFonts.nunito().fontFamily,
              ),
            ),
            const SizedBox(height: 16),

            // Кнопка записей
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AppointmentsScreen(business: business),
                  ),
                ),
                icon: const Icon(Icons.format_list_bulleted_rounded, size: 20),
                label: const Text('ЗАПИСИ'),
                style: OutlinedButton.styleFrom(
                  // ПРАВКА 2: Замена белого на темный текст
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.border, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.nunito().fontFamily,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Кнопка Настройки
            SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BotConfigScreen(business: business),
                  ),
                ),
                icon: const Icon(Icons.settings_suggest_rounded, size: 20),
                label: const Text('НАСТРОЙКИ ПРОМПТА'),
                style: OutlinedButton.styleFrom(
                  // ПРАВКА 2: Замена белого на темный текст
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.border, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  textStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.nunito().fontFamily,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Кнопка активации
            if (!isActivated)
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Логика Stage 2.2
                  },
                  icon: const Icon(Icons.group_add_rounded),
                  label: Text(
                    'АКТИВИРОВАТЬ ГРУППУ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        fontFamily: GoogleFonts.nunito().fontFamily),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(bool isActivated) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (isActivated ? AppColors.success : AppColors.warning)
                  .withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isActivated
                  ? Icons.check_circle_rounded
                  : Icons.pending_actions_rounded,
              color: isActivated ? AppColors.success : AppColors.warning,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isActivated ? 'Бот активен' : 'Требуется настройка',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    // ПРАВКА 1: Замена белого на темный текст
                    color: AppColors.textPrimary,
                    fontFamily: GoogleFonts.nunito().fontFamily,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isActivated
                      ? 'Бот готов к приему заказов'
                      : 'Привяжите Telegram группу',
                  style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      fontFamily: GoogleFonts.nunito().fontFamily),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
