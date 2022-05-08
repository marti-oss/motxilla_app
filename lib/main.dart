import 'package:Motxilla/menu.dart';
import 'package:Motxilla/provider/activity_provider.dart';
import 'package:Motxilla/team_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'barra.dart';
import 'calendar.dart';
import 'email_page.dart';
import 'login.dart';
import 'transition.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ActivityProvider()),
      ],
      child: Consumer<ActivityProvider>(
        builder: (context,provider,child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Transition(),
          routes: <String, WidgetBuilder>{
            'login': (BuildContext context) => Login(),
            'transition': (BuildContext context) => Transition(),
            'perfil': (BuildContext context) => Menu(),
            'barra': (BuildContext context) => Barra(),
            'calendar': (BuildContext context) => Calendar(),
            'listequip': (BuildContext context) => ListPage(title: "Equips"),
            'enviarEmail': (BuildContext context) => EmailPage("hola")
          },
        ),
      )
    );
  }
}