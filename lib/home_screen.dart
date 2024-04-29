import 'package:flutter/material.dart';
import 'package:temari_bet_elearning_app/course_lessons_screen.dart';
import 'package:temari_bet_elearning_app/video_player_screen.dart';
import 'package:temari_bet_elearning_app/calendar_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Image.asset(
            'assets/images/App Logo.png',
            width: 30,
            height: 30,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 1, 44, 2),
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 3,
                      spreadRadius: 2,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              SizedBox(height: 24),
              _buildGradeSection('Grade 7', [
                _buildCourseCard(context, 'Math', Colors.lightGreen,
                    Icons.calculate, 'Math', 7),
                _buildCourseCard(context, 'English', Colors.lightGreen,
                    Icons.language, 'English', 7),
                _buildCourseCard(context, 'Science', Colors.lightGreen,
                    Icons.science, 'Science', 7),
                _buildCourseCard(context, 'Amharic', Colors.lightGreen,
                    Icons.text_fields, 'Amharic', 7),
                _buildCourseCard(context, 'Social Science', Colors.lightGreen,
                    Icons.group, 'Social Science', 7),
                _buildCourseCard(context, 'Civics', Colors.lightGreen,
                    Icons.people, 'Civics', 7),
              ]),
              SizedBox(height: 24),
              _buildGradeSection('Grade 8', [
                _buildCourseCard(context, 'Math', Colors.lightBlue,
                    Icons.calculate, 'Math', 8),
                _buildCourseCard(context, 'English', Colors.lightBlue,
                    Icons.language, 'English', 8),
                _buildCourseCard(context, 'Science', Colors.lightBlue,
                    Icons.science, 'Science', 8),
                _buildCourseCard(context, 'Amharic', Colors.lightBlue,
                    Icons.text_fields, 'Amharic', 8),
                _buildCourseCard(context, 'Social Science', Colors.lightBlue,
                    Icons.group, 'Social Science', 8),
                _buildCourseCard(context, 'Civics', Colors.lightBlue,
                    Icons.people, 'Civics', 8),
              ]),
              SizedBox(height: 24),
              Text(
                'Popular Lessons',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.calendar_today),
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
              icon: Icon(Icons.person),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradeSection(String title, List<Widget> courses) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: courses,
          ),
        ),
      ],
    );
  }

  _buildCourseCard(BuildContext context, String title, Color color,
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
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color.withOpacity(0.8), color.withOpacity(0.6)],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 28,
                    color: Colors.white,
                  ),
                  SizedBox(height: 8),
                  Text(
                    title, // Display title here
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: 200,
                height: 120,
              ),
            ),
            SizedBox(height: 8),
            Text(
              lessonTitle,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              lessonDescription,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
