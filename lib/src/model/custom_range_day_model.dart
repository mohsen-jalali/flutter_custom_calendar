import 'package:flutter/material.dart';

class CalendarRangeDayModel {
  final double height;
  final double width;
  final TextStyle? style;
  final TextStyle? rangeStyle;
  final TextStyle? headsStyle;
  final TextStyle? disableStyle;
  final Decoration? decoration;
  final Decoration? rangeDecoration;
  final Decoration? headsDecoration;
  final Decoration? disableDecoration;
  final EdgeInsets? padding;
  final bool disablePastDays;

  const CalendarRangeDayModel({
    this.height = 60,
    this.width = 60,
    this.decoration,
    this.padding,
    this.style,
    this.rangeStyle,
    this.headsStyle,
    this.disableStyle,
    this.rangeDecoration = const BoxDecoration(
      shape: BoxShape.rectangle,
      color: Colors.lightBlueAccent,
    ),
    this.headsDecoration = const BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.blue,
    ),
    this.disableDecoration,
    this.disablePastDays = false,
  });
}
