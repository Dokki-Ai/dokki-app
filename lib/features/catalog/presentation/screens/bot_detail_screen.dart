import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/bot.dart';

class BotDetailScreen extends StatelessWidget {
  final Bot bot;

  const BotDetailScreen({super.key, required this.bot});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: AppColors.textPrimary),
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderImage(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bot.name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Chip(
                          label: Text(bot.category),
                          backgroundColor: AppColors.card,
                          labelStyle:
                              const TextStyle(color: AppColors.textSecondary),
                          side: BorderSide
                              .none, // Исправлено: side вместо borderSide
                          visualDensity: VisualDensity.compact,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          bot.description,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                        if (bot.features != null &&
                            bot.features!.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          const Text(
                            "Возможности",
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...bot.features!
                              .map((feature) => _buildFeatureItem(feature)),
                        ],
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildConnectButton(context),
        ],
      ),
    );
  }

  Widget _buildHeaderImage() {
    const double imageHeight = 250;

    if (bot.imageUrl != null && bot.imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: bot.imageUrl!,
        height: imageHeight,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          height: imageHeight,
          color: AppColors.card,
          child: const Center(
              child: CircularProgressIndicator(color: AppColors.accent)),
        ),
        errorWidget: (context, url, error) => _buildFallbackImage(imageHeight),
      );
    } else {
      return _buildFallbackImage(imageHeight);
    }
  }

  Widget _buildFallbackImage(double height) {
    return Container(
      height: height,
      width: double.infinity,
      color: AppColors.card,
      child: const Icon(Icons.smart_toy_outlined,
          size: 64, color: AppColors.textSecondary),
    );
  }

  Widget _buildFeatureItem(String feature) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: AppColors.accent,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              feature,
              style:
                  const TextStyle(color: AppColors.textPrimary, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      color: Colors.transparent,
      child: SafeArea(
        top: false,
        child: ElevatedButton(
          onPressed: () {
            context.push('/connect-bot/${bot.id}/${bot.name}');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: AppColors.textPrimary,
            minimumSize: const Size(double.infinity, 50),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
          ),
          child: const Text(
            "Подключить",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
