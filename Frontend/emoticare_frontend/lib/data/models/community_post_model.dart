class CommunityPostModel {
  const CommunityPostModel({
    this.id,
    this.userId,
    this.text,
    this.timestamp,
  });

  final String? id;
  final String? userId;
  final String? text;
  final DateTime? timestamp;

  factory CommunityPostModel.fromJson(Map<String, dynamic> json) {
    return CommunityPostModel(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      text: json['text'] as String?,
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp'] as String) : null,
    );
  }
}
