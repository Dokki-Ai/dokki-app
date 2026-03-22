import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart'; // Сохранено
import '../../domain/bot.dart';
import '../../../../core/theme/app_theme.dart';

class BotCard extends StatelessWidget {
  final Bot bot;
  final VoidCallback onTap;

  const BotCard({
    super.key,
    required this.bot,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const fallbackColor = Color(0xFFF5F0FF);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppColors.card,
      // ПРИМЕНЕННАЯ ПРАВКА: Усиление тени для контраста на светлом фоне
      elevation: 4,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border, width: 0.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Иллюстрация 80x80
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: fallbackColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: bot.imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: bot.imageUrl!,
                          fit: BoxFit.contain,
                          alignment: Alignment.bottomCenter,
                          placeholder: (context, url) => const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.smart_toy_outlined,
                            size: 32,
                            color: AppColors.textSecondary,
                          ),
                        )
                      : const Icon(
                          Icons.smart_toy_outlined,
                          size: 32,
                          color: AppColors.textSecondary,
                        ),
                ),
              ),
              const SizedBox(width: 14),

              // Информация
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      bot.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily:
                            GoogleFonts.nunito().fontFamily, // Сохранено
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Чип категории
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.accent
                            .withValues(alpha: 0.08), // Сохранено
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        bot.category.toUpperCase(),
                        style: TextStyle(
                          fontFamily:
                              GoogleFonts.nunito().fontFamily, // Сохранено
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          color: AppColors.accent,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      bot.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily:
                            GoogleFonts.nunito().fontFamily, // Сохранено
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.border,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
