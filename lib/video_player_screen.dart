import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPlayerScreen extends StatelessWidget {
  final String videoTitle;
  final String videoDescription;
  final String videoUrl; // Direct URL for the video

  const VideoPlayerScreen({
    Key? key,
    required this.videoTitle,
    required this.videoDescription,
    required this.videoUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Convert the URL to a video ID
    final videoId = YoutubePlayer.convertUrlToId(videoUrl) ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player - $videoTitle'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          YoutubePlayer(
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
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16),
                Text(
                  'Title: $videoTitle',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Description: $videoDescription',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
