class Endpoints {
  Endpoints._();

  static const login = '/auth/login';
  static const register = '/auth/register';
  static const me = '/user/me';

  static const habits = '/api/habits';
  static const habitsByUser = '/api/habits/user';
  static const goals = '/api/goals';
  static const goalsByUser = '/api/goals/user';
  static const moods = '/api/moods';
  static const moodHistory = '/api/moods/history';
  static const journal = '/api/journals';
  static const journalByUser = '/api/journals/user';
  static const chatSend = '/chat/send';
  static const chatHistory = '/chat/history';
  static const communityAll = '/api/community/all';
  static const communityCreate = '/api/community/create';
  static const weeklySummaryUser = '/api/weekly-summary/user';
}
