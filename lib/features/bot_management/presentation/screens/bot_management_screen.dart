import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/business.dart';
import '../../providers/bot_management_providers.dart';
import '../../data/price_parser.dart'; // Задача 19: Импорт парсера

class BotManagementScreen extends ConsumerStatefulWidget {
  final Business business;

  const BotManagementScreen({
    super.key,
    required this.business,
  });

  @override
  ConsumerState<BotManagementScreen> createState() =>
      _BotManagementScreenState();
}

class _BotManagementScreenState extends ConsumerState<BotManagementScreen> {
  late final TextEditingController _promptController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _promptController = TextEditingController(
      text: widget.business.systemPrompt ?? '',
    );
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  // Обновленный метод выбора и автоматической загрузки файла (Задача 19)
  Future<void> _pickPriceFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls', 'csv'],
    );

    if (result == null || result.files.single.path == null) return;

    setState(() => _isSaving = true);

    try {
      final filePath = result.files.single.path!;

      // 1. Парсим файл в List<Map>
      final products = await PriceParser.parseFile(filePath);

      if (products.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Файл пуст или имеет неверный формат'),
              backgroundColor: AppColors.error,
            ),
          );
        }
        return;
      }

      // 2. Отправляем данные на Fly.io
      final success =
          await ref.read(priceListRepositoryProvider).uploadPriceList(
                telegramUsername: widget.business.telegramUsername,
                products: products,
              );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success
                ? 'Успешно загружено ${products.length} позиций'
                : 'Ошибка при сохранении на сервере'),
            backgroundColor: success ? Colors.green : AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка парсинга: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _handleSave() async {
    setState(() => _isSaving = true);
    final String promptText = _promptController.text.trim();

    try {
      final bool success =
          await ref.read(botPromptRepositoryProvider).updateSystemPrompt(
                telegramUsername: widget.business.telegramUsername,
                systemPrompt: promptText,
              );

      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Промпт сохранен'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        throw Exception('Сервер Fly.io не ответил');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.business.botName,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Секция: Инструкции ---
            TextField(
              controller: _promptController,
              maxLines: 10,
              maxLength: 10000,
              enabled: !_isSaving,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 15,
                fontFamily: 'Inter',
              ),
              decoration: InputDecoration(
                labelText: 'Инструкции для бота',
                labelStyle: const TextStyle(color: AppColors.textSecondary),
                alignLabelWithHint: true,
                filled: true,
                fillColor: AppColors.card,
                counterStyle: const TextStyle(color: AppColors.textSecondary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppColors.accent, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'СОХРАНИТЬ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                        ),
                      ),
              ),
            ),

            // --- Секция: Прайс-лист ---
            const SizedBox(height: 32),
            const Text(
              'Прайс-лист',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _isSaving ? null : _pickPriceFile,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.upload_file_rounded,
                      color: _isSaving
                          ? AppColors.textSecondary
                          : AppColors.accent,
                      size: 40,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _isSaving ? 'Обработка...' : 'Загрузить Excel/CSV',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 15,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
