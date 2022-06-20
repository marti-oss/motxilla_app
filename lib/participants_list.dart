import 'dart:convert';

import 'package:Motxilla/Resp.dart';
import 'package:Motxilla/email_page.dart';
import 'package:Motxilla/perfilNen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ParticipantsListPage extends StatefulWidget {
  final int idEquip;
  final String nom;
  const ParticipantsListPage({
    required this.idEquip,
    required this.nom
  }) : super();

  @override
  ParticipantsListPageState createState() => ParticipantsListPageState(idEquip, nom);
}

String token = '';


class ParticipantsListPageState extends State<ParticipantsListPage> {
  late final int idEquip;
  late final String nom;
  late Future<List> llistat;

  ParticipantsListPageState(this.idEquip, this.nom);


  @override
  void initState() {
    super.initState();
    llistat = getList();
  }

  Future<List> getList() async {
    final resposta = await getParticipants(idEquip);
    llistat = Future.value(resposta.list![0]['participants']);
    return llistat;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(() {});
  }

  Future<Resp> getParticipants(int id) async {
    final storage2 = new FlutterSecureStorage();
    token = (await storage2.read(key: 'jwt'))!;
    final response = await http.get(
        Uri.parse('https://motxilla-api.herokuapp.com/equips/$id'),
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
                  )
              )
          ),

          title: Text("Participants"),
          actions: [
            IconButton(
              icon: Icon(Icons.email),
              tooltip: "Enviar missatge als responsables" ,
              onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => EmailPage(idEquip,nom)
                )
              )
            )
          ]
        ),
        body: FutureBuilder<List>(
          future: llistat,
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if(snapshot.hasData){
              return ListView.builder(itemCount: snapshot.data?.length, itemBuilder:  (BuildContext context, int index){
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16),
                            title: Text(snapshot.data![index]["nom"],
                                style: TextStyle(fontSize: 20,)),
                            trailing: IconButton(
                              icon: Icon(Icons.arrow_forward),
                              onPressed: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) =>
                                        PerfilNen(idParticipant: snapshot.data![index]["id"]))
                                );
                              },
                            ),
                          )
                      ),
                    ]
                );
              });
            }
            else {
              Text("carregant");
            }

            return Text('');
          }
        ),
    );
  }
}

/*Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16),
                            title: Text(llistat[index]["name"],
                                style: TextStyle(fontSize: 20,)),
                            trailing: IconButton(
                              icon: Icon(Icons.arrow_forward),
                              onPressed: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) =>
                                          PerfilNen())
                                  );
                              },
                            ),
                          )
                      ),
                    ]
                )*/