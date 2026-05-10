class Reel {
  final String id;
  final String videoUrl;
  final String thumbnailUrl;
  final String userName;
  final String title;

  Reel({
    required this.id,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.userName,
    this.title = 'Delicious Cooking',
  });
}
