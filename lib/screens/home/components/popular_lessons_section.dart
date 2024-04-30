import 'package:flutter/material.dart';
import 'package:temari_bet_elearning_app/screens/video_player/video_player_screen.dart';
import 'package:temari_bet_elearning_app/config/app_config.dart';

class PopularLessonsSection extends StatelessWidget {
  final List<dynamic> videos;
  const PopularLessonsSection({Key? key, required this.videos})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: videos.map((video) {
          return _buildPopularLessonCard(
            video['Title'],
            video['Description'],
            video['image'],
            () => _navigateToVideoPlayer(context, video['_id'], video['Title'],
                video['Description'], video['urlLink']),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPopularLessonCard(String lessonTitle, String lessonDescription,
      String imagePath, Function onTap) {
    String fullImageUrl = AppConfig.imageUrl + imagePath;
    return GestureDetector(
      onTap: onTap as void Function(),
      child: Container(
        width: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                fullImageUrl,
                fit: BoxFit.cover,
                width: 200,
                height: 120,
              ),
            ),
            SizedBox(height: 8),
            Text(
              lessonTitle,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToVideoPlayer(BuildContext context, String videoId,
      String title, String description, String videoUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(
          videoId: videoId,
          videoTitle: title,
          videoDescription: description,
          videoUrl: videoUrl,
        ),
      ),
    );
  }
}
