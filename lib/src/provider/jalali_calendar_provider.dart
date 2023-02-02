import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
import 'package:flutter_custom_calendar/src/provider/calendar_provider.dart';
import 'package:flutter_custom_calendar/src/utils/calendar_date_time_extension.dart';
import 'package:flutter_custom_calendar/src/utils/jalali_extension.dart';
import 'package:shamsi_date/shamsi_date.dart';

class JalaliCalendarProvider extends CalendarProvider {
  JalaliCalendarProvider({
    required CalendarDateTime? selectedDate,
    required CalendarMode calendarMode,
  }) : super(
          calendarType: CalendarType.jalali,
          selectedDate:
              selectedDate ?? CalendarDateTime.fromJalali(Jalali.now()),
          calendarMode: calendarMode,
        );

  @override
  void initCalendarDateTime() {
    if (selectedDate.calendarType == CalendarType.gregorian) {
      selectedDate = selectedDate.changeCalendarType(CalendarType.jalali);
    }
    calendarDateTime = CalendarDateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      calendarType: CalendarType.jalali,
    );
  }

  @override
  void selectCurrentDate() {
    selectCalendarDate(CalendarDateTime.fromJalali(Jalali.now()));
    calendarDateTime = CalendarDateTime(
      selectedDate.year,
      selectedDate.month,
      1,
      calendarType: CalendarType.jalali,
    );
  }

  @override
  void nextWeek() {
    Jalali jalali = calendarDateTime.toJalali;
    if(jalali.month != jalali.addDays(8-jalali.weekDay).month){
      nextMonth();
    }
    else{
      jalali = jalali.addDays(8 - jalali.weekDay);
      calendarDateTime = CalendarDateTime.fromJalali(jalali);
    }
  }

  @override
  void previousWeek() {
    Jalali jalali = calendarDateTime.toJalali;
    if(jalali.month != jalali.subtract(Duration(days: jalali.weekDay - 1)).month){
      jalali = jalali.subtract(Duration(days: jalali.weekDay - 1));
      calendarDateTime = CalendarDateTime.fromJalali(jalali);
    }
    else{
      jalali = jalali.subtract(Duration(days: jalali.weekDay));
      calendarDateTime = CalendarDateTime.fromJalali(jalali);
    }
  }

  @override
  List<CalendarDateTime> getWeeklyDatesList() {
    List<CalendarDateTime> calendarDates = [];
    Jalali jalali = calendarDateTime.toJalali;
    jalali = jalali.subtract(Duration(days: jalali.weekDay - 1));
    while (calendarDates.length < 7) {
      calendarDates.add(CalendarDateTime.fromJalali(jalali));
      jalali = jalali.addDays(1);
    }
    return calendarDates;
  }

  @override
  List<CalendarDateTime> getMonthlyDatesList() {
    List<CalendarDateTime> calendarDates = [];
    Jalali jalali = Jalali(calendarDateTime.year, calendarDateTime.month, 1);
    jalali = jalali.subtract(Duration(days: jalali.weekDay - 1));
    while (true) {
      if (calendarDateTime.month != jalali.month && jalali.weekDay == 7) {
        calendarDates.add(CalendarDateTime.fromJalali(jalali));
        break;
      }
      calendarDates.add(CalendarDateTime.fromJalali(jalali));
      jalali = jalali.addDays(1);
      if (calendarDateTime.month != jalali.month && jalali.weekDay == 1) {
        break;
      }
    }
    return calendarDates;
  }
}
