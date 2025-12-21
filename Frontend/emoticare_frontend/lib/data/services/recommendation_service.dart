import '../../domain/entities/habit_entity.dart';
import '../../domain/repositories/recommendation_repository.dart';
import '../api/dio_client.dart';
import '../models/habit_model.dart';

class RecommendationService implements RecommendationRepository {
  RecommendationService(this._client);

  final DioClient _client;

  @override
  Future<List<HabitEntity>> getUserHabits(String userId) async {
    final res = await _client.client.get(
      '/api/recommendation/habits/$userId',
    );
    final list = (res.data as List<dynamic>? ?? [])
        .map((e) => HabitModel.fromJson(e as Map<String, dynamic>).toEntity())
        .toList();
    return list;
  }

  @override
  Future<String> recommendActivities(String userId, String? moodSummary) async {
    final res = await _client.client.get(
      '/api/recommendation/activities/$userId',
      queryParameters: moodSummary != null ? {'moodSummary': moodSummary} : null,
    );
    return res.data as String;
  }
}
