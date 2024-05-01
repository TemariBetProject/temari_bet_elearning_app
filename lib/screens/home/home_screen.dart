import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:temari_bet_elearning_app/config/app_config.dart';
import 'package:temari_bet_elearning_app/screens/home/components/grade_sections.dart';
import 'package:temari_bet_elearning_app/screens/home/components/popular_lessons_section.dart';
import 'package:temari_bet_elearning_app/screens/home/components/search_results.dart';
import 'package:temari_bet_elearning_app/screens/calendar/calendar_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    fetchTopVideos(); // Ensure this method is properly awaited or handled
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
      Uri.parse(AppConfig.fetchSearchUrl + '?q=$query'),
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

  Future<void> refreshTopVideos() async {
    await fetchTopVideos(); // Call fetchTopVideos and await its result
  }

  Future<void> fetchTopVideos() async {
    try {
      var response = await http.get(Uri.parse(AppConfig.topVideoUrl));
      if (response.statusCode == 200) {
        var data = json.decode(response.body)['videoData'];
        setState(() {
          _topVideos = data; // Ensure setState is called to update the UI
        });
      } else {
        throw Exception('Failed to load top videos');
      }
    } catch (e) {
      print('Error fetching top videos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Image.asset('assets/images/App Logo.png'),
          ),
          actions: [
            PopupMenuButton<String>(
              onSelected: (String result) {
                if (result == 'logout') {
                  _showLogoutDialog(context);
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Text('Log Out'),
                ),
              ],
              icon: Icon(Icons.more_vert, color: Colors.black87),
            ),
          ],
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: RefreshIndicator(
          onRefresh: refreshTopVideos,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
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
                    SearchResults(searchResults: _searchResults),
                  ] else ...[
                    SizedBox(height: 24),
                    GradeSections(),
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
                    PopularLessonsSection(
                      videos: _topVideos,
                      refreshTopVideos: refreshTopVideos,
                    ),
                  ]
                ],
              ),
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
                icon:
                    Icon(Icons.calendar_today_outlined, color: Colors.black87),
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
        ));
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Log Out'),
          content: Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Dismiss the dialog but not log out
              },
              child: Text('Cancel'),
            ),
            TextButton(
              child: Text('Log Out'),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('token'); // Remove the stored token
                Navigator.of(context).popUntil((route) => route.isFirst);
                Navigator.pushReplacementNamed(
                    context, '/login'); // Navigate to login screen
              },
            ),
          ],
        );
      },
    );
  }
}
