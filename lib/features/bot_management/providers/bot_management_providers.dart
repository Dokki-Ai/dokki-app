import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/supabase/supabase_client.dart';
import '../domain/business.dart';
import '../domain/business_repository.dart';
import '../data/business_repository_impl.dart';
import '../data/telegram_repository.dart';
import '../data/appointments_repository.dart';
import '../data/bot_config_repository.dart';
import '../data/bot_prompt_repository.dart';
import '../data/price_list_repository.dart'; // Задача 18: Импорт репозитория прайсов

// 1. Провайдер Telegram API
final telegramRepositoryProvider = Provider<TelegramRepository>((ref) {
  return TelegramRepository();
});

// 2. Провайдер управления ботами
final businessRepositoryProvider = Provider<BusinessRepository>((ref) {
  return BusinessRepositoryImpl(ref.watch(supabaseClientProvider));
});

// 3. Провайдер списка подключенных ботов
final connectedBotsProvider =
    FutureProvider.autoDispose<List<Business>>((ref) async {
  final repository = ref.watch(businessRepositoryProvider);
  return repository.getConnectedBots();
});

// 4. Провайдер репозитория записей (TomatoAdmin)
final appointmentsRepositoryProvider = Provider<AppointmentsRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AppointmentsRepository(client);
});

// 5. Провайдер списка записей для конкретного бизнеса
final appointmentsProvider =
    FutureProvider.family<List<Map<String, dynamic>>, Business>(
        (ref, business) async {
  return ref.watch(appointmentsRepositoryProvider).getAppointments();
});

// 6. Провайдер репозитория конфигурации бота
final botConfigRepositoryProvider = Provider<BotConfigRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return BotConfigRepository(client);
});

// 7. Провайдер конфигурации для конкретного бизнеса
final botConfigProvider =
    FutureProvider.family<Map<String, dynamic>?, Business>(
        (ref, business) async {
  final businessId = business.id;
  return ref.watch(botConfigRepositoryProvider).getConfig(businessId);
});

// 8. Провайдер репозитория промптов
final botPromptRepositoryProvider = Provider<BotPromptRepository>((ref) {
  return BotPromptRepository();
});

// 9. Провайдер репозитория прайс-листов (Задача 18)
final priceListRepositoryProvider = Provider<PriceListRepository>((ref) {
  return PriceListRepository();
});
