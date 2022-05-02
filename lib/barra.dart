import 'package:Motxilla/login.dart';
import 'package:Motxilla/utils/images.dart';
import 'package:Motxilla/utils/topBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:Motxilla/utils/fonts.dart';
import 'calendar.dart';
import 'menu.dart';
import 'utils/topBarWidget.dart';

class Barra extends StatefulWidget {
  static String tag = '/EGNavigationScreen';

  @override
  BarraState createState() => BarraState();
}

class BarraState extends State<Barra> {
  var _selectedIndex = 0;
  var _pages = [Menu(), Calendar()];
  //var _pages = [Home(), Search(), Tienda(), Perfil()];
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);


  Widget _createBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromRGBO(182, 218, 7, 0.658 ), Color.fromRGBO(26, 156, 255, 0.455)],
          begin: Alignment.topLeft,
          end: Alignment.topRight,
          stops: [0.0, 0.8],
          tileMode: TileMode.clamp,
        )
      ),
      child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Inici",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: "Calendari",
            )
          ],
          fixedColor: Colors.black,
          onTap: (int inIndex) {
            setState(() {
              _selectedIndex = inIndex;
            });
          })
    );
  }

  PreferredSizeWidget _createTopNavigationBar() {
    return AppBar(
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
        leading: Image.asset(motxilla_logo),
        title: Text("Motxilla"),
        actions:[
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: "Sortir",
            onPressed: (){
              Navigator.pushNamed(context, "login");
            },
          )
        ]
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //appBar: TopNavigationBar(),
        body: Center(child: _pages.elementAt(_selectedIndex)),
        bottomNavigationBar: _createBottomNavigationBar()
    );
  }
}