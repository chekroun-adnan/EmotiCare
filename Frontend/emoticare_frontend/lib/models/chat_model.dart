class ChatResponse {
  final bool crisis;
  final String reply;
  final String? sentiment;
  final String? recommendations;
  final Map<String, dynamic>? actions;
  final List<dynamic>? goals;
  final List<dynamic>? habits;

  ChatResponse({
    required this.crisis,
    required this.reply,
    this.sentiment,
    this.recommendations,
    this.actions,
    this.goals,
    this.habits,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      crisis: json['crisis'] ?? false,
      reply: json['reply'] ?? '',
      sentiment: json['sentiment'],
      recommendations: json['recommendations'],
      actions: json['actions'],
      goals: json['goals'],
      habits: json['habits'],
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final String time;
  final String? sentiment;
  final String? recommendations;
  final bool isCrisis;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
    this.sentiment,
    this.recommendations,
    this.isCrisis = false,
  });
}

