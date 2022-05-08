import 'package:Motxilla/utils/topBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Menu extends StatefulWidget {
  static String tag = '/EGProfileScreen';

  @override
  MenuState createState() => MenuState();
}
class OptionData {
  OptionData(this.icon, this.title,this.color, this.route);
  final IconData icon;
  final String title;
  final Color color;
  final String route;
}

class MenuState extends State<Menu> {
  final List<OptionData> menu = [
    OptionData(Icons.people, 'Equip', Colors.indigoAccent, "listequip"),
    OptionData(Icons.emoji_people, 'Perfil', Colors.orangeAccent, "login" ),
    OptionData(Icons.calendar_today, 'Calendari', Colors.redAccent.shade400, "calendar"),
    OptionData(Icons.format_list_bulleted_rounded, 'Repositori', Colors.lightGreenAccent, "login"),
  ];

  Widget _textHeader() {
    return
      Container(
        margin: const EdgeInsets.only(top: 20,left: 20),
        child: const Text("Hola Martí",
            style: TextStyle(
              fontSize: 36.0,
              fontWeight: FontWeight.bold,
            )
        ),
    );
  }

  Widget _buttonsIcons() {
    return GridView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemCount: menu.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 1,
        crossAxisCount: 2,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0),
      itemBuilder: (BuildContext context, int index){
        return Card(
          color: menu[index].color,
          elevation: 0.2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
          child: InkWell(
            onTap:() {
              Navigator.pushNamed(context, menu[index].route);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(menu[index].icon, size:30),
                SizedBox(height: 20),
                Text(menu[index].title, textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: Colors.black87),)
              ]
            )
          )
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavigationBar(),
      body: Container(
        child: Scrollbar(
          thickness: 3,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                _textHeader(),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: _buttonsIcons()
                ),
              ],
            )
          )
        )

      ),
    );
  }

}