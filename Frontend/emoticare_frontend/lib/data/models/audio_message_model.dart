class AudioMessageModel {
  const AudioMessageModel({
    this.id,
    this.userId,
    this.url,
    this.timestamp,
  });

  final String? id;
  final String? userId;
  final String? url;
  final DateTime? timestamp;

  factory AudioMessageModel.fromJson(Map<String, dynamic> json) {
    return AudioMessageModel(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      url: json['url'] as String?,
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp'] as String) : null,
    );
  }
}
