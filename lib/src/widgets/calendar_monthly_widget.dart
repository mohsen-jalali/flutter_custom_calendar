import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
import 'package:flutter_custom_calendar/src/provider/calendar_provider.dart';
import 'package:flutter_custom_calendar/src/utils/calendar_date_time_extension.dart';
import 'package:flutter_custom_calendar/src/widgets/calendar_day_widget.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

class CalendarMonthlyWidget extends StatelessWidget {
  final PageController pageController;
  final List<CalendarDateTime> calendarDates;
  final Function(int) onMonthChanged;
  final Function(CalendarDateTime) onSelectDate;
  final CalendarDayModel? calendarDayModel;



  const CalendarMonthlyWidget({
    Key? key,
    required this.calendarDates,
    required this.pageController,
    required this.onMonthChanged,
    required this.onSelectDate,
    this.calendarDayModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: calculateHeight,
      width: MediaQuery.of(context).size.width,
      duration: const Duration(milliseconds: 300),
      child: PageView.builder(
        controller: pageController,
        onPageChanged: onMonthChanged,
        itemBuilder: (context, index) => GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisExtent: 50,
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
                  child: CalendarDayWidget(
                    calendarDateTime: calendarDates[index],
                    calendarDateModel: calendarDayModel,
                    isSelected: context.read<CalendarProvider>().selectedDate ==
                        calendarDates[index],
                    isOverFlow:
                        context.read<CalendarProvider>().currentTime.month !=
                            calendarDates[index].month,
                    onSelectDate: () {
                      onSelectDate.call(calendarDates[index]);
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  double get calculateHeight {
    if (calendarDates.length % 7 != 0) {
      return 50 * (calendarDates.length ~/ 7 + 1);
    }
    return (50 * calendarDates.length ~/ 7).toDouble();
  }
}
