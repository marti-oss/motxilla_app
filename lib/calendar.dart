import 'package:Motxilla/utils/calendarWidget.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'calendar_add_activity.dart';

class Calendar extends StatefulWidget {
  @override
  CalendarState createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CalendarWidget(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color.fromRGBO(182, 218, 7, 0.658 ),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => CalendarAddActivity())
          );
        },
      ),

    );

  }
}

