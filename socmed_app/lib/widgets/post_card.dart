import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/post_model.dart';
import 'video_widget.dart';

class PostCard extends StatefulWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
    // lib/widgets/post_card.dart
// ... inside the build method of PostCard ...
    ListTile(
    leading: CircleAvatar(backgroundImage: NetworkImage(widget.post.profileImage)),
    title: Text(
    widget.post.username,
    style: GoogleFonts.pangolin( // Apply the requested font here
    fontWeight: FontWeight.bold,
    color: const Color(0xFF000000), // Using your highlight green
    fontSize: 16,
    ),
    ),
    trailing: const Icon(Icons.more_vert, color: Colors.white70),
    ),
        // Display Image or Video based on availability
        if (widget.post.imageUrl != null)
          Image.network(widget.post.imageUrl!, width: double.infinity, fit: BoxFit.cover)
        else if (widget.post.videoUrl != null)
          VideoWidget(url: widget.post.videoUrl!),

        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              IconButton(
                icon: Icon(widget.post.isLiked ? Icons.favorite : Icons.favorite_border),
                color: widget.post.isLiked ? Colors.red : Colors.black,
                onPressed: () => setState(() => widget.post.isLiked = !widget.post.isLiked),
              ),
              const Icon(Icons.chat_bubble_outline),
              const SizedBox(width: 15),
              const Icon(Icons.send_outlined),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: RichText(
            text: TextSpan(style: const TextStyle(color: Colors.black), children: [
              TextSpan(text: "${widget.post.username} ", style: const TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: widget.post.caption),
            ]),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }
}