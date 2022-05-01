import 'package:flutter/material.dart';
import 'login.dart';
import 'transition.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Transition(),
      routes: <String, WidgetBuilder>{
        'login': (BuildContext context) => Login(),
        'transition': (BuildContext context) => Transition()
      },
    );
  }
}