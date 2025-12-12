import '../../data/models/habit_model.dart';

class HabitEntity {
  const HabitEntity({
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

  factory HabitEntity.fromModel(HabitModel model) => HabitEntity(
        id: model.id,
        userId: model.userId,
        name: model.name,
        description: model.description,
        completed: model.completed,
      );

  HabitModel toModel() => HabitModel(
        id: id,
        userId: userId,
        name: name,
        description: description,
        completed: completed,
      );

  HabitEntity copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    bool? completed,
  }) {
    return HabitEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      completed: completed ?? this.completed,
    );
  }
}
