import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
      margin: const EdgeInsets.only(bottom: 16),
      color: AppColors.card,
      elevation: 4,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Иллюстрация сверху (160px) с BoxFit.contain
            Container(
              color: fallbackColor,
              width: double.infinity,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                child: bot.imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: bot.imageUrl!,
                        height: 160,
                        width: double.infinity,
                        fit: BoxFit.contain, // Теперь персонаж виден целиком
                        alignment: Alignment.bottomCenter,
                        placeholder: (context, url) => Container(
                          height: 160,
                          color: AppColors.background,
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: 160,
                          color: fallbackColor,
                          child: const Icon(
                            Icons.smart_toy_outlined,
                            size: 50,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      )
                    : Container(
                        height: 160,
                        color: fallbackColor,
                        child: const Icon(
                          Icons.smart_toy_outlined,
                          size: 50,
                          color: AppColors.textSecondary,
                        ),
                      ),
              ),
            ),

            // Контентная часть
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Название + Категория
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          bot.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          bot.category.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.accent,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Описание
                  Text(
                    bot.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Кнопка вправо
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: onTap,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.accent,
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      child: const Text('Подробнее →'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
