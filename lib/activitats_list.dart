import 'dart:convert';
import 'dart:io';

import 'package:Motxilla/Resp.dart';
import 'package:Motxilla/activitat_detall.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:http/http.dart' as http;

class ActivitatsList extends StatefulWidget {
  ActivitatsList({
    Key? key,
  }) : super(key: key);

  @override
  ActivitatsListState createState() => ActivitatsListState();
}

class ActivitatsListState extends State<ActivitatsList>{
  late Future<List> llistatactivitats;
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    llistatactivitats = getList();
    super.initState();
  }

  Future<List> getList() async{
    final resposta = await  getActivitats();
    llistatactivitats = Future.value(resposta.list!);
    return llistatactivitats;
  }

  Future<Resp> getActivitats() async {
    final String? token = await storage.read(key: 'jwt');
    final response = await http.get(
      Uri.parse('https://motxilla-api.herokuapp.com/activitats'),
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

          title: Text("Activitats"),
        ),
        body: FutureBuilder<List>(
          future: llistatactivitats,
          builder: (BuildContext context, AsyncSnapshot<List> snapshot){
            if (snapshot.hasData) {
              return ListView.builder(itemCount:  snapshot.data?.length,itemBuilder: (BuildContext context, int index){
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
                            title: Text(snapshot.data![index]["name"],//categories[0]["name"]!,
                                style: TextStyle(fontSize: 20,)),
                            trailing: IconButton(
                              icon: Icon(Icons.arrow_forward),
                              onPressed: () {

                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (context) =>
                                        ActivitatDetall(idActivitat:  snapshot.data![index]["id"]))
                                );
                              },
                            ),
                          )
                      ),
                    ]
                );
              });
            }
            return Text(' ');
          },
        )
    );
  }
}