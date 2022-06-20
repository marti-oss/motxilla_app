import 'dart:convert';

import 'package:Motxilla/Resp.dart';
import 'package:Motxilla/configuracio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;

class ActivitatDetall extends StatefulWidget {
  final int idActivitat;
  ActivitatDetall({
    required this.idActivitat
  }) : super();
  @override
  ActivitatDetallState createState() => ActivitatDetallState(idActivitat);
}

class ActivitatDetallState extends State<ActivitatDetall> {
  late final int idActivitat;
  late Future<Map<String, dynamic>?> infoDetallada;
  ActivitatDetallState(this.idActivitat);

  @override
  void initState() {
    super.initState();
    print(1);
    infoDetallada = getInfoDetallada();
  }

  Future<Map<String, dynamic>?> getInfoDetallada() async {
    print(2);
    final resposta = await getDetall();
    print(resposta.data);
    return resposta.data;
  }

  Future<Resp> getDetall() async {
    print(3);
    final storage = new FlutterSecureStorage();
    print(4);
    String token = (await storage.read(key: 'jwt'))!;
    print(5);
    final response = await http.get(
        Uri.parse(
            'https://motxilla-api.herokuapp.com/activitats/$idActivitat'),
        headers: {
          'Authorization': 'Bearer $token',
        });
    if (response.statusCode == 200) {
      print(6);
      var json = jsonDecode(response.body);
      print(json);
      return Resp.fromJson(json);
    } else {
      print(8);
      throw Exception('Failed to load response');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:AppBar(
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
            title: Text("Detalls"),
        ),
        body: Container(
            margin: EdgeInsets.only(top:20, left: 20),
            child: FutureBuilder(
                future: infoDetallada,
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    String interior = 'No';
                    if (snapshot.data['interior'] == true)
                      interior = 'Sí';
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("${snapshot.data!['name']}",
                            style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold
                            )
                        ),
                        10.height,
                        5.height,
                        _boxInfo("Nom",snapshot.data!['name']),
                        5.height,
                        _boxInfo("Objectiu","${snapshot.data!['objectiu']}"),
                        5.height,
                        _boxInfo("Interior",interior),
                        5.height,
                        _boxDescripcio("Descripció",snapshot.data!['descripcio'].toString()),
                        5.height
                      ],
                    );

                  }
                  else Text('Loading...');
                  return Text('');
                })
        )
    );
  }
}

Widget _boxInfo(field, info) {
  return Container(
    child: Row(
        children: [
          Flexible(
            child: Container(
              height: 50,
              padding: EdgeInsets.symmetric(
                horizontal: 2,
                vertical: 2,
              ),

              decoration: BoxDecoration(
                color: Color.fromRGBO(182, 218, 7, 0.658),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                ),
              ),
              child: Row(children: [
                SizedBox(width: 2),
                Expanded(child: Text(field)),
              ]
              ),
            ),
          ),

          Flexible(
            child: Container(
              height: 50,
              padding: EdgeInsets.symmetric(
                horizontal: 2,
                vertical: 2,
              ),

              decoration: BoxDecoration(
                color: Colors.blueGrey[50],
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
              child: Row(children: [
                SizedBox(width: 2),
                Expanded(child: Text(info)),
              ]
              ),
            ),
          ),
        ]),
  );
}

  Widget _boxDescripcio(field, info){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        child: Align(
          alignment: Alignment.center,
            child: Text(
              field,
              textAlign: TextAlign.center,
            ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 2,
          vertical: 2,
        ),
        height: 25,
        decoration: BoxDecoration(
          color: Color.fromRGBO(182, 218, 7, 0.658 ),
          borderRadius:BorderRadius.only(
            topLeft: Radius.circular(5),
            topRight: Radius.circular(5),
          ),
        ),
      ),
    Container(
      padding: EdgeInsets.symmetric(
        horizontal: 2,
        vertical: 2,
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          info,
          textAlign: TextAlign.center,
        ),
      ),

      decoration: BoxDecoration(
        color: Colors.blueGrey[50],
        borderRadius:BorderRadius.only(
        bottomRight: Radius.circular(5),
        bottomLeft: Radius.circular(5),
        ),
      ),
    )

    ],
  );
    /*return Container(
      child: Row(
          children: [
            Flexible(
              child:Container(
                height: 50,
                padding: EdgeInsets.symmetric(
                  horizontal: 2,
                  vertical: 2,
                ),

                decoration: BoxDecoration(
                  color: Color.fromRGBO(182, 218, 7, 0.658 ),
                  borderRadius:BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  ),
                ),
                child: Row(children: [
                  SizedBox(width: 2),
                  Expanded(child: Text(field)),
                ]
                ),
              ),
            ),

            Flexible(
              child:Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 2,
                  vertical: 2,
                ),

                decoration: BoxDecoration(
                  color: Colors.blueGrey[50],
                  borderRadius:BorderRadius.only(
                    topRight: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                ),
                child: Row(children: [
                  SizedBox(width: 2),
                  Expanded(child: Text(info)),
                ]
                ),
              ),
            ),
          ]),
    );*/
}