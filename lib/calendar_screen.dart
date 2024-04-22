import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:temari_bet_elearning_app/date_screen.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _selectedDate;
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _currentMonth = DateTime(_selectedDate.year, _selectedDate.month);
    initializeDateFormatting(); // Initialize date formatting
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
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
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
        ),
        itemCount: weekdays.length + daysInMonth.length,
        itemBuilder: (context, index) {
          if (index < weekdays.length) {
            // Weekday header
            return Center(
              child: Text(
                weekdays[index],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          } else {
            // Calendar day item
            final day = daysInMonth[index - weekdays.length];
            final currentDate =
                DateTime(_currentMonth.year, _currentMonth.month, day);
            final isSelected = currentDate == _selectedDate;
            final isCurrentMonth = currentDate.month == _currentMonth.month;
            final isToday = currentDate.year == now.year &&
                currentDate.month == now.month &&
                currentDate.day == now.day;

            return InkWell(
              onTap: () {
                _navigateToDateScreen(currentDate);
              },
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.blue
                      : (isCurrentMonth
                          ? Colors.transparent
                          : Colors.grey[200]),
                  borderRadius: BorderRadius.circular(10),
                  border: isToday
                      ? Border.all(color: Colors.red, width: 2.0)
                      : null,
                ),
                child: Text(
                  '$day',
                  style: TextStyle(
                    color: isCurrentMonth
                        ? (isSelected ? Colors.white : Colors.black)
                        : Colors.grey,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
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

  void _navigateToDateScreen(DateTime selectedDate) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DateScreen(selectedDate: selectedDate),
      ),
    );
  }
}
