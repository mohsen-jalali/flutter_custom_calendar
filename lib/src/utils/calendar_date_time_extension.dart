import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';

extension CalendarDateTimeExtension on CalendarDateTime {
  CalendarDateTime get increaseYear {
    return CalendarDateTime(year + 1, 1, 1, calendarType: calendarType);
  }

  CalendarDateTime get decreaseYear {
    return CalendarDateTime(year - 1, 12, 1, calendarType: calendarType);
  }

  CalendarDateTime get increaseMonth {
    if (month == 12) {
      return increaseYear;
    }
    return CalendarDateTime(year, month + 1, 1, calendarType: calendarType);
  }

  CalendarDateTime get decreaseMonth {
    if (month == 1) {
      return decreaseYear;
    }
    return CalendarDateTime(year, month - 1, 1, calendarType: calendarType);
  }
}