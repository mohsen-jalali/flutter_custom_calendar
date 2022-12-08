import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';

class CalendarDayModel {
  final double? height;
  final double? width;
  final Color? backgroundColor;
  final Color? disableDayBackgroundColor;
  final TextStyle? dayTitleStyle;
  final Decoration Function(CalendarDateType)? decoration;
  final EdgeInsets? padding;


  const CalendarDayModel({
    this.height,
    this.width,
    this.backgroundColor,
    this.decoration,
    this.padding,
    this.dayTitleStyle,
    this.disableDayBackgroundColor,
  });
}