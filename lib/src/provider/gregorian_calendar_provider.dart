import 'package:flutter_custom_calendar/src/model/calendar_date_time.dart';
import 'package:flutter_custom_calendar/src/provider/calendar_provider.dart';
import 'package:flutter_custom_calendar/src/utils/calendar_date_time_extension.dart';

class GregorianCalendarProvider extends CalendarProvider {
  GregorianCalendarProvider({
    required CalendarDateTime? selectedDate,
    required CalendarMode calendarMode,
  }) : super(
          calendarType: CalendarType.gregorian,
          selectedDate:
              selectedDate ?? CalendarDateTime.fromDateTime(DateTime.now()),
          calendarMode: calendarMode,
        );

  @override
  void initCalendarDateTime() {
    if (selectedDate.calendarType == CalendarType.jalali) {
      selectedDate = selectedDate.changeCalendarType(CalendarType.gregorian);
    }
    calendarDateTime = CalendarDateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      calendarType: CalendarType.gregorian,
    );
  }

  @override
  void selectCurrentDate() {
    selectCalendarDate(CalendarDateTime.fromDateTime(DateTime.now()));
    calendarDateTime = CalendarDateTime(
      selectedDate.year,
      selectedDate.month,
      1,
      calendarType: CalendarType.gregorian,
    );
  }

  @override
  void nextWeek() {
    DateTime dateTime = calendarDateTime.toDateTime;
    if (dateTime.month !=
        dateTime.add(Duration(days: 8 - dateTime.weekday)).month) {
      nextMonth();
    } else {
      dateTime = dateTime.add(Duration(days: 8 - dateTime.weekday));
      calendarDateTime = CalendarDateTime.fromDateTime(dateTime);
    }
  }

  @override
  void previousWeek() {
    DateTime dateTime = calendarDateTime.toDateTime;
    if (dateTime.month !=
        dateTime.subtract(Duration(days: dateTime.weekday - 1)).month) {
      dateTime = dateTime.subtract(Duration(days: dateTime.weekday - 1));
      calendarDateTime = CalendarDateTime.fromDateTime(dateTime);
    } else {
      dateTime = dateTime.subtract(Duration(days: dateTime.weekday));
      calendarDateTime = CalendarDateTime.fromDateTime(dateTime);
    }
  }

  @override
  List<CalendarDateTime> getMonthlyDatesList() {
    List<CalendarDateTime> calendarDates = [];
    DateTime dateTime =
        DateTime(calendarDateTime.year, calendarDateTime.month, 1);
    dateTime = dateTime.subtract(Duration(days: dateTime.weekday - 1));
    while (true) {
      if (calendarDateTime.month != dateTime.month && dateTime.weekday == 7) {
        calendarDates.add(CalendarDateTime.fromDateTime(dateTime));
        break;
      }
      calendarDates.add(CalendarDateTime.fromDateTime(dateTime));

      ///because of time difference, add method will not work properly in september
      dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day + 1);
      if (calendarDateTime.month != dateTime.month && dateTime.weekday == 1) {
        break;
      }
    }
    return calendarDates;
  }

  @override
  List<CalendarDateTime> getWeeklyDatesList() {
    List<CalendarDateTime> calendarDates = [];
    DateTime dateTime = calendarDateTime.toDateTime;
    dateTime = dateTime.subtract(Duration(days: dateTime.weekday - 1));
    while (calendarDates.length < 7) {
      calendarDates.add(CalendarDateTime.fromDateTime(dateTime));
      dateTime = dateTime.add(const Duration(days: 1));
    }
    return calendarDates;
  }
}
