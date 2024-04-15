import 'dart:convert'; // Import dart:convert for json.decode
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:temari_bet_elearning_app/video_player_screen.dart';

class VideoLessonDetailsScreen extends StatefulWidget {
  final String title;

  VideoLessonDetailsScreen({required this.title});

  @override
  _VideoLessonDetailsScreenState createState() =>
      _VideoLessonDetailsScreenState();
}

class _VideoLessonDetailsScreenState extends State<VideoLessonDetailsScreen> {
  String _videoUrl = '';

  @override
  void initState() {
    super.initState();
    _fetchVideoUrl();
  }

  Future<void> _fetchVideoUrl() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.137.117:3000/getvideo?Title=${widget.title}'),
      );
      final responseData = json.decode(response.body);
      setState(() {
        _videoUrl = responseData['videoLink'];
      });
    } catch (error) {
      print('Failed to fetch video URL: $error');
      print(widget.title);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Lesson Details - ${widget.title}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_videoUrl.isNotEmpty) // Remove null check
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPlayerScreen(
                          videoTitle: widget.title,
                          videoUrl: _videoUrl,
                        ),
                      ),
                    );
                  },
                  child: Text('Play Video'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
