import '../models/suggested_action_model.dart';

abstract class SuggestedActionRepository {
  Future<SuggestedActionModel> save(SuggestedActionModel action);
  Future<List<SuggestedActionModel>> getForUser(String userId);
  Future<void> delete(String userId, String id);
  Future<String> generateAndSave(String userId, String context);
}
