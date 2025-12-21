import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/proactive_repository.dart';
import 'app_providers.dart';
import 'auth_provider.dart';

class ProactiveNotifier extends AsyncNotifier<String?> {
  @override
  Future<String?> build() async {
    return null;
  }

  Future<void> manualCheckIn() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final auth = ref.read(authProvider);
      if (!auth.isAuthenticated) return 'Not authenticated';
      final repo = ref.read(proactiveServiceProvider) as ProactiveRepository;
      final res = await repo.manualCheckIn(auth.user!.id!);
      return res;
    });
  }
}

final proactiveProvider = AsyncNotifierProvider<ProactiveNotifier, String?>(
  ProactiveNotifier.new,
);
