class DigitalTwin {
  final String userId;
  final String dominantEmotion;
  final String stressTrigger;
  final String preferredCoping;

  DigitalTwin({
    required this.userId,
    required this.dominantEmotion,
    required this.stressTrigger,
    required this.preferredCoping,
  });

  factory DigitalTwin.fromJson(Map<String, dynamic> json) {
    return DigitalTwin(
      userId: json['userId'] ?? '',
      dominantEmotion: json['dominantEmotion'] ?? 'Neutral',
      stressTrigger: json['stressTrigger'] ?? 'Unknown',
      preferredCoping: json['preferredCoping'] ?? 'Unknown',
    );
  }
}
