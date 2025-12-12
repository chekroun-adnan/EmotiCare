import '../entities/goal_entity.dart';

abstract class GoalRepository {
  Future<List<GoalEntity>> list(String userId);
  Future<GoalEntity> create(GoalEntity goal);
  Future<GoalEntity> update(GoalEntity goal);
  Future<void> delete(String id);
  Future<void> complete(String id);
}
