import 'package:Motxilla/provider/activity_provider.dart';
import 'package:Motxilla/utils/tasksWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../activity_data_source.dart';

class CalendarWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final activities = Provider.of<ActivityProvider>(context).activities;

    return SfCalendar(
      firstDayOfWeek: 1,
      dataSource: ActivityDataSource(activities),
      view: CalendarView.month,
      initialSelectedDate:  DateTime.now(),
      onLongPress: (details) {
        final provider = Provider.of<ActivityProvider>(context,listen: false);
        provider.setDate(details.date!);
        showModalBottomSheet(
            context: context,
            builder: (context) => TasksWidget());
      }
    );
  }
}