class ConversationMessageModel {
  const ConversationMessageModel({
    this.id,
    this.userId,
    this.sender,
    this.content,
    this.sentiment,
    this.timestamp,
  });

  final String? id;
  final String? userId;
  final String? sender;
  final String? content;
  final String? sentiment;
  final DateTime? timestamp;

  factory ConversationMessageModel.fromJson(Map<String, dynamic> json) {
    return ConversationMessageModel(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      sender: json['sender'] as String?,
      content: json['content'] as String?,
      sentiment: json['sentiment'] as String?,
      timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp'] as String) : null,
    );
  }
}

class ConversationResultModel {
  const ConversationResultModel({this.reply});
  final String? reply;

  factory ConversationResultModel.fromJson(Map<String, dynamic> json) {
    return ConversationResultModel(reply: json['reply'] as String?);
  }
}

class ChatResponseModel {
  final bool crisis;
  final String? reply;
  final String? sentiment;
  final String? recommendations;
  final Map<String, dynamic>? actions;

  const ChatResponseModel({
    required this.crisis,
    this.reply,
    this.sentiment,
    this.recommendations,
    this.actions,
  });

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatResponseModel(
      crisis: json['crisis'] as bool? ?? false,
      reply: json['reply'] as String?,
      sentiment: json['sentiment'] as String?,
      recommendations: json['recommendations'] as String?,
      actions: json['actions'] as Map<String, dynamic>?,
    );
  }
}
