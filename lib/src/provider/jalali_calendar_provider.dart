import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
import 'package:flutter_custom_calendar/src/provider/calendar_provider.dart';
import 'package:flutter_custom_calendar/src/utils/calendar_date_time_extension.dart';
import 'package:flutter_custom_calendar/src/utils/jalali_extension.dart';
import 'package:shamsi_date/shamsi_date.dart';

class JalaliCalendarProvider extends CalendarProvider {
  JalaliCalendarProvider({
    required CalendarDateTime? selectedDate,
  }) : super(
          calendarType: CalendarType.jalali,
          selectedDate:
              selectedDate ?? CalendarDateTime.fromJalali(Jalali.now()),
        );

  @override
  void initCalendarDateTime() {
    if(selectedDate.calendarType == CalendarType.gregorian){
      selectedDate = selectedDate.changeCalendarType(CalendarType.jalali);
    }
    calendarDateTime = CalendarDateTime(
      selectedDate.year,
      selectedDate.month,
      1,
      calendarType: CalendarType.jalali,
    );
  }

  @override
  List<CalendarDateTime> getMonthDateLit() {
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
}
