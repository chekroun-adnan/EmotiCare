import '../../core/constants/endpoints.dart';
import '../../domain/entities/mood_entity.dart';
import '../../domain/repositories/mood_repository.dart';
import '../api/dio_client.dart';
import '../models/mood_model.dart';

class MoodService implements MoodRepository {
  MoodService(this._client);

  final DioClient _client;

  @override
  Future<MoodEntity> track(String userId, String mood, {String? note}) async {
    final res = await _client.client.post(
      '${Endpoints.moods}/track',
      queryParameters: {'userId': userId, 'mood': mood, 'note': note},
    );
    return MoodEntity.fromModel(MoodModel.fromJson(res.data as Map<String, dynamic>));
  }

  @override
  Future<List<MoodEntity>> history(String userId) async {
    final res = await _client.client.get('${Endpoints.moodHistory}/$userId');
    final list = (res.data as List<dynamic>? ?? [])
        .map((e) => MoodEntity.fromModel(MoodModel.fromJson(e as Map<String, dynamic>)))
        .toList();
    return list;
  }
}
