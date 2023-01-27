import 'package:flutter_custom_calendar/src/model/calendar_date_time.dart';
import 'package:flutter_custom_calendar/src/provider/calendar_provider.dart';
import 'package:flutter_custom_calendar/src/utils/calendar_date_time_extension.dart';

class GregorianCalendarProvider extends CalendarProvider {
  GregorianCalendarProvider({
    required CalendarDateTime? selectedDate,
  }) : super(
    calendarType: CalendarType.gregorian,
    selectedDate:
    selectedDate ?? CalendarDateTime.fromDateTime(DateTime.now()),
  );

  @override
  void initCalendarDateTime() {
    if(selectedDate.calendarType == CalendarType.jalali) {
      selectedDate = selectedDate.changeCalendarType(CalendarType.gregorian);
    }
    calendarDateTime = CalendarDateTime(
      selectedDate.year,
      selectedDate.month,
      1,
      calendarType: CalendarType.gregorian,
    );
  }

  @override
  List<CalendarDateTime> getMonthDateLit() {
    List<CalendarDateTime> calendarDates = [];
    DateTime dateTime = DateTime(calendarDateTime.year, calendarDateTime.month, 1);
    dateTime = dateTime.subtract(Duration(days: dateTime.weekday - 1));
    while (true) {
      if (calendarDateTime.month != dateTime.month && dateTime.weekday == 7) {
        calendarDates.add(CalendarDateTime.fromDateTime(dateTime));
        break;
      }
      calendarDates.add(CalendarDateTime.fromDateTime(dateTime));
      dateTime = dateTime.add(const Duration(days: 1));
      if (calendarDateTime.month != dateTime.month && dateTime.weekday == 1) {
        break;
      }

    }
    return calendarDates;
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
}
