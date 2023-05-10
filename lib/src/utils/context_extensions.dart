import 'package:flutter/cupertino.dart';
import 'package:flutter_custom_calendar/src/provider/calendar_provider.dart';
import 'package:scoped_model/scoped_model.dart';

extension ContextExtensions on BuildContext {
  CalendarProvider get provider => ScopedModel.of<CalendarProvider>(this);

  double get screenWidth => MediaQuery.of(this).size.width;

  double get screenHeight => MediaQuery.of(this).size.height;
}
