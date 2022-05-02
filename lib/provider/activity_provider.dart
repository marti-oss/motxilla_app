import 'package:flutter/material.dart';

import '../activity.dart';

class ActivityProvider extends ChangeNotifier {
  final List<Activity> _activities = [];

  List<Activity> get activities => _activities; //Aqui fer l'import de la api

  DateTime _selectedDate = DateTime.now();

  DateTime get selectedDate => _selectedDate;

  void setDate(DateTime date) => _selectedDate = date;

  List<Activity> get activitiesOfSelectedDate => _activities;

  void addActivity(Activity activity) {
    _activities.add(activity);

    notifyListeners();
  }

  void editActivity(Activity newActivity, Activity oldActivity) {
    final index = _activities.indexOf(oldActivity);
    _activities[index] = newActivity;

    notifyListeners();
  }
}