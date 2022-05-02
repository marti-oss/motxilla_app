import 'package:flutter/material.dart';

class Activity {
  final String title;
  final String description;
  final DateTime from;
  final DateTime to;
  final backgroundColor;
  final bool isAllDay;

  const Activity({
    required this.title,
    required this.description,
    required this.from,
    required this.to,
    this.backgroundColor = Colors.lightGreen,
    this.isAllDay= false,
  });
}