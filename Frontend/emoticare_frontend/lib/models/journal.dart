class Journal {
  final String id;
  final String userId;
  final String text;
  final DateTime? timestamp;

  Journal({
    required this.id,
    required this.userId,
    required this.text,
    this.timestamp,
  });

  factory Journal.fromJson(Map<String, dynamic> json) {
    return Journal(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      text: json['text'] ?? '',
      timestamp: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
    );
  }
}
