import 'package:flutter_custom_calendar/src/model/calendar_date_time.dart';

class CalendarUtils {
  static List<String> weekDaysTitle(CalendarType calendarType) {
    switch (calendarType) {
      case CalendarType.jalali:
        return ["Shb","1sh","2sh","3sh","4sh","5sh","jom"];
      case CalendarType.gregorian:
        return ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    }
  }
}
