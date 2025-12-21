import '../../domain/entities/habit_entity.dart';

abstract class RecommendationRepository {
  Future<List<HabitEntity>> getUserHabits(String userId);
  Future<String> recommendActivities(String userId, String? moodSummary);
}
