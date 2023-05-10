import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
import 'package:flutter_custom_calendar/src/widgets/base_calendar_widget.dart';
import 'package:flutter_custom_calendar/src/widgets/normal_calendar/calendar_day_widget.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class CalendarLinearWidget extends BaseCalendarWidget {
  final CalendarType calendarType;
  final CalendarDayModel calendarDayModel;
  final bool showOverflowDays;

  const CalendarLinearWidget({
    Key? key,
    required this.calendarType,
    required this.showOverflowDays,
    required this.calendarDayModel,
    required CalendarMode calendarMode,
    CalendarDateTime? selectedDate,
    Function(CalendarDateTime)? onSelectDate,
    HeaderModel? headerModel,
    EdgeInsets? padding,
    DateTime? maxDate,
    DateTime? minDate,
    TextStyle? weekDayStyle,
    EdgeInsets? calendarPadding,
  }) : super(
          key: key,
          calendarMode: calendarMode,
          selectedDate: selectedDate,
          headerModel: headerModel,
          maxDate: maxDate,
          minDate: minDate,
          onSelectDate: onSelectDate,
          padding: padding,
          weekDayStyle: weekDayStyle,
          hasWeekDayTitle: false,
          calendarPadding: calendarPadding,
        );

  @override
  State<CalendarLinearWidget> createState() => CalendarLinearWidgetState();
}

class CalendarLinearWidgetState
    extends BaseCalendarWidgetState<CalendarLinearWidget> {
  ScrollController scrollController = ScrollController();

  @override
  Widget body(BuildContext context, BoxConstraints constraints) {
    return PageView.builder(
      controller: pageController,
      onPageChanged: onPageChanged,
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
                  calendarDayModel: widget.calendarDayModel,
                  showOverFlowDays: false,
                  showWeekdayTitle: true,
                  isSelected:
                      provider.selectedSingleDate == calendarDates[index],
                  isOverFlow: provider.calendarDateTime.month !=
                      calendarDates[index].month,
                  onSelectDate: () =>
                      selectDate(calendarDates[index], constraints.maxWidth),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void nextPage() {
    super.previousPage();
    resetScrollController();
  }

  @override
  void previousPage() {
    super.previousPage();
    resetScrollController();
  }

  @override
  void selectCurrentDate(double calendarWidth) {
    super.selectCurrentDate(calendarWidth);
    updateScrollPosition(calendarWidth);
  }

  void resetScrollController() {
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void updateScrollPosition(double calendarWidth) {
    double dayWidth = widget.calendarDayModel.width;
    double offset = dayWidth * ((provider.selectedSingleDate?.day ?? 1) - 1) -
        calendarWidth / 2 +
        dayWidth / 2;
    scrollController.animateTo(offset,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  void selectDate(CalendarDateTime selectedDate, double calendarWidth) {
    super.selectDate(selectedDate, calendarWidth);
    updateScrollPosition(calendarWidth);
  }

  @override
  double get calendarHeight =>
      widget.calendarDayModel.height +
      (widget.calendarDayModel.padding?.bottom ?? 0) +
      (widget.calendarDayModel.padding?.top ?? 0) +
      48;
}
