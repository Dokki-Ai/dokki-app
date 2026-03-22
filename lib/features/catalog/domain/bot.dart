class Bot {
  final String id;
  final String name;
  final String description;
  final String category;
  final bool isActive;
  final String? githubRepo;
  final String? imageUrl;
  final List<String>? features; // Добавлено поле

  const Bot({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.isActive,
    this.githubRepo,
    this.imageUrl,
    this.features, // Добавлено в конструктор
  });

  factory Bot.fromJson(Map<String, dynamic> json) {
    return Bot(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      isActive: json['is_active'] as bool,
      githubRepo: json['github_repo'] as String?,
      imageUrl: json['image_url'] as String?,
      // Маппинг списка фич
      features: (json['features'] as List?)?.map((e) => e.toString()).toList(),
    );
  }
}
