import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarHomePage extends StatefulWidget {
  const CalendarHomePage({super.key});

  @override
  CalendarHomePageState createState() => CalendarHomePageState();
}

class CalendarHomePageState extends State<CalendarHomePage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                setState(() {
                  _focusedDay = DateTime(
                    _focusedDay.year,
                    _focusedDay.month - 1,
                    1,
                  );
                });
              },
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _focusedDay = DateTime.now();
                });
              },
              child: Text(
                DateFormat.yMMM('ko_KR').format(_focusedDay),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: () {
                setState(() {
                  _focusedDay = DateTime(
                  _focusedDay.year,
                  _focusedDay.month + 1,
                  1,
                  );
                });
              },
            ),
          ],
        ),
      ),
      body: TableCalendar(
        locale: 'ko_KR',
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        startingDayOfWeek: StartingDayOfWeek.sunday,
        calendarBuilders: CalendarBuilders(
          dowBuilder: (context, day) {
            if (day.weekday == DateTime.sunday) {
              final text = DateFormat.E('ko_KR').format(day);
              return Center(
                child: Text(
                  text,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            if (day.weekday == DateTime.saturday) {
              final text = DateFormat.E('ko_KR').format(day);
              return Center(
                child: Text(
                  text,
                  style: const TextStyle(color: Colors.blue),
                ),
              );
            }
            return null;
          },
        ),
        headerVisible: false,
      ),
    );
  }
}