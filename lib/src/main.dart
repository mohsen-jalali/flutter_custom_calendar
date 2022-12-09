import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/src/model/calendar_date_time.dart';
import 'package:flutter_custom_calendar/src/model/custom_day_model.dart';
import 'package:flutter_custom_calendar/src/model/custom_header_model.dart';
import 'package:flutter_custom_calendar/src/provider/calendar_provider.dart';
import 'package:flutter_custom_calendar/src/widgets/calendar_header.dart';
import 'package:flutter_custom_calendar/src/widgets/calendar_monthly_widget.dart';
import 'package:flutter_custom_calendar/src/widgets/calendar_week_day_row.dart';
import 'package:provider/provider.dart';

class CustomCalendar extends StatelessWidget {
  final CalendarType calendarType;
  final bool includeDisableDays;
  final CalendarDateTime? selectedDate;
  final Function(CalendarDateTime)? onSelectDate;
  final CalendarDayModel? calendarDayModel;
  final HeaderModel? headerModel;
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
    this.headerModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: padding,
        clipBehavior: Clip.antiAlias,
        decoration: backgroundDecoration ??
            BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 10,
                  )
                ]),
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => CalendarProvider(
                calendarType: calendarType,
              ),
            ),
          ],
          builder: (context, child) => Column(
            children: [
              CalendarHeader(
                calendarDateTime: context.watch<CalendarProvider>().currentTime,
                onPressNext: () {
                  context.read<CalendarProvider>().goToNextPage();
                },
                onPressPrevious: () {
                  context.read<CalendarProvider>().goToPreviousPage();
                },
                headerModel: headerModel,
              ),
              Consumer<CalendarProvider>(
                builder: (context, provider, child) => CalendarMonthlyWidget(
                  pageController: provider.pageController,
                  onMonthChanged: provider.onChangeMonthPageView,
                  onSelectDate: (calendarDateTime) {
                    provider.selectDate(calendarDateTime);
                    onSelectDate?.call(calendarDateTime);
                  },
                  calendarDayModel: calendarDayModel,
                  calendarDates: provider.calendarDates,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
