import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/src/model/calendar_date_time.dart';
import 'package:flutter_custom_calendar/src/model/custom_range_day_model.dart';
import 'package:flutter_custom_calendar/src/utils/calendar_date_time_extension.dart';
import 'package:flutter_custom_calendar/src/utils/date_utils.dart';

enum RangeDayStatus { inRange, notInRange, startHead, endHead }

class CalendarRangeDayWidget extends StatelessWidget {
  final CalendarDateTime calendarDateTime;
  final CalendarRangeDayModel? calendarDateModel;
  final VoidCallback onSelectDate;
  final RangeDayStatus status;
  final bool isOverFlow;
  final bool showOverFlowDays;
  final bool showWeekdayTitle;

  const CalendarRangeDayWidget({
    Key? key,
    required this.calendarDateTime,
    required this.onSelectDate,
    required this.status,
    required this.isOverFlow,
    this.showOverFlowDays = false,
    this.showWeekdayTitle = false,
    this.calendarDateModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (showOverFlowDays == false && isOverFlow) {
      return const SizedBox.shrink();
    }
    return Column(
      children: [
        Visibility(
          visible: showWeekdayTitle,
          child: Center(
            child: Text(
              CalendarUtils.getDateWeekdayTitle(calendarDateTime, context),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: calendarDateModel?.height,
            width: calendarDateModel?.width,
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: status == RangeDayStatus.startHead
                      ? const Radius.circular(1000)
                      : Radius.zero,
                  topLeft: status == RangeDayStatus.startHead
                      ? const Radius.circular(1000)
                      : Radius.zero,
                  topRight: status == RangeDayStatus.endHead
                      ? const Radius.circular(1000)
                      : Radius.zero,
                  bottomRight: status == RangeDayStatus.endHead
                      ? const Radius.circular(1000)
                      : Radius.zero,
                )),
            child: Center(
              child: Container(
                height: calendarDateModel?.height,
                width: calendarDateModel?.width,
                margin: calendarDateModel?.padding,
                decoration: decoration,
                child: InkWell(
                  onTap: isDisable ? null : onSelectDate,
                  child: Center(
                    child: Text(
                      calendarDateTime.day.toString(),
                      style: textStyle ??
                          const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color? get backgroundColor {
    if (isOverFlow) return null;
    if (status == RangeDayStatus.startHead ||
        status == RangeDayStatus.endHead) {
      return calendarDateModel?.rangeDecoration != null
          ? (calendarDateModel?.rangeDecoration as BoxDecoration).color
          : null;
    }
    return null;
  }

  bool get isDisable {
    return calendarDateTime.isBeforeNow &&
        (calendarDateModel?.disablePastDays ?? false);
  }

  Decoration? get decoration {
    if (isDisable || isOverFlow) {
      return calendarDateModel?.disableDecoration;
    }
    switch (status) {
      case RangeDayStatus.inRange:
        return calendarDateModel?.rangeDecoration;
      case RangeDayStatus.notInRange:
        if (calendarDateTime.isToday) {
          return calendarDateModel?.todayDecoration;
        }
        return calendarDateModel?.decoration;
      default:
        return calendarDateModel?.headsDecoration;
    }
  }

  TextStyle? get textStyle {
    if (isDisable || isOverFlow) {
      return calendarDateModel?.disableStyle;
    }
    switch (status) {
      case RangeDayStatus.inRange:
        return calendarDateModel?.rangeStyle;
      case RangeDayStatus.notInRange:
        if(calendarDateTime.isToday){
          return calendarDateModel?.todayStyle;
        }
        return calendarDateModel?.style;
      default:
        return calendarDateModel?.headsStyle;
    }
  }
}
