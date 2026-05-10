import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:lacarte/ui/lacarte_ft/view_models/reels_view_model.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ReelsViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(child: CircularProgressIndicator(color: Colors.white)),
          );
        }

        if (viewModel.reels.isEmpty) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(
              child: Text('No reels found', style: TextStyle(color: Colors.white)),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.black,
          body: PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: viewModel.reels.length,
            itemBuilder: (context, index) {
              final reel = viewModel.reels[index];
              return ReelPlayerWidget(
                videoUrl: reel.videoUrl,
                userName: reel.userName,
                title: reel.title,
              );
            },
          ),
        );
      },
    );
  }
}

class ReelPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final String userName;
  final String title;

  const ReelPlayerWidget({
    super.key,
    required this.videoUrl,
    required this.userName,
    required this.title,
  });

  @override
  State<ReelPlayerWidget> createState() => _ReelPlayerWidgetState();
}

class _ReelPlayerWidgetState extends State<ReelPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        if (mounted) {
          setState(() {});
          _controller.play();
          _controller.setLooping(true);
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        _isPlaying = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: _togglePlayPause,
          child: Container(
            color: Colors.black,
            child: Center(
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : const CircularProgressIndicator(color: Colors.white),
            ),
          ),
        ),
        if (!_isPlaying)
          Center(
            child: IconButton(
              icon: const Icon(Icons.play_arrow, color: Colors.white, size: 80),
              onPressed: _togglePlayPause,
            ),
          ),
        // Overlay for user info
        Positioned(
          bottom: 90, // Adjusted to sit above the bottom nav bar
          left: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '@${widget.userName}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
