import 'dart:convert';

import 'package:Motxilla/Resp.dart';
import 'package:Motxilla/activity.dart';
import 'package:Motxilla/activity_data_source.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:http/http.dart' as http;

import '../activity_view_page.dart';

class TasksWidget extends StatefulWidget{
  final DateTime date;
  const TasksWidget({
    required this.date
  }): super();

  @override
  TasksWidgetState createState() => TasksWidgetState(date);
}

class TasksWidgetState extends State<TasksWidget> {
  late final DateTime date;
  late final Future<List> selectedActivities;
  TasksWidgetState(this.date);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedActivities = getActivities();
  }

  Future<List> getActivities() async {
    final resposta = await getActivitatsProgramades();
    final List<Activity> appointmentData = [];
    for (var data in resposta.list!) {
      String descripcio = '';
      if (data['descripcio'] != null) descripcio = data['descripcio'];
      Activity activityData = Activity(
          id: data['id'],
          title: data['nom'],
          objectiu: data['objectiu'],
          interior: data['interior'],
          description: descripcio,
          from: DateTime.parse(data['dataIni']['date']),
          to: DateTime.parse(data['dataFi']['date'])
      );
      appointmentData.add(activityData);
    }
    return appointmentData;
  }

  Future<Resp> getActivitatsProgramades() async {
    final storage = new FlutterSecureStorage();
    String token = (await storage.read(key: 'jwt'))!;
    String id = (await storage.read(key: 'idMonitor'))!;
    String dateFormat = simplyFormat(time: date);
    final response = await http.get(
        Uri.parse(
            'https://motxilla-api.herokuapp.com/monitors/${id}/activitatsprogramades/${dateFormat}'),
        headers: {
          'Authorization': 'Bearer $token',
        }
    );
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return Resp.fromJson2(json);
    } else {
      throw Exception('Failed to load response');
    }
  }

  Widget appointmentBuilder(BuildContext context,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getActivities(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData){
            return SfCalendar(
                view: CalendarView.timelineDay,
                dataSource: ActivityDataSource(snapshot.data),
                initialDisplayDate: date,
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
          else {
            return Text('Loading...');
          }
        }
      )
    );


  }
}

String simplyFormat({required DateTime time}) {
  String year = time.year.toString();
  String month = time.month.toString().padLeft(2, '0');
  String day = time.day.toString().padLeft(2, '0');
  return "$year-$month-$day";
}