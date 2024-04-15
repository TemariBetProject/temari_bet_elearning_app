import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatelessWidget {
  final String videoTitle;
  final String? videoUrl;

  const VideoPlayerScreen({
    required this.videoTitle,
    this.videoUrl,
  });

  @override
  Widget build(BuildContext context) {
    final videoId = videoUrl != null
        ? YoutubePlayer.convertUrlToId(videoUrl!) ??
            '' // Use default value if null
        : '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player - $videoTitle'),
      ),
      body: Center(
        child: YoutubePlayer(
          controller: YoutubePlayerController(
            initialVideoId: videoId,
            flags: YoutubePlayerFlags(
              autoPlay: true,
              mute: false,
            ),
          ),
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.amber,
          progressColors: ProgressBarColors(
            playedColor: Colors.amber,
            handleColor: Colors.amberAccent,
          ),
          onReady: () {
            print('Video is ready.');
          },
        ),
      ),
    );
  }
}
