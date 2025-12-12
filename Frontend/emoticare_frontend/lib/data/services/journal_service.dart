import '../../core/constants/endpoints.dart';
import '../../domain/entities/journal_entity.dart';
import '../../domain/repositories/journal_repository.dart';
import '../api/dio_client.dart';
import '../models/journal_model.dart';

class JournalService implements JournalRepository {
  JournalService(this._client);

  final DioClient _client;

  @override
  Future<JournalEntity> create(String userId, String text) async {
    final res = await _client.client.post(
      Endpoints.journal,
      queryParameters: {'userId': userId, 'text': text},
    );
    return JournalEntity.fromModel(JournalModel.fromJson(res.data as Map<String, dynamic>));
  }

  @override
  Future<List<JournalEntity>> list(String userId) async {
    final res = await _client.client.get('${Endpoints.journalByUser}/$userId');
    final list = (res.data as List<dynamic>? ?? [])
        .map((e) => JournalEntity.fromModel(JournalModel.fromJson(e as Map<String, dynamic>)))
        .toList();
    return list;
  }
}
