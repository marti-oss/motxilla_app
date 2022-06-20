import 'dart:convert';

import 'package:Motxilla/Resp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;

class EmailPage extends StatefulWidget{
  @override
  final int teamId;
  final String nom;
  EmailPage(this.teamId, this.nom);
  EmailPageState createState() => EmailPageState(teamId,nom);
}

class EmailPageState extends State<EmailPage> {
  late final int teamId;
  late final String nom;
  EmailPageState(this.teamId, this.nom);
  FocusNode asuntoNode = FocusNode();
  FocusNode descripcionNode = FocusNode();
  String asumpte = '';
  String contingut = '';

  Future<Resp> enviarEmails() async{
    var storage = new FlutterSecureStorage();
    var token = (await storage.read(key: 'jwt'))!;
    var map = new Map<String,dynamic>();
    map['asumpte'] = asumpte;
    map['contingut'] = contingut;
    final response = await http.post(
        Uri.parse("https://motxilla-api.herokuapp.com/equips/5/emails"),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: map
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
        title: Text("Enviar email"),
        actions: [
          IconButton(
              icon: Icon(Icons.send),
              tooltip: "Enviar",
              onPressed: () {
                enviarEmails();
              }
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                margin: EdgeInsets.only(top:10,left: 20),
                child: Text("Per a: ${nom}",
                        style: TextStyle(
                            fontSize: 20
                        ),),
              ) ,
            ),
            20.height,
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.grey[100]),
              child: TextFormField(
                cursorColor: const Color(0x683210),
                focusNode: asuntoNode,
                autofocus: false,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (term) {
                  asuntoNode.unfocus();
                  FocusScope.of(context).requestFocus(descripcionNode);
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Asumpte',
                  hintStyle: secondaryTextStyle(size:16),
                ) ,
                onChanged: (newValue) {
                  asumpte = newValue;
                },
              ).paddingOnly(left: 8,top:2),
            ).cornerRadiusWithClipRRect(12),
            Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.grey[100]),
              child: TextFormField(
                cursorColor: const Color(0x683210),
                focusNode: descripcionNode,
                autofocus: false,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (term) {
                  asuntoNode.unfocus();
                  FocusScope.of(context).requestFocus(descripcionNode);
                },
                keyboardType: TextInputType.text,
                maxLines: 8,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Descripció',
                  hintStyle: secondaryTextStyle(size:16),
                ),
                onChanged: (newValue){
                  contingut = newValue;
                },
              ).paddingOnly(left: 8,top:2),
            ).cornerRadiusWithClipRRect(12),
          ],
        )
      )
    );
  }
}