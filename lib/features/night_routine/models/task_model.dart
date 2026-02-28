class TaskModel {
  final String id;
  String name;

  int hours;        // user input
  int minutes;      // user input

  bool enabled;

  TaskModel({
    required this.id,
    required this.name,
    required this.hours,
    required this.minutes,
    this.enabled = true,
  });

  int get totalMinutes => (hours * 60) + minutes;
}