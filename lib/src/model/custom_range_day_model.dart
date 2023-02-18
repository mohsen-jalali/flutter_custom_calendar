import 'package:flutter/material.dart';

class CalendarRangeDayModel {
  /// The height of each day widget can be set with height property.
  final double height;

  /// The width of each day widget can be set with width property.
  final double width;

  /// The [TextStyle] of normal enable days, is customized by [style].
  final TextStyle? style;

  /// The [TextStyle] of selected day's which places in the range of selected dates,
  /// can be customized by [rangeStyle].
  final TextStyle? rangeStyle;

  /// The [TextStyle] of selected day's which places in heads of the selected range,
  /// can be customized by [headsStyle].
  final TextStyle? headsStyle;

  /// The [TextStyle] of disable days day which includes past days, is customized by [disableStyle].
  final TextStyle? disableStyle;

  /// The [TextStyle] of today, is customized by [disableStyle].
  final TextStyle? todayStyle;

  /// The Decoration of of normal enable days, is customized by [decoration].
  final Decoration? decoration;

  /// The [Decoration] of selected day's which places in the range of selected dates,
  /// can be customized by [rangeDecoration].
  final Decoration? rangeDecoration;

  /// The [Decoration] of selected day's which places in heads of the selected range,
  /// can be customized by [headsDecoration].
  final Decoration? headsDecoration;

  /// The [Decoration] of disable days day which includes past days,
  /// can be customized by [disableDecoration].
  final Decoration? disableDecoration;
  final Decoration? todayDecoration;

  /// The padding day widget, can be set by [padding].
  final EdgeInsets? padding;

  /// Past days can be enabled or disabled by [disablePastDays].
  final bool disablePastDays;

  /// [TextStyle] of the weekDay title can be set by [weekDayStyle].
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
