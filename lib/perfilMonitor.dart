import 'dart:convert';

import 'package:Motxilla/Resp.dart';
import 'package:Motxilla/configuracio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;

class PerfilMonitor extends StatefulWidget{
  @override
  PerfilMonitorState createState() => PerfilMonitorState();
}


String token = '';
String nom = '';
String cognom1 = '';
String cognom2 = '';
int? llicencia = null;
String targetaSanitaria = '';
String email = '';
String dni = '';



class PerfilMonitorState extends State<PerfilMonitor> {

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async{
    final storage2 = new FlutterSecureStorage();
    token = (await storage2.read(key: 'jwt'))!;
    getIdMonitorAutentificat().then((response) async {
      var idMonitor = response.list![0]['id'];
        getMonitor(idMonitor).then((resposta) async {
          nom = resposta.data!['nom'];
          cognom1 = resposta.data!['cognom1'];
          cognom2 = resposta.data!['cognom2'] == null ? '': resposta.data!['cognom2'];
          llicencia = resposta.data!['llicencia'] == null ? '': resposta.data!['llicencia'];
          targetaSanitaria = resposta.data!['targetaSanitaria'] == null ? '': resposta.data!['targetaSanitaria'];
          email = resposta.data!['email'];
          dni = resposta.data!['dni'];
        });
      setState(() {});
    });
  }

  Future<Resp> getIdMonitorAutentificat() async {
    final response = await http.get(
      Uri.parse('https://motxilla-api.herokuapp.com/tokenid'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return Resp.fromJson2(json);
    } else {
      throw Exception('Failed to load response');
    }
  }

  Future<Resp> getMonitor(int id) async {
    final response = await http.get(
        Uri.parse('https://motxilla-api.herokuapp.com/monitors/$id'),
        headers: {
          'Authorization': 'Bearer $token',
        }
    );
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      return Resp.fromJson(json);
    } else {
      throw Exception('Failed to load response');
    }
  }


  Widget _boxInfo(field, info){
    return Container(
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
                height: 50,
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
    );
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
        title: Text("El meu perfil"),
        actions:[
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: "Sortir",
            onPressed: (){
              Navigator.pushNamed(context, "login");
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            tooltip: "Configuració",
            onPressed: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context)=> Configuracio())
              );
            },
          )
        ]
      ),
      body: Container(
        margin: EdgeInsets.only(top:20, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(nom +' ' +cognom1,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold
              )
            ),
            10.height,
            Text('Les meves dades',style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold
            )),
            5.height,
            _boxInfo("Nom",nom),
            5.height,
            _boxInfo("Cognoms",cognom1 + " " + cognom2),
            5.height,
            _boxInfo("DNI",dni),
            5.height,
            _boxInfo("Llicència",llicencia.toString()),
            5.height,
            _boxInfo("Targeta Sanitària",targetaSanitaria),
            5.height,
            _boxInfo("Email",email),
            5.height,
          ],
        ),
      )
    );

  }
}