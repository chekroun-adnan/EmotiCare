class ApiConstants {
  static const String baseUrl = 'http://localhost:8084';
  
  // Auth
  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/auth/register';
  
  // User
  static const String userMe = '$baseUrl/user/me';
  
  // Moods
  static const String moods = '$baseUrl/api/moods';
  static const String moodTrack = '$baseUrl/api/moods/track';
  static const String moodHistory = '$baseUrl/api/moods/history';
  static const String moodDistribution = '$baseUrl/api/moods/distribution';
  
  // Journal
  static const String journals = '$baseUrl/api/journals';
  
  // Goals
  static const String goals = '$baseUrl/api/goals';

  // Chat
  static const String chatSend = '$baseUrl/api/chat/send';
  static const String chatHistory = '$baseUrl/api/conversation/user'; // User chat history

  // Community
  static const String community = '$baseUrl/api/community/all';
  static const String communityPost = '$baseUrl/api/community/create';

  // Habits
  static const String habits = '$baseUrl/api/habits';
  static const String habitsUser = '$baseUrl/api/habits/user';
  static const String habitSuggest = '$baseUrl/api/habits/suggest';

  // Digital Twin
  static const String twin = '$baseUrl/api/twin';
  static const String twinUpdate = '$baseUrl/api/twin/update';

  // Therapy
  static const String therapyStart = '$baseUrl/api/therapy/start';
  static const String therapyEnd = '$baseUrl/api/therapy/end';
  static const String therapyUser = '$baseUrl/api/therapy/user';
  static const String therapySummarize = '$baseUrl/api/therapy/summarize';

  // Analytics
  static const String analyticsSummary = '$baseUrl/analytics/weekly-summary'; // Note: Controller uses @RequestParam User userId, which is odd (usually String ID), let's check.
  // Actually checking AnalyticsController: public String weeklySummary(@RequestParam User userId)
  // Spring Boot might try to convert String to User via converter? Or it expects a JSON body?
  // Given standard practices, it likely expects a String userId if not configured with a converter.
  // However, I'll assume it takes a userId string given the other controllers.
  // Wait, if it takes @RequestParam User userId, it might be looking for ?userId=... and mapping it?
  // Let's assume standard passing of userId for now.
  
  // Recommendations
  static const String recommendationActivities = '$baseUrl/api/recommendation/activities';
}
