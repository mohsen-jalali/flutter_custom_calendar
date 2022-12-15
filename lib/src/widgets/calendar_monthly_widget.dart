import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
import 'package:flutter_custom_calendar/src/helpers/helper_functions.dart';
import 'package:flutter_custom_calendar/src/provider/calendar_provider.dart';
import 'package:flutter_custom_calendar/src/widgets/calendar_day_widget.dart';
import 'package:flutter_custom_calendar/src/widgets/calendar_header.dart';
import 'package:flutter_custom_calendar/src/widgets/calendar_week_day_row.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

class CalendarMonthlyWidget extends StatefulWidget {
  final CalendarType calendarType;
  final CalendarDateTime? selectedDate;
  final Function(CalendarDateTime)? onSelectDate;
  final CalendarDayModel? calendarDayModel;
  final HeaderModel? headerModel;

  const CalendarMonthlyWidget({
    Key? key,
    required this.calendarType,
    this.selectedDate,
    this.onSelectDate,
    this.calendarDayModel,
    this.headerModel,
  }) : super(key: key);

  @override
  State<CalendarMonthlyWidget> createState() => _CalendarMonthlyWidgetState();
}

class _CalendarMonthlyWidgetState extends State<CalendarMonthlyWidget> {
  @override
  void initState() {
    postFrameCallback(() {
      provider.initialCalendar(widget.calendarType, widget.selectedDate);
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CalendarMonthlyWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.calendarType != widget.calendarType) {
      postFrameCallback(() {
        provider.changeCalendarType(widget.calendarType);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CalendarHeader(
          calendarDateTime: context.watch<CalendarProvider>().calendarDate,
          onPressNext: () {
            provider.goToNextPage();
          },
          onPressPrevious: () {
            provider.goToPreviousPage();
          },
          onPressCurrentDate: () {
            provider.goToCurrentDate();
          },
          headerModel: widget.headerModel,
        ),
        RowCalendarWeekDayTitle(
          calendarType: context.watch<CalendarProvider>().calendarType,
        ),
        Consumer<CalendarProvider>(
          builder: (context, provider, child) => AnimatedContainer(
            height: calculateHeight,
            width: MediaQuery.of(context).size.width,
            duration: const Duration(milliseconds: 300),
            child: PageView.builder(
              controller: provider.pageController,
              itemBuilder: (context, index) => GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisExtent: 50,
                ),
                physics: const NeverScrollableScrollPhysics(),
                itemCount: provider.calendarDates.length,
                itemBuilder: (context, index) {
                  return AnimationConfiguration.staggeredGrid(
                    columnCount: 7,
                    position: index,
                    duration: const Duration(milliseconds: 400),
                    child: ScaleAnimation(
                      child: FadeInAnimation(
                        child: CalendarDayWidget(
                          calendarDateTime: provider.calendarDates[index],
                          calendarDateModel: widget.calendarDayModel,
                          isSelected: provider.selectedDate ==
                              provider.calendarDates[index],
                          isOverFlow: provider.calendarDate.month !=
                              provider.calendarDates[index].month,
                          onSelectDate: () {
                            provider.selectDate(provider.calendarDates[index]);
                            widget.onSelectDate
                                ?.call(provider.calendarDates[index]);
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  CalendarProvider get provider {
    return context.read<CalendarProvider>();
  }

  double get calculateHeight {
    if (provider.calendarDates.length % 7 != 0) {
      return 50 * (provider.calendarDates.length ~/ 7 + 1);
    }
    return (50 * provider.calendarDates.length ~/ 7).toDouble();
  }
}
