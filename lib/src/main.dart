import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/src/model/calendar_date_time.dart';
import 'package:flutter_custom_calendar/src/model/custom_day_model.dart';
import 'package:flutter_custom_calendar/src/model/custom_header_model.dart';
import 'package:flutter_custom_calendar/src/provider/calendar_provider.dart';
import 'package:flutter_custom_calendar/src/widgets/calendar_table_widget.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomCalendar extends StatefulWidget {
  final CalendarType calendarType;
  final CalendarDateTime? selectedDate;
  final Function(CalendarDateTime)? onSelectDate;
  final CalendarDayModel? calendarDayModel;
  final HeaderModel? headerModel;
  final Color? backgroundColor;
  final Decoration? calendarDecoration;
  final EdgeInsets? padding;
  final CalendarMode calendarMode;

  const CustomCalendar({
    Key? key,
    this.calendarType = CalendarType.gregorian,
    this.selectedDate,
    this.onSelectDate,
    this.calendarDayModel,
    this.backgroundColor,
    this.calendarDecoration,
    this.padding,
    this.headerModel,
    this.calendarMode = CalendarMode.monthlyTable,
  }) : super(key: key);

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  late GlobalKey<CalendarTableWidgetState> monthlyStateKey;
  late CalendarProvider calendarProvider;

  @override
  void initState() {
    super.initState();
    monthlyStateKey = GlobalKey<CalendarTableWidgetState>();
    initialCalendarProvider();
  }

  @override
  void didUpdateWidget(covariant CustomCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.calendarType != widget.calendarType) {
      initialCalendarProvider();
      updateWidgets();
    }
  }

  void initialCalendarProvider() {
    calendarProvider = CalendarProvider.createInstance(
      calendarType: widget.calendarType,
      selectedDate: widget.selectedDate,
      calendarMode: widget.calendarMode,
    );
  }

  void updateWidgets() {
    switch (widget.calendarType) {
      default:
        monthlyStateKey.currentState?.initialization();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
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
            builder: (context, child, provider) {
              switch (provider.calendarMode) {
                case CalendarMode.monthlyLinear:
                  return const Center(
                    child: Text("Coming Soon"),
                  );
                default:
                  return CalendarTableWidget(
                    key: monthlyStateKey,
                    calendarMode: provider.calendarMode,
                    calendarType: widget.calendarType,
                    selectedDate: widget.selectedDate,
                    headerModel: widget.headerModel,
                    calendarDayModel: widget.calendarDayModel,
                    onSelectDate: widget.onSelectDate,
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}
