import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/goal_entity.dart';
import '../../domain/repositories/goal_repository.dart';
import 'app_providers.dart';
import 'auth_provider.dart';

class GoalListNotifier extends AsyncNotifier<List<GoalEntity>> {
  @override
  Future<List<GoalEntity>> build() async {
    final auth = ref.watch(authProvider);
    if (!auth.isAuthenticated) return [];
    final repo = ref.watch(goalServiceProvider) as GoalRepository;
    return repo.list(auth.user!.id!);
  }

  Future<void> createGoal(String description) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(goalServiceProvider);
      final auth = ref.read(authProvider);
      final created = await repo.create(
        GoalEntity(userId: auth.user!.id, description: description),
      );
      final list = await repo.list(auth.user!.id!);
      return [created, ...list];
    });
  }

  Future<void> toggleComplete(GoalEntity goal) async {
    final repo = ref.read(goalServiceProvider);
    await repo.complete(goal.id!);
    ref.invalidateSelf();
  }
}

final goalListProvider = AsyncNotifierProvider<GoalListNotifier, List<GoalEntity>>(
  GoalListNotifier.new,
);
