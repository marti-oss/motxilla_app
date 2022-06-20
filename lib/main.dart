import 'dart:convert';

import 'package:Motxilla/Resp.dart';
import 'package:Motxilla/activitats_list.dart';
import 'package:Motxilla/menu.dart';
import 'package:Motxilla/perfilMonitor.dart';
import 'package:Motxilla/provider/activity_provider.dart';
import 'package:Motxilla/team_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'barra.dart';
import 'calendar.dart';
import 'email_page.dart';
import 'login.dart';
import 'transition.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  Future<Resp> getEquips(Map<String,String> allValues) async {
    final String id = allValues['idMonitor']!;
    final String token = allValues['jwt']!;
    final response = await http.get(
        Uri.parse('https://motxilla-api.herokuapp.com/monitors/$id/equips'),
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
            'listequip': (BuildContext context) => ListPage(),
            'perfilMonitor': (BuildContext context) => PerfilMonitor(),
            'llistaActivitats': (BuildContext context) => ActivitatsList()
          },
        ),
      )
    );
  }
}