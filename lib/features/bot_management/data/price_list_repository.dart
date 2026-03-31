import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';

class PriceListRepository {
  Future<bool> uploadPriceList({
    required String telegramUsername,
    required List<Map<String, dynamic>> products,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.botBaseUrl}/api/prices/upload'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'telegram_username': telegramUsername,
          'products': products,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
