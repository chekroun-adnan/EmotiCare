class TherapySession {
  final String id;
  final String userId;
  final DateTime startTime;
  final DateTime? endTime;
  final String? summary;
  final String status; // "ACTIVE", "COMPLETED"

  TherapySession({
    required this.id,
    required this.userId,
    required this.startTime,
    this.endTime,
    this.summary,
    required this.status,
  });

  factory TherapySession.fromJson(Map<String, dynamic> json) {
    return TherapySession(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      summary: json['summary'],
      status: json['status'] ?? 'ACTIVE',
    );
  }
}
