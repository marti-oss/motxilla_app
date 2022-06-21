import 'dart:convert';

import 'package:Motxilla/Resp.dart';
import 'package:Motxilla/activity.dart';
import 'package:Motxilla/calendar.dart';
import 'package:Motxilla/email_page.dart';
import 'package:Motxilla/perfilNen.dart';
import 'package:Motxilla/utils/dates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_calendar/calendar.dart';

class GuardarActivitatEquip extends StatefulWidget{
  final Activity activity;
  const GuardarActivitatEquip({
    required this.activity
  }): super();

  @override
  GuardarActivitatEquipState createState() => GuardarActivitatEquipState(activity);
}

String dropdownValue = '';

class GuardarActivitatEquipState extends State<GuardarActivitatEquip> {
  late final Activity activity;
  late Future<List> equips;
  GuardarActivitatEquipState(this.activity);

  @override
  void initState() {
    equips = getList();
    super.initState();
  }

  Future<List> getList() async {
    final respuesta = await getEquips();
    equips = Future.value(respuesta.list!);
    return equips;
  }

  Future<Resp> getEquips() async {
    final storage = const FlutterSecureStorage();
    final Map<String,String> allValues = await storage.readAll();
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

  Future<Resp> guardarActivitat(Activity activity) async {
    final storage = new FlutterSecureStorage();
    String token = (await storage.read(key: 'jwt'))!;
    var map = new Map<String,dynamic>();
    map['dataIni'] = DateFormat('yyyy-MM-dd kk:mm').format(activity.from);
    map['dataFi'] = DateFormat('yyyy-MM-dd kk:mm').format(activity.to);
    map['nom'] = activity.title;
    map['objectiu'] = activity.objectiu;
    map['interior'] = activity.interior ? "true" : "false";
    map['descripcio'] = activity.description;
    var splitted = dropdownValue.split('(');
    splitted = splitted[1].split("");
    splitted.removeLast();
    var id = splitted.join();
    final response = await http.post(
      Uri.parse('https://motxilla-api.herokuapp.com/equips/${id}/activitatsprogramades'),
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: map,
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
                icon: Icon(Icons.save),
                tooltip: "Guardar" ,
                onPressed: () {
                  guardarActivitat(activity);
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Calendar())
                  );
                }
            )
          ],
        ),
        body: FutureBuilder<List>(
          future: equips,
          builder: (BuildContext context, AsyncSnapshot<List> snapshot){
            if (snapshot.hasData) {
              return ListView(
                padding: EdgeInsets.all(32),
                children: [
                  Row(
                    children:[
                      const Text(
                          'Seleccionar equip: ',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                          )
                      ),
                      buildAutocomplete(),
                    ]
                  ),
                  SizedBox(height: 32,),
                  buildDateTime(activity),
                  SizedBox(height: 32,),
                  Text(activity.title,
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
                      Text( activity.objectiu,
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
                      Text( activity.interior == true ? 'Sí': 'No',
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


              );
            }
            return Text(' ');
          },
        )
    );
  }

  Widget buildAutocomplete() {
    return FutureBuilder(
      future: equips,
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasData){
            dropdownValue = "${snapshot.data?[0]['name']} (${snapshot.data?[0]['id']})";
            List<String> list = [];
            snapshot.data?.forEach((equipItem) {
              list.add("${equipItem['name']} (${equipItem['id']})");
            });


            return DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.black),
              underline: Container(
                height: 2,
                color: Colors.blue,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items: list
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            );

          }
          return Text('Loading...');
        }
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