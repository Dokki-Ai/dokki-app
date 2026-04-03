import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class StripeService {
  final _supabase = Supabase.instance.client;

  // Твой эндпоинт Edge Function
  static const String checkoutUrl =
      'https://capqdnwuquxdeuqnohps.supabase.co/functions/v1/create-checkout-session';

  // Актуальный Price ID из Stripe
  static const String priceId = 'price_1THeDO1nVM8AbdfCUeaylULL';

  Future<void> createCheckoutSession() async {
    final session = _supabase.auth.currentSession;

    if (session == null) {
      debugPrint('StripeService: No active Supabase session');
      throw 'User not authenticated';
    }

    try {
      debugPrint('StripeService: Initiating checkout session...');

      final response = await http.post(
        Uri.parse(checkoutUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${session.accessToken}',
        },
        body: jsonEncode({
          'priceId': priceId,
          // ИСПОЛЬЗУЕМ HTTPS UNIVERSAL LINKS ВМЕСТО CUSTOM SCHEMES
          'successUrl': 'https://app.dokki.org/payment-success',
          'cancelUrl': 'https://app.dokki.org/payment-cancel',
        }),
      );

      debugPrint('Stripe Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String? url = data['url'];

        if (url != null) {
          final uri = Uri.parse(url);

          // LaunchMode.externalApplication КРИТИЧЕН для Universal Links.
          // Это заставляет iOS/Android проверить, есть ли приложение,
          // готовое обработать обратный URL при редиректе.
          if (await canLaunchUrl(uri)) {
            debugPrint('StripeService: Launching Stripe Checkout URL...');
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            debugPrint('StripeService: Could not launch URL $url');
            throw 'Could not launch payment URL';
          }
        } else {
          debugPrint('StripeService: URL is null in response');
          throw 'Server returned empty checkout URL';
        }
      } else {
        final errorData = jsonDecode(response.body);
        debugPrint('StripeService Error Response: ${response.body}');
        throw errorData['error'] ?? 'Server error ${response.statusCode}';
      }
    } catch (e) {
      debugPrint('StripeService Exception: $e');
      rethrow;
    }
  }
}
