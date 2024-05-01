import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:temari_bet_elearning_app/config/app_config.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoId;
  final String videoTitle;
  final String videoDescription;
  final String videoUrl;

  const VideoPlayerScreen({
    Key? key,
    required this.videoId,
    required this.videoTitle,
    required this.videoDescription,
    required this.videoUrl,
  }) : super(key: key);

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;
  bool _hasIncrementedView = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(widget.videoUrl) ?? '',
      flags: YoutubePlayerFlags(autoPlay: true, mute: false),
    );

    _controller.addListener(() {
      if (_controller.value.isPlaying && !_hasIncrementedView) {
        _incrementViewCount();
        _hasIncrementedView = true;
      }
    });
  }

  Future<void> _incrementViewCount() async {
    try {
      var response = await http.patch(
        Uri.parse(
            AppConfig.incrementViewUrl + '${widget.videoId}/incrementViews'),
      );
      if (response.statusCode == 200) {
        print('View count incremented');
      } else {
        throw Exception('Failed to increment view count');
      }
    } catch (e) {
      print('Error incrementing view count: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player - ${widget.videoTitle}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            YoutubePlayer(controller: _controller),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Title: ${widget.videoTitle}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Description: ${widget.videoDescription}',
                      style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
