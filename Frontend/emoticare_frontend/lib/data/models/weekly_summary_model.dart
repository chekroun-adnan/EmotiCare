class WeeklySummaryModel {
  const WeeklySummaryModel({
    this.id,
    this.userId,
    this.summaryText,
    this.aiGeneratedAdvice,
  });

  final String? id;
  final String? userId;
  final String? summaryText;
  final String? aiGeneratedAdvice;

  factory WeeklySummaryModel.fromJson(Map<String, dynamic> json) {
    return WeeklySummaryModel(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      summaryText: json['summaryText'] as String?,
      aiGeneratedAdvice: json['aiGeneratedAdvice'] as String?,
    );
  }
}
