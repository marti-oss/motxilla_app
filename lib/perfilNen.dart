import 'dart:convert';

import 'package:Motxilla/Resp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;

class PerfilNen extends StatefulWidget {
  final int idParticipant;
  const PerfilNen({required this.idParticipant}) : super();

  @override
  PerfilNenState createState() => PerfilNenState(idParticipant);
}

Widget _boxInfo(field, info) {
  if (info == 'null') info = '';
  return Container(
    child: Row(children: [
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
          ]),
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
          ]),
        ),
      ),
    ]),
  );
}

Widget _boxResponsables(nom, cognom1, cognom2, dni, telefon1, telefon2, email) {
  String cognoms = '';
  if (cognom1 != null) {
    cognoms = cognom1;
    if (cognom2 != null) cognoms += cognom2;
  }
  return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        children: [
          _boxInfo("Nom", nom ?? ''),
          5.height,
          _boxInfo("Cognoms", cognoms),
          5.height,
          _boxInfo("DNI", dni ?? ''),
          5.height,
          _boxInfo("Telèfon 1", telefon1.toString()),
          5.height,
          _boxInfo("Telèfon 2", telefon2.toString()),
          5.height,
          _boxInfo("Correu electrònic", email ?? ''),
        ],
      ));
}

class PerfilNenState extends State<PerfilNen> {
  late final int idParticipant;
  late Future<Map<String, dynamic>?> infoParticipant;
  late Future<List> infoResponsables;

  PerfilNenState(this.idParticipant);

  @override
  void initState() {
    super.initState();
    infoParticipant = getParticipantInfo();
    infoResponsables = getResponsablesInfo();
  }

  Future<Map<String, dynamic>?> getParticipantInfo() async {
    final resposta = await getParticipant();
    return resposta.data;
  }

  Future<List> getResponsablesInfo() async {
    final resposta = await getResponsables();
    return resposta.list!;
  }

  Future<Resp> getParticipant() async {
    final storage = new FlutterSecureStorage();
    String token = (await storage.read(key: 'jwt'))!;
    final response = await http.get(
        Uri.parse(
            'https://motxilla-api.herokuapp.com/participants/$idParticipant'),
        headers: {
          'Authorization': 'Bearer $token',
        });
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return Resp.fromJson(json);
    } else {
      throw Exception('Failed to load response');
    }
  }

  Future<Resp> getResponsables() async {
    final storage = new FlutterSecureStorage();
    String token = (await storage.read(key: 'jwt'))!;
    final response = await http.get(
        Uri.parse(
            'https://motxilla-api.herokuapp.com/participants/$idParticipant/responsables'),
        headers: {
          'Authorization': 'Bearer $token',
        });
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      print('json');
      print(json);
      return Resp.fromJson2(json);
    } else {
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
            colors: [
              Color.fromRGBO(182, 218, 7, 0.658),
              Color.fromRGBO(26, 156, 255, 0.455)
            ],
            begin: Alignment.topLeft,
            end: Alignment.topRight,
            stops: [0.0, 0.8],
            tileMode: TileMode.clamp,
          ))),
          title: Text("Perfil"),
        ),
        body: Container(
            margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: SingleChildScrollView(
                child: Container(
                  child: FutureBuilder(
                      future: infoParticipant,
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.hasData) {
                          String autoritzacio = 'No';
                          if (snapshot.data['autoritzacio'] == true)
                            autoritzacio = 'Sí';

                          return Column(children: [
                            Text("${snapshot.data['nom']} ${snapshot.data['cognom1']}  ${snapshot.data['cognom2']}",
                                style: TextStyle(
                                  fontSize: 36.0,
                                  fontWeight: FontWeight.bold,
                                )),
                            5.height,
                            _boxInfo("Nom", snapshot.data['nom']),
                            5.height,
                            _boxInfo("Cognoms",
                                "${snapshot.data['cognom1']}  ${snapshot.data['cognom2']}"),
                            5.height,
                            _boxInfo("DNI", snapshot.data['dni']),
                            5.height,
                            _boxInfo("Autorització", autoritzacio),
                            5.height,
                            _boxInfo("Targeta Sanitària",
                                snapshot.data['targetaSanitaria']),
                            20.height,
                            FutureBuilder<List>(
                              future: infoResponsables,
                              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                if(snapshot.hasData){
                                  return ListView.builder(shrinkWrap: true, itemCount: snapshot.data?.length, itemBuilder:(BuildContext context, int index){
                                    return Column (
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                      Text("Responsables",
                                          style: TextStyle(
                                            fontSize: 36.0,
                                            fontWeight: FontWeight.bold,
                                          )),
                                        5.height,
                                        _boxResponsables(snapshot.data![index]['nom'], snapshot.data![index]['cognom1'], snapshot.data![index]['cognom2'], snapshot.data![index]['dni'], snapshot.data![index]['telefon1'], snapshot.data![index]['telefon2'], snapshot.data![index]['email']),
                                        5.height,
                                      ],
                                    );
                                  });

                                }
                                else return Text(' ');
                              },)
                          ]
                          );
                        }
                        return Text('');
                      }),
                ))));
  }
}

/*
Container(
        margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text("Martí Serra Aguilera",
                style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                )
              ),
              5.height,
              _boxInfo("Nom", "Martí"),
              5.height,
              _boxInfo("Cognoms", "Serra Aguilera"),
              5.height,
              _boxInfo("DNI", "4797****"),
              5.height,
              _boxInfo("Autorització", "Sí"),
              5.height,
              _boxInfo("Targeta Sanitària", "SEAG 0 990126 003"),
              5.height,
              _boxInfo("Equip", "Campaments"),
              20.height,
              Text("Responsables",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              5.height,
              _boxResponsables("Josep", "Jiménez", "Aguilera", "4798****j", "699234578", "", "jja@motxilla.com"),
              5.height,
              _boxResponsables("Marc", "Serra", "Cruz", "8897****k", "645239871", "698784578", "mmc@motxilla.com"),
              5.height,


            ],
          )
 */
