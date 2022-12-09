import 'package:flutter/material.dart';

class HeaderModel {
  final TextStyle? titleStyle;
  final Color? iconsColor;
  final double? iconsSize;
  final Decoration? headerDecoration;
  final EdgeInsets? padding;

  const HeaderModel({
    this.titleStyle,
    this.iconsColor,
    this.iconsSize,
    this.headerDecoration,
    this.padding,
  });
}
