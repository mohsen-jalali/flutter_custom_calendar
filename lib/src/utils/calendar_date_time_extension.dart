import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
import 'package:shamsi_date/shamsi_date.dart';

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

  bool get isBeforeNow{
    if(calendarType == CalendarType.jalali){
      return CalendarDateTime.fromJalali(Jalali.now()).isAfter(this) == 1;
    }
    return CalendarDateTime.fromDateTime(DateTime.now()).isAfter(this)  == 1;
  }

  Jalali get toJalali{
    return Jalali(year,month,day);
  }

  DateTime get toDateTime{
    return DateTime(year,month,day);
  }

  int isAfter(CalendarDateTime dateTime){
    if(year > dateTime.year){
      return 1;
    }
    else if(year < dateTime.year){
      return -1;
    }
    else{
      if(month > dateTime.month){
        return 1;
      }
      else if(month < dateTime.month){
        return -1;
      }
      else{
        if(day > dateTime.day){
          return 1;
        }
        else if(day < dateTime.day){
          return -1;
        }
        return 0;
      }
    }
  }
}