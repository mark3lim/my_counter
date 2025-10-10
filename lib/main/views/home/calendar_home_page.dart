import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'widgets/custom_calendar.dart';

class CalendarHomePage extends StatefulWidget {
  const CalendarHomePage({super.key});

  @override
  CalendarHomePageState createState() => CalendarHomePageState();
}

class CalendarHomePageState extends State<CalendarHomePage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                setState(() {
                  final targetMonth = DateTime(
                    _focusedDay.year,
                    _focusedDay.month - 1,
                  );
                  final lastDayOfTargetMonth = DateTime(
                    targetMonth.year,
                    targetMonth.month + 1,
                    0,
                  ).day;
                  final safeDay = _focusedDay.day > lastDayOfTargetMonth
                      ? lastDayOfTargetMonth
                      : _focusedDay.day;
                  _focusedDay = DateTime(
                    targetMonth.year,
                    targetMonth.month,
                    safeDay,
                  );
                });
              },
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _focusedDay = DateTime.now();
                  _selectedDay = DateTime.now();
                });
              },
              child: Text(
                DateFormat.yMMMM('ko_KR').format(_focusedDay),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {
                setState(() {
                  final targetMonth = DateTime(
                    _focusedDay.year,
                    _focusedDay.month + 1,
                  );
                  final lastDayOfTargetMonth = DateTime(
                    targetMonth.year,
                    targetMonth.month + 1,
                    0,
                  ).day;
                  final safeDay = _focusedDay.day > lastDayOfTargetMonth
                      ? lastDayOfTargetMonth
                      : _focusedDay.day;
                  _focusedDay = DateTime(
                    targetMonth.year,
                    targetMonth.month,
                    safeDay,
                  );
                });
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomCalendar(
          focusedDay: _focusedDay,
          selectedDay: _selectedDay,
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          startingDayOfWeek: CustomStartingDayOfWeek.sunday,
        ),
      ),
    );
  }
}
