import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/habit_entity.dart';
import '../../domain/repositories/habit_repository.dart';
import 'app_providers.dart';
import 'auth_provider.dart';

class HabitListNotifier extends AsyncNotifier<List<HabitEntity>> {
  @override
  Future<List<HabitEntity>> build() async {
    final auth = ref.watch(authProvider);
    if (!auth.isAuthenticated) return [];
    final repo = ref.watch(habitServiceProvider) as HabitRepository;
    return repo.list(auth.user!.id!);
  }

  Future<void> createHabit(HabitEntity habit) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(habitServiceProvider);
      final auth = ref.read(authProvider);
      final created = await repo.create(habit.copyWith(userId: auth.user!.id));
      final list = await repo.list(auth.user!.id!);
      return [created, ...list];
    });
  }

  Future<void> toggleCompleted(HabitEntity habit) async {
    final repo = ref.read(habitServiceProvider);
    await repo.complete(habit.id!);
    ref.invalidateSelf();
  }
}

final habitListProvider = AsyncNotifierProvider<HabitListNotifier, List<HabitEntity>>(
  HabitListNotifier.new,
);
