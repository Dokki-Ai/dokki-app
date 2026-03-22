class Business {
  final String id;
  final String userId;
  final String botId;
  final String status;
  final String botToken;
  final String? telegramGroupId;
  final String? botSupabaseUrl;
  final String? botSupabaseAnonKey;
  final String? botBusinessId;
  final DateTime? createdAt;
  final String? clientRailwayToken;
  final String? clientRailwayWorkspaceId;
  final String? botImageUrl; // Новое поле

  Business({
    required this.id,
    required this.userId,
    required this.botId,
    required this.status,
    required this.botToken,
    this.telegramGroupId,
    this.botSupabaseUrl,
    this.botSupabaseAnonKey,
    this.botBusinessId,
    this.createdAt,
    this.clientRailwayToken,
    this.clientRailwayWorkspaceId,
    this.botImageUrl,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      botId: json['bot_id'] as String,
      status: json['status'] as String,
      botToken: json['bot_token'] as String,
      telegramGroupId: json['telegram_group_id'] as String?,
      botSupabaseUrl: json['bot_supabase_url'] as String?,
      botSupabaseAnonKey: json['bot_supabase_anon_key'] as String?,
      botBusinessId: json['bot_business_id'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      clientRailwayToken: json['client_railway_token'] as String?,
      clientRailwayWorkspaceId: json['client_railway_workspace_id'] as String?,
      // Получаем image_url из связанной таблицы bot_catalog
      botImageUrl: json['bot_catalog']?['image_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'bot_id': botId,
      'status': status,
      'bot_token': botToken,
      'telegram_group_id': telegramGroupId,
      'bot_supabase_url': botSupabaseUrl,
      'bot_supabase_anon_key': botSupabaseAnonKey,
      'bot_business_id': botBusinessId,
      'created_at': createdAt?.toIso8601String(),
      'client_railway_token': clientRailwayToken,
      'client_railway_workspace_id': clientRailwayWorkspaceId,
    };
  }
}
