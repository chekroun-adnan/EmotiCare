import '../../domain/repositories/suggested_action_repository.dart';
import '../api/dio_client.dart';
import '../models/suggested_action_model.dart';

class SuggestedActionService implements SuggestedActionRepository {
  SuggestedActionService(this._client);

  final DioClient _client;

  @override
  Future<SuggestedActionModel> save(SuggestedActionModel action) async {
    final res = await _client.client.post(
      '/api/actions',
      data: action.toJson(),
    );
    return SuggestedActionModel.fromJson(res.data as Map<String, dynamic>);
  }

  @override
  Future<List<SuggestedActionModel>> getForUser(String userId) async {
    final res = await _client.client.get(
      '/api/actions/user/$userId',
    );
    final list = (res.data as List<dynamic>? ?? [])
        .map((e) => SuggestedActionModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return list;
  }

  @override
  Future<void> delete(String userId, String id) async {
    await _client.client.delete(
      '/api/actions/$userId',
      queryParameters: {'id': id},
    );
  }

  @override
  Future<String> generateAndSave(String userId, String context) async {
    final res = await _client.client.post(
      '/api/actions/generate',
      queryParameters: {
        'userId': userId,
        'context': context,
      },
    );
    return res.data as String;
  }
}
