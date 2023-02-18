import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/src/model/calendar_date_time.dart';
import 'package:flutter_custom_calendar/src/model/custom_day_model.dart';
import 'package:flutter_custom_calendar/src/model/custom_header_model.dart';
import 'package:flutter_custom_calendar/src/model/custom_range_day_model.dart';
import 'package:flutter_custom_calendar/src/model/picked_range_model.dart';
import 'package:flutter_custom_calendar/src/model/selected_date_model.dart';
import 'package:flutter_custom_calendar/src/provider/calendar_provider.dart';
import 'package:flutter_custom_calendar/src/utils/calendar_utils.dart';
import 'package:flutter_custom_calendar/src/widgets/range_picker_calendar/calendar_range_widget.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomCalendarRangePicker extends StatefulWidget {
  final CalendarType calendarType;
  final PickedRange selectedRange;
  final Function(PickedRange)? onSelectRangeDates;
  final CalendarRangeDayModel calendarRangeDayModel;
  final HeaderModel? headerModel;
  final Color? backgroundColor;
  final Decoration? calendarDecoration;
  final EdgeInsets? padding;
  final bool showOverFlowDays;
  final List<String>? weekDaysTitles;
  final List<String>? monthTitles;

  const CustomCalendarRangePicker({
    Key? key,
    required this.selectedRange,
    this.calendarType = CalendarType.gregorian,
    this.calendarRangeDayModel = const CalendarRangeDayModel(),
    this.backgroundColor,
    this.calendarDecoration,
    this.padding,
    this.headerModel,
    this.showOverFlowDays = false,
    this.onSelectRangeDates,
    this.weekDaysTitles,
    this.monthTitles,
  }) : super(key: key);

  @override
  State<CustomCalendarRangePicker> createState() =>
      _CustomCalendarRangePickerState();
}

class _CustomCalendarRangePickerState extends State<CustomCalendarRangePicker> {
  late GlobalKey<CalendarRangeWidgetState> rangePickerWidgetKey;
  late CalendarProvider calendarProvider;

  @override
  void initState() {
    super.initState();
    rangePickerWidgetKey = GlobalKey<CalendarRangeWidgetState>();
    initialCalendarProvider();
  }

  @override
  void didUpdateWidget(covariant CustomCalendarRangePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.calendarType != widget.calendarType) {
      initialCalendarProvider();
      updateWidgets();
    }
  }

  void initialCalendarProvider() {
    calendarProvider = CalendarProvider.createInstance(
      calendarType: widget.calendarType,
      selectedDateModel: SelectedDateModel(
          rangeDates: widget.selectedRange,
          singleDate: CalendarDateTime.fromDateTime(DateTime.now())),
      calendarMode: CalendarMode.monthlyTable,
      selectionMode: CalendarSelectionMode.range,
    );
  }

  void updateWidgets() {
    rangePickerWidgetKey.currentState?.initialization();
  }

  @override
  Widget build(BuildContext context) {

    CalendarUtils.initialization(
      calendarType: widget.calendarType,
      context: context,
      weekDaysTitle: widget.weekDaysTitles,
      monthTitle: widget.monthTitles,
    );

    return ScopedModel<CalendarProvider>(
      model: calendarProvider,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: widget.padding,
          clipBehavior: Clip.antiAlias,
          decoration: widget.calendarDecoration ??
              BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 10,
                  )
                ],
              ),
          child: ScopedModelDescendant<CalendarProvider>(
            builder: (context, child, provider) => CalendarRangeWidget(
              showOverflowDays: widget.showOverFlowDays,
              calendarMode: provider.calendarMode,
              calendarType: widget.calendarType,
              headerModel: widget.headerModel,
              calendarRangeDayModel: widget.calendarRangeDayModel,
              onSelectRange: widget.onSelectRangeDates,
            ),
          ),
        ),
      ),
    );
  }
}
