import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class RoutineTask {
  final String id;
  String name;
  final IconData icon;
  int hours;
  int mins;
  bool isEnabled;

  RoutineTask({
    required this.id,
    required this.name,
    required this.icon,
    this.hours = 0,
    this.mins = 0,
    this.isEnabled = true,
  });

  int get totalMinutes => isEnabled ? (hours * 60) + mins : 0;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'iconCode': icon.codePoint,
    'hours': hours,
    'mins': mins,
    'isEnabled': isEnabled,
  };

  factory RoutineTask.fromJson(Map<String, dynamic> json) => RoutineTask(
    id: json['id'],
    name: json['name'],
    icon: IconData(json['iconCode'], fontFamily: 'MaterialIcons'),
    hours: json['hours'],
    mins: json['mins'],
    isEnabled: json['isEnabled'],
  );
}

// ─── Serialization helpers ───────────────────

String encodeTaskList(List<RoutineTask> tasks) =>
    jsonEncode(tasks.map((t) => t.toJson()).toList());

List<RoutineTask> decodeTaskList(String json) =>
    (jsonDecode(json) as List).map((e) => RoutineTask.fromJson(e)).toList();

// ─── Defaults ────────────────────────────────

final List<RoutineTask> defaultRoutineTasks = [
  RoutineTask(id: '1', name: 'Tahajjud Prayer', icon: Icons.nest_cam_wired_stand, hours: 0, mins: 30),
  RoutineTask(id: '2', name: 'Quran Study',     icon: Icons.menu_book_outlined,   hours: 1, mins: 0),
  RoutineTask(id: '3', name: 'Suhoor Meal',     icon: Icons.restaurant_outlined,  hours: 0, mins: 20),
];