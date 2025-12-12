import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/api/dio_client.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/chat_service.dart';
import '../../data/services/community_service.dart';
import '../../data/services/goal_service.dart';
import '../../data/services/habit_service.dart';
import '../../data/services/journal_service.dart';
import '../../data/services/mood_service.dart';

final dioClientProvider = Provider<DioClient>((ref) => DioClient());

final authServiceProvider = Provider<AuthService>((ref) {
  final client = ref.watch(dioClientProvider);
  return AuthService(client);
});

final habitServiceProvider = Provider<HabitService>((ref) {
  final client = ref.watch(dioClientProvider);
  return HabitService(client);
});

final goalServiceProvider = Provider<GoalService>((ref) {
  final client = ref.watch(dioClientProvider);
  return GoalService(client);
});

final moodServiceProvider = Provider<MoodService>((ref) {
  final client = ref.watch(dioClientProvider);
  return MoodService(client);
});

final journalServiceProvider = Provider<JournalService>((ref) {
  final client = ref.watch(dioClientProvider);
  return JournalService(client);
});

final communityServiceProvider = Provider<CommunityService>((ref) {
  final client = ref.watch(dioClientProvider);
  return CommunityService(client);
});

final chatServiceProvider = Provider<ChatService>((ref) {
  final client = ref.watch(dioClientProvider);
  return ChatService(client);
});
