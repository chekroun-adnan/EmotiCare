class Mood {
  final String id;
  final String userId;
  final String mood; // "Happy", "Sad", etc.
  final String? note;
  final DateTime? timestamp; // Backend might send this

  Mood({
    required this.id,
    required this.userId,
    required this.mood,
    this.note,
    this.timestamp,
  });

  factory Mood.fromJson(Map<String, dynamic> json) {
    return Mood(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      mood: json['mood'] ?? '',
      note: json['note'],
      timestamp: json['timestamp'] != null ? DateTime.tryParse(json['timestamp']) : null,
    );
  }
}
