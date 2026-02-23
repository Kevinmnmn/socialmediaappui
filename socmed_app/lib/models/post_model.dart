class Post {
  final int id;
  final String username;
  final String profileImage;
  final String caption;
  final String? imageUrl;
  final String? videoUrl;
  bool isLiked;

  Post({
    required this.id,
    required this.username,
    required this.profileImage,
    required this.caption,
    this.imageUrl,
    this.videoUrl,
    this.isLiked = false,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] ?? 0,
      username: json['username'] ?? 'Unknown',
      profileImage: json['profile_image'] ?? 'https://i.pravatar.cc/150',
      caption: json['caption'] ?? '',
      imageUrl: json['image_url'],
      videoUrl: json['video_url'],
    );
  }
}