import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
import 'package:flutter_custom_calendar/src/model/picked_range_model.dart';

class SelectedDateModel {
  CalendarDateTime? singleDate;
  PickedRange? rangeDates;

  SelectedDateModel({
    this.singleDate,
    this.rangeDates,
  });

}
