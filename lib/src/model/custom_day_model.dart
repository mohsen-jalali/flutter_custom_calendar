import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';

class CalendarDayModel {
  /// The height of each day widget can be set with height property.
  final double height;

  /// The width of each day widget can be set with width property.
  final double width;

  /// The TextStyle of normal enable days, is customized by [style].
  final TextStyle? style;

  /// The TextStyle of selected day, is customized by [selectedStyle].
  final TextStyle? selectedStyle;

  /// The TextStyle of disable days day which includes past days, is customized by [disableStyle].
  final TextStyle? disableStyle;

  /// The Decoration of of normal enable days, is customized by [decoration].
  final Decoration? decoration;

  /// The Decoration of of selected day, is customized by [selectedDecoration].
  final Decoration? selectedDecoration;

  /// The Decoration of of selected day, is customized by [disableDecoration].
  final Decoration? disableDecoration;

  /// The padding day widget, can be set by [padding].
  final EdgeInsets? padding;

  /// Past days can be enabled or disabled by [disablePastDays].
  final bool disablePastDays;

  /// Every day widget can have a tag widget which placed on top of the widget
  /// and can be build by [tagBuilder], the CalendarDateTime input is the date of the day.
  final Widget Function(CalendarDateTime)? tagBuilder;

  /// [Alignment] of the tag widget can be set by [tagAlignment].
  final Alignment tagAlignment;

  /// [TextStyle] of the weekDay title can be set by [weekDayStyle].
  final TextStyle? weekDayStyle;

  const CalendarDayModel({
    this.height = 60,
    this.width = 60,
    this.decoration,
    this.padding,
    this.style,
    this.selectedStyle,
    this.disableStyle,
    this.selectedDecoration = const BoxDecoration(
      color: Colors.blue,
      shape: BoxShape.circle,
    ),
    this.disableDecoration,
    this.tagBuilder,
    this.weekDayStyle,
    this.disablePastDays = false,
    this.tagAlignment = Alignment.bottomRight,
  });
}
