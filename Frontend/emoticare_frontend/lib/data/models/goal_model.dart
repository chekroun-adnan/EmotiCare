class GoalModel {
  const GoalModel({
    this.id,
    this.userId,
    required this.description,
    this.completed = false,
  });

  final String? id;
  final String? userId;
  final String description;
  final bool completed;

  factory GoalModel.fromJson(Map<String, dynamic> json) {
    return GoalModel(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      description: json['description'] as String? ?? '',
      completed: json['completed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'description': description,
      'completed': completed,
    };
  }

  GoalModel copyWith({
    String? id,
    String? userId,
    String? description,
    bool? completed,
  }) {
    return GoalModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      description: description ?? this.description,
      completed: completed ?? this.completed,
    );
  }
}
