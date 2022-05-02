
import 'package:Motxilla/calendar_add_activity.dart';
import 'package:Motxilla/utils/dates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'activity.dart';

bool isExpanded = false;

class ActivityViewPage extends StatelessWidget {
  final Activity activity;

  const ActivityViewPage({
    Key? key,
    required this.activity,
  }) : super(key: key);

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
            tooltip: "Sortir",
            onPressed: (){
              Navigator.pushNamed(context, "login");
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
              fontSize: 24,
              fontWeight: FontWeight.bold
            )
          ),
          Text(
            activity.description,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          )
        ],
      ),
    );
  }
  Widget buildDateTime(Activity activity){
    return Column(
      children: [
        buildDate(activity.isAllDay ? 'Tot el dia': 'Des de: ', activity.from),
      SizedBox(height: 10),
        if (!activity.isAllDay) buildDate('To: ', activity.to)
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