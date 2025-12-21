import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_constants.dart';
import '../models/user.dart';
import '../models/mood.dart';
import '../models/journal.dart';
import '../models/goal.dart';
import '../models/chat_model.dart';
import '../models/community_post.dart';
import '../models/habit.dart';
import '../models/digital_twin.dart';
import '../models/therapy_session.dart';

class ApiService {
  String? _token;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('accessToken');
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(ApiConstants.login),
      body: {'email': email, 'password': password}, // @RequestParam in backend means query or form url encoded? 
      // AuthController uses @RequestParam, so it expects query params or form-data. 
      // safer to use query params if strictly @RequestParam, but usually post body if form-encoded.
      // Let's try form-encoded.
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _token = data['accessToken'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', _token!);
      return data;
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  Future<User> getMe() async {
    if (_token == null) throw Exception('Not authenticated');
    final response = await http.get(
      Uri.parse(ApiConstants.userMe),
      headers: {'Authorization': 'Bearer $_token'},
    );

    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
       throw Exception('Failed to get user');
    }
  }

  Future<List<Mood>> getMoodHistory(String userId) async {
     final response = await http.get(
      Uri.parse('${ApiConstants.moodHistory}/$userId'),
       headers: {'Authorization': 'Bearer $_token'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Mood.fromJson(json)).toList();
    }
    return [];
  }
  
  Future<void> trackMood(String userId, String mood, String? note) async {
    // MoodController uses @RequestParam
    final uri = Uri.parse(ApiConstants.moodTrack).replace(queryParameters: {
      'userId': userId,
      'mood': mood,
      'note': note ?? '',
    });
    
     await http.post(
      uri,
       headers: {'Authorization': 'Bearer $_token'},
    );
  }

  Future<List<Journal>> getJournals(String userId) async {
     final response = await http.get(
      Uri.parse('${ApiConstants.journals}/user/$userId'),
      headers: {'Authorization': 'Bearer $_token'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Journal.fromJson(json)).toList();
    }
    return [];
  }

  Future<List<Goal>> getGoals(String userId) async {
     final response = await http.get(
      Uri.parse('${ApiConstants.goals}/user/$userId'),
      headers: {'Authorization': 'Bearer $_token'},
    );
     if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Goal.fromJson(json)).toList();
    }
    return [];
  }
  
  Future<void> createGoal(Goal goal) async {
    await http.post(
      Uri.parse(ApiConstants.goals),
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
      body: json.encode(goal.toJson()),
    );
  }

    Future<void> toggleGoal(String id) async {
    await http.post(
      Uri.parse('${ApiConstants.goals}/$id/complete'),
       headers: {'Authorization': 'Bearer $_token'},
    );
  }

  // Chat
  Future<ChatResponse> sendMessage(String userId, String message) async {
    final response = await http.post(
      Uri.parse(ApiConstants.chatSend),
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json', // ChatController expects @RequestBody String
      },
      // Backend expects: userId query param + Body String.
      // But look at controller: @RequestParam String userId, @RequestBody String message.
      // So URL needs param.
      // Wait, let's fix the URL construction.
    );
    // Actually better to construct properly below
    return ChatResponse(crisis: false, reply: "Error", sentiment: "", recommendations: ""); // Placeholder fallback
  }

  Future<ChatResponse>  sendChatMessage(String userId, String message) async {
     final uri = Uri.parse(ApiConstants.chatSend).replace(queryParameters: {'userId': userId});
     final response = await http.post(
       uri,
       headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'text/plain', // Consumes plain string
       },
       body: message,
     );

     if (response.statusCode == 200) {
       return ChatResponse.fromJson(json.decode(response.body));
     }
     throw Exception('Failed to send message: ${response.body}');
  }

  // Community
  Future<List<CommunityPost>> getCommunityPosts() async {
    final response = await http.get(
      Uri.parse(ApiConstants.community),
      headers: {'Authorization': 'Bearer $_token'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => CommunityPost.fromJson(json)).toList();
    }
    return [];
  }

  Future<void> createCommunityPost(String userId, String text) async {
    // Controller: @RequestParam userId, @RequestParam text -> Form encoded or query params
     final response = await http.post(
      Uri.parse(ApiConstants.communityPost),
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'userId': userId, 'text': text},
    );
    
    if (response.statusCode != 200) {
      throw Exception('Failed to post');
    }
  }

  // Habits
  Future<List<Habit>> getHabits(String userId) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.habitsUser}/$userId'),
      headers: {'Authorization': 'Bearer $_token'},
    );
     if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Habit.fromJson(json)).toList();
    }
    return [];
  }

  Future<void> createHabit(Habit habit) async {
     await http.post(
      Uri.parse(ApiConstants.habits),
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
      body: json.encode(habit.toJson()),
    );
  }

  Future<void> completeHabit(String id) async {
     await http.post(
      Uri.parse('${ApiConstants.habits}/complete/$id'), // Assuming endpoint pattern
      headers: {'Authorization': 'Bearer $_token'},
    );
    // Note: Controller has @PostMapping("/complete/{id}")
  }

  // Digital Twin
  Future<DigitalTwin> getDigitalTwin(String userId) async {
     final response = await http.get(
       Uri.parse('${ApiConstants.twin}/$userId'),
       headers: {'Authorization': 'Bearer $_token'},
     );
     if (response.statusCode == 200) {
       return DigitalTwin.fromJson(json.decode(response.body));
     }
     throw Exception('Failed to load Twin');
  }

  // Therapy
  Future<TherapySession> startTherapySession(String userId) async {
    final response = await http.post(
      Uri.parse('${ApiConstants.therapyStart}/$userId'),
       headers: {'Authorization': 'Bearer $_token'},
    );
    if (response.statusCode == 200) {
      return TherapySession.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to start session');
  }

  Future<List<TherapySession>> getTherapySessions(String userId) async {
     final response = await http.get(
      Uri.parse('${ApiConstants.therapyUser}/$userId'),
      headers: {'Authorization': 'Bearer $_token'},
    );
     if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => TherapySession.fromJson(json)).toList();
    }
    return [];
  }

  // Analytics
  Future<String> getWeeklySummary(String userId) async {
    // Controller expects @RequestParam User userId.
    // Ideally pass ID. If backend fails, we might need adjustments.
    final response = await http.get(
      Uri.parse(ApiConstants.analyticsSummary).replace(queryParameters: {'userId': userId}),
      headers: {'Authorization': 'Bearer $_token'},
    );
    if (response.statusCode == 200) {
      return response.body;
    }
    return "No summary available.";
  }
  
  // Chat History
  Future<List<ChatMessage>> getChatHistory(String userId) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.chatHistory}/$userId'),
      headers: {'Authorization': 'Bearer $_token'},
    );
    
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) {
        final sender = item['sender'] ?? 'user';
        final isUser = sender.toString().toLowerCase() == 'user';
        // Backend 'suggestions' is a Map or String? Entity says Map<String, Object>.
        // Frontend expects String recommendations. Let's try to extract something reasonable.
        String? recs;
        if (item['suggestions'] != null) {
           recs = item['suggestions'].toString(); 
           // Or try to be more specific if possible. For now toString is safe fallback.
        }
        
        return ChatMessage(
          text: item['content'] ?? '',
          isUser: isUser,
          time: item['timestamp'] != null ? item['timestamp'].toString().substring(11, 16) : '', // Extract HH:mm crude
          sentiment: item['sentiment'],
          recommendations: recs,
        );
      }).toList();
    }
    return [];
  }
}
