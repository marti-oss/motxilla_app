import 'package:Motxilla/utils/calendarWidget.dart';
import 'package:Motxilla/utils/topBarWidget.dart';
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
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color.fromRGBO(182, 218, 7, 0.658 ), Color.fromRGBO(26, 156, 255, 0.455)],
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                  stops: [0.0, 0.8],
                  tileMode: TileMode.clamp,
                )
            )
        ),
        title: Text("Calendari"),

      ),
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

