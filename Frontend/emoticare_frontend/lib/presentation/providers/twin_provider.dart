import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/twin_entity.dart';
import '../../domain/repositories/twin_repository.dart';
import 'app_providers.dart';
import 'auth_provider.dart';

class TwinNotifier extends AsyncNotifier<TwinEntity> {
  @override
  Future<TwinEntity> build() async {
    final auth = ref.watch(authProvider);
    if (!auth.isAuthenticated) {
      return const TwinEntity();
    }
    final repo = ref.watch(twinServiceProvider) as TwinRepository;
    return repo.getTwin(auth.user!.id!);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final auth = ref.read(authProvider);
      final repo = ref.read(twinServiceProvider);
      return repo.getTwin(auth.user!.id!);
    });
  }

  Future<void> updateTwin() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final auth = ref.read(authProvider);
      final repo = ref.read(twinServiceProvider);
      return repo.updateTwin(auth.user!.id!);
    });
  }
}

final twinProvider = AsyncNotifierProvider<TwinNotifier, TwinEntity>(
  TwinNotifier.new,
);

