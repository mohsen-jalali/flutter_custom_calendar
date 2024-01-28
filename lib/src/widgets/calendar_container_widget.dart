import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
import 'package:flutter_custom_calendar/src/utils/calendar_utils.dart';
import 'package:flutter_custom_calendar/src/utils/context_extensions.dart';
import 'package:flutter_custom_calendar/src/widgets/calendar_header.dart';
import 'package:flutter_custom_calendar/src/widgets/normal_calendar/calendar_week_day_row.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

enum SelectionMenuEnum { month, year, none }

class CalendarContainerWidget extends StatefulWidget {
  final Widget calendarWidget;
  final VoidCallback onTapNext;
  final VoidCallback onTapPrevious;
  final VoidCallback? onSelectCurrentDate;
  final bool hasWeekDayTitle;
  final HeaderModel? headerModel;
  final TextStyle? weekDayStyle;
  final EdgeInsets? padding;
  final double calendarHeight;
  final VoidCallback refreshCalendar;
  final Decoration? decoration;

  const CalendarContainerWidget({
    Key? key,
    required this.calendarWidget,
    required this.onTapNext,
    required this.onTapPrevious,
    required this.onSelectCurrentDate,
    required this.hasWeekDayTitle,
    required this.headerModel,
    required this.weekDayStyle,
    required this.padding,
    required this.calendarHeight,
    required this.refreshCalendar,
    this.decoration,
  }) : super(key: key);

  @override
  State<CalendarContainerWidget> createState() =>
      _CalendarContainerWidgetState();
}

class _CalendarContainerWidgetState extends State<CalendarContainerWidget> {
  final ScrollController _scrollController = ScrollController();
  SelectionMenuEnum selectionMenu = SelectionMenuEnum.none;
  List<int> years = [];

  double get containerHeight {
    if (selectionMenu == SelectionMenuEnum.none) {
      return widget.calendarHeight;
    }
    return 250;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CalendarHeader(
          calendarDateTime: context.provider.calendarDateTime,
          onPressNext: widget.onTapNext,
          onPressPrevious: widget.onTapPrevious,
          onPressCurrentDate: widget.onSelectCurrentDate,
          headerModel: widget.headerModel,
          onPressMonth: onPressMonth,
          onPressYear: onPressYear,
          onPressBackOnMenu: onCloseMenu,
          isSelectionMenu: selectionMenu != SelectionMenuEnum.none,
        ),
        Container(
          decoration: widget.decoration,
          child: Column(
            children: [
              if (widget.hasWeekDayTitle &&
                  selectionMenu == SelectionMenuEnum.none)
                Container(
                  padding: EdgeInsets.only(
                    left: widget.padding?.left ?? 0,
                    right: widget.padding?.right ?? 0,
                    top: widget.padding?.top ?? 0,
                  ),
                  child: RowCalendarWeekDayTitle(
                    calendarType: context.provider.calendarType,
                    textStyle: widget.weekDayStyle,
                  ),
                ),
              AnimatedContainer(
                height: containerHeight,
                padding: widget.padding,
                width: context.screenWidth,
                duration: const Duration(milliseconds: 300),
                child: Builder(
                  builder: (context) {
                    switch (selectionMenu) {
                      case SelectionMenuEnum.none:
                        return widget.calendarWidget;
                      case SelectionMenuEnum.year:
                        return Center(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              mainAxisExtent: 48,
                            ),
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            itemCount: years.length,
                            itemBuilder: (context, index) => _menuOptionWidget(
                              isSelected:
                                  context.provider.calendarDateTime.year ==
                                      years[index],
                              index: index,
                              title: years[index].toString(),
                              onPress: () => onSelectYear(years[index]),
                            ),
                          ),
                        );
                      default:
                        return Center(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              mainAxisExtent: 48,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 8,
                            ),
                            itemCount: 12,
                            itemBuilder: (context, index) => _menuOptionWidget(
                              isSelected:
                                  context.provider.calendarDateTime.month ==
                                      index + 1,
                              index: index,
                              title: CalendarUtils.monthsTitles[index],
                              onPress: () => onSelectMonth(index + 1),
                            ),
                          ),
                        );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _menuOptionWidget({
    required bool isSelected,
    required int index,
    required String title,
    required VoidCallback onPress,
  }) {
    return AnimationConfiguration.staggeredGrid(
      columnCount: 3,
      position: index,
      duration: const Duration(milliseconds: 100),
      child: ScaleAnimation(
        child: FadeInAnimation(
          child: Container(
            decoration: (isSelected
                    ? widget.headerModel?.selectedMenuItemDecoration
                    : widget.headerModel?.menuItemDecoration) ??
                BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
            child: InkWell(
              onTap: onPress,
              child: Center(
                child: Text(
                  title,
                  style: isSelected
                      ? widget.headerModel?.selectedMenuItemStyle
                      : widget.headerModel?.menuItemStyle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onPressMonth() {
    selectionMenu = SelectionMenuEnum.month;
    setState(() {});
  }

  void onPressYear() {
    selectionMenu = SelectionMenuEnum.year;
    initYearsList();
    setState(() {});
    _updateScrollController();
  }

  void _updateScrollController() async {
    await Future.delayed(const Duration(milliseconds: 300));
    int selectedIndex = years.indexWhere(
                (year) => context.provider.calendarDateTime.year == year) ~/
            3 +
        1;
    _scrollController.animateTo(selectedIndex * 48,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void onCloseMenu() {
    selectionMenu = SelectionMenuEnum.none;
    setState(() {});
  }

  void onSelectMonth(int month) {
    context.provider.goToMonth(month);
    onCloseMenu();
    widget.refreshCalendar.call();
  }

  void onSelectYear(int year) {
    context.provider.goToYear(year);
    onCloseMenu();
    widget.refreshCalendar.call();
  }

  void initYearsList() {
    int minYear = context.provider.calendarDateTime.year > 50
        ? context.provider.calendarDateTime.year - 50
        : 0;
    int maxYear = context.provider.calendarDateTime.year + 50;
    years.clear();
    for (int index = minYear; index <= maxYear; index++) {
      years.add(index);
    }
  }
}
