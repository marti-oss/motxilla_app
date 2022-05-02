
import 'package:Motxilla/utils/dates.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'activity.dart';

class ActivityViewPage extends StatelessWidget {
  final Activity activity;

  const ActivityViewPage({
    Key? key,
    required this.activity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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