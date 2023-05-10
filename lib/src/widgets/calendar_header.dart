import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
import 'package:flutter_custom_calendar/src/utils/calendar_utils.dart';

class CalendarHeader extends StatelessWidget {
  final CalendarDateTime calendarDateTime;
  final VoidCallback onPressNext;
  final VoidCallback onPressPrevious;
  final VoidCallback? onPressCurrentDate;
  final VoidCallback? onPressMonth;
  final VoidCallback? onPressYear;
  final HeaderModel? headerModel;
  final bool isSelectionMenu;
  final VoidCallback onPressBackOnMenu;

  const CalendarHeader({
    Key? key,
    required this.calendarDateTime,
    required this.onPressNext,
    required this.onPressPrevious,
    required this.onPressBackOnMenu,
    this.headerModel = const HeaderModel(),
    this.onPressCurrentDate,
    this.isSelectionMenu = false,
    this.onPressMonth,
    this.onPressYear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: headerModel?.padding,
      margin: headerModel?.margin,
      decoration: headerModel?.headerDecoration,
      child: Visibility(
        visible: isSelectionMenu == false,
        replacement: Row(
          children: [
            IconButton(
              onPressed: onPressBackOnMenu,
              icon: const Icon(Icons.arrow_back_ios),
              color: headerModel?.iconsColor ?? Colors.black,
              iconSize: headerModel?.iconsSize,
              splashRadius: 20,
            ),
          ],
        ),
        child: Row(
          children: [
            if (headerModel?.iconAlignment == HeaderIconAlignment.right)
              titleWidget(context),
            IconButton(
              onPressed: onPressPrevious,
              icon: const Icon(Icons.arrow_back_ios),
              iconSize: headerModel?.iconsSize,
              color: headerModel?.iconsColor ?? Colors.black,
              splashRadius: 20,
            ),
            if (headerModel?.iconAlignment == HeaderIconAlignment.center)
              titleWidget(context),
            IconButton(
              onPressed: onPressNext,
              splashRadius: 20,
              iconSize: headerModel?.iconsSize,
              color: headerModel?.iconsColor ?? Colors.black,
              icon: Icon(
                Icons.arrow_forward_ios,
                color: headerModel?.iconsColor ?? Colors.black,
              ),
            ),
            if (headerModel?.iconAlignment == HeaderIconAlignment.left)
              titleWidget(context),
          ],
        ),
      ),
    );
  }

  Widget titleWidget(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: headerModel?.titleBuilder != null
                ? headerModel!.titleBuilder!
                    .call(calendarDateTime, onPressYear!, onPressMonth!)
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: onPressMonth,
                        child: Text(
                          CalendarUtils.getMonthName(calendarDateTime, context),
                          style: headerModel?.titleStyle ??
                              const TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                        onTap: onPressYear,
                        child: Text(
                          "${calendarDateTime.year}",
                          style: headerModel?.titleStyle ??
                              const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
          ),
          Visibility(
            visible: headerModel?.hasTodayIcon ?? false,
            child: IconButton(
              onPressed: onPressCurrentDate,
              icon: Icon(
                Icons.today,
                color: headerModel?.iconsColor,
                size: headerModel?.iconsSize,
              ),
            ),
          )
        ],
      ),
    );
  }
}
