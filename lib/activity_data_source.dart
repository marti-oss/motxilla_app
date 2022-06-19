import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'activity.dart';

class ActivityDataSource extends CalendarDataSource {
  ActivityDataSource(List<Activity> appointments){
    this.appointments  = appointments;
  }

  Activity getActivity(int index) => appointments![index] as Activity;

  @override
  DateTime getStartTime(int index) => getActivity(index).from;

  @override
  DateTime getEndTime(int index) => getActivity(index).to;

  @override
  String getSubject(int index) => getActivity(index).title;

  @override
  Color getColor(int index) => getActivity(index).backgroundColor;

  @override
  bool isAllDay(int index) => getActivity(index).isAllDay;

}