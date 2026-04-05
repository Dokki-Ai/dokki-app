class ApiConstants {
  /// 🤖 URL основного бота (развёрнут на DigitalOcean)
  ///
  /// ВАЖНО: Это единственный сервер для ВСЕХ клиентов (multi-tenant)
  /// При переносе на другой хостинг — меняй только этот URL
  static const String botBaseUrl =
      'https://stingray-app-ewoo6.ondigitalocean.app';

  static const String configEndpoint = '/api/config';

  static String get configUrl => '$botBaseUrl$configEndpoint';
}
