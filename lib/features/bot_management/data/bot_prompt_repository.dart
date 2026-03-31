import 'dart:convert';
import 'package:http/http.dart' as http;

class BotPromptRepository {
  /// Отправляет POST запрос на внешний API для обновления системного промпта бота.
  /// Возвращает [true], если запрос успешен (status 200), иначе [false].
  Future<bool> updateSystemPrompt({
    required String telegramUsername,
    required String systemPrompt,
  }) async {
    // Формируем юзернейм с префиксом @, если он отсутствует
    final String formattedUsername = telegramUsername.startsWith('@')
        ? telegramUsername
        : '@$telegramUsername';

    try {
      final response = await http.post(
        Uri.parse('https://dokki-sales-fly.fly.dev/api/update-prompt'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'telegram_username': formattedUsername,
          'system_prompt': systemPrompt,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      // В случае сетевой ошибки или исключения возвращаем false
      return false;
    }
  }
}
