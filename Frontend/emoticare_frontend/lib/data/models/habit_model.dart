class HabitModel {
  const HabitModel({
    this.id,
    this.userId,
    required this.name,
    this.description,
    this.completed = false,
  });

  final String? id;
  final String? userId;
  final String name;
  final String? description;
  final bool completed;

  factory HabitModel.fromJson(Map<String, dynamic> json) {
    return HabitModel(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      completed: json['completed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'description': description,
      'completed': completed,
    };
  }

  HabitModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    bool? completed,
  }) {
    return HabitModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      completed: completed ?? this.completed,
    );
  }
}
