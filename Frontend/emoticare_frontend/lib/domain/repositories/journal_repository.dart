import '../entities/journal_entity.dart';

abstract class JournalRepository {
  Future<JournalEntity> create(String userId, String text);
  Future<List<JournalEntity>> list(String userId);
}
