class TwinModel {
  const TwinModel({
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

  factory TwinModel.fromJson(Map<String, dynamic> json) {
    return TwinModel(
      userId: json['userId'] as String?,
      dominantEmotion: json['dominantEmotion'] as String?,
      preferredCoping: json['preferredCoping'] as String?,
      stressTrigger: json['stressTrigger'] as String?,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'dominantEmotion': dominantEmotion,
      'preferredCoping': preferredCoping,
      'stressTrigger': stressTrigger,
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

