import '../../domain/repositories/therapy_session_repository.dart';
import '../api/dio_client.dart';
import '../models/therapy_session_model.dart';

class TherapySessionService implements TherapySessionRepository {
  TherapySessionService(this._client);

  final DioClient _client;

  @override
  Future<TherapySessionModel> startSession(String userId) async {
    final res = await _client.client.post(
      '/api/therapy/start/$userId',
    );
    return TherapySessionModel.fromJson(res.data as Map<String, dynamic>);
  }

  @override
  Future<TherapySessionModel> endSession(String sessionId) async {
    final res = await _client.client.post(
      '/api/therapy/end/$sessionId',
    );
    return TherapySessionModel.fromJson(res.data as Map<String, dynamic>);
  }

  @override
  Future<TherapySessionModel?> getSession(String sessionId) async {
    try {
      final res = await _client.client.get(
        '/api/therapy/$sessionId',
      );
      return TherapySessionModel.fromJson(res.data as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<TherapySessionModel>> getSessionsForUser(String userId) async {
    final res = await _client.client.get(
      '/api/therapy/user/$userId',
    );
    final list = (res.data as List<dynamic>? ?? [])
        .map((e) => TherapySessionModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return list;
  }

  @override
  Future<String> summarizeSession(String sessionId) async {
    final res = await _client.client.get(
      '/api/therapy/summarize/$sessionId',
    );
    return res.data as String;
  }
}
