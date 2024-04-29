import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:temari_bet_elearning_app/course_lessons_screen.dart';
import 'package:temari_bet_elearning_app/video_player_screen.dart';
import 'package:temari_bet_elearning_app/calendar_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // for JSON decoding

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _topVideos = [];
  TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    fetchTopVideos().then((videos) {
      setState(() {
        _topVideos = videos;
      });
    });
    _searchController.addListener(_onSearchChanged);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_searchController.text.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
    } else {
      setState(() {
        _isSearching = true;
      });
      _performSearch(_searchController.text);
    }
  }

  Future<void> _performSearch(String query) async {
    var response = await http.get(
      Uri.parse('http://192.168.137.62:3000/search?q=$query'),
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        _searchResults = data['videoData'];
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }
  }

  Future<List<dynamic>> fetchTopVideos() async {
    try {
      var response = await http
          .get(Uri.parse('http://192.168.137.62:3000/videos/topViews'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data['videoData'];
      } else {
        throw Exception('Failed to load top videos');
      }
    } catch (e) {
      print('Error fetching top videos: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.grey[100], // A light grey background for the whole page
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white, // AppBar with white background
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Image.asset('assets/images/App Logo.png'),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black87),
            onPressed: () {},
          ),
        ],
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(left: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    border: InputBorder.none,
                    suffixIcon: Icon(Icons.search, color: Colors.black87),
                  ),
                ),
              ),
              if (_isSearching) ...[
                SizedBox(height: 24),
                _buildSearchResults(),
              ] else ...[
                SizedBox(height: 24),
                _buildGradeSections(),
                SizedBox(height: 30),
                Text(
                  'Popular Lessons',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 20),
                _buildPopularLessonsSection(),
              ]
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home, color: Colors.black87),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.favorite_outline, color: Colors.black87),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.calendar_today_outlined, color: Colors.black87),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CalendarScreen(),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.person_outline, color: Colors.black87),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        var result = _searchResults[index];
        String imageUrl =
            'http://192.168.137.62:3000/uploads/' + result['image'];

        // Extracting necessary data for video player
        String videoId = result['_id'];
        String videoTitle = result['Title'];
        String videoDescription = result['Description'];
        String videoUrl = result['urlLink'];

        return ListTile(
          leading:
              Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover),
          title: Text(videoTitle),
          onTap: () {
            // Navigate to the Video Player Screen with all required details
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoPlayerScreen(
                    videoId: videoId,
                    videoTitle: videoTitle,
                    videoDescription: videoDescription,
                    videoUrl: videoUrl),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildGradeSections() {
    return Column(
      children: [
        _buildGradeSection('Grade 7', [
          _buildCourseCard(
              context, 'Math', Colors.lightGreen, Icons.calculate, 'Math', 7),
          _buildCourseCard(context, 'English', Colors.lightGreen,
              Icons.language, 'English', 7),
          _buildCourseCard(context, 'Science', Colors.lightGreen, Icons.science,
              'Science', 7),
          _buildCourseCard(context, 'Amharic', Colors.lightGreen,
              Icons.text_fields, 'Amharic', 7),
          _buildCourseCard(context, 'Social Science', Colors.lightGreen,
              Icons.group, 'Social Science', 7),
          _buildCourseCard(
              context, 'Civics', Colors.lightGreen, Icons.people, 'Civics', 7),
        ]),
        SizedBox(height: 24),
        _buildGradeSection('Grade 8', [
          _buildCourseCard(
              context, 'Math', Colors.lightBlue, Icons.calculate, 'Math', 8),
          _buildCourseCard(context, 'English', Colors.lightBlue, Icons.language,
              'English', 8),
          _buildCourseCard(context, 'Science', Colors.lightBlue, Icons.science,
              'Science', 8),
          _buildCourseCard(context, 'Amharic', Colors.lightBlue,
              Icons.text_fields, 'Amharic', 8),
          _buildCourseCard(context, 'Social Science', Colors.lightBlue,
              Icons.group, 'Social Science', 8),
          _buildCourseCard(
              context, 'Civics', Colors.lightBlue, Icons.people, 'Civics', 8),
        ]),
      ],
    );
  }

  Widget _buildGradeSection(String title, List<Widget> courses) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87)),
        SizedBox(height: 16),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal, child: Row(children: courses)),
      ],
    );
  }

  Widget _buildCourseCard(BuildContext context, String title, Color color,
      IconData icon, String courseName, int grade) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseLessonsScreen(
                courseName: title, gradeLevel: grade.toString()),
          ),
        );
      },
      child: Container(
        width: 80,
        height: 80,
        margin: EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(0, 3))
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color.withOpacity(0.8), color.withOpacity(0.6)]),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 28, color: Colors.white),
                  SizedBox(height: 8),
                  Text(title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPopularLessonCard(String lessonTitle, String lessonDescription,
      String imagePath, Function() onTap) {
    String fullImageUrl = 'http://192.168.137.62:3000/uploads/' +
        imagePath; // Ensure this is a complete URL
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                fullImageUrl, // Use the full URL here
                fit: BoxFit.cover,
                width: 200,
                height: 120,
              ),
            ),
            SizedBox(height: 8),
            Text(lessonTitle,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularLessonsSection() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _topVideos.map((video) {
          // Assuming video['_id'] holds a unique identifier for the video
          return _buildPopularLessonCard(
            video['Title'],
            video['Description'],
            video['image'], // Ensure this is a complete URL if necessary
            () => _navigateToVideoPlayer(context, video['_id'], video['Title'],
                video['Description'], video['urlLink']),
          );
        }).toList(),
      ),
    );
  }

  void _navigateToVideoPlayer(BuildContext context, String videoId,
      String title, String description, String videoUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(
          videoId: videoId, // Pass the video ID to the video player
          videoTitle: title,
          videoDescription: description,
          videoUrl: videoUrl,
        ),
      ),
    );
  }
}
