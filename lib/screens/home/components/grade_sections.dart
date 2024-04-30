import 'package:flutter/material.dart';
import 'package:temari_bet_elearning_app/screens/course_lessons/course_lessons_screen.dart';

class GradeSections extends StatelessWidget {
  const GradeSections({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildGradeSection(context, 'Grade 7', [
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
        _buildGradeSection(context, 'Grade 8', [
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

  Widget _buildGradeSection(
      BuildContext context, String title, List<Widget> courses) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: courses),
        ),
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
                    title,
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
}
