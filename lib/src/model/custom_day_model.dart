import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';

class CalendarDayModel {
  final double height;
  final double width;
  final TextStyle? style;
  final TextStyle? selectedStyle;
  final TextStyle? disableStyle;
  final Decoration? decoration;
  final Decoration? selectedDecoration;
  final Decoration? disableDecoration;
  final EdgeInsets? padding;
  final bool disablePastDays;
  final Widget Function(CalendarDateTime)? tagBuilder;
  final Alignment tagAlignment;

  const CalendarDayModel({
    this.height = 60,
    this.width = 60,
    this.decoration,
    this.padding,
    this.style,
    this.selectedStyle,
    this.disableStyle,
    this.selectedDecoration,
    this.disableDecoration,
    this.tagBuilder,
    this.disablePastDays = false,
    this.tagAlignment = Alignment.bottomRight,
  });
}
