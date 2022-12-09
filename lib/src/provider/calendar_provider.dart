import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/src/model/calendar_date_time.dart';
import 'package:flutter_custom_calendar/src/utils/calendar_date_time_extension.dart';
import 'package:flutter_custom_calendar/src/utils/jalali_extension.dart';
import 'package:shamsi_date/shamsi_date.dart';

class CalendarProvider extends ChangeNotifier {
  final CalendarType calendarType;

  CalendarProvider({
    required this.calendarType,
  }) {
    if (calendarType == CalendarType.jalali) {
      currentTime = CalendarDateTime.fromJalali(Jalali.now());
    } else {
      currentTime = CalendarDateTime.fromDateTime(DateTime.now());
    }
    generateCalendarDateTimeList();
  }

  late CalendarDateTime currentTime;
  CalendarDateTime? selectedDate;
  List<CalendarDateTime> calendarDates = [];
  PageController pageController = PageController(initialPage: 1000);
  int currentPage = 1000;

  void goToNextPage() {
    pageController.nextPage(
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void goToPreviousPage() {
    pageController.previousPage(
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void onChangeMonthPageView(int index) {
    if (currentPage > index) {
      decreaseMonth();
    }
    if (currentPage < index) {
      increaseMonth();
    }
    currentPage = index;
  }

  void selectDate(CalendarDateTime date) {
    selectedDate = date;
    notifyListeners();
    if (currentTime.month != date.month) {
      if (currentTime.isAfter(date) == 1) {
        goToPreviousPage();
      } else if (currentTime.isAfter(date) == -1) {
        goToNextPage();
      }
    }
  }

  void increaseMonth() {
    currentTime = currentTime.increaseMonth;
    generateCalendarDateTimeList();
  }

  void decreaseMonth() {
    currentTime = currentTime.decreaseMonth;
    generateCalendarDateTimeList();
  }

  void generateCalendarDateTimeList() {
    calendarDates.clear();
    switch (calendarType) {
      case CalendarType.jalali:
        calculateJalaliDateTimes();
        break;
      case CalendarType.gregorian:
        calculateGregorianDateTimes();
        break;
    }
    notifyListeners();
  }

  void calculateJalaliDateTimes() {
    Jalali jalali = Jalali(currentTime.year, currentTime.month, 1);
    for (int index = jalali.weekDay - 1; index >= 1; index--) {
      calendarDates.add(
        CalendarDateTime.fromJalali(
          jalali.subtract(Duration(days: index)),
        ),
      );
    }
    while (jalali.month == currentTime.month) {
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

  void calculateGregorianDateTimes() {
    DateTime dateTime = DateTime(currentTime.year, currentTime.month, 1);
    for (int index = dateTime.weekday; index > 1; index--) {
      calendarDates.add(CalendarDateTime.fromDateTime(
        dateTime.subtract(Duration(days: index - 1)),
      ));
    }
    while (dateTime.month == currentTime.month) {
      calendarDates.add(CalendarDateTime.fromDateTime(
        dateTime,
      ));

      dateTime =
          DateTime(currentTime.year, currentTime.month, dateTime.day + 1);
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
