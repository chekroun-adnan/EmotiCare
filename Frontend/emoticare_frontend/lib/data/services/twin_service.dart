import '../../core/constants/endpoints.dart';
import '../../domain/entities/twin_entity.dart';
import '../../domain/repositories/twin_repository.dart';
import '../api/dio_client.dart';
import '../models/twin_model.dart';

class TwinService implements TwinRepository {
  TwinService(this._client);

  final DioClient _client;

  @override
  Future<TwinEntity> getTwin(String userId) async {
    final res = await _client.client.get('${Endpoints.twin}/$userId');
    return TwinEntity.fromModel(
      TwinModel.fromJson(res.data as Map<String, dynamic>),
    );
  }

  @override
  Future<TwinEntity> updateTwin(String userId) async {
    final res = await _client.client.post('${Endpoints.twinUpdate}/$userId');
    return TwinEntity.fromModel(
      TwinModel.fromJson(res.data as Map<String, dynamic>),
    );
  }
}

