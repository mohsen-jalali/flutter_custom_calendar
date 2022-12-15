import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/src/model/calendar_date_time.dart';
import 'package:flutter_custom_calendar/src/utils/calendar_date_time_extension.dart';
import 'package:flutter_custom_calendar/src/utils/jalali_extension.dart';
import 'package:shamsi_date/shamsi_date.dart';

class CalendarProvider extends ChangeNotifier {
  CalendarType calendarType = CalendarType.gregorian;
  CalendarDateTime calendarDate = CalendarDateTime.fromDateTime(DateTime.now());
  CalendarDateTime? selectedDate;
  List<CalendarDateTime> calendarDates = [];
  PageController pageController = PageController(initialPage: 100000);

  void initialCalendar(
      CalendarType calendarType, CalendarDateTime? initialDate) {
    this.calendarType = calendarType;
    if (initialDate != null) {
      calendarDate = initialDate;
    } else {
      if (calendarType == CalendarType.jalali) {
        calendarDate = CalendarDateTime.fromJalali(Jalali.now());
      } else {
        calendarDate = CalendarDateTime.fromDateTime(DateTime.now());
      }
    }
    _generateCalendarDateTimeList();
    selectDate(calendarDate);
  }

  void goToCurrentDate() {
    if (calendarType == CalendarType.jalali) {
      calendarDate = CalendarDateTime.fromJalali(Jalali.now());
    } else {
      calendarDate = CalendarDateTime.fromDateTime(DateTime.now());
    }
    _generateCalendarDateTimeList();
    selectDate(calendarDate);
  }

  void goToNextPage() {
    pageController.nextPage(
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    _increaseMonth();
  }

  void goToPreviousPage() {
    pageController.previousPage(
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    _decreaseMonth();
  }

  void selectDate(CalendarDateTime date) {
    selectedDate = date;
    notifyListeners();
    if (calendarDate.month != date.month) {
      if (calendarDate.isAfter(date) == 1) {
        goToPreviousPage();
      } else if (calendarDate.isAfter(date) == -1) {
        goToNextPage();
      }
    }
  }

  void changeCalendarType(CalendarType calendarType) {
    if (this.calendarType == calendarType) return;
    this.calendarType = calendarType;
    calendarDate = calendarDate.changeCalendarType(calendarType);
    if (selectedDate != null) {
      selectedDate = selectedDate!.changeCalendarType(calendarType);
    }
    _generateCalendarDateTimeList();
  }

  void _increaseMonth() {
    calendarDate = calendarDate.increaseMonth;
    _generateCalendarDateTimeList();
  }

  void _decreaseMonth() {
    calendarDate = calendarDate.decreaseMonth;
    _generateCalendarDateTimeList();
  }

  void _generateCalendarDateTimeList() {
    calendarDates.clear();
    switch (calendarType) {
      case CalendarType.jalali:
        _calculateJalaliDateTimes();
        break;
      case CalendarType.gregorian:
        _calculateGregorianDateTimes();
        break;
    }
    notifyListeners();
  }

  void _calculateJalaliDateTimes() {
    Jalali jalali = Jalali(calendarDate.year, calendarDate.month, 1);
    for (int index = jalali.weekDay - 1; index >= 1; index--) {
      calendarDates.add(
        CalendarDateTime.fromJalali(
          jalali.subtract(Duration(days: index)),
        ),
      );
    }
    while (jalali.month == calendarDate.month) {
      calendarDates.add(CalendarDateTime.fromJalali(
        jalali,
      ));
      jalali = jalali.addDays(1);
    }
    if (jalali.weekDay > 1) {
      for (int index = jalali.weekDay; index <= 7; index++) {
        calendarDates.add(CalendarDateTime.fromJalali(
          jalali,
        ));
        jalali = jalali.addDays(1);
      }
    }
  }

  void _calculateGregorianDateTimes() {
    DateTime dateTime = DateTime(calendarDate.year, calendarDate.month, 1);
    for (int index = dateTime.weekday; index > 1; index--) {
      calendarDates.add(CalendarDateTime.fromDateTime(
        dateTime.subtract(Duration(days: index - 1)),
      ));
    }
    while (dateTime.month == calendarDate.month) {
      calendarDates.add(CalendarDateTime.fromDateTime(
        dateTime,
      ));

      dateTime =
          DateTime(calendarDate.year, calendarDate.month, dateTime.day + 1);
    }
    if (dateTime.weekday > 1) {
      for (int index = dateTime.weekday; index <= 7; index++) {
        calendarDates.add(CalendarDateTime.fromDateTime(
          dateTime,
        ));
        dateTime = dateTime.add(const Duration(days: 1));
      }
    }
  }
}
