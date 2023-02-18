import 'package:flutter/material.dart';

class CalendarRangeDayModel {
  final double height;
  final double width;
  final TextStyle? style;
  final TextStyle? rangeStyle;
  final TextStyle? headsStyle;
  final TextStyle? disableStyle;
  final TextStyle? todayStyle;
  final Decoration? decoration;
  final Decoration? rangeDecoration;
  final Decoration? headsDecoration;
  final Decoration? disableDecoration;
  final Decoration? todayDecoration;
  final EdgeInsets? padding;
  final bool disablePastDays;
  final TextStyle? weekDayStyle;


  const CalendarRangeDayModel({
    this.height = 60,
    this.width = 60,
    this.decoration,
    this.padding,
    this.style,
    this.rangeStyle,
    this.headsStyle,
    this.disableStyle,
    this.weekDayStyle,
    this.rangeDecoration = const BoxDecoration(
      shape: BoxShape.rectangle,
      color: Colors.lightBlueAccent,
    ),
    this.headsDecoration = const BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.blue,
    ),
    this.todayStyle,
    this.todayDecoration = const BoxDecoration(
      shape: BoxShape.circle,
      border: Border(
        bottom: BorderSide(color: Colors.blue),
        top: BorderSide(color: Colors.blue),
        left: BorderSide(color: Colors.blue),
        right: BorderSide(color: Colors.blue),
      )
    ),
    this.disableDecoration,
    this.disablePastDays = false,
  });
}
