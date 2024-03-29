import 'package:shamsi_date/shamsi_date.dart';

enum CalendarType { jalali, gregorian }

enum CalendarMode { weekly, monthlyTable , monthlyLinear }

enum CalendarSelectionMode { range, single }

class CalendarDateTime {
  int year;
  int month;
  int day;
  CalendarType calendarType;

  CalendarDateTime(
    this.year,
    this.month,
    this.day, {
    this.calendarType = CalendarType.gregorian,
  });

  factory CalendarDateTime.fromDateTime(DateTime dateTime) =>
      CalendarDateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day,
        calendarType: CalendarType.gregorian,
      );

  factory CalendarDateTime.fromJalali(Jalali jalali) =>
      CalendarDateTime(
        jalali.year,
        jalali.month,
        jalali.day,
        calendarType: CalendarType.jalali,
      );

  @override
  String toString() {
    return "$year-${month.toString().padLeft(2,"0")}-${day.toString().padLeft(2,"0")}";
  }

  @override
  bool operator ==(Object other) {
    if(other is CalendarDateTime){
      return year == other.year && month == other.month && day == other.day;
    }
    return super == other;
  }


}
