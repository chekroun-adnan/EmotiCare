class MoodModel {
  const MoodModel({
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

  factory MoodModel.fromJson(Map<String, dynamic> json) {
    return MoodModel(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      mood: json['mood'] as String? ?? '',
      note: json['note'] as String?,
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'mood': mood,
      'note': note,
      'timestamp': timestamp?.toIso8601String(),
    };
  }
}
