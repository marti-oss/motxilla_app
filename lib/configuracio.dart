import 'package:Motxilla/login.dart';
import 'package:flutter/material.dart';


import 'package:nb_utils/nb_utils.dart';class Configuracio extends StatefulWidget {

  @override
  ConfiguracioState createState() => ConfiguracioState();
}

class ConfiguracioState extends State<Configuracio> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
            title: Text("Configuració"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Canviar contrasenya",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold
                        )),
                    Text(
                      "Introduir contrasenya actual",
                      style: TextStyle(color: Color(0xFF757575), fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      decoration: BoxDecoration(color: Colors.grey[100]),
                      child: TextFormField(
                        autofocus: false,
                        style: secondaryTextStyle(
                            color: Colors.black ),
                        keyboardType: TextInputType.text,
                        onChanged: (newValue) {
                          /*
                          mail = newValue;
                          correct_mail = true;
                          */
                          setState(() {});
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Contrasenya actual",
                            hintStyle: secondaryTextStyle(size: 16)),
                      ).paddingOnly(left: 8, top: 2),
                    ).cornerRadiusWithClipRRect(12)
                        .paddingOnly(top: 16, bottom: 8),
                    Text(
                      "Introduir contrasenya nova",
                      style: TextStyle(color: Color(0xFF757575), fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    Container(
                      decoration: BoxDecoration(color: Colors.grey[100]),
                      child: TextFormField(
                        autofocus: false,
                        style: secondaryTextStyle(
                            color: Colors.black ),
                        keyboardType: TextInputType.text,
                        onChanged: (newValue) {
                          /*
                          mail = newValue;
                          correct_mail = true;
                          */
                          setState(() {});
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Contrasenya nova",
                            hintStyle: secondaryTextStyle(size: 16)),
                      ).paddingOnly(left: 8, top: 2),
                    ).cornerRadiusWithClipRRect(12)
                        .paddingOnly(top: 16, bottom: 8),
                    Align(
                        alignment: Alignment.center,
                        child: ElevatedButton.icon(
                          label: Text("Canviar"),
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(140, 40),
                            primary: Colors.green,
                            onPrimary: Colors.white,
                            onSurface: Colors.grey,
                          ),
                          icon: Icon(Icons.check, size: 18),
                          onPressed: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context)=> Login())
                            );
                          },
                        )
                    ).paddingTop(10)
                  ],
                ),
              ),
              Divider( thickness: 5),
              Align(
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                    label: Text("Tancar sessió"),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(140, 40),
                      primary: Colors.red,
                      onPrimary: Colors.white,
                      onSurface: Colors.grey,
                    ),
                    icon: Icon(Icons.exit_to_app_rounded, size: 18),
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context)=> Login())
                      );
                    },
                  )
              ).paddingTop(10),
            ],
          ).paddingAll(16),
        ),
      ),
    );
  }
}
