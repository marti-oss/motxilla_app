
import 'dart:convert';

import 'package:Motxilla/calendar.dart';
import 'package:Motxilla/calendar_add_activity.dart';
import 'package:Motxilla/menu.dart';
import 'package:Motxilla/utils/dates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'Resp.dart';
import 'activity.dart';

bool isExpanded = false;

class ActivityViewPage extends StatefulWidget {
  final Activity activity;
  const ActivityViewPage({
    Key? key,
    required this.activity,
  }) : super(key: key);

  @override
  ActivityViewPageState createState() => ActivityViewPageState(activity);
}

class ActivityViewPageState extends State<ActivityViewPage>{
  late final Activity activity;

  ActivityViewPageState(this.activity);

  Future<Resp> eliminarActivitat(id) async{
    final storage = new FlutterSecureStorage();
    String token = (await storage.read(key: 'jwt'))!;
    final response = await http.delete(
        Uri.parse("https://motxilla-api.herokuapp.com/activitatsprogramades/${id}"),
        headers: {
          'Authorization': 'Bearer $token',
        },
    );
    if (response.statusCode == 200){
      return Resp.fromJson(jsonDecode(response.body));
    }
    else {
      throw Exception('Failed to load response');
    }
  }



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
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            tooltip: "Edit",
            onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => CalendarAddActivity(activity: activity)
                )
            )
          ),
          IconButton(
            icon: Icon(Icons.delete),
            tooltip: "Esborrar",
            onPressed: (){
              eliminarActivitat(activity.id);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Calendar())
              );
            },
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(32),
        children: [
          buildDateTime(activity),
          SizedBox(height: 32,),
          Text(
            activity.title,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold
            )
          ),
          Row(
            children: [
              const Text(
                'Objectiu: ',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                )
              ),
              Text(
                activity.objectiu,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                )
              )
            ],
          ),
          Row(
            children: [
              const Text(
                  'Interior: ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  )
              ),
              Text(
                activity.interior == true ? 'Sí': 'No',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text(
                  'Descripció: ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                  )
              ),
              Text(
                  activity.description!,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  )
              )
            ],
          ),
        ],
      ),
    );
  }
  Widget buildDateTime(Activity activity){
    return Column(
      children: [
        buildDate('Des de: ', activity.from),
      SizedBox(height: 10),
        buildDate('Fins a: ', activity.to)
      ]
    );
  }

  Widget buildDate(String text, DateTime date){
    return Row(
      children: [
        Expanded(
          child: Text(
              text,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              )
          )
        ),
        Expanded(
          child:Container(
            child: Text(Date.toDateTime(date)),
            width: 10,
          )

        )

      ],
    );
  }

}