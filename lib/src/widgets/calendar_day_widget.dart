import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/src/model/calendar_date_time.dart';
import 'package:flutter_custom_calendar/src/model/custom_day_model.dart';
import 'package:flutter_custom_calendar/src/utils/calendar_date_time_extension.dart';

class CalendarDayWidget extends StatelessWidget {
  final CalendarDateTime calendarDateTime;
  final CalendarDayModel? calendarDateModel;
  final VoidCallback onSelectDate;
  final bool isSelected;
  final bool isOverFlow;

  const CalendarDayWidget({
    Key? key,
    required this.calendarDateTime,
    required this.onSelectDate,
    required this.isSelected,
    required this.isOverFlow,
    this.calendarDateModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (calendarDateModel?.showOverFlowDays == false && isOverFlow) {
      return const SizedBox.shrink();
    }
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: calendarDateModel?.padding,
      decoration: decoration ??
          BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.rectangle,
          ),
      child: InkWell(
        onTap: isDisable ? null : onSelectDate,
        child: Center(
          child: Text(
            calendarDateTime.day.toString(),
            style:
                textStyle ?? const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
      ),
    );
  }

  bool get isDisable {
    return calendarDateTime.isBeforeNow &&
        (calendarDateModel?.disablePastDays ?? false);
  }

  Color get backgroundColor {
    if (isDisable || isOverFlow) {
      return calendarDateModel?.disableDayBackgroundColor ?? Colors.transparent;
    }
    if (isSelected) {
      return calendarDateModel?.selectedBackgroundColor ?? Colors.green;
    }
    return calendarDateModel?.backgroundColor ?? Colors.blue;
  }

  Decoration? get decoration {
    if (isDisable || isOverFlow) {
      return calendarDateModel?.disableDecoration;
    }
    if (isSelected) {
      return calendarDateModel?.selectedDecoration;
    }
    return calendarDateModel?.decoration;
  }

  TextStyle? get textStyle {
    if (isDisable || isOverFlow) {
      return calendarDateModel?.disableStyle;
    }
    if (isSelected) {
      return calendarDateModel?.selectedStyle;
    }
    return calendarDateModel?.style;
  }
}
