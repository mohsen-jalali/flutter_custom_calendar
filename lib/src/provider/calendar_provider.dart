import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
import 'package:flutter_custom_calendar/src/model/picked_range_model.dart';
import 'package:flutter_custom_calendar/src/model/selected_date_model.dart';
import 'package:flutter_custom_calendar/src/provider/gregorian_calendar_provider.dart';
import 'package:flutter_custom_calendar/src/provider/jalali_calendar_provider.dart';
import 'package:flutter_custom_calendar/src/utils/calendar_date_time_extension.dart';
import 'package:scoped_model/scoped_model.dart';

abstract class CalendarProvider extends Model {
  CalendarType calendarType;
  SelectedDateModel selectedDate;
  CalendarMode calendarMode;
  CalendarSelectionMode calendarSelectionMode;

  CalendarProvider({
    required this.calendarType,
    required this.selectedDate,
    required this.calendarMode,
    required this.calendarSelectionMode,
  }) {
    initCalendarDateTime();
  }

  late CalendarDateTime calendarDateTime;

  factory CalendarProvider.createInstance({
    required CalendarType calendarType,
    required CalendarMode calendarMode,
    required SelectedDateModel? selectedDateModel,
    required CalendarSelectionMode selectionMode,
  }) {
    switch (calendarType) {
      case CalendarType.jalali:
        return JalaliCalendarProvider(
          selectedDate: selectedDateModel,
          calendarMode: calendarMode,
          selectionMode: selectionMode,
        );
      case CalendarType.gregorian:
        return GregorianCalendarProvider(
          selectedDate: selectedDateModel,
          calendarMode: calendarMode,
          selectionMode: selectionMode,
        );
    }
  }

  CalendarDateTime? get selectedSingleDate => selectedDate.singleDate;

  PickedRange? get selectedRangeDates => selectedDate.rangeDates;

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

  void previousMonth() {
    if (calendarDateTime.month == 1) {
      calendarDateTime = calendarDateTime.decreaseYear;
    } else {
      calendarDateTime = CalendarDateTime(
          calendarDateTime.year, calendarDateTime.month - 1, 1,
          calendarType: calendarType);
    }
  }

  void goToMonth(int month) {
    calendarDateTime = CalendarDateTime(calendarDateTime.year, month, 1,
        calendarType: calendarType);
  }

  void goToYear(int year) {
    calendarDateTime = CalendarDateTime(year, calendarDateTime.month, 1,
        calendarType: calendarType);
  }

  void selectDate(CalendarDateTime selectedDate) {
    switch (calendarSelectionMode) {
      case CalendarSelectionMode.range:
        _selectRangeCalendarDate(selectedDate);
        break;
      case CalendarSelectionMode.single:
        _selectSingleDate(selectedDate);
        break;
    }
  }

  void _selectSingleDate(CalendarDateTime selectedDate) {
    this.selectedDate.singleDate = selectedDate;
  }

  void _selectRangeCalendarDate(CalendarDateTime selectedDate) {
    if (selectedRangeDates!.startDate == null &&
        selectedRangeDates!.endDate == null) {
      selectedRangeDates?.startDate = selectedDate;
    } else if (selectedRangeDates!.startDate != null &&
        selectedRangeDates!.endDate == null) {
      if (selectedRangeDates!.startDate!.isAfter(selectedDate) == 1) {
        selectedRangeDates!.endDate = selectedRangeDates!.startDate;
        selectedRangeDates!.startDate = selectedDate;
      }
    } else {
      if (selectedDate.isAfter(selectedRangeDates!.startDate!) == -1) {
        selectedRangeDates?.startDate = selectedDate;
      } else if (selectedDate.isAfter(selectedRangeDates!.endDate!) == 1) {
        selectedRangeDates?.endDate = selectedDate;
      } else {
        if (selectedRangeDates!.startDate!.differenceInDays(selectedDate) <
            selectedRangeDates!.endDate!.differenceInDays(selectedDate)) {
          selectedRangeDates!.startDate = selectedDate;
        } else {
          selectedRangeDates!.endDate = selectedDate;
        }
      }
    }
  }

  void changeCalendarMode(CalendarMode calendarMode) {
    this.calendarMode = calendarMode;
    notifyListeners();
  }
}
