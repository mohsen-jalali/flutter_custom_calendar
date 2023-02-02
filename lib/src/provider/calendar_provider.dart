import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
import 'package:flutter_custom_calendar/src/provider/gregorian_calendar_provider.dart';
import 'package:flutter_custom_calendar/src/provider/jalali_calendar_provider.dart';
import 'package:flutter_custom_calendar/src/utils/calendar_date_time_extension.dart';
import 'package:scoped_model/scoped_model.dart';

abstract class CalendarProvider extends Model {
  CalendarType calendarType;
  CalendarDateTime selectedDate;
  CalendarMode calendarMode;

  CalendarProvider({
    required this.calendarType,
    required this.selectedDate,
    required this.calendarMode,
  }) {
    initCalendarDateTime();
  }

  late CalendarDateTime calendarDateTime;

  factory CalendarProvider.createInstance({
    required CalendarType calendarType,
    required CalendarMode calendarMode,
    required CalendarDateTime? selectedDate,
  }) {
    if (calendarType == CalendarType.gregorian) {
      return GregorianCalendarProvider(
        selectedDate: selectedDate,
        calendarMode: calendarMode,
      );
    }
    return JalaliCalendarProvider(
      selectedDate: selectedDate,
      calendarMode: calendarMode,
    );
  }

  void initCalendarDateTime();

  List<CalendarDateTime> getDateList() {
    if (calendarMode == CalendarMode.weekly) {
      return getWeeklyDatesList();
    }
    return getMonthlyDatesList();
  }

  List<CalendarDateTime> getMonthlyDatesList();

  List<CalendarDateTime> getWeeklyDatesList();

  void selectCurrentDate();

  void nextWeek();

  void previousWeek();

  void nextMonth() {
    if (calendarDateTime.month == 12) {
      calendarDateTime = calendarDateTime.increaseYear;
    } else {
      calendarDateTime = CalendarDateTime(
          calendarDateTime.year, calendarDateTime.month + 1, 1,
          calendarType: calendarType);
    }
  }

  void previousMonth(){
    if (calendarDateTime.month == 12) {
      calendarDateTime = calendarDateTime.decreaseYear;
    } else {
      calendarDateTime = CalendarDateTime(
          calendarDateTime.year, calendarDateTime.month - 1, 1,
          calendarType: calendarType);
    }
  }

  void selectCalendarDate(CalendarDateTime selectedDate) {
    this.selectedDate = selectedDate;
  }

  void changeCalendarMode(CalendarMode calendarMode) {
    this.calendarMode = calendarMode;
    notifyListeners();
  }
}
