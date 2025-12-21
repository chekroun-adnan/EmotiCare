class CommunityPost {
  final String id;
  final String userId;
  final String text;
  final DateTime? timestamp;

  CommunityPost({
    required this.id,
    required this.userId,
    required this.text,
    this.timestamp,
  });

  factory CommunityPost.fromJson(Map<String, dynamic> json) {
    return CommunityPost(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      text: json['text'] ?? '',
      timestamp: json['timestamp'] != null ? DateTime.tryParse(json['timestamp']) : null,
    );
  }
}
