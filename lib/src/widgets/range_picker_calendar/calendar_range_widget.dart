import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
import 'package:flutter_custom_calendar/src/utils/calendar_range_date_extensions.dart';
import 'package:flutter_custom_calendar/src/widgets/base_calendar_widget.dart';
import 'package:flutter_custom_calendar/src/widgets/range_picker_calendar/calendar_range_day_widget.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class CalendarRangeWidget extends BaseCalendarWidget {
  final CalendarType calendarType;
  final Function(PickedRange)? onSelectRange;
  final CalendarRangeDayModel calendarRangeDayModel;
  final bool showOverflowDays;

  const CalendarRangeWidget({
    Key? key,
    required this.calendarType,
    required this.showOverflowDays,
    required this.calendarRangeDayModel,
    required this.onSelectRange,
    required CalendarMode calendarMode,
    CalendarDateTime? selectedDate,
    Function(CalendarDateTime)? onSelectDate,
    HeaderModel? headerModel,
    EdgeInsets? padding,
    TextStyle? weekDayStyle,
    EdgeInsets? calendarPadding,
  }) : super(
          key: key,
          calendarMode: calendarMode,
          selectedDate: selectedDate,
          headerModel: headerModel,
          onSelectDate: onSelectDate,
          padding: padding,
          weekDayStyle: weekDayStyle,
          hasWeekDayTitle: false,
          calendarPadding: calendarPadding,
        );

  @override
  State<CalendarRangeWidget> createState() => CalendarRangeWidgetState();
}

class CalendarRangeWidgetState
    extends BaseCalendarWidgetState<CalendarRangeWidget> {
  @override
  Widget body(BuildContext context) {
    return PageView.builder(
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
                  onSelectDate: () =>
                      selectDate(calendarDates[index]),
                  status: dayStatus(calendarDates[index]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
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

  RangeDayStatus dayStatus(CalendarDateTime date) {
    if (provider.selectedRangeDates == null) return RangeDayStatus.notInRange;
    if (provider.selectedRangeDates!.isEndTime(date)) {
      return RangeDayStatus.endHead;
    } else if (provider.selectedRangeDates!.isStartTime(date)) {
      return RangeDayStatus.startHead;
    } else if (provider.selectedRangeDates!.isInRange(date)) {
      return RangeDayStatus.inRange;
    }
    return RangeDayStatus.notInRange;
  }

  @override
  void selectDate(CalendarDateTime selectedDate) {
    provider.selectDate(selectedDate);
    widget.onSelectRange?.call(provider.selectedRangeDates!);
    setState(() {});
  }
}
