import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../bot_management/domain/business.dart';

class BusinessCard extends StatelessWidget {
  final Business business;
  final VoidCallback onManage;

  const BusinessCard({
    super.key,
    required this.business,
    required this.onManage,
  });

  String _formatBotId(String id) {
    return id
        .split(RegExp(r'[-_]'))
        .map((word) => word.isEmpty
            ? ''
            : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
        .join(' ');
  }

  Widget _buildStatusBadge() {
    String label;
    Color color;

    if (business.status == 'active' && business.telegramGroupId != null) {
      label = 'В работе';
      color = AppColors.success;
    } else if (business.status == 'active' &&
        business.telegramGroupId == null) {
      label = 'Настройка';
      color = AppColors.warning;
    } else {
      label = 'Выкл';
      color = AppColors.error;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.4),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            fontFamily: GoogleFonts.nunito().fontFamily,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const fallbackColor = Color(0xFFF5F0FF);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                // Иллюстрация бота 80x80
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: fallbackColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: business.botImageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: business.botImageUrl!,
                            fit: BoxFit.contain,
                            alignment: Alignment.bottomCenter,
                            placeholder: (context, url) => const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
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
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatBotId(business.botId),
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts.nunito().fontFamily,
                        ),
                      ),
                      const SizedBox(height: 6),
                      _buildStatusBadge(),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: onManage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'УПРАВЛЕНИЕ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    fontFamily: GoogleFonts.nunito().fontFamily,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
