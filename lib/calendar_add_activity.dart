import 'dart:convert';

import 'package:Motxilla/Resp.dart';
import 'package:Motxilla/guardarActivitatEquip.dart';
import 'package:Motxilla/provider/activity_provider.dart';
import 'package:Motxilla/utils/dates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:http/http.dart' as http;

import 'activity.dart';
import 'calendar.dart';


class CalendarAddActivity extends StatefulWidget {
  final Activity? activity;
  const CalendarAddActivity({
    Key? key,
    this.activity
  }) : super(key: key);

  @override
  CalendarAddActivityState createState() => CalendarAddActivityState();
}

var id;

class CalendarAddActivityState extends State<CalendarAddActivity> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final  objectiveController = TextEditingController();
  final descriptionController = TextEditingController();
  late DateTime fromDate;
  late DateTime toDate;
  bool interior = true;



  @override
  void initState() {
    super.initState();
    if (widget.activity == null){
      fromDate = DateTime.now();
      toDate = DateTime.now().add(Duration(hours: 2));
    } else {
      final activity = widget.activity!;
      titleController.text = activity.title;
      fromDate = activity.from;
      toDate = activity.to;
      objectiveController.text = activity.objectiu;
      interior = activity.interior;
      descriptionController.text = activity.description!;
      id =  activity.id;
    }
  }

  Future<Resp> editarActivity(activity) async {
      final storage = new FlutterSecureStorage();
      String token = (await storage.read(key: 'jwt'))!;
      var map = new Map<String,dynamic>();
      map['dataIni'] = DateFormat('yyyy-MM-dd kk:mm').format(activity.from);
      map['dataFi'] = DateFormat('yyyy-MM-dd kk:mm').format(activity.to);
      map['nom'] = activity.title;
      map['objectiu'] = activity.objectiu;
      map['interior'] = activity.interior ? "true" : "false";
      map['descripcio'] = activity.description;
      int id = activity.id;
      final response = await http.put(
        Uri.parse('https://motxilla-api.herokuapp.com/activitatsprogramades/${id}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
        body: map,
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
        actions: [
          IconButton(
              icon: (widget.activity != null) ? Icon(Icons.save) : Icon(Icons.arrow_forward),
              tooltip: "Guardar" ,
              onPressed: () async {
                Activity activity = await createActivity();
                if(widget.activity != null){ //editar
                  editarActivity(activity);
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => Calendar())
                  );
                }
                else { //nou
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => GuardarActivitatEquip(activity: activity))
                  );
                }
              }
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                buildTitle(),
                SizedBox(height: 12),
                buildDateTimePickers(),
                SizedBox(height: 12),
                buildObjective(),
                SizedBox(height: 12),
                buildSwitch(),
                SizedBox(height: 12),
                buildDescripcio()


              ]
          )
        )

      ),
    );
  }
  Widget buildTitle() {
    return TextFormField(
      style: TextStyle(fontSize: 24),
      decoration: InputDecoration(
          border: UnderlineInputBorder(),
          hintText: 'Afegir Títol'
      ),
      onFieldSubmitted: (_) {},
      controller: titleController,
      validator: (title) => title != null && title.isEmpty ? 'Títol no pot se buit' : null,
    );
  }

  Widget buildObjective() {
    return TextFormField(
      style: TextStyle(fontSize: 24),
      decoration: InputDecoration(
          border: UnderlineInputBorder(),
          hintText: 'Afegir Objectiu'
      ),
      onFieldSubmitted: (_) {},
      controller: objectiveController,
      validator: (objective) => objective != null && objective.isEmpty ? 'Objectiu no pot se buit' : null,
    );
  }

  Widget buildSwitch() {
    return Row(
      children: [
        Text('Interior: ',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
            )
        ),
        Switch.adaptive(
            value: interior,
            onChanged: (value) => setState(()  => interior = value)
        ),
      ],
    );
  }

  Widget buildDescripcio() {
    return TextFormField(
      style: TextStyle(fontSize: 24),
      decoration: InputDecoration(
          border: UnderlineInputBorder(),
          hintText: 'Afegir Descripcio'
      ),
      onFieldSubmitted: (_) {},
      controller: descriptionController,
      //validator: (description) => description != null && title.isEmpty ? 'Títol no pot se buit' : null,
    );
  }

  Widget buildDateTimePickers() {
    return Column(
      children: [
        buildForm(),
        buildTo(),
      ],

    );
  }

  Widget buildForm() {
    return buildHeader(
      header: 'DES DE',
      child: Row(
        children: [
          Expanded(
            flex:2,
            child: buildDropdownField(
              text: Date.toDate(fromDate),
              onClicked: () {
                pickFromDateTime(pickDate: true);
              },
            ),
          ),
          Expanded(
            child: buildDropdownField(
              text: Date.toTime(fromDate),
              onClicked: () {
                pickFromDateTime(pickDate: false);
              },
            )
          ),
        ],
      ),
    );
  }

  Widget buildDropdownField({required String text, required VoidCallback onClicked}) {
    return ListTile(
      title: Text(text),
      trailing: Icon(Icons.arrow_drop_down),
      onTap: onClicked
    );
  }

  Widget buildHeader({required String header, required Row child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(header, style: TextStyle(fontWeight: FontWeight.bold)),
        child
      ],
    );
  }

  Widget buildTo() {
    return buildHeader(
      header: 'FINS A',
      child: Row(
        children: [
          Expanded(
            flex:2,
            child: buildDropdownField(
              text: Date.toDate(toDate),
              onClicked: () {
                pickToDateTime(pickDate:true);
              },
            ),
          ),
          Expanded(
              child: buildDropdownField(
                text: Date.toTime(toDate),
                onClicked: () {
                  pickToDateTime(pickDate:false);
                },
              )
          ),
        ],
      ),
    );
  }

  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(fromDate, pickDate: pickDate);
    if (date == null) return;

    if (date.isAfter(toDate)) {
      toDate = date.add(Duration(hours: 2));//DateTime(date.year, date.month, date.day, toDate.hour, toDate.minute);
    }
    setState(() {
      fromDate = date;
    });
  }

  Future pickToDateTime({required bool pickDate}) async {
    final date = await pickDateTime(toDate, pickDate: pickDate,firstDate: pickDate ? fromDate : null);
    if (date == null) return;

    if (date.isBefore(fromDate)){
      fromDate = date.subtract(Duration(hours:2));
    }

    setState(() {
      toDate = date;
    });
  }

  Future<DateTime?> pickDateTime(
      DateTime initialDate,{
      required bool pickDate,
      DateTime? firstDate,
      }) async {
      if(pickDate){
        final date = await showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: firstDate ?? DateTime(2015,8),
            lastDate: DateTime(2101)
        );
        if (date == null) return null;
        final time = Duration(hours: initialDate.hour, minutes: initialDate.minute);
        return date.add(time);
      } else{
        final timeOfDay = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.fromDateTime(initialDate));
        if (timeOfDay == null) return null;
        final date = DateTime(initialDate.year, initialDate.month, initialDate.day, 0, 0);
        final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);
        return date.add(time);
      }
  }

  Future<Activity> createActivity() async{
    final isValid = _formKey.currentState!.validate();

    if (isValid){
      final activity = Activity(
          id: id,
          title: titleController.text,
          objectiu: objectiveController.text,
          interior: true,
          description: descriptionController.text,
          from: fromDate,
          to: toDate);
      return activity;
    }
    return Activity(id:-1,objectiu:'',interior:false,description: '', from:DateTime.now(), to:DateTime.now(), title: '');
  }

}

