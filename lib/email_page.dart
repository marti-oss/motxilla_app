import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class EmailPage extends StatefulWidget{
  @override
  final int teamId;
  EmailPage(this.teamId);
  EmailPageState createState() => EmailPageState(teamId);
}

class EmailPageState extends State<EmailPage> {
  late final int teamId;
  EmailPageState(this.teamId);
  FocusNode asuntoNode = FocusNode();
  FocusNode descripcionNode = FocusNode();

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
              onPressed: () {}
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
                child: Text("Per a: Campaments",
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
                ) ,
              ).paddingOnly(left: 8,top:2),
            ).cornerRadiusWithClipRRect(12),
          ],
        )
      )
    );
  }
}