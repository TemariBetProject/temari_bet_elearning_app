import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:temari_bet_elearning_app/screens/calendar/date_screen.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _selectedDate;
  late DateTime _currentMonth;
  late SharedPreferences prefs;
  Map<String, List<String>> tasksByDate = {};

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _currentMonth = DateTime(_selectedDate.year, _selectedDate.month);
    initializeDateFormatting();
    _loadTasksForMonth();
  }

  void _loadTasksForMonth() async {
    prefs = await SharedPreferences.getInstance();
    final daysInMonth = _getDaysInMonth(_currentMonth);
    Map<String, List<String>> newTasksByDate = {};
    for (var day in daysInMonth) {
      DateTime date = DateTime(_currentMonth.year, _currentMonth.month, day);
      String key = _formatDate(date);
      newTasksByDate[key] = prefs.getStringList(key) ?? [];
    }
    setState(() {
      tasksByDate = newTasksByDate;
    });
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month}-${date.day}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            _buildMonthNavigator(),
            SizedBox(height: 16),
            _buildCalendarGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthNavigator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: _previousMonth,
        ),
        Text(
          DateFormat.yMMM().format(_currentMonth),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: _nextMonth,
        ),
      ],
    );
  }

  Widget _buildCalendarGrid() {
    final List<String> weekdays = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun'
    ];
    final List<int> daysInMonth = _getDaysInMonth(_currentMonth);
    final DateTime now = DateTime.now();

    return Expanded(
      child: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
        itemCount: weekdays.length + daysInMonth.length,
        itemBuilder: (context, index) {
          if (index < weekdays.length) {
            return Center(
              child: Text(
                weekdays[index],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          } else {
            int day = daysInMonth[index - weekdays.length];
            DateTime date =
                DateTime(_currentMonth.year, _currentMonth.month, day);
            bool hasTasks =
                (tasksByDate[_formatDate(date)]?.isNotEmpty ?? false);
            bool isToday = now.year == date.year &&
                now.month == date.month &&
                now.day == date.day;

            return InkWell(
              onTap: () => _navigateToDateScreen(date),
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: isToday
                          ? Colors.red
                          : (hasTasks ? Colors.green : Colors.transparent),
                      width: 2.0),
                ),
                child: Text(
                  '$day',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  List<int> _getDaysInMonth(DateTime month) {
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    return List.generate(daysInMonth, (index) => index + 1);
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
      _loadTasksForMonth();
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
      _loadTasksForMonth();
    });
  }

  void _navigateToDateScreen(DateTime selectedDate) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DateScreen(selectedDate: selectedDate),
      ),
    ).then((_) => setState(() {
          _loadTasksForMonth();
        }));
  }
}
