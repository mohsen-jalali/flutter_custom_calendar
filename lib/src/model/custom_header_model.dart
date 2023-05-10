import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';

enum HeaderIconAlignment { right, left, center }

class HeaderModel {
  final TextStyle? titleStyle;
  final Color? iconsColor;
  final double? iconsSize;
  final Decoration? headerDecoration;
  final TextStyle? menuItemStyle;
  final TextStyle? selectedMenuItemStyle;
  final Decoration? menuItemDecoration;
  final Decoration? selectedMenuItemDecoration;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final HeaderIconAlignment iconAlignment;
  final bool hasTodayIcon;
  final Widget Function(
    CalendarDateTime calendarDateTime,
    VoidCallback onSelectYear,
    VoidCallback onSelectMont,
  )? titleBuilder;

  const HeaderModel({
    this.titleStyle,
    this.iconsColor,
    this.iconsSize,
    this.headerDecoration,
    this.padding,
    this.margin,
    this.titleBuilder,
    this.menuItemStyle,
    this.selectedMenuItemStyle,
    this.menuItemDecoration,
    this.selectedMenuItemDecoration,
    this.hasTodayIcon = true,
    this.iconAlignment = HeaderIconAlignment.right,
  });
}
