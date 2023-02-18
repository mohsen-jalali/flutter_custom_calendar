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


  List<String>? getWeekTitles(){
    if(calendarType == CalendarType.gregorian){
      return ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"];
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomCalendarRangePicker(
                calendarType: calendarType,
                showOverFlowDays: showOverflowDays,
                monthTitles: [
                  "فروردین",
                  "اردیبهشت",
                  "خرداد",
                  "تیر",
                  "مرداد",
                  "شهریور",
                  "مهر",
                  "آبان",
                  "آذر",
                  "دی",
                  "بهمن",
                  "اسفند",
                ],
                weekDaysTitles: getWeekTitles(),
                headerModel: const HeaderModel(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10)),
                calendarRangeDayModel: CalendarRangeDayModel(
                  disablePastDays: disablePastDays,
                  width: 64,
                  height: 64,
                  rangeDecoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2)
                  ),
                  disableStyle: TextStyle(
                      fontSize: 16, color: Colors.black.withOpacity(0.4)),
                ),
                selectedRange: PickedRange(
                  startDate: CalendarDateTime.fromDateTime(DateTime.now().add(Duration(days: 1))),
                  endDate: CalendarDateTime.fromDateTime(DateTime.now().add(Duration(days: 3))),
                ),
              ),
              SizedBox(
                height: 64,
              ),
              // CustomCalendar(
              //   calendarType: calendarType,
              //   selectedDate: selectedDate,
              //   showOverFlowDays: showOverflowDays,
              //   calendarMode: calendarMode,
              //   weekDaysTitles: getWeekTitles(),
              //   onSelectDate: (selectedDate) {
              //     this.selectedDate = selectedDate;
              //     if (color == Colors.green) {
              //       color = Colors.red;
              //     } else {
              //       color = Colors.green;
              //     }
              //     setState(() {});
              //   },
              //   headerModel: const HeaderModel(
              //       padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10)),
              //   calendarDayModel: CalendarDayModel(
              //     disablePastDays: disablePastDays,
              //     width: 64,
              //     height: 64,
              //     padding: EdgeInsets.only(bottom: 10),
              //     tagBuilder: (p0) => Container(
              //       height: 25,
              //       width: 25,
              //       decoration: BoxDecoration(
              //         color: Colors.black,
              //         borderRadius: BorderRadius.circular(5)
              //       ),
              //       child: Center(child: Text(p0.day.toString(),style: TextStyle(color: Colors.white),)),
              //     ),
              //     decoration: BoxDecoration(
              //       shape: BoxShape.circle,
              //       color: Colors.blue,
              //     ),
              //     selectedDecoration: BoxDecoration(
              //       shape: BoxShape.circle,
              //       color: Colors.green,
              //     ),
              //     disableStyle: TextStyle(
              //         fontSize: 16, color: Colors.black.withOpacity(0.4)),
              //   ),
              // ),
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
              SizedBox(
                height: 24,
              ),
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
              SizedBox(
                height: 24,
              ),
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
              SizedBox(
                height: 24,
              ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
