import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
import 'package:flutter_custom_calendar/src/utils/jalali_extension.dart';
import 'package:shamsi_date/shamsi_date.dart';

extension CalendarDateTimeExtension on CalendarDateTime {
  CalendarDateTime get increaseYear {
    return CalendarDateTime(year + 1, 1, 1, calendarType: calendarType);
  }

  CalendarDateTime get decreaseYear {
    return CalendarDateTime(year - 1, 12, 1, calendarType: calendarType);
  }

  CalendarDateTime changeCalendarType(CalendarType calendarType) {
    if (calendarType == CalendarType.jalali) {
      return CalendarDateTime.fromJalali(toJalali);
    }
    return CalendarDateTime.fromDateTime(toDateTime);
  }

  bool get isToday {
    DateTime dateTime = toDateTime;
    DateTime now = DateTime.now();
    if (dateTime.day == now.day &&
        dateTime.month == now.month &&
        dateTime.year == now.year) {
      return true;
    }
    return false;
  }

  bool get isBeforeNow {
    if (calendarType == CalendarType.jalali) {
      return CalendarDateTime.fromJalali(Jalali.now()).isAfter(this) == 1;
    }
    return CalendarDateTime.fromDateTime(DateTime.now()).isAfter(this) == 1;
  }

  int differenceInDays(CalendarDateTime date) {
    return date.toDateTime.difference(toDateTime).inDays.abs();
  }

  Jalali get toJalali {
    if (calendarType == CalendarType.gregorian) {
      return toDateTime.toJalali();
    }
    return Jalali(year, month, day);
  }

  int get weekDay{
    if(calendarType == CalendarType.gregorian){
      return toDateTime.weekday;
    }
    return toJalali.weekDay;
  }

  DateTime get toDateTime {
    if (calendarType == CalendarType.jalali) {
      return toJalali.toDateTime();
    }
    return DateTime(year, month, day);
  }

  int isAfterDateTime(DateTime dateTime) {
    CalendarDateTime calendarDateTime = CalendarDateTime.fromDateTime(dateTime)
        .changeCalendarType(calendarType);
    return isAfter(calendarDateTime);
  }

  int isAfter(CalendarDateTime? dateTime) {
    if(dateTime == null) return 0;
    if (year > dateTime.year) {
      return 1;
    } else if (year < dateTime.year) {
      return -1;
    } else {
      if (month > dateTime.month) {
        return 1;
      } else if (month < dateTime.month) {
        return -1;
      } else {
        if (day > dateTime.day) {
          return 1;
        } else if (day < dateTime.day) {
          return -1;
        }
        return 0;
      }
    }
  }
}
