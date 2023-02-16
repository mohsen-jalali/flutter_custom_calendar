import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
import 'package:flutter_custom_calendar/src/provider/calendar_provider.dart';
import 'package:flutter_custom_calendar/src/utils/helper_functions.dart';
import 'package:flutter_custom_calendar/src/utils/calendar_date_time_extension.dart';
import 'package:flutter_custom_calendar/src/widgets/normal_calendar/calendar_day_widget.dart';
import 'package:flutter_custom_calendar/src/widgets/calendar_header.dart';
import 'package:flutter_custom_calendar/src/widgets/normal_calendar/calendar_week_day_row.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:scoped_model/scoped_model.dart';

class CalendarTableWidget extends StatefulWidget {
  final CalendarType calendarType;
  final CalendarDateTime? selectedDate;
  final Function(CalendarDateTime)? onSelectDate;
  final CalendarDayModel calendarDayModel;
  final HeaderModel? headerModel;
  final CalendarMode calendarMode;
  final bool showOverflowDays;

  const CalendarTableWidget({
    Key? key,
    required this.calendarType,
    required this.calendarMode,
    required this.showOverflowDays,
    required this.calendarDayModel,
    this.selectedDate,
    this.onSelectDate,
    this.headerModel,
  }) : super(key: key);

  @override
  State<CalendarTableWidget> createState() => CalendarTableWidgetState();
}

class CalendarTableWidgetState extends State<CalendarTableWidget> {
  PageController pageController = PageController(initialPage: 1000000);
  int currentPage = 1000000;
  List<CalendarDateTime> calendarDates = [];

  CalendarProvider get provider => ScopedModel.of<CalendarProvider>(context);

  double get calendarHeight {
    double padding = (widget.calendarDayModel.padding?.bottom ?? 0);
    if (calendarDates.length % 7 != 0) {
      return (widget.calendarDayModel.width) * (calendarDates.length ~/ 7 + 1) + padding;
    }
    return ((widget.calendarDayModel.width) * calendarDates.length ~/ 7)
        .toDouble() + padding;
  }

  @override
  void didUpdateWidget(covariant CalendarTableWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (provider.calendarMode != oldWidget.calendarMode) {
      initialization();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CalendarHeader(
          calendarDateTime: provider.calendarDateTime,
          onPressNext: () {
            pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
          },
          onPressPrevious: () {
            pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
          },
          onPressCurrentDate: () => selectCurrentDate(),
          headerModel: widget.headerModel,
        ),
        RowCalendarWeekDayTitle(
          calendarType: provider.calendarType,
        ),
        GestureDetector(
          onPanUpdate: onChangedCalendarMode,
          child: AnimatedContainer(
            height: calendarHeight,
            width: MediaQuery.of(context).size.width,
            duration: const Duration(milliseconds: 300),
            child: PageView.builder(
              controller: pageController,
              onPageChanged: (pageIndex) => onPageChanged(pageIndex),
              itemBuilder: (context, index) => GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisExtent: widget.calendarDayModel.width,
                  childAspectRatio: 1,
                ),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: calendarDates.length,
                itemBuilder: (context, index) {
                  return AnimationConfiguration.staggeredGrid(
                    columnCount: 7,
                    position: index,
                    duration: const Duration(milliseconds: 400),
                    child: ScaleAnimation(
                      child: FadeInAnimation(
                        child: CalendarDayWidget(
                          calendarDateTime: calendarDates[index],
                          calendarDateModel: widget.calendarDayModel,
                          showOverFlowDays: widget.showOverflowDays,
                          isSelected:
                              provider.selectedSingleDate == calendarDates[index],
                          isOverFlow: provider.calendarDateTime.month !=
                              calendarDates[index].month,
                          onSelectDate: () => selectDate(calendarDates[index]),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    initialization();
    super.initState();
  }

  void initialization() {
    postFrameCallback(() {
      getCalendarDates();
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
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
    if (currentPage < pageIndex) {
      nextPage();
    } else {
      previousPage();
    }
    currentPage = pageIndex;
  }

  void selectCurrentDate() {
    provider.selectCurrentDate();
    getCalendarDates();
    widget.onSelectDate?.call(provider.selectedSingleDate);
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

  void onChangedCalendarMode(DragUpdateDetails details) {
    ///Swiping up to change calendar mode to weekly
    if (details.delta.dy < -10) {
      provider.changeCalendarMode(CalendarMode.weekly);
    } else if (details.delta.dy > 10) {
      provider.changeCalendarMode(CalendarMode.monthlyTable);
    }
  }
}
