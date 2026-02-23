import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/post_model.dart';
import '../services/api_service.dart'; // Import Service
import '../widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late Future<List<Post>> _postsFuture;

  // --- CUSTOM DESIGN COLORS ---
  final Color primaryDark = const Color(0xFFEDFFEA);   // Charcoal
  final Color accentMuted = const Color(0xFFBBB197);   // Muted Green
  final Color highlightGreen = const Color(0xFF36403A); // Vibrant Green

  @override
  void initState() {
    super.initState();
    _postsFuture = ApiService.fetchPosts();
  }

  void _loadPosts() {
    setState(() {
      _postsFuture = ApiService.fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background using the primary dark shade
      backgroundColor: primaryDark,
      appBar: AppBar(
        title: Text(
          "InstaTech",
          style: GoogleFonts.elsieSwashCaps( // 2. Use the Elsie Swash Caps font
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
            color: highlightGreen,
            fontSize: 24, // Optional: You might want to increase size for this font style
          ),
        ),
        backgroundColor: primaryDark,
        elevation: 0,
        centerTitle: false,
        // Separation line using the muted green with low opacity
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: accentMuted.withOpacity(0.3),
            height: 1.0,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.auto_awesome, color: highlightGreen),
            onPressed: () async {
              String suggestion = await ApiService.generateAiCaption("a trending topic for developers");
              if (mounted) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: primaryDark,
                    title: Text("AI Suggestion", style: TextStyle(color: highlightGreen)),
                    content: Text(suggestion, style: const TextStyle(color: Colors.white70)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cool", style: TextStyle(color: accentMuted)),
                      )
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: highlightGreen));
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.white)));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No posts found.", style: TextStyle(color: Colors.white)));
          }

          final posts = snapshot.data!;
          return RefreshIndicator(
            color: highlightGreen,
            backgroundColor: primaryDark,
            onRefresh: () async {
              _loadPosts();
            },
            child: ListView.separated(
              itemCount: posts.length,
              // Spacing between posts using the muted green background
              separatorBuilder: (context, index) => Container(
                height: 12,
                color: Colors.black.withOpacity(0.2),
              ),
              itemBuilder: (context, index) {
                return Container(
                  color: primaryDark, // Consistent dark theme for cards
                  child: PostCard(post: posts[index]),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
