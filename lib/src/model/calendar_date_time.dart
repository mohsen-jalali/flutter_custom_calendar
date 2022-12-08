import 'package:shamsi_date/shamsi_date.dart';

enum CalendarType { jalali, gregorian }

class CalendarDateTime  {
  int year;
  int month;
  int day;
  CalendarType calendarType;
  bool isDisable;

  CalendarDateTime(
    this.year,
    this.month,
    this.day, {
    this.calendarType = CalendarType.gregorian,
    this.isDisable = false,
  });

  factory CalendarDateTime.fromDateTime(DateTime dateTime,
          {bool isDisable = false}) =>
      CalendarDateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day,
        calendarType: CalendarType.jalali,
        isDisable: isDisable,
      );

  factory CalendarDateTime.fromJalali(Jalali jalali,
          {bool isDisable = false}) {
    return CalendarDateTime(
      jalali.year,
      jalali.month,
      jalali.day,
      calendarType: CalendarType.jalali,
      isDisable: isDisable,
    );
  }

  @override
  String toString() {
    return "$year-$month-$day";
  }

}


