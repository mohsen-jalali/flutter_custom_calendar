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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children:  [
              CustomCalendar(
                calendarType: CalendarType.jalali,
                headerModel: const HeaderModel(
                  padding: EdgeInsets.symmetric(horizontal: 8,vertical: 10)
                ),
                calendarDayModel:  CalendarDayModel(
                  backgroundColor: Colors.green,
                  showOverFlowDays: false,
                  disablePastDays: true,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                  ),
                  disableStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.black.withOpacity(0.4)
                  ),
                  disableDayBackgroundColor: Colors.transparent
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
