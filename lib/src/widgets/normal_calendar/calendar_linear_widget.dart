import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
import 'package:flutter_custom_calendar/src/provider/calendar_provider.dart';
import 'package:flutter_custom_calendar/src/utils/helper_functions.dart';
import 'package:flutter_custom_calendar/src/utils/calendar_date_time_extension.dart';
import 'package:flutter_custom_calendar/src/widgets/normal_calendar/calendar_day_widget.dart';
import 'package:flutter_custom_calendar/src/widgets/calendar_header.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:scoped_model/scoped_model.dart';

class CalendarLinearWidget extends StatefulWidget {
  final CalendarType calendarType;
  final CalendarDateTime? selectedDate;
  final Function(CalendarDateTime)? onSelectDate;
  final CalendarDayModel calendarDayModel;
  final HeaderModel? headerModel;
  final CalendarMode calendarMode;
  final bool showOverflowDays;

  const CalendarLinearWidget({
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
  State<CalendarLinearWidget> createState() => CalendarLinearWidgetState();
}

class CalendarLinearWidgetState extends State<CalendarLinearWidget> {
  ScrollController scrollController = ScrollController();
  PageController pageController = PageController(initialPage: 1000000);
  int currentPage = 1000000;
  List<CalendarDateTime> calendarDates = [];

  CalendarProvider get provider => ScopedModel.of<CalendarProvider>(context);

  @override
  void didUpdateWidget(covariant CalendarLinearWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (provider.calendarMode != oldWidget.calendarMode) {
      initialization();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => Column(
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
            onPressCurrentDate: () => selectCurrentDate(constraints.maxWidth),
            headerModel: widget.headerModel,
          ),
          SizedBox(
            height: widget.calendarDayModel.height + (widget.calendarDayModel.padding?.bottom ?? 0),
            width: MediaQuery.of(context).size.width,
            child: PageView.builder(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (pageIndex) => onPageChanged(pageIndex),
              itemBuilder: (context, index) => ListView.builder(
                itemCount: calendarDates.length,
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 100),
                    child: ScaleAnimation(
                      child: FadeInAnimation(
                        child: CalendarDayWidget(
                          calendarDateTime: calendarDates[index],
                          calendarDateModel: widget.calendarDayModel,
                          showOverFlowDays: false,
                          showWeekdayTitle: true,
                          isSelected:
                              provider.selectedSingleDate == calendarDates[index],
                          isOverFlow: provider.calendarDateTime.month !=
                              calendarDates[index].month,
                          onSelectDate: () => selectDate(calendarDates[index],constraints.maxWidth),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    initialization();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
    scrollController.dispose();
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
    provider.nextMonth();
    getCalendarDates();
  }

  void previousPage() {
    provider.previousMonth();
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

  void selectCurrentDate(double calendarWidth) {
    provider.selectCurrentDate();
    getCalendarDates();
    widget.onSelectDate?.call(provider.selectedSingleDate);
    updateScrollPosition(calendarWidth);
  }

  void updateScrollPosition(double calendarWidth){
    double dayWidth = widget.calendarDayModel.width;
    double offset = dayWidth * (provider.selectedSingleDate.day - 1) - calendarWidth/2 + dayWidth/2;
    scrollController.animateTo(offset, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void selectDate(CalendarDateTime selectedDate,double calendarWidth) {
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
    updateScrollPosition(calendarWidth);
    setState(() {});
  }

}
