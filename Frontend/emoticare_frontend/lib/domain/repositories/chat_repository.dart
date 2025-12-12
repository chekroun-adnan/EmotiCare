import '../../data/models/conversation_models.dart';

abstract class ChatRepository {
  Future<String> send(String userId, String message);
  Future<List<ConversationMessageModel>> history(String userId);
}
