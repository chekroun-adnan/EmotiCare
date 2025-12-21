import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/mood.dart';
import '../models/journal.dart';

import '../models/goal.dart';
import '../models/chat_model.dart';
import '../models/community_post.dart';
import '../models/habit.dart';
import '../models/digital_twin.dart';
import '../models/therapy_session.dart';
import '../services/api_service.dart';

class AppProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  ApiService get apiService => _apiService;
  
  User? _currentUser;
  List<Mood> _moods = [];
  List<Journal> _journals = [];
  List<Goal> _goals = [];
  List<ChatMessage> _chatHistory = [];
  List<CommunityPost> _communityPosts = [];
  List<Habit> _habits = [];
  List<TherapySession> _therapySessions = [];
  DigitalTwin? _digitalTwin;
  String _weeklySummary = "";
  
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  List<Mood> get moods => _moods;
  List<Journal> get journals => _journals;
  List<Goal> get goals => _goals;
  List<ChatMessage> get chatHistory => _chatHistory;
  List<CommunityPost> get communityPosts => _communityPosts;
  List<Habit> get habits => _habits;
  List<TherapySession> get therapySessions => _therapySessions;
  DigitalTwin? get digitalTwin => _digitalTwin;
  String get weeklySummary => _weeklySummary;
  
  bool get isLoading => _isLoading;

  Future<void> init() async {
    await _apiService.init();
    try {
        _currentUser = await _apiService.getMe();
        await loadDashboardData();
    } catch (e) {
        print("User not logged in or error: $e");
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _apiService.login(email, password);
      _currentUser = await _apiService.getMe();
      await loadDashboardData();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> loadDashboardData() async {
    if (_currentUser == null) return;
    final userId = _currentUser!.id;
    _moods = await _apiService.getMoodHistory(userId);
    _journals = await _apiService.getJournals(userId);
    _goals = await _apiService.getGoals(userId);
    _communityPosts = await _apiService.getCommunityPosts();
    _chatHistory = await _apiService.getChatHistory(userId);
    _habits = await _apiService.getHabits(userId);
    try{ _digitalTwin = await _apiService.getDigitalTwin(userId); } catch(e) {/* ignore */ }
    _therapySessions = await _apiService.getTherapySessions(userId);
    try{ _weeklySummary = await _apiService.getWeeklySummary(userId); } catch(e) {/* ignore */}
    notifyListeners();
  }
  
  // Habits
  Future<void> createHabit(String name, String description) async {
     if (_currentUser == null) return;
     final habit = Habit(id: '', userId: _currentUser!.id, name: name, description: description, completed: false);
     await _apiService.createHabit(habit);
     await loadDashboardData();
  }
  
  Future<void> completeHabit(String id) async {
    await _apiService.completeHabit(id);
    await loadDashboardData();
  }
  
  // Therapy
  Future<void> startTherapy() async {
     if (_currentUser == null) return;
     await _apiService.startTherapySession(_currentUser!.id);
     await loadDashboardData();
  }
  
  Future<void> sendMessage(String text) async {
    if (_currentUser == null) return;
    // Add user message immediately for UI
    _chatHistory.add(ChatMessage(text: text, isUser: true, time: 'Now'));
    notifyListeners();
    
    try {
      final response = await _apiService.sendChatMessage(_currentUser!.id, text);
      _chatHistory.add(ChatMessage(
        text: response.reply, 
        isUser: false, 
        time: 'Now',
        sentiment: response.sentiment,
        recommendations: response.recommendations,
        isCrisis: response.crisis,
      ));
      notifyListeners();
      
      // If new goals/habits were generated, reload dashboard
      if ((response.goals != null && response.goals!.isNotEmpty) || 
          (response.habits != null && response.habits!.isNotEmpty)) {
         await loadDashboardData();
      }
    } catch (e) {
      _chatHistory.add(ChatMessage(text: "Error connecting to coach.", isUser: false, time: 'Now'));
      notifyListeners();
    }
  }

  Future<void> createPost(String text) async {
    if(_currentUser == null) return;
    await _apiService.createCommunityPost(_currentUser!.id, text);
    await loadDashboardData();
  }
  
  Future<void> trackMood(String mood, String? note) async {
     if (_currentUser == null) return;
     await _apiService.trackMood(_currentUser!.id, mood, note);
     await loadDashboardData();
  }
  
  Future<void> createGoal(String description) async {
     if (_currentUser == null) return;
     final goal = Goal(id: '', userId: _currentUser!.id, description: description, completed: false);
     await _apiService.createGoal(goal);
     await loadDashboardData();
  }
  
  Future<void> toggleGoal(String id) async {
    await _apiService.toggleGoal(id);
    await loadDashboardData();
  }
}
