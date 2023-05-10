import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
import 'package:flutter_custom_calendar/src/utils/calendar_date_time_extension.dart';

class PickedRange {
  CalendarDateTime? startDate;
  CalendarDateTime? endDate;

  PickedRange({
    this.startDate,
    this.endDate,
  }) : assert(
          startDate?.isAfter(endDate) != 1,
        );
}
