import 'package:Motxilla/perfilNen.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ListPage extends StatefulWidget {
  static String tag = '/EGProfileScreen';
  final String title;
  const ListPage({
    Key? key,
    required this.title
  }) : super(key: key);

  @override
  ListPageState createState() => ListPageState(title);
}

List equips = [
  {'name': 'John', 'group': 'Team A'},
  {'name': 'Will', 'group': 'Team B'},
  {'name': 'Beth', 'group': 'Team A'},
  {'name': 'Miranda', 'group': 'Team B'},
  {'name': 'Mike', 'group': 'Team C'},
  {'name': 'Danny', 'group': 'Team C'},
  {'name': 'P', 'group': 'Team C'},
  {'name': 'K', 'group': 'Team C'},
  {'name': 'G', 'group': 'Team C'},
  {'name': 'Q', 'group': 'Team C'},
];

List nens = [
  {'name': 'Martí', 'group': 'Team A'},
  {'name': 'Arnau', 'group': 'Team B'},
  {'name': 'Show', 'group': 'Team A'},
  {'name': 'Miranda', 'group': 'Team B'},
  {'name': 'Julia', 'group': 'Team C'},
  {'name': 'Jimena', 'group': 'Team C'},
  {'name': 'p', 'group': 'Team C'},
  {'name': 'K', 'group': 'Team C'},
  {'name': 'G', 'group': 'Team C'},
  {'name': 'Q', 'group': 'Team C'},
];

class ListPageState extends State<ListPage> {
  late final String title;
  ListPageState(this.title);
  List categories = [];

  @override
  Widget build(BuildContext context){
    if (title == "Equips") {
      categories = equips;
    }else{
      categories = nens;
    }
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
          title: Text(widget.title),

      ),
      body: AnimatedList(
        initialItemCount: categories.length,
        itemBuilder: (context, index, animation) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Container(
              margin:EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                title: Text(categories[index]["name"],
                            style: TextStyle(fontSize: 20,)),
                trailing: IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    if (categories == nens){
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => PerfilNen())
                      );
                    }
                    else {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ListPage(title:"Nens"))
                      );
                    }
                  },
                ),
              )
            ),
          ]
        )
      )
    );
  }
}

class ListItemWidget extends StatelessWidget {
  Widget build(BuildContext context) => Container();
}