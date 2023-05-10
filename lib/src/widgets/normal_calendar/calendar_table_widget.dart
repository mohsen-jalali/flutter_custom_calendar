import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
import 'package:flutter_custom_calendar/src/widgets/base_calendar_widget.dart';
import 'package:flutter_custom_calendar/src/widgets/normal_calendar/calendar_day_widget.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class CalendarTableWidget extends BaseCalendarWidget {
  final CalendarType calendarType;
  final CalendarDayModel calendarDayModel;
  final bool showOverflowDays;

  const CalendarTableWidget({
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
    calendarPadding: calendarPadding,
        );

  @override
  State<CalendarTableWidget> createState() => CalendarTableWidgetState();
}

class CalendarTableWidgetState
    extends BaseCalendarWidgetState<CalendarTableWidget> {
  @override
  double get calendarHeight {
    double padding = (widget.calendarDayModel.padding?.bottom ?? 0) +
        (widget.calendarDayModel.padding?.top ?? 0);
    if (calendarDates.length % 7 != 0) {
      return (widget.calendarDayModel.height) *
              (calendarDates.length ~/ 7 + 1) +
          padding;
    }
    return ((widget.calendarDayModel.height) * calendarDates.length ~/ 7)
            .toDouble() +
        padding;
  }

  @override
  Widget body(BuildContext context) {
    return GestureDetector(
      onPanUpdate: onChangedCalendarMode,
      child: PageView.builder(
        controller: pageController,
        onPageChanged: (pageIndex) => onPageChanged(pageIndex),
        itemBuilder: (context, index) => GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisExtent: widget.calendarDayModel.height,
          ),
          padding: EdgeInsets.zero,
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
                    calendarDayModel: widget.calendarDayModel,
                    showOverFlowDays: widget.showOverflowDays,
                    isSelected:
                        provider.selectedSingleDate == calendarDates[index],
                    isOverFlow: provider.calendarDateTime.month !=
                        calendarDates[index].month,
                    onSelectDate: () =>
                        selectDate(calendarDates[index]),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
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
