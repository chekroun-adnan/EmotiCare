import '../entities/habit_entity.dart';

abstract class HabitRepository {
  Future<List<HabitEntity>> list(String userId);
  Future<HabitEntity> create(HabitEntity habit);
  Future<HabitEntity> update(HabitEntity habit);
  Future<void> delete(String userId, String id);
  Future<void> complete(String id);
}
