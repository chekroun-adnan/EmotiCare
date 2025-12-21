import '../../core/constants/endpoints.dart';
import '../../domain/repositories/weekly_summary_repository.dart';
import '../api/dio_client.dart';
import '../models/weekly_summary_model.dart';

class WeeklySummaryService implements WeeklySummaryRepository {
  WeeklySummaryService(this._client);

  final DioClient _client;

  @override
  Future<WeeklySummaryModel> createSummary(String userId) async {
    final res = await _client.client.post(
      '/api/weekly-summary/create/$userId',
    );
    return WeeklySummaryModel.fromJson(res.data as Map<String, dynamic>);
  }

  @override
  Future<List<WeeklySummaryModel>> getSummariesForUser(String userId) async {
    final res = await _client.client.get(
      Endpoints.weeklySummaryUser.replaceAll('{userId}', userId),
    );
    final list = (res.data as List<dynamic>? ?? [])
        .map((e) => WeeklySummaryModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return list;
  }

  @override
  Future<WeeklySummaryModel?> getSummaryById(String summaryId) async {
    try {
      final res = await _client.client.get(
        '/api/weekly-summary/$summaryId',
      );
      return WeeklySummaryModel.fromJson(res.data as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> deleteSummary(String summaryId) async {
    await _client.client.delete(
      '/api/weekly-summary/$summaryId',
    );
  }
}
