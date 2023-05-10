import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/src/model/calendar_date_time.dart';
import 'package:flutter_custom_calendar/src/model/custom_header_model.dart';
import 'package:flutter_custom_calendar/src/provider/calendar_provider.dart';
import 'package:flutter_custom_calendar/src/utils/calendar_date_time_extension.dart';
import 'package:flutter_custom_calendar/src/utils/context_extensions.dart';
import 'package:flutter_custom_calendar/src/utils/helper_functions.dart';
import 'package:flutter_custom_calendar/src/widgets/calendar_container_widget.dart';

abstract class BaseCalendarWidget extends StatefulWidget {
  final CalendarDateTime? selectedDate;
  final Function(CalendarDateTime)? onSelectDate;
  final HeaderModel? headerModel;
  final CalendarMode calendarMode;
  final EdgeInsets? padding;
  final TextStyle? weekDayStyle;
  final bool hasWeekDayTitle;
  final EdgeInsets? calendarPadding;

  const BaseCalendarWidget({
    Key? key,
    required this.calendarMode,
    this.selectedDate,
    this.onSelectDate,
    this.headerModel,
    this.padding,
    this.weekDayStyle,
    this.calendarPadding,
    this.hasWeekDayTitle = true,
  }) : super(key: key);
}

/// Base class of the calendar's state class
abstract class BaseCalendarWidgetState<T extends BaseCalendarWidget>
    extends State<T> {
  PageController pageController = PageController(initialPage: 1000000);
  List<CalendarDateTime> calendarDates = [];

  CalendarProvider get provider => context.provider;

  double get calendarHeight;

  @override
  Widget build(BuildContext context) {
    return CalendarContainerWidget(
      weekDayStyle: widget.weekDayStyle,
      padding: widget.padding,
      calendarHeight: calendarHeight +
          (widget.calendarPadding?.bottom ?? 0) +
          (widget.calendarPadding?.top ?? 0),
      onTapNext: () {
          pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut);
      },
      onTapPrevious: () {
          pageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut);
      },
      onSelectCurrentDate: () => selectCurrentDate(),
      hasWeekDayTitle: widget.hasWeekDayTitle,
      refreshCalendar: initialization,
      headerModel: widget.headerModel,
      calendarWidget: body(context),
    );
  }

  Widget body(BuildContext context);

  @override
  void initState() {
    super.initState();
    initialization();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (provider.calendarMode != oldWidget.calendarMode) {
      initialization();
    }
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void initialization() {
    postFrameCallback(() {
      getCalendarDates();
    });
  }

  void getCalendarDates() {
    calendarDates = provider.getDateList();
    setState(() {});
  }

  void nextPage() {
    if (provider.calendarMode == CalendarMode.weekly) {
      provider.nextWeek();
    } else {
      provider.nextMonth();
    }
    getCalendarDates();
  }

  void previousPage() {
    if (provider.calendarMode == CalendarMode.weekly) {
      provider.previousWeek();
    } else {
      provider.previousMonth();
    }
    getCalendarDates();
  }

  void onPageChanged(int pageIndex) {
    if ((pageController.page ?? 0) < pageIndex) {
      nextPage();
    } else {
      previousPage();
    }
  }

  void selectCurrentDate() {
    provider.selectCurrentDate();
    getCalendarDates();
    widget.onSelectDate?.call(provider.selectedSingleDate!);
  }

  void selectDate(CalendarDateTime selectedDate) {
    provider.selectDate(selectedDate);
    if (selectedDate.month != provider.calendarDateTime.month) {
      if (selectedDate.isAfter(provider.calendarDateTime) == 1) {
        pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut);
      } else {
        pageController.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut);
      }
    }
    widget.onSelectDate?.call(selectedDate);
    setState(() {});
  }
}
