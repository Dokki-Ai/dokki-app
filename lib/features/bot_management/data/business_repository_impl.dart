import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/business.dart';
import '../domain/business_repository.dart';

class BusinessRepositoryImpl implements BusinessRepository {
  final SupabaseClient _supabase;

  BusinessRepositoryImpl(this._supabase);

  @override
  Future<Business> connectBot({
    required String botId,
    required String botToken,
    required String railwayToken,
    required String railwayWorkspaceId,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('Пользователь не авторизован');

      // Вставляем данные и сразу запрашиваем их обратно вместе с данными каталога
      final response = await _supabase
          .from('businesses')
          .insert({
            'user_id': userId,
            'bot_id': botId,
            'bot_token': botToken,
            'client_railway_token': railwayToken,
            'client_railway_workspace_id': railwayWorkspaceId,
            'status': 'active', // Начальный статус при подключении
          })
          .select('*, bot_catalog(image_url, name)')
          .single();

      return Business.fromJson(response);
    } catch (e) {
      throw Exception('Ошибка при подключении бота: $e');
    }
  }

  @override
  Future<List<Business>> getConnectedBots() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return [];

      final response = await _supabase
          .from('businesses')
          .select('*, bot_catalog(image_url, name)')
          .eq('user_id', userId);

      return (response as List).map((json) => Business.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Ошибка загрузки подключенных ботов: $e');
    }
  }

  @override
  Future<Business?> getBusinessById(String id) async {
    try {
      final response = await _supabase
          .from('businesses')
          .select('*, bot_catalog(image_url, name)')
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;
      return Business.fromJson(response);
    } catch (e) {
      throw Exception('Ошибка получения данных бизнеса: $e');
    }
  }
}
