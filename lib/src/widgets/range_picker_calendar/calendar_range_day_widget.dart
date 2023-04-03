import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/src/model/calendar_date_time.dart';
import 'package:flutter_custom_calendar/src/model/custom_range_day_model.dart';
import 'package:flutter_custom_calendar/src/utils/calendar_date_time_extension.dart';

enum RangeDayStatus { inRange, notInRange, startHead, endHead }

class CalendarRangeDayWidget extends StatelessWidget {
  final CalendarDateTime calendarDateTime;
  final CalendarRangeDayModel? calendarRangeDayModel;
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
    this.calendarRangeDayModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (showOverFlowDays == false && isOverFlow) {
      return const SizedBox.shrink();
    }
    return Stack(
      children: [
        Row(
          textDirection: status == RangeDayStatus.startHead
              ? TextDirection.rtl
              : TextDirection.ltr,
          children: [
            Expanded(
              child: Container(
                margin: calendarRangeDayModel?.padding,
                height: calendarRangeDayModel?.height,
                decoration: BoxDecoration(
                  color: backgroundColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: status == RangeDayStatus.startHead
                          ? const Radius.circular(10)
                          : Radius.zero,
                      topLeft: status == RangeDayStatus.startHead
                          ? const Radius.circular(10)
                          : Radius.zero,
                      topRight: status == RangeDayStatus.endHead
                          ? const Radius.circular(10)
                          : Radius.zero,
                      bottomRight: status == RangeDayStatus.endHead
                          ? const Radius.circular(10)
                          : Radius.zero,
                    )                ),
              ),
            ),
            const Expanded(child: SizedBox())
          ],
        ),
        Container(
          margin: calendarRangeDayModel?.padding,
          height: calendarRangeDayModel?.height,
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
        )
      ],
    );
  }

  bool get isDisable {
    return calendarDateTime.isBeforeNow &&
        (calendarRangeDayModel?.disablePastDays ?? false);
  }

  Color? get backgroundColor {
    if (isOverFlow) return null;
    if ((calendarRangeDayModel?.rangeDecoration as BoxDecoration).shape !=
        BoxShape.rectangle) return null;
    if (status == RangeDayStatus.startHead ||
        status == RangeDayStatus.endHead) {
      return calendarRangeDayModel?.rangeDecoration != null
          ? (calendarRangeDayModel?.rangeDecoration as BoxDecoration).color
          : null;
    }
    return null;
  }

  Decoration? get decoration {
    if (isDisable || isOverFlow) {
      return calendarRangeDayModel?.disableDecoration;
    }
    switch (status) {
      case RangeDayStatus.inRange:
        return calendarRangeDayModel?.rangeDecoration;
      case RangeDayStatus.notInRange:
        if (calendarDateTime.isToday) {
          return calendarRangeDayModel?.todayDecoration;
        }
        return calendarRangeDayModel?.decoration;
      default:
        return calendarRangeDayModel?.headsDecoration;
    }
  }

  TextStyle? get textStyle {
    if (isDisable || isOverFlow) {
      return calendarRangeDayModel?.disableStyle;
    }
    switch (status) {
      case RangeDayStatus.inRange:
        return calendarRangeDayModel?.rangeStyle;
      case RangeDayStatus.notInRange:
        if (calendarDateTime.isToday) {
          return calendarRangeDayModel?.todayStyle;
        }
        return calendarRangeDayModel?.style;
      default:
        return calendarRangeDayModel?.headsStyle;
    }
  }
}
