class JournalModel {
  const JournalModel({
    this.id,
    this.userId,
    required this.text,
    this.timestamp,
  });

  final String? id;
  final String? userId;
  final String text;
  final DateTime? timestamp;

  factory JournalModel.fromJson(Map<String, dynamic> json) {
    return JournalModel(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      text: json['text'] as String? ?? '',
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'text': text,
      'timestamp': timestamp?.toIso8601String(),
    };
  }
}
