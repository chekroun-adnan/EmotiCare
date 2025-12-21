import '../../domain/repositories/proactive_repository.dart';
import '../api/dio_client.dart';

class ProactiveService implements ProactiveRepository {
  ProactiveService(this._client);

  final DioClient _client;

  @override
  Future<String> manualCheckIn(String userId) async {
    final res = await _client.client.get('/api/proactive/manual-checkin/$userId');
    return res.data as String;
  }
}
