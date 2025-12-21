import '../entities/twin_entity.dart';

abstract class TwinRepository {
  Future<TwinEntity> getTwin(String userId);
  Future<TwinEntity> updateTwin(String userId);
}

