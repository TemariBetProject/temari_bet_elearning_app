import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DateScreen extends StatefulWidget {
  final DateTime selectedDate;

  DateScreen({required this.selectedDate});

  @override
  _DateScreenState createState() => _DateScreenState();
}

class _DateScreenState extends State<DateScreen> {
  List<String> dueItems = [];
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  _loadTasks() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      dueItems = prefs.getStringList(_formatDate(widget.selectedDate)) ?? [];
    });
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month}-${date.day}";
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks for ${_formatDate(widget.selectedDate)}'),
        backgroundColor: theme.primaryColor,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 20),
              _buildDateInfo(theme),
              _buildTasksList(theme),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _showAddDialog,
                icon: Icon(Icons.add),
                label: Text('Add Assignment/Exam'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColorDark,
                  foregroundColor: Colors.white,
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateInfo(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.primaryColorLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getDayOfWeek(widget.selectedDate.weekday),
            style: theme.textTheme.headline6!.copyWith(color: Colors.white),
          ),
          Text(
            '${widget.selectedDate.day}/${widget.selectedDate.month}/${widget.selectedDate.year}',
            style: theme.textTheme.subtitle1!.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksList(ThemeData theme) {
    return Column(
      children: dueItems.isEmpty
          ? [Text('No due assignments/exams', style: theme.textTheme.subtitle1)]
          : dueItems
              .map((item) => Card(
                    margin: EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(item),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            dueItems.remove(item);
                            prefs.setStringList(
                                _formatDate(widget.selectedDate), dueItems);
                          });
                        },
                      ),
                    ),
                  ))
              .toList(),
    );
  }

  void _showAddDialog() {
    String? type;
    String? course;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Assignment/Exam'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: type,
                decoration: InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                ),
                items: ['Exam', 'Assignment'].map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) => type = value,
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: course,
                decoration: InputDecoration(
                  labelText: 'Course',
                  border: OutlineInputBorder(),
                ),
                items: [
                  'Math',
                  'English',
                  'Science',
                  'Amharic',
                  'Social Science',
                  'Civics'
                ].map((String course) {
                  return DropdownMenuItem<String>(
                    value: course,
                    child: Text(course),
                  );
                }).toList(),
                onChanged: (value) => course = value,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (type != null && course != null) {
                  setState(() {
                    dueItems.add('$course $type');
                    prefs.setStringList(
                        _formatDate(widget.selectedDate), dueItems);
                  });
                }
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  String _getDayOfWeek(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return '';
    }
  }
}
