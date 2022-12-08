import 'package:shamsi_date/shamsi_date.dart';

enum CalendarType { jalali, gregorian }

enum CalendarMode { weekly, monthlyTable , monthlyLinear }

enum CalendarDateType { previousMonth, nextMonth, current }

class CalendarDateTime {
  int year;
  int month;
  int day;
  CalendarType calendarType;
  CalendarDateType dateType;

  CalendarDateTime(
    this.year,
    this.month,
    this.day, {
    this.calendarType = CalendarType.gregorian,
    this.dateType = CalendarDateType.current,
  });

  factory CalendarDateTime.fromDateTime(DateTime dateTime,
          {CalendarDateType dateType = CalendarDateType.current}) =>
      CalendarDateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day,
        calendarType: CalendarType.jalali,
        dateType: dateType,
      );

  factory CalendarDateTime.fromJalali(Jalali jalali,
          {CalendarDateType dateType = CalendarDateType.current}) =>
      CalendarDateTime(
        jalali.year,
        jalali.month,
        jalali.day,
        calendarType: CalendarType.jalali,
        dateType: dateType,
      );

  @override
  String toString() {
    return "$year-$month-$day";
  }
}
