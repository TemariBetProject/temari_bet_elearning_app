import 'package:flutter/material.dart';
import 'package:temari_bet_elearning_app/video_player_screen.dart';

class CourseLessonsScreen extends StatelessWidget {
  final String courseName;

  const CourseLessonsScreen({Key? key, required this.courseName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(courseName),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildCourseLessonCard(
            'Lesson 1',
            'Introduction to $courseName Lesson 1',
            'assets/images/Lesson1.png',
            () => _navigateToVideoPlayer(
                context, 'Lesson 1', 'Introduction to $courseName Lesson 1'),
          ),
          SizedBox(height: 16),
          _buildCourseLessonCard(
            'Lesson 2',
            'Introduction to $courseName Lesson 2',
            'assets/images/Lesson2.png',
            () => _navigateToVideoPlayer(
                context, 'Lesson 2', 'Introduction to $courseName Lesson 2'),
          ),
          SizedBox(height: 16),
          _buildCourseLessonCard(
            'Lesson 3',
            'Introduction to $courseName Lesson 3',
            'assets/images/Lesson3.png',
            () => _navigateToVideoPlayer(
                context, 'Lesson 3', 'Introduction to $courseName Lesson 3'),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseLessonCard(String lessonTitle, String lessonDescription,
      String imagePath, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 150,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  lessonTitle,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  lessonDescription,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToVideoPlayer(
      BuildContext context, String title, String description) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(
          videoTitle: title,
          videoDescription: description,
        ),
      ),
    );
  }
}
