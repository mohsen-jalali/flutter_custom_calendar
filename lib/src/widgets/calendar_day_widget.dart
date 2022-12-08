import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/src/model/calendar_date_time.dart';
import 'package:flutter_custom_calendar/src/model/custom_day_model.dart';

class CalendarDayWidget extends StatelessWidget {
  final CalendarDateTime calendarDateTime;
  final CalendarDayModel? calendarDayModel;

  const CalendarDayWidget({
    Key? key,
    required this.calendarDateTime,
    this.calendarDayModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: calendarDayModel?.padding,
      decoration: calendarDayModel?.decoration?.call(
          calendarDateTime.dateType) ?? BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.rectangle,
      ),
      child: Center(
        child: Text(
          calendarDateTime.day.toString(),
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  Color get backgroundColor {
    switch (calendarDateTime.dateType) {
      case CalendarDateType.current:
        return calendarDayModel?.backgroundColor ?? Colors.blue;
      default:
        return calendarDayModel?.disableDayBackgroundColor ?? Colors.transparent;
    }
  }
}
