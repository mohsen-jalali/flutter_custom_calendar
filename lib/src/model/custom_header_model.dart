import 'package:flutter/material.dart';

enum HeaderIconAlignment { right, left, center }

class HeaderModel {
  final TextStyle? titleStyle;
  final Color? iconsColor;
  final double? iconsSize;
  final Decoration? headerDecoration;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final HeaderIconAlignment iconAlignment;

  const HeaderModel({
    this.titleStyle,
    this.iconsColor,
    this.iconsSize,
    this.headerDecoration,
    this.padding,
    this.margin,
    this.iconAlignment = HeaderIconAlignment.right,
  });
}
