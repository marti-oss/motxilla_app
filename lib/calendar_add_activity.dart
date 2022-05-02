import 'package:Motxilla/provider/activity_provider.dart';
import 'package:Motxilla/utils/dates.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

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

class CalendarAddActivityState extends State<CalendarAddActivity> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  late DateTime fromDate;
  late DateTime toDate;


  @override
  void initState() {
    super.initState();
    if (widget.activity == null){
      fromDate = DateTime.now();
      toDate = DateTime.now().add(Duration(hours: 2));
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

              ]
          )
        )

      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color.fromRGBO(182, 218, 7, 0.658 ),
        onPressed: () {
          saveForm();
          Navigator.of(context).pop();
        },
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
      toDate = DateTime(date.year, date.month, date.day, toDate.hour, toDate.minute);
    }
    setState(() {
      fromDate = date;
    });
  }

  Future pickToDateTime({required bool pickDate}) async {
    final date = await pickDateTime(toDate, pickDate: pickDate,firstDate: pickDate ? fromDate : null);
    if (date == null) return;

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
        final date = DateTime(initialDate.year, initialDate.month, initialDate.day, initialDate.hour, initialDate.minute);
        final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);

        return date.add(time);
      }
  }

  Future saveForm() async{
    final isValid = _formKey.currentState!.validate();

    if (isValid){
      final activity = Activity(
          title: titleController.text,
          description: 'description',
          from: fromDate,
          to: toDate,
          isAllDay: false);
      final provider = Provider.of<ActivityProvider>(context, listen: false);
      provider.addActivity(activity);
    }

  }
  
}

