import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
import 'package:flutter_custom_calendar/src/provider/calendar_provider.dart';
import 'package:flutter_custom_calendar/src/utils/calendar_range_date_extensions.dart';
import 'package:flutter_custom_calendar/src/utils/helper_functions.dart';
import 'package:flutter_custom_calendar/src/widgets/calendar_header.dart';
import 'package:flutter_custom_calendar/src/widgets/normal_calendar/calendar_week_day_row.dart';
import 'package:flutter_custom_calendar/src/widgets/range_picker_calendar/calendar_range_day_widget.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:scoped_model/scoped_model.dart';

class CalendarRangeWidget extends StatefulWidget {
  final CalendarType calendarType;
  final Function(PickedRange)? onSelectRange;
  final CalendarRangeDayModel calendarRangeDayModel;
  final HeaderModel? headerModel;
  final CalendarMode calendarMode;
  final bool showOverflowDays;

  const CalendarRangeWidget({
    Key? key,
    required this.calendarType,
    required this.calendarMode,
    required this.showOverflowDays,
    required this.calendarRangeDayModel,
    this.headerModel,
    this.onSelectRange,
  }) : super(key: key);

  @override
  State<CalendarRangeWidget> createState() => CalendarRangeWidgetState();
}

class CalendarRangeWidgetState extends State<CalendarRangeWidget> {
  PageController pageController = PageController(initialPage: 1000000);
  int currentPage = 1000000;
  List<CalendarDateTime> calendarDates = [];

  CalendarProvider get provider => ScopedModel.of<CalendarProvider>(context);

  double get calendarHeight {
    double padding = (widget.calendarRangeDayModel.padding?.bottom ?? 0);
    if (calendarDates.length % 7 != 0) {
      return (widget.calendarRangeDayModel.width) *
              (calendarDates.length ~/ 7 + 1) +
          padding;
    }
    return ((widget.calendarRangeDayModel.width) * calendarDates.length ~/ 7)
            .toDouble() +
        padding;
  }

  @override
  void didUpdateWidget(covariant CalendarRangeWidget oldWidget) {
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
          headerModel: widget.headerModel,
        ),
        RowCalendarWeekDayTitle(
          calendarType: provider.calendarType,
          textStyle: widget.calendarRangeDayModel.weekDayStyle,
        ),
        AnimatedContainer(
          height: calendarHeight,
          width: MediaQuery.of(context).size.width,
          duration: const Duration(milliseconds: 300),
          child: PageView.builder(
            controller: pageController,
            onPageChanged: (pageIndex) => onPageChanged(pageIndex),
            itemBuilder: (context, index) => GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisExtent: widget.calendarRangeDayModel.height,
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
                      child: CalendarRangeDayWidget(
                        calendarDateTime: calendarDates[index],
                        calendarRangeDayModel: widget.calendarRangeDayModel,
                        showOverFlowDays: widget.showOverflowDays,
                        isOverFlow: provider.calendarDateTime.month !=
                            calendarDates[index].month,
                        onSelectDate: () => selectDate(calendarDates[index]),
                        status: dayStatus(calendarDates[index]),
                      ),
                    ),
                  ),
                );
              },
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

  RangeDayStatus dayStatus(CalendarDateTime date) {
    if (provider.selectedRangeDates.isEndTime(date)) {
      return RangeDayStatus.endHead;
    } else if (provider.selectedRangeDates.isStartTime(date)) {
      return RangeDayStatus.startHead;
    } else if (provider.selectedRangeDates.isInRange(date)) {
      return RangeDayStatus.inRange;
    }
    return RangeDayStatus.notInRange;
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

  void selectDate(CalendarDateTime selectedDate) {
    provider.selectDate(selectedDate);
    widget.onSelectRange?.call(provider.selectedRangeDates);
    setState(() {});
  }
}
