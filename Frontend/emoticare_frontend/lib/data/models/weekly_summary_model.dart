class WeeklySummaryModel {
  const WeeklySummaryModel({
    this.id,
    this.userId,
    this.summaryText,
    this.moodIds,
    this.journalIds,
    this.habitIds,
    this.aiGeneratedAdvice,
  });

  final String? id;
  final String? userId;
  final String? summaryText;
  final List<String>? moodIds;
  final List<String>? journalIds;
  final List<String>? habitIds;
  final String? aiGeneratedAdvice;

  factory WeeklySummaryModel.fromJson(Map<String, dynamic> json) {
    return WeeklySummaryModel(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      summaryText: json['summaryText'] as String?,
      moodIds: (json['moodIds'] as List<dynamic>?)?.map((e) => e as String).toList(),
      journalIds: (json['journalIds'] as List<dynamic>?)?.map((e) => e as String).toList(),
      habitIds: (json['habitIds'] as List<dynamic>?)?.map((e) => e as String).toList(),
      aiGeneratedAdvice: json['aiGeneratedAdvice'] as String?,
    );
  }
}
