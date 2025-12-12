import '../../core/constants/endpoints.dart';
import '../../domain/repositories/chat_repository.dart';
import '../api/dio_client.dart';
import '../models/conversation_models.dart';

class ChatService implements ChatRepository {
  ChatService(this._client);

  final DioClient _client;

  @override
  Future<String> send(String userId, String message) async {
    final res = await _client.client.post(
      Endpoints.chatSend,
      queryParameters: {'userId': userId, 'message': message},
    );
    return res.data?.toString() ?? '';
  }

  @override
  Future<List<ConversationMessageModel>> history(String userId) async {
    final res = await _client.client.get(
      Endpoints.chatHistory,
      queryParameters: {'userId': userId},
    );
    final list = (res.data as List<dynamic>? ?? [])
        .map((e) => ConversationMessageModel.fromJson(e as Map<String, dynamic>))
        .toList();
    return list;
  }
}
