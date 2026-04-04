import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class StripeService {
  final _supabase = Supabase.instance.client;

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

      // Нативный вызов Supabase Edge Function.
      // Автоматически добавляет 'Authorization': 'Bearer ${session.accessToken}'
      final response = await _supabase.functions.invoke(
        'create-checkout-session',
        body: {
          'priceId': priceId,
          'successUrl': 'https://app.dokki.org/payment-success',
          'cancelUrl': 'https://app.dokki.org/payment-cancel',
        },
      );

      debugPrint('Stripe Response Status: ${response.status}');

      if (response.status == 200 || response.status == 201) {
        // Нативный клиент уже возвращает распарсенный JSON в response.data
        final String? stripeRedirectUrl = response.data['url'];

        if (stripeRedirectUrl != null && stripeRedirectUrl.startsWith('http')) {
          final uri = Uri.parse(stripeRedirectUrl);

          debugPrint('StripeService: Launching Stripe Checkout URL...');

          // LaunchMode.externalApplication КРИТИЧЕН.
          // Мы открываем системный браузер. Когда оплата завершится,
          // редирект на https://app.dokki.org будет перехвачен iOS/Android
          // или обработан Cloudflare во Flutter Web.
          final launched =
              await launchUrl(uri, mode: LaunchMode.externalApplication);

          if (!launched) {
            throw 'Could not launch payment URL';
          }
        } else {
          debugPrint('StripeService: Received invalid URL: $stripeRedirectUrl');
          throw 'Server returned empty or invalid checkout URL';
        }
      } else {
        debugPrint('StripeService Error Response: ${response.data}');
        throw response.data?['error'] ?? 'Server error ${response.status}';
      }
    } on FunctionException catch (e) {
      debugPrint(
          'StripeService FunctionException: ${e.reasonPhrase} - ${e.details}');
      throw e.details?['error'] ??
          e.reasonPhrase ??
          'Edge Function connection error';
    } catch (e) {
      debugPrint('StripeService Exception: $e');
      rethrow;
    }
  }
}
