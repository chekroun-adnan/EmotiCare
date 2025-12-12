import '../../core/constants/endpoints.dart';
import '../../domain/entities/goal_entity.dart';
import '../../domain/repositories/goal_repository.dart';
import '../api/dio_client.dart';
import '../models/goal_model.dart';

class GoalService implements GoalRepository {
  GoalService(this._client);

  final DioClient _client;

  @override
  Future<List<GoalEntity>> list(String userId) async {
    final res = await _client.client.get('${Endpoints.goalsByUser}/$userId');
    final list = (res.data as List<dynamic>? ?? [])
        .map((e) => GoalEntity.fromModel(GoalModel.fromJson(e as Map<String, dynamic>)))
        .toList();
    return list;
  }

  @override
  Future<GoalEntity> create(GoalEntity goal) async {
    final res = await _client.client.post(
      Endpoints.goals,
      data: goal.toModel().toJson(),
    );
    return GoalEntity.fromModel(GoalModel.fromJson(res.data as Map<String, dynamic>));
  }

  @override
  Future<GoalEntity> update(GoalEntity goal) async {
    if (goal.id == null) throw Exception('Goal id is required for update');
    final res = await _client.client.put(
      '${Endpoints.goals}/${goal.id}',
      data: goal.toModel().toJson(),
    );
    return GoalEntity.fromModel(GoalModel.fromJson(res.data as Map<String, dynamic>));
  }

  @override
  Future<void> delete(String id) async {
    await _client.client.delete('${Endpoints.goals}/$id');
  }

  @override
  Future<void> complete(String id) async {
    await _client.client.post('${Endpoints.goals}/$id/complete');
  }
}
