import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/conversation_models.dart';
import '../../domain/repositories/chat_repository.dart';
import 'app_providers.dart';
import 'auth_provider.dart';

final chatSendingProvider = StateProvider<bool>((ref) => false);

class ChatHistoryNotifier extends AsyncNotifier<List<ConversationMessageModel>> {
  @override
  Future<List<ConversationMessageModel>> build() async {
    final auth = ref.watch(authProvider);
    if (!auth.isAuthenticated) return [];
    final repo = ref.watch(chatServiceProvider) as ChatRepository;
    return repo.history(auth.user!.id!);
  }

  Future<void> send(String message) async {
    final auth = ref.read(authProvider);
    if (!auth.isAuthenticated) return;
    ref.read(chatSendingProvider.notifier).state = true;
    try {
      final repo = ref.read(chatServiceProvider);
      await repo.send(auth.user!.id!, message);
      state = AsyncData(await repo.history(auth.user!.id!));
    } finally {
      ref.read(chatSendingProvider.notifier).state = false;
    }
  }
}

final chatHistoryProvider =
    AsyncNotifierProvider<ChatHistoryNotifier, List<ConversationMessageModel>>(ChatHistoryNotifier.new);
