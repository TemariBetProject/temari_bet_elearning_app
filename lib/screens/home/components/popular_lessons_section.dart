import 'package:flutter/material.dart';
import 'package:temari_bet_elearning_app/screens/video_player/video_player_screen.dart';
import 'package:temari_bet_elearning_app/config/app_config.dart';
import 'package:temari_bet_elearning_app/screens/home/home_screen.dart';

class PopularLessonsSection extends StatelessWidget {
  final List<dynamic> videos;
  final VoidCallback refreshTopVideos;

  const PopularLessonsSection({
    Key? key,
    required this.videos,
    required this.refreshTopVideos, // Initialize here
  }) : super(key: key);

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
        margin: EdgeInsets.only(
            right: 16), // Add spacing on the right for each card
        decoration: BoxDecoration(
          border:
              Border.all(color: Colors.grey.shade300, width: 1), // Add border
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.network(
                fullImageUrl,
                fit: BoxFit.cover,
                width: 200,
                height: 120,
              ),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 8), // Padding for text inside the card
              height:
                  90, // Keep the height to accommodate two lines for description.
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    lessonTitle,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Expanded(
                    child: Text(
                      lessonDescription,
                      style: TextStyle(fontSize: 12),
                      maxLines: 2, // Allow for two lines of text.
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
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
    ).then((watched) {
      if (watched ?? false) {
        print('Video watched, triggering refresh'); // Debug statement
        refreshTopVideos(); // Refresh the videos on return
      } else {
        print(
            'Video not watched, no refresh triggered'); // Debug for navigation without watching
      }
    });
  }
}
