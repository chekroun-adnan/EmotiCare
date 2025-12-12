import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/community_post_model.dart';
import '../../domain/repositories/community_repository.dart';
import 'app_providers.dart';
import 'auth_provider.dart';

class CommunityNotifier extends AsyncNotifier<List<CommunityPostModel>> {
  @override
  Future<List<CommunityPostModel>> build() async {
    final auth = ref.watch(authProvider);
    if (!auth.isAuthenticated) return [];
    final repo = ref.watch(communityServiceProvider) as CommunityRepository;
    return repo.all();
  }

  Future<void> create(String text) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final auth = ref.read(authProvider);
      final repo = ref.read(communityServiceProvider);
      await repo.create(auth.user!.id!, text);
      return repo.all();
    });
  }
}

final communityProvider =
    AsyncNotifierProvider<CommunityNotifier, List<CommunityPostModel>>(CommunityNotifier.new);
