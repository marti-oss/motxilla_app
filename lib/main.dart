import 'package:Motxilla/menu.dart';
import 'package:flutter/material.dart';
import 'barra.dart';
import 'login.dart';
import 'transition.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Transition(),
      routes: <String, WidgetBuilder>{
        'login': (BuildContext context) => Login(),
        'transition': (BuildContext context) => Transition(),
        'perfil': (BuildContext context) => Menu(),
        'barra': (BuildContext context) => Barra()
      },
    );
  }
}