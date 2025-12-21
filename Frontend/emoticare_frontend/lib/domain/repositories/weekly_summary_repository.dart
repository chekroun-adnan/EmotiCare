import '../models/weekly_summary_model.dart';

abstract class WeeklySummaryRepository {
  Future<WeeklySummaryModel> createSummary(String userId);
  Future<List<WeeklySummaryModel>> getSummariesForUser(String userId);
  Future<WeeklySummaryModel?> getSummaryById(String summaryId);
  Future<void> deleteSummary(String summaryId);
}
