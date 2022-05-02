import 'package:Motxilla/activity_data_source.dart';
import 'package:Motxilla/provider/activity_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../activity_view_page.dart';

class TasksWidget extends StatefulWidget{
  @override
  TasksWidgetState createState() => TasksWidgetState();
}

class TasksWidgetState extends State<TasksWidget> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ActivityProvider>(context);
    final selectedActivities = provider.activitiesOfSelectedDate;

    if (selectedActivities.isEmpty){
      return Center(
        child: Text(
          'No hi ha activitates programades',
          style: TextStyle(color: Colors.black, fontSize: 24),
        )
      );
    }
    return SfCalendar(
      view: CalendarView.timelineDay,
      dataSource: ActivityDataSource(provider.activities),
      initialDisplayDate: provider.selectedDate,
      appointmentBuilder: appointmentBuilder,
      onTap: (details){
        if(details.appointments == null) return;
        final activity = details.appointments!.first;

        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ActivityViewPage(activity: activity)
        ));
      }
    );
  }

  Widget appointmentBuilder(
      BuildContext context,
      CalendarAppointmentDetails details) {
    final activity = details.appointments.first;
    return Container(
      width: details.bounds.width,
      height: details.bounds.height,
      decoration: BoxDecoration(
        color: activity.backgroundColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          activity.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          )
        ),
      )
    );
  }
}