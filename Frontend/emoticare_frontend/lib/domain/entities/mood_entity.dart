import '../../data/models/mood_model.dart';

class MoodEntity {
  const MoodEntity({
    this.id,
    this.userId,
    required this.mood,
    this.note,
    this.timestamp,
  });

  final String? id;
  final String? userId;
  final String mood;
  final String? note;
  final DateTime? timestamp;

  factory MoodEntity.fromModel(MoodModel model) => MoodEntity(
        id: model.id,
        userId: model.userId,
        mood: model.mood,
        note: model.note,
        timestamp: model.timestamp,
      );

  MoodModel toModel() => MoodModel(
        id: id,
        userId: userId,
        mood: mood,
        note: note,
        timestamp: timestamp,
      );
}
