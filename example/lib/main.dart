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
  CalendarMode calendarMode = CalendarMode.monthlyTable;
  bool showOverflowDays = false;
  bool disablePastDays = false;
  CalendarDateTime selectedDate =
      CalendarDateTime.fromDateTime(DateTime.now().add(Duration(days: 1)));
  Color color = Colors.green;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomCalendar(
                  calendarType: calendarType,
                  selectedDate: selectedDate,
                  showOverFlowDays: showOverflowDays,
                  calendarMode: calendarMode,
                  onSelectDate: (selectedDate) {
                    this.selectedDate = selectedDate;
                    if (color == Colors.green) {
                      color = Colors.red;
                    } else {
                      color = Colors.green;
                    }
                    setState(() {});
                  },
                  headerModel: const HeaderModel(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10)),
                  calendarDayModel: CalendarDayModel(
                    disablePastDays: disablePastDays,
                    width: 64,
                    height: 64,
                    selectedBackgroundColor: color,
                    disableStyle: TextStyle(
                        fontSize: 16, color: Colors.black.withOpacity(0.4)),
                    disableDayBackgroundColor: Colors.transparent,
                  ),
                ),
                const SizedBox(
                  height: 36,
                ),
                Text(
                  "Calendar type:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: DropdownButton<CalendarType>(
                    value: calendarType,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                        value: CalendarType.jalali,
                        child: Text("jalali"),
                      ),
                      DropdownMenuItem(
                        value: CalendarType.gregorian,
                        child: Text("gregorian"),
                      )
                    ],
                    onChanged: (calendarType) {
                      if (calendarType != null) {
                        this.calendarType = calendarType;
                        setState(() {});
                      }
                    },
                  ),
                ),
                SizedBox(height: 24,),
                Text(
                  "Calendar mode:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: DropdownButton<CalendarMode>(
                    value: calendarMode,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                        value: CalendarMode.monthlyTable,
                        child: Text("Table calendar"),
                      ),
                      DropdownMenuItem(
                        value: CalendarMode.weekly,
                        child: Text("weekly calendar"),
                      ),
                      DropdownMenuItem(
                        value: CalendarMode.monthlyLinear,
                        child: Text("monthly calendar"),
                      )
                    ],
                    onChanged: (calendarMode) {
                      if (calendarMode != null) {
                        this.calendarMode = calendarMode;
                        setState(() {});
                      }
                    },
                  ),
                ),
                SizedBox(height: 24,),
                Text(
                  "Show overflow days:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<bool>(
                        value: true,
                        groupValue: showOverflowDays,
                        title: Text("true"),
                        onChanged: (value) {
                          if (value != null) {
                            showOverflowDays = value;
                            setState(() {});
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<bool>(
                        value: false,
                        groupValue: showOverflowDays,
                        title: Text("false"),
                        onChanged: (value) {
                          if (value != null) {
                            showOverflowDays = value;
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24,),
                Text(
                  "Disable past days:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<bool>(
                        value: true,
                        groupValue: disablePastDays,
                        title: Text("true"),
                        onChanged: (value) {
                          if (value != null) {
                            disablePastDays = value;
                            setState(() {});
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<bool>(
                        value: false,
                        groupValue: disablePastDays,
                        title: Text("false"),
                        onChanged: (value) {
                          if (value != null) {
                            disablePastDays = value;
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  ],
                )

              ],
            ),
          ),
        ),
      ),
    );
  }
}
