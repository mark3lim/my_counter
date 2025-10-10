import 'package:counting_app/data/model/event_color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// table_calendar 패키지의 StartingDayOfWeek enum을 대체하여 의존성을 제거합니다.
enum CustomStartingDayOfWeek { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

// 더미 데이터
// 더미 데이터
Map<DateTime, List<EventColor>> get _dummyEvents {
  final now = DateTime.now();
  return {
    DateTime.utc(now.year, now.month, now.day): [
      EventColor.defaultColor,
      EventColor.monthColor,
      EventColor.weekColor,
      EventColor.dayColor,
    ],
    DateTime.utc(now.year, now.month, now.day + 3): [
      EventColor.defaultColor,
    ],
  };
}

class CustomCalendar extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final Function(DateTime, DateTime) onDaySelected;
  final CustomStartingDayOfWeek startingDayOfWeek;

  const CustomCalendar({
    super.key,
    required this.focusedDay,
    this.selectedDay,
    required this.onDaySelected,
    this.startingDayOfWeek = CustomStartingDayOfWeek.sunday,
  });

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDaysOfWeek(context),
        const SizedBox(height: 8.0),
        _buildCalendarGrid(context),
      ],
    );
  }

  Widget _buildDaysOfWeek(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final weekDays = DateFormat.E(locale).dateSymbols.SHORTWEEKDAYS;
    List<Widget> headers = [];
    for (int i = 0; i < 7; i++) {
      headers.add(
        Expanded(
          child: Center(
            child: Text(
              weekDays[i],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: i == 0 ? Colors.red : (i == 6 ? Colors.blue : Colors.black87),
                fontSize: 18.0,
              ),
            ),
          ),
        ),
      );
    }
    return Row(children: headers);
  }

  Widget _buildCalendarGrid(BuildContext context) {
    final days = _getCalendarDays(focusedDay);
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1.0,
      ),
      itemCount: days.length,
      itemBuilder: (context, index) {
        final date = days[index];
        final isSelected = selectedDay != null && _isSameDay(date, selectedDay!);
        final isToday = _isSameDay(date, DateTime.now());
        final isCurrentMonth = date.month == focusedDay.month;
        final events = _dummyEvents[DateTime.utc(date.year, date.month, date.day)] ?? [];

        Color textColor;
        if (!isCurrentMonth) {
          textColor = Colors.grey.withValues(alpha: 0.7);
        } else if (date.weekday == DateTime.sunday) {
          textColor = Colors.red;
        } else if (date.weekday == DateTime.saturday) {
          textColor = Colors.blue;
        } else {
          textColor = Colors.black87;
        }

        return GestureDetector(
          onTap: () => onDaySelected(date, date),
          child: Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: isToday ? Theme.of(context).primaryColor.withValues(alpha: 0.2) : Colors.transparent,
              shape: BoxShape.circle,
              border: isSelected ? Border.all(color: Colors.grey.shade700, width: 1.5) : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${date.day}',
                  style: TextStyle(
                    color: textColor,
                    fontWeight: isCurrentMonth ? FontWeight.normal : FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 4.0),
                _buildEventDots(events),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEventDots(List<EventColor> events) {
    if (events.isEmpty) {
      return const SizedBox(height: 5);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(events.length.clamp(0, 4), (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 1.5),
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            color: events[index].color,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }

  List<DateTime> _getCalendarDays(DateTime month) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    
    // In Dart, DateTime.sunday is 7. We want it to be the start of the week.
    // The weekday of the first day of the month (0=Sun, 1=Mon, ..., 6=Sat)
    int firstDayWeekday = (firstDayOfMonth.weekday % 7);

    // The first day to show on the calendar grid.
    final DateTime firstDayOfCalendar = firstDayOfMonth.subtract(Duration(days: firstDayWeekday));

    final List<DateTime> days = [];
    for (int i = 0; i < 42; i++) {
      days.add(firstDayOfCalendar.add(Duration(days: i)));
    }
    return days;
  }
}