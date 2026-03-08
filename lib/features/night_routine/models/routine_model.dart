import 'task_model.dart';

class RoutineModel {
  List<RoutineTask> tasks;
  int bedExitBufferMinutes; // clumsiness time
  DateTime fajrTime;

  RoutineModel({
    required this.tasks,
    required this.bedExitBufferMinutes,
    required this.fajrTime,
  });
}