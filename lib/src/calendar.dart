import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/src/model/calendar_date_time.dart';
import 'package:flutter_custom_calendar/src/model/custom_day_model.dart';
import 'package:flutter_custom_calendar/src/model/custom_header_model.dart';
import 'package:flutter_custom_calendar/src/model/selected_date_model.dart';
import 'package:flutter_custom_calendar/src/provider/calendar_provider.dart';
import 'package:flutter_custom_calendar/src/utils/calendar_utils.dart';
import 'package:flutter_custom_calendar/src/widgets/normal_calendar/calendar_linear_widget.dart';
import 'package:flutter_custom_calendar/src/widgets/normal_calendar/calendar_table_widget.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomCalendar extends StatefulWidget {
  /// [CalendarType] used to switch calendar to different types of calendar
  /// like Jalali & Gregorian, currently it supports two types of calendar
  /// [CalendarType.jalali] & [CalendarType.gregorian].
  final CalendarType calendarType;

  /// [CalendarMode] can be used to change calendar widget. Three modes are available:
  ///  * [CalendarMode.weekly]: separate a month to weeks and show the weeks in ui.
  ///  * [CalendarMode.monthlyTable]: shows calendar in month in a table with seven columns.
  ///  * [CalendarMode.monthlyLinear]: shows calendar in month in a horizontal listview.
  final CalendarMode calendarMode;

  /// Initialized selected date can be initialized with [selectedDate], type of the
  /// date should be [CalendarDateTime].
  ///
  /// [CalendarDateTime] is a class to save date properties (day,month,year) in a
  ///  object in order to use it with different types of calendars.
  final CalendarDateTime? selectedDate;

  /// Call back function for changing selected date.
  final Function(CalendarDateTime)? onSelectDate;

  /// [CalendarDayModel] used to customize calendar day widget.
  final CalendarDayModel calendarDayModel;

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

  final bool disableCalendarModeChange;

  const CustomCalendar({
    Key? key,
    this.calendarType = CalendarType.gregorian,
    this.selectedDate,
    this.onSelectDate,
    this.calendarDayModel = const CalendarDayModel(),
    this.backgroundColor,
    this.calendarDecoration,
    this.padding,
    this.headerModel,
    this.showOverFlowDays = false,
    this.calendarMode = CalendarMode.monthlyTable,
    this.weekDaysTitles,
    this.monthTitles,
    this.disableCalendarModeChange = false,
  }) : super(key: key);

  @override
  State<CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  late GlobalKey<CalendarTableWidgetState> monthlyStateKey;
  late GlobalKey<CalendarLinearWidgetState> linearStateKey;
  late CalendarProvider calendarProvider;

  @override
  void initState() {
    super.initState();
    monthlyStateKey = GlobalKey<CalendarTableWidgetState>();
    linearStateKey = GlobalKey<CalendarLinearWidgetState>();
    initialCalendarProvider();
  }

  @override
  void didUpdateWidget(covariant CustomCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.calendarType != widget.calendarType ||
        oldWidget.calendarMode != widget.calendarMode) {
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
        singleDate: widget.selectedDate,
      ),
      calendarMode: widget.calendarMode,
      selectionMode: CalendarSelectionMode.single,
    );
  }

  /// After changing calendar logical properties, this function calls & it initialize
  /// widgets initialization with new properties.
  void updateWidgets() {
    switch (widget.calendarMode) {
      case CalendarMode.monthlyLinear:
        linearStateKey.currentState?.initialization();
        break;
      default:
        monthlyStateKey.currentState?.initialization();
        break;
    }
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
        child: ScopedModelDescendant<CalendarProvider>(
          builder: (context, child, provider) {
            switch (provider.calendarMode) {
              case CalendarMode.monthlyLinear:
                return CalendarLinearWidget(
                  key: linearStateKey,
                  showOverflowDays: widget.showOverFlowDays,
                  calendarMode: provider.calendarMode,
                  calendarType: widget.calendarType,
                  selectedDate: widget.selectedDate,
                  headerModel: widget.headerModel,
                  calendarDayModel: widget.calendarDayModel,
                  onSelectDate: widget.onSelectDate,
                  padding: widget.padding,
                  calendarPadding: widget.padding,
                );
              default:
                return CalendarTableWidget(
                  key: monthlyStateKey,
                  calendarDecoration: widget.calendarDecoration,
                  showOverflowDays: widget.showOverFlowDays,
                  calendarMode: provider.calendarMode,
                  calendarType: widget.calendarType,
                  selectedDate: widget.selectedDate,
                  headerModel: widget.headerModel,
                  calendarDayModel: widget.calendarDayModel,
                  onSelectDate: widget.onSelectDate,
                  padding: widget.padding,
                  calendarPadding: widget.padding,
                  weekDayStyle: widget.calendarDayModel.weekDayStyle,
                  disableCalendarModeChange: widget.disableCalendarModeChange,
                );
            }
          },
        ),
      ),
    );
  }
}
