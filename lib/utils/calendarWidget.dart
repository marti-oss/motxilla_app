import 'dart:convert';

import 'package:Motxilla/Resp.dart';
import 'package:Motxilla/activity.dart';
import 'package:Motxilla/provider/activity_provider.dart';
import 'package:Motxilla/utils/tasksWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:http/http.dart' as http;

import '../activity_data_source.dart';

class CalendarWidget extends StatefulWidget {
  @override
  CalendarWidgetState createState() => CalendarWidgetState();
}

class CalendarWidgetState extends State<CalendarWidget> {

  late final Future<List> activities;

  @override
  void initState() {
    super.initState();
    activities = getActivities();
  }

  Future<List> getActivities() async {
    final resposta = await getActivitatsProgramades();
    final List<Activity> appointmentData = [];
    for (var data in resposta.list!){
      String descripcio = '';
      if (data['descripcio'] != null) descripcio = data['descripcio'];
      Activity activityData = Activity(
          id: data['id'],
          title: data['nom'],
          objectiu: data['objectiu'],
          interior: data['interior'],
          description: descripcio,
          from: DateTime.parse(data['dataIni']['date']),
          to:  DateTime.parse(data['dataFi']['date'])
      );
      appointmentData.add(activityData);
    }
    return appointmentData;
  }

  Future<Resp> getActivitatsProgramades() async{
    final storage = new FlutterSecureStorage();
    String token = (await storage.read(key: 'jwt'))!;
    String id = (await storage.read(key: 'idMonitor'))!;
    final response = await http.get(
        Uri.parse('https://motxilla-api.herokuapp.com/monitors/${id}/activitatsprogramades'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder(
          future: getActivities(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData){
              return SafeArea(
                child: Container(
                  child: SfCalendar(
                    firstDayOfWeek: 1,
                    view: CalendarView.month,
                    initialSelectedDate:  DateTime.now(),
                    dataSource: ActivityDataSource(snapshot.data),
                      onLongPress: (details) {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => TasksWidget(date: details.date!));
                      }
                  )
                )
              );
            }
            return Text('Loading...');
          }),
      )
    );
  }
}