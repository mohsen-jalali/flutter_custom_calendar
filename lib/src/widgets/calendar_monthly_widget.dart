import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
import 'package:flutter_custom_calendar/src/model/custom_day_model.dart';
import 'package:flutter_custom_calendar/src/widgets/calendar_day_widget.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class CalendarMonthlyWidget extends StatelessWidget {
  final PageController pageController;
  final List<CalendarDateTime> calendarDates;
  final Function(int) onMonthChanged;
  final CalendarDayModel? calendarDayModel;

  const CalendarMonthlyWidget({
    Key? key,
    required this.calendarDates,
    required this.pageController,
    required this.onMonthChanged,
    this.calendarDayModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: calculateHeight,
      color: Colors.red,
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
                    calendarDayModel: calendarDayModel,
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
