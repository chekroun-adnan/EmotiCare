import '../entities/mood_entity.dart';

abstract class MoodRepository {
  Future<MoodEntity> track(String userId, String mood, {String? note});
  Future<List<MoodEntity>> history(String userId);
}
