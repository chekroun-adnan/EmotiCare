import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/mood_entity.dart';
import '../../domain/repositories/mood_repository.dart';
import 'app_providers.dart';
import 'auth_provider.dart';

class MoodHistoryNotifier extends AsyncNotifier<List<MoodEntity>> {
  @override
  Future<List<MoodEntity>> build() async {
    final auth = ref.watch(authProvider);
    if (!auth.isAuthenticated) return [];
    final repo = ref.watch(moodServiceProvider) as MoodRepository;
    return repo.history(auth.user!.id!);
  }

  Future<void> track(String mood, {String? note}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final auth = ref.read(authProvider);
      final repo = ref.read(moodServiceProvider);
      await repo.track(auth.user!.id!, mood, note: note);
      return repo.history(auth.user!.id!);
    });
  }
}

final moodHistoryProvider = AsyncNotifierProvider<MoodHistoryNotifier, List<MoodEntity>>(
  MoodHistoryNotifier.new,
);
