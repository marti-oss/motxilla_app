import 'package:Motxilla/provider/activity_provider.dart';
import 'package:Motxilla/utils/tasksWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../activity_data_source.dart';
import 'images.dart';


class TopNavigationBar extends StatelessWidget
    implements PreferredSizeWidget{
  const TopNavigationBar({
    Key? key,
  }) : super(key:key);

  @override
  Size get preferredSize => Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
        leading: Image.asset(motxilla_logo),
        title: Text("Motxilla"),
        actions:[
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: "Sortir",
            onPressed: (){
              Navigator.pushNamed(context, "login");
            },
          )
        ]
    );

  }
}