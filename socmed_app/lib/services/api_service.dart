import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';

class ApiService {
  // --- GEMINI CONFIGURATION ---
  static const String apiKey = ''; // ← Replace with your key!
  static const String apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';

  /// 1. REAL API CALL: Generate an AI Caption for a post
  /// This follows the exact structure of your GeminiService request
  static Future<String> generateAiCaption(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'role': 'user',
              'parts': [
                {'text': "Write a short, engaging Instagram caption for: $prompt"}
              ],
            }
          ],
          'generationConfig': {
            'temperature': 0.7,
            'maxOutputTokens': 100,
          }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        return 'Error: Could not generate caption (${response.statusCode})';
      }
    } catch (e) {
      return 'Network Error: $e';
    }
  }

  /// 2. FEED API CALL: Fetching the Post List
  /// We keep this static to match your GeminiService style
  static Future<List<Post>> fetchPosts() async {
    try {
      // In a real app, you would hit your backend:
      // final response = await http.get(Uri.parse('https://your-backend.com/posts'));

      // Simulating network delay for the feed
      await Future.delayed(const Duration(seconds: 1));

      // Returning Mock Data that fits our Model
      return [
        Post(
          id: 1,
          username: '@BryanTheCoder',
          profileImage: 'https://i.pravatar.cc/150?u=1',
          caption: 'Building the UI with Gemini integration! ',
          imageUrl: 'https://images.stockcake.com/public/d/c/4/dc43867d-5a5b-49e4-82e7-3eb135eb8dea_large/coding-classroom-activity-stockcake.jpg',
        ),
        Post(
          id: 2,
          username: '@CodeWith_tey',
          profileImage: 'https://i.pravatar.cc/150?u=2',
          caption: 'Coding with perfect performance.... ',
          videoUrl: 'https://media.istockphoto.com/id/873227696/video/hackers-program-code-running-on-screen.mp4?s=mp4-640x640-is&k=20&c=QS5UByB741HPl9GFdVteUWqLTULAfWTyjmsb5-MZkOU=',
        ),
      ];
    } catch (e) {
      throw Exception("Error connecting to server: $e");
    }
  }
}
