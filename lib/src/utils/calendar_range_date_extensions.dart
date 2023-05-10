import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
import 'package:flutter_custom_calendar/src/model/picked_range_model.dart';
import 'package:flutter_custom_calendar/src/utils/calendar_date_time_extension.dart';

extension PickedRangeExtensions on PickedRange {
  bool isInRange(CalendarDateTime dateTime) {
    if(startDate == null || endDate == null) {
      return false;
    }
    if (dateTime.isAfter(startDate!) == 1 && dateTime.isAfter(endDate!) == -1) {
      return true;
    }
    return false;
  }

  bool isEndTime(CalendarDateTime dateTime) {
    if (endDate == dateTime) {
      return true;
    }
    return false;
  }

  bool isStartTime(CalendarDateTime dateTime) {
    if (startDate == dateTime) {
      return true;
    }
    return false;
  }

  int get rangeInDays{
    if(startDate == null || endDate == null){
      return 0;
    }
    return startDate!.differenceInDays(endDate!) + 1;
  }
}
