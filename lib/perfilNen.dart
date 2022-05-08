import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class PerfilNen extends StatefulWidget{
  @override
  PerfilNenState createState() => PerfilNenState();
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

Widget _boxResponsables(nom, cognom1, cognom2, dni, telefon1, telefon2, email){
  return Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
    ),
    child: Column(
      children: [
        _boxInfo("Nom", nom),
        5.height,
        _boxInfo("Cognoms", cognom1 + " " + cognom2),
        5.height,
        _boxInfo("DNI", dni),
        5.height,
        _boxInfo("Telèfon 1", telefon1),
        5.height,
        _boxInfo("Telèfon 2", telefon2),
        5.height,
        _boxInfo("Correu electrònic", email),
      ],
    )
  );
}

class PerfilNenState extends State<PerfilNen> {
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
          title: Text("Perfil: "+ "Martí"),
        ),
      body: Container(
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
        )
      )
    );
  }
}