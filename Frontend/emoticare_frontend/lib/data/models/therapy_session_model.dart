class TherapySessionModel {
  const TherapySessionModel({
    this.id,
    this.userId,
    this.startTime,
    this.endTime,
  });

  final String? id;
  final String? userId;
  final DateTime? startTime;
  final DateTime? endTime;

  factory TherapySessionModel.fromJson(Map<String, dynamic> json) {
    return TherapySessionModel(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      startTime: json['startTime'] != null ? DateTime.parse(json['startTime'] as String) : null,
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime'] as String) : null,
    );
  }
}
