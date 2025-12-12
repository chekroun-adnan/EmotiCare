import '../../data/models/goal_model.dart';

class GoalEntity {
  const GoalEntity({
    this.id,
    this.userId,
    required this.description,
    this.completed = false,
  });

  final String? id;
  final String? userId;
  final String description;
  final bool completed;

  factory GoalEntity.fromModel(GoalModel model) => GoalEntity(
        id: model.id,
        userId: model.userId,
        description: model.description,
        completed: model.completed,
      );

  GoalModel toModel() => GoalModel(
        id: id,
        userId: userId,
        description: description,
        completed: completed,
      );
}
