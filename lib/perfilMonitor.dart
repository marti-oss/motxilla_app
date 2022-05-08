import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class PerfilMonitor extends StatefulWidget{
  @override
  PerfilMonitorState createState() => PerfilMonitorState();
}
class PerfilMonitorState extends State<PerfilMonitor> {
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
              Navigator.pushNamed(context, "login");
            },
          )
        ]
      ),
      body: Container(
        margin: EdgeInsets.only(top:20, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Martí Serra',
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
            _boxInfo("Nom","Martí"),
            5.height,
            _boxInfo("Cognoms","Serra" + " " + "Aguilera"),
            5.height,
            _boxInfo("DNI","4797****k"),
            5.height,
            _boxInfo("Llicència","12345567"),
            5.height,
            _boxInfo("Targeta Sanitària","SEAG 0 990126 003"),
            5.height,
            _boxInfo("Equips","Campaments"),
            5.height,
          ],
        ),
      )
    );

  }
}