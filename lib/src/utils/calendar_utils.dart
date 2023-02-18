import 'package:flutter/cupertino.dart';
import 'package:flutter_custom_calendar/src/model/calendar_date_time.dart';
import 'package:flutter_custom_calendar/src/utils/calendar_date_time_extension.dart';

class CalendarUtils {
  static List<String> weekDaysTitles = [];
  static List<String> monthsTitles = [];

  static void initialization({
    required CalendarType calendarType,
    required BuildContext context,
    List<String>? weekDaysTitle,
    List<String>? monthTitle,
  }) {
    weekDaysTitles = weekDaysTitle ?? getWeekDaysTitle(calendarType);
    monthsTitles = monthTitle ?? getMonthTitles(calendarType, context);
  }

  static List<String> getWeekDaysTitle(CalendarType calendarType) {
    switch (calendarType) {
      case CalendarType.jalali:
        return jalaliWeekDays;
      case CalendarType.gregorian:
        return gregorianWeekDays;
    }
  }

  static List<String> getMonthTitles(
      CalendarType calendarType, BuildContext context) {
    switch (calendarType) {
      case CalendarType.jalali:
        switch (Localizations.localeOf(context).languageCode) {
          case "fa":
            return persianJalaliMonthTitles;
          default:
            return englishJalaliMonthTitles;
        }
      case CalendarType.gregorian:
        switch (Localizations.localeOf(context).languageCode) {
          case "fa":
            return persianGregorianMonthTitles;
          default:
            return englishGregorianMonthTitles;
        }
    }
  }

  static String getMonthName(
      CalendarDateTime calendarDateTime, BuildContext context) {
    return monthsTitles[calendarDateTime.month - 1];
  }

  static String getWeekdayTitle(
      CalendarDateTime calendarDateTime, BuildContext context) {
    return weekDaysTitles[calendarDateTime.weekDay - 1];
  }

  static const List<String> jalaliWeekDays = [
    "شنبه",
    "یکشنبه",
    "دوشنبه",
    "سه شنبه",
    "چهارشنبه",
    "پنجشنبه",
    "جمعه",
  ];

  static const List<String> gregorianWeekDays = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun"
  ];

  static const List<String> persianJalaliMonthTitles = [
    "فروردین",
    "اردیبهشت",
    "خرداد",
    "تیر",
    "مرداد",
    "شهریور",
    "مهر",
    "آبان",
    "آذر",
    "دی",
    "بهمن",
    "اسفند",
  ];

  static const List<String> englishJalaliMonthTitles = [
    "Farvardin",
    "Ordibehesht",
    "Khordad",
    "Tir",
    "Mordad",
    "Shahrivar",
    "Mehr",
    "Aban",
    "Azar",
    "Dey",
    "Bahman",
    "Esfand"
  ];

  static const List<String> persianGregorianMonthTitles = [
    "ژانویه",
    "فوریه",
    "مارچ",
    "آپریل",
    "می",
    "ژوئن",
    "ژوئیه",
    "آگوست",
    "سپتامبر",
    "اکتبر",
    "نوامبر",
    "دسامبر",
  ];

  static const List<String> englishGregorianMonthTitles = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];
}
