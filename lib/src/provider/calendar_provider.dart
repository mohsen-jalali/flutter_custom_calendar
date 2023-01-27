import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
import 'package:flutter_custom_calendar/src/provider/gregorian_calendar_provider.dart';
import 'package:flutter_custom_calendar/src/provider/jalali_calendar_provider.dart';
import 'package:flutter_custom_calendar/src/utils/calendar_date_time_extension.dart';
import 'package:scoped_model/scoped_model.dart';

abstract class CalendarProvider extends Model {
  CalendarType calendarType;
  CalendarDateTime selectedDate;

  CalendarProvider({
    required this.calendarType,
    required this.selectedDate,
  }) {
    initCalendarDateTime();
  }

  late CalendarDateTime calendarDateTime;

  factory CalendarProvider.createInstance({
    required CalendarType calendarType,
    required CalendarDateTime? selectedDate,
  }) {
    if (calendarType == CalendarType.gregorian) {
      return GregorianCalendarProvider(
        selectedDate: selectedDate,
      );
    }
    return JalaliCalendarProvider(selectedDate: selectedDate);
  }

  void initCalendarDateTime();

  List<CalendarDateTime> getMonthDateLit();

  void selectCurrentDate();

  void increaseMonth() {
    calendarDateTime = calendarDateTime.increaseMonth;
  }

  void decreaseMonth() {
    calendarDateTime = calendarDateTime.decreaseMonth;
  }

  void selectCalendarDate(CalendarDateTime selectedDate) {
    this.selectedDate = selectedDate;
  }
}
