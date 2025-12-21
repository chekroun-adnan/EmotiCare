import '../models/therapy_session_model.dart';

abstract class TherapySessionRepository {
  Future<TherapySessionModel> startSession(String userId);
  Future<TherapySessionModel> endSession(String sessionId);
  Future<TherapySessionModel?> getSession(String sessionId);
  Future<List<TherapySessionModel>> getSessionsForUser(String userId);
  Future<String> summarizeSession(String sessionId);
}
