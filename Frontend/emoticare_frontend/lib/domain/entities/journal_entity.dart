import '../../data/models/journal_model.dart';

class JournalEntity {
  const JournalEntity({
    this.id,
    this.userId,
    required this.text,
    this.timestamp,
  });

  final String? id;
  final String? userId;
  final String text;
  final DateTime? timestamp;

  factory JournalEntity.fromModel(JournalModel model) => JournalEntity(
        id: model.id,
        userId: model.userId,
        text: model.text,
        timestamp: model.timestamp,
      );

  JournalModel toModel() => JournalModel(
        id: id,
        userId: userId,
        text: text,
        timestamp: timestamp,
      );
}
