import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/src/model/calendar_date_time.dart';
import 'package:flutter_custom_calendar/src/model/custom_day_model.dart';
import 'package:flutter_custom_calendar/src/model/custom_header_model.dart';
import 'package:flutter_custom_calendar/src/provider/calendar_provider.dart';
import 'package:flutter_custom_calendar/src/widgets/calendar_header.dart';
import 'package:flutter_custom_calendar/src/widgets/calendar_monthly_widget.dart';
import 'package:flutter_custom_calendar/src/widgets/calendar_week_day_row.dart';
import 'package:provider/provider.dart';

class CustomCalendar extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: padding,
        clipBehavior: Clip.antiAlias,
        decoration: calendarDecoration ??
            BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 10,
                  )
                ]),
        child: Builder(
          builder: (context) {
            switch (calendarMode) {
              case CalendarMode.monthlyLinear:
                return const Center(
                  child: Text("Coming Soon"),
                );
              default:
                return ChangeNotifierProvider(
                  create: (context) => CalendarProvider(),
                  builder: (context, child) => CalendarMonthlyWidget(
                    calendarType: calendarType,
                    selectedDate: selectedDate,
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
