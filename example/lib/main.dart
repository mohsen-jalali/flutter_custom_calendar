import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CalendarType calendarType = CalendarType.gregorian;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomCalendar(
                calendarType: calendarType,
                selectedDate: CalendarDateTime.fromDateTime(DateTime.now().add(Duration(days: 60))),
                headerModel: const HeaderModel(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10)),
                calendarDayModel: CalendarDayModel(
                  showOverFlowDays: true,
                  disablePastDays: true,
                  disableStyle: TextStyle(
                      fontSize: 16, color: Colors.black.withOpacity(0.4)),
                  disableDayBackgroundColor: Colors.transparent,
                ),
              ),
              TextButton(
                onPressed: () {
                  if (calendarType == CalendarType.gregorian) {
                    calendarType = CalendarType.jalali;
                  } else {
                    calendarType = CalendarType.gregorian;
                  }
                  setState(() {});
                },
                child: Text("${calendarType.name.toString()}"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
