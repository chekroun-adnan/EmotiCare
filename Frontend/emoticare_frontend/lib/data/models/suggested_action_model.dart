class SuggestedActionModel {
  const SuggestedActionModel({
    this.id,
    this.userId,
    this.category,
    this.description,
    this.done = false,
  });

  final String? id;
  final String? userId;
  final String? category;
  final String? description;
  final bool done;

  factory SuggestedActionModel.fromJson(Map<String, dynamic> json) {
    return SuggestedActionModel(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      category: json['category'] as String?,
      description: json['description'] as String?,
      done: json['done'] as bool? ?? false,
    );
  }
}
