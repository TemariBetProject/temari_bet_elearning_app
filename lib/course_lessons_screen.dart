import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // for JSON decoding
import 'package:temari_bet_elearning_app/video_player_screen.dart';

class CourseLessonsScreen extends StatefulWidget {
  final String courseName;
  final String gradeLevel;

  const CourseLessonsScreen({
    Key? key,
    required this.courseName,
    required this.gradeLevel,
  }) : super(key: key);

  @override
  _CourseLessonsScreenState createState() => _CourseLessonsScreenState();
}

class _CourseLessonsScreenState extends State<CourseLessonsScreen> {
  List<dynamic> lessons = [];
  final String baseUrl = 'http://192.168.137.1:3000/uploads/';

  @override
  void initState() {
    super.initState();
    fetchLessons();
  }

  Future<void> fetchLessons() async {
    try {
      var url = Uri.parse(
          'http://192.168.137.1:3000/get_video_data_by_course?course=${widget.courseName}&grade=${widget.gradeLevel}');
      print("Fetching data from: $url");
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status']) {
          setState(() {
            lessons = data['videoData'];
          });
        } else {
          throw Exception('No video data found');
        }
      } else {
        throw Exception('Failed to load lessons');
      }
    } catch (e) {
      print('Error fetching lessons: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to fetch lessons: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.courseName),
      ),
      body: lessons.isEmpty
          ? Center(
              child: Text("No lessons available for ${widget.courseName}",
                  style: TextStyle(fontSize: 16)))
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: lessons.length,
              itemBuilder: (context, index) {
                var lesson = lessons[index];
                return _buildCourseLessonCard(
                  lesson['Title'],
                  lesson['Description'],
                  baseUrl + lesson['image'], // Ensure the image URL is correct
                  lesson[
                      'urlLink'], // Assuming 'urlLink' is the key for the video URL in the data
                  () => _navigateToVideoPlayer(
                      context,
                      lesson['Title'],
                      lesson['Description'],
                      lesson['urlLink']), // Pass the video URL here
                );
              },
            ),
    );
  }

  Widget _buildCourseLessonCard(String lessonTitle, String lessonDescription,
      String imagePath, String videoUrl, Function onTap) {
    return GestureDetector(
      onTap: onTap as void Function(),
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
                  child: Image.network(
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
      BuildContext context, String title, String description, String videoUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(
          videoTitle: title,
          videoDescription: description,
          videoUrl: videoUrl, // Pass the video URL to the video player
        ),
      ),
    );
  }
}
