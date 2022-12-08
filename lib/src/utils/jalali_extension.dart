import 'package:shamsi_date/shamsi_date.dart';

extension JalaliExtension on Jalali {
  Jalali subtract(Duration duration){
    DateTime dateTime = toDateTime();
    dateTime = DateTime(dateTime.year,dateTime.month,dateTime.day - duration.inDays);
    return dateTime.toJalali();
  }
}