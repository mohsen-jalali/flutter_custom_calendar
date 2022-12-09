import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
import 'package:flutter_custom_calendar/src/model/custom_header_model.dart';
import 'package:flutter_custom_calendar/src/utils/date_utils.dart';

class CalendarHeader extends StatelessWidget {
  final CalendarDateTime calendarDateTime;
  final VoidCallback onPressNext;
  final VoidCallback onPressPrevious;
  final HeaderModel? headerModel;
  const CalendarHeader({
    Key? key,
    required this.calendarDateTime,
    required this.onPressNext,
    required this.onPressPrevious,
    this.headerModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: headerModel?.padding,
      decoration: headerModel?.headerDecoration,
      child: Row(
        children: [
          IconButton(
            onPressed: onPressPrevious,
            icon: const Icon(Icons.arrow_back),
            color: headerModel?.iconsColor ?? Colors.black,
            splashRadius: 20,
          ),
          Expanded(
            child: Row(
              children: [
                Text(
                  "${CalendarUtils.getMonthNameByIndex(calendarDateTime.month, calendarDateTime.calendarType, context)} ${calendarDateTime.year}",
                  style: headerModel?.titleStyle ?? const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onPressNext,
            splashRadius: 20,
            icon:  Icon(
              Icons.arrow_forward,
              color: headerModel?.iconsColor ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
