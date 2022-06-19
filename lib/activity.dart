import 'package:flutter/material.dart';

class Activity {
  final int id;
  final String title;
  final String? description;
  final String objectiu;
  final bool interior;
  final DateTime from;
  final DateTime to;
  final backgroundColor;
  final bool isAllDay;

  const Activity({
    required this.id,
    required this.title,
    required this.objectiu,
    required this.interior,
    this.description,
    required this.from,
    required this.to,
    this.backgroundColor = Colors.lightGreen,
    this.isAllDay= false,
  });
}