class FeedbackModel {
  const FeedbackModel({
    this.id,
    this.userId,
    this.messageId,
    this.rating,
    this.comment,
  });

  final String? id;
  final String? userId;
  final String? messageId;
  final int? rating;
  final String? comment;

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      messageId: json['messageId'] as String?,
      rating: json['rating'] as int?,
      comment: json['comment'] as String?,
    );
  }
}
