import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/src/model/calendar_date_time.dart';
import 'package:flutter_custom_calendar/src/model/custom_day_model.dart';
import 'package:flutter_custom_calendar/src/provider/calendar_provider.dart';
import 'package:flutter_custom_calendar/src/widgets/calendar_monthly_widget.dart';
import 'package:flutter_custom_calendar/src/widgets/calendar_week_day_row.dart';
import 'package:provider/provider.dart';

class CustomCalendar extends StatefulWidget {
  final CalendarType calendarType;
  final bool includeDisableDays;
  final CalendarDateTime? selectedDate;
  final Function(CalendarDateTime)? onSelectDate;
  final CalendarDayModel? calendarDayModel;
  final Color? backgroundColor;
  final Decoration? backgroundDecoration;
  final EdgeInsets? padding;

  const CustomCalendar({
    Key? key,
    this.calendarType = CalendarType.gregorian,
    this.includeDisableDays = true,
    this.selectedDate,
    this.onSelectDate,
    this.calendarDayModel,
    this.backgroundColor,
    this.backgroundDecoration,
    this.padding,
  }) : super(key: key);

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  PageController pageController = PageController(initialPage: 1000);
  int currentPage = 1000;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CalendarProvider(
            calendarType: widget.calendarType,
          ),
        ),
      ],
      builder: (context, child) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    context.read<CalendarProvider>().increaseMonth();
                    currentPage -= 1;
                    pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                Expanded(
                  child: Center(
                    child: Text(context
                        .watch<CalendarProvider>()
                        .currentTime
                        .toString()),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    context.read<CalendarProvider>().decreaseMonth();
                    currentPage += 1;
                    pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut);
                  },
                  icon: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
            RowCalendarWeekDayTitle(
              calendarType: widget.calendarType,
            ),
            Consumer<CalendarProvider>(
              builder: (context, provider, child) => CalendarMonthlyWidget(
                pageController: pageController,
                onMonthChanged: (index) {
                  if (currentPage > index) {
                    context.read<CalendarProvider>().increaseMonth();
                  }
                  if (currentPage < index) {
                    context.read<CalendarProvider>().decreaseMonth();
                  }
                  currentPage = index;
                },
                calendarDayModel: widget.calendarDayModel,
                calendarDates: provider.calendarDates,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
