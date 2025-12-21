import '../../data/models/twin_model.dart';

class TwinEntity {
  const TwinEntity({
    this.userId,
    this.dominantEmotion,
    this.preferredCoping,
    this.stressTrigger,
    this.updatedAt,
  });

  final String? userId;
  final String? dominantEmotion;
  final String? preferredCoping;
  final String? stressTrigger;
  final DateTime? updatedAt;

  factory TwinEntity.fromModel(TwinModel model) => TwinEntity(
        userId: model.userId,
        dominantEmotion: model.dominantEmotion,
        preferredCoping: model.preferredCoping,
        stressTrigger: model.stressTrigger,
        updatedAt: model.updatedAt,
      );

  TwinModel toModel() => TwinModel(
        userId: userId,
        dominantEmotion: dominantEmotion,
        preferredCoping: preferredCoping,
        stressTrigger: stressTrigger,
        updatedAt: updatedAt,
      );
}

