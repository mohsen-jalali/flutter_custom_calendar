import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/src/model/calendar_date_time.dart';
import 'package:flutter_custom_calendar/src/utils/calendar_utils.dart';

class RowCalendarWeekDayTitle extends StatelessWidget {
  final CalendarType calendarType;
  final TextStyle? textStyle;

  const RowCalendarWeekDayTitle({
    Key? key,
    required this.calendarType,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: CalendarUtils.weekDaysTitles
            .map((day) => Expanded(
                  child: Center(
                    child: Text(
                      day,
                      style: textStyle,
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
