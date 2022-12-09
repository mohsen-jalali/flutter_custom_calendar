import 'package:flutter/material.dart';

class CalendarDayModel {
  final double? height;
  final double? width;
  final Color? backgroundColor;
  final Color? selectedBackgroundColor;
  final Color? disableDayBackgroundColor;
  final TextStyle? style;
  final TextStyle? selectedStyle;
  final TextStyle? disableStyle;
  final Decoration? decoration;
  final Decoration? selectedDecoration;
  final Decoration? disableDecoration;
  final EdgeInsets? padding;
  final bool showOverFlowDays;
  final bool disablePastDays;

  const CalendarDayModel({
    this.height,
    this.width,
    this.backgroundColor,
    this.decoration,
    this.padding,
    this.style,
    this.selectedStyle,
    this.disableStyle,
    this.disableDayBackgroundColor,
    this.selectedBackgroundColor,
    this.selectedDecoration,
    this.disableDecoration,
    this.showOverFlowDays = false,
    this.disablePastDays = false,
  });
}
