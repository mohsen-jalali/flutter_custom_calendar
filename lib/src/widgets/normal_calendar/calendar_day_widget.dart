import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/src/model/calendar_date_time.dart';
import 'package:flutter_custom_calendar/src/model/custom_day_model.dart';
import 'package:flutter_custom_calendar/src/utils/calendar_date_time_extension.dart';
import 'package:flutter_custom_calendar/src/utils/calendar_utils.dart';

class CalendarDayWidget extends StatelessWidget {
  final CalendarDateTime calendarDateTime;
  final CalendarDayModel calendarDayModel;
  final VoidCallback onSelectDate;
  final bool isSelected;
  final bool isOverFlow;
  final bool showOverFlowDays;
  final bool showWeekdayTitle;

  const CalendarDayWidget({
    Key? key,
    required this.calendarDateTime,
    required this.onSelectDate,
    required this.isSelected,
    required this.isOverFlow,
    required this.calendarDayModel,
    this.showOverFlowDays = false,
    this.showWeekdayTitle = false,
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
          child: SizedBox(
            height: 32,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Text(
                  CalendarUtils.getWeekdayTitle(calendarDateTime, context),
                  style: calendarDayModel.weekDayStyle,
                ),
              ),
            ),
          ),
        ),
        Flexible(
          child: AnimatedContainer(
            height: calendarDayModel.height,
            width: calendarDayModel.width,
            duration: const Duration(milliseconds: 300),
            margin: calendarDayModel.padding,
            decoration: decoration,
            child: Stack(
              alignment: calendarDayModel.tagAlignment,
              children: [
                InkWell(
                  onTap: isDisable ? null : onSelectDate,
                  child: Center(
                    child: Text(
                      calendarDateTime.day.toString(),
                      style: textStyle ??
                          const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ),
                if (calendarDayModel.tagBuilder != null &&
                    isOverFlow == false &&
                    isDisable == false)
                  IgnorePointer(child: calendarDayModel.tagBuilder!(calendarDateTime))
              ],
            ),
          ),
        ),
      ],
    );
  }

  bool get isDisable {
    if(calendarDayModel.isDisableDay != null){
      return calendarDayModel.isDisableDay!.call(calendarDateTime);
    }
    return calendarDateTime.isBeforeNow && calendarDayModel.disablePastDays;
  }

  Decoration? get decoration {
    if (isDisable || isOverFlow) {
      return calendarDayModel.disableDecoration;
    }
    if (isSelected) {
      return calendarDayModel.selectedDecoration;
    }
    if(calendarDateTime.isToday){
      return calendarDayModel.todayDecoration;
    }
    return calendarDayModel.decoration;
  }

  TextStyle? get textStyle {
    if (isDisable || isOverFlow) {
      return calendarDayModel.disableStyle;
    }
    if (isSelected) {
      return calendarDayModel.selectedStyle;
    }
    if(calendarDateTime.isToday){
      return calendarDayModel.todayStyle;
    }
    return calendarDayModel.style;
  }
}
