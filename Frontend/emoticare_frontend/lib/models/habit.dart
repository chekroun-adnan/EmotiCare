class Habit {
  final String id;
  final String userId;
  final String name;
  final String description;
  final bool completed;

  Habit({
    required this.id,
    required this.userId,
    required this.name,
    required this.description,
    required this.completed,
  });

  factory Habit.fromJson(Map<String, dynamic> json) {
    return Habit(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      completed: json['completed'] ?? false,
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
}
