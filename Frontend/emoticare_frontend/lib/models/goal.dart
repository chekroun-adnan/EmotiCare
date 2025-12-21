class Goal {
  final String id;
  final String userId;
  final String description;
  final bool completed;

  Goal({
    required this.id,
    required this.userId,
    required this.description,
    required this.completed,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      description: json['description'] ?? '',
      completed: json['completed'] ?? false,
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
}
