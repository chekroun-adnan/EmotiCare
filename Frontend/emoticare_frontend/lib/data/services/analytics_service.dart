import '../../domain/repositories/analytics_repository.dart';
import '../api/dio_client.dart';

class AnalyticsService implements AnalyticsRepository {
  AnalyticsService(this._client);

  final DioClient _client;

  @override
  Future<String> getWeeklySummary(String userId) async {
    final res = await _client.client.get(
      '/analytics/weekly-summary',
      queryParameters: {'userId': userId},
    );
    return res.data as String;
  }
}
