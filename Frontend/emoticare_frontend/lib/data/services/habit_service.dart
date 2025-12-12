import '../../core/constants/endpoints.dart';
import '../../domain/entities/habit_entity.dart';
import '../../domain/repositories/habit_repository.dart';
import '../api/dio_client.dart';
import '../models/habit_model.dart';

class HabitService implements HabitRepository {
  HabitService(this._client);

  final DioClient _client;

  @override
  Future<List<HabitEntity>> list(String userId) async {
    final res = await _client.client.get('${Endpoints.habitsByUser}/$userId');
    final list = (res.data as List<dynamic>? ?? [])
        .map((e) => HabitEntity.fromModel(HabitModel.fromJson(e as Map<String, dynamic>)))
        .toList();
    return list;
  }

  @override
  Future<HabitEntity> create(HabitEntity habit) async {
    final res = await _client.client.post(
      Endpoints.habits,
      data: habit.toModel().toJson(),
    );
    return HabitEntity.fromModel(HabitModel.fromJson(res.data as Map<String, dynamic>));
  }

  @override
  Future<HabitEntity> update(HabitEntity habit) async {
    if (habit.id == null) throw Exception('Habit id is required for update');
    final res = await _client.client.put(
      '${Endpoints.habits}/${habit.id}',
      data: habit.toModel().toJson(),
    );
    return HabitEntity.fromModel(HabitModel.fromJson(res.data as Map<String, dynamic>));
  }

  @override
  Future<void> delete(String userId, String id) async {
    await _client.client.delete('${Endpoints.habitsByUser}/$userId/$id');
  }

  @override
  Future<void> complete(String id) async {
    await _client.client.post('${Endpoints.habits}/complete/$id');
  }
}
