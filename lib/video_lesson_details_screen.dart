import 'package:flutter/material.dart';
import 'package:temari_bet_elearning_app/video_player_screen.dart';

class VideoLessonDetailsScreen extends StatelessWidget {
  final String title;

  VideoLessonDetailsScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Lesson Details - $title'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoPlayerScreen(
                        videoTitle: 'Sample Video',
                        videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
                      ),
                    ),
                  );
                },
                child: Text('Play Sample Video'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
