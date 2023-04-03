import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/src/model/calendar_date_time.dart';
import 'package:flutter_custom_calendar/src/model/custom_header_model.dart';
import 'package:flutter_custom_calendar/src/model/custom_range_day_model.dart';
import 'package:flutter_custom_calendar/src/model/picked_range_model.dart';
import 'package:flutter_custom_calendar/src/model/selected_date_model.dart';
import 'package:flutter_custom_calendar/src/provider/calendar_provider.dart';
import 'package:flutter_custom_calendar/src/utils/calendar_utils.dart';
import 'package:flutter_custom_calendar/src/widgets/range_picker_calendar/calendar_range_widget.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomCalendarRangePicker extends StatefulWidget {
  /// [CalendarType] used to switch calendar to different types of calendar
  /// like Jalali & Gregorian, currently it supports two types of calendar
  /// [CalendarType.jalali] & [CalendarType.gregorian].
  final CalendarType calendarType;

  /// Initialized [PickedRange] date can be initialized with [selectedRange],
  /// it includes startDate which is the first date of the selected range and
  /// endDate which is the last date of the selected range. The type of both startDate &
  /// endDate is [CalendarDateTime].
  ///
  /// [CalendarDateTime] is a class to save date properties (day,month,year) in a
  ///  object in order to use it with different types of calendars.
  final PickedRange selectedRange;

  /// Call back function for changing selected Range.
  final Function(PickedRange)? onSelectRangeDates;

  /// [CalendarRangeDayModel] used to customize calendar day widget.
  final CalendarRangeDayModel calendarRangeDayModel;

  /// [HeaderModel] used to customize customize calendar header.
  final HeaderModel? headerModel;

  /// Calendar background can be set by this property.
  final Color? backgroundColor;

  /// Calendar decoration can be set & customize by this property.
  final Decoration? calendarDecoration;

  /// Calendar padding can be set & customize by this property.
  final EdgeInsets? padding;

  /// In calculating calendar monthly dates, days which are in head and tail of
  /// the month are over flow days.
  /// the visibility of this days in calendar can be set by this showOverFlowDays.
  final bool showOverFlowDays;

  /// The title of week day of a day can be set by [weekDaysTitles].
  /// List should includes of seven String which represents week days titles.
  final List<String>? weekDaysTitles;

  /// The title of month's can be set by this [monthTitles].
  /// List should includes of seven String which represents 12 month's titles.
  final List<String>? monthTitles;

  const CustomCalendarRangePicker({
    Key? key,
    required this.selectedRange,
    this.calendarType = CalendarType.gregorian,
    this.calendarRangeDayModel = const CalendarRangeDayModel(),
    this.backgroundColor,
    this.calendarDecoration,
    this.padding,
    this.headerModel,
    this.showOverFlowDays = false,
    this.onSelectRangeDates,
    this.weekDaysTitles,
    this.monthTitles,
  }) : super(key: key);

  @override
  State<CustomCalendarRangePicker> createState() =>
      _CustomCalendarRangePickerState();
}

class _CustomCalendarRangePickerState extends State<CustomCalendarRangePicker> {
  late GlobalKey<CalendarRangeWidgetState> rangePickerWidgetKey;
  late CalendarProvider calendarProvider;

  @override
  void initState() {
    super.initState();
    rangePickerWidgetKey = GlobalKey<CalendarRangeWidgetState>();
    initialCalendarProvider();
  }

  @override
  void didUpdateWidget(covariant CustomCalendarRangePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.calendarType != widget.calendarType) {
      initialCalendarProvider();
      updateWidgets();
    }
  }

  /// Calendar logic provider initialized by this method.
  /// The [CalendarProvider.createInstance] is a factory constructor which creates
  /// an instance based on calendar type.
  /// if calendarType is [CalendarType.jalali], it creates an instance of [JalaliCalendarProvider]
  /// & if is [CalendarType.gregorian], it creates [GregorianCalendarProvider] which
  /// handles date's calculating with [Jalali] & [Datetime] classes.
  void initialCalendarProvider() {
    calendarProvider = CalendarProvider.createInstance(
      calendarType: widget.calendarType,
      selectedDateModel: SelectedDateModel(
          rangeDates: widget.selectedRange,
          singleDate: CalendarDateTime.fromDateTime(DateTime.now())),
      calendarMode: CalendarMode.monthlyTable,
      selectionMode: CalendarSelectionMode.range,
    );
  }

  /// After changing calendar logical properties, this function calls & it initialize
  /// widgets initialization with new properties.
  void updateWidgets() {
    rangePickerWidgetKey.currentState?.initialization();
  }

  @override
  Widget build(BuildContext context) {
    CalendarUtils.initialization(
      calendarType: widget.calendarType,
      context: context,
      weekDaysTitle: widget.weekDaysTitles,
      monthTitle: widget.monthTitles,
    );

    return ScopedModel<CalendarProvider>(
      model: calendarProvider,
      child: Material(
        color: Colors.transparent,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: widget.calendarDecoration ??
              BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 10,
                  )
                ],
              ),
          child: ScopedModelDescendant<CalendarProvider>(
            builder: (context, child, provider) => CalendarRangeWidget(
              showOverflowDays: widget.showOverFlowDays,
              calendarMode: provider.calendarMode,
              calendarType: widget.calendarType,
              headerModel: widget.headerModel,
              calendarRangeDayModel: widget.calendarRangeDayModel,
              onSelectRange: widget.onSelectRangeDates,
              padding: widget.padding,
            ),
          ),
        ),
      ),
    );
  }
}
