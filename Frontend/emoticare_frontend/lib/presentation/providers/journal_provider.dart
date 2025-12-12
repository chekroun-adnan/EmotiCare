import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/journal_entity.dart';
import '../../domain/repositories/journal_repository.dart';
import 'app_providers.dart';
import 'auth_provider.dart';

class JournalListNotifier extends AsyncNotifier<List<JournalEntity>> {
  @override
  Future<List<JournalEntity>> build() async {
    final auth = ref.watch(authProvider);
    if (!auth.isAuthenticated) return [];
    final repo = ref.watch(journalServiceProvider) as JournalRepository;
    return repo.list(auth.user!.id!);
  }

  Future<void> createEntry(String text) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final auth = ref.read(authProvider);
      final repo = ref.read(journalServiceProvider);
      await repo.create(auth.user!.id!, text);
      return repo.list(auth.user!.id!);
    });
  }
}

final journalListProvider =
    AsyncNotifierProvider<JournalListNotifier, List<JournalEntity>>(JournalListNotifier.new);
