import 'package:shared_preferences/shared_preferences.dart';

import '../models/task_model.dart';

/// Persists routine tasks and buffer time across sessions.
class RoutineStorageService {
  static const _tasksKey = 'routine_tasks';
  static const _bufferKey = 'buffer_minutes';

  static Future<List<RoutineTask>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_tasksKey);
    if (json == null) return List.from(defaultRoutineTasks);
    try {
      return decodeTaskList(json);
    } catch (_) {
      return List.from(defaultRoutineTasks);
    }
  }

  static Future<void> saveTasks(List<RoutineTask> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tasksKey, encodeTaskList(tasks));
  }

  static Future<int> loadBuffer() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_bufferKey) ?? 15;
  }

  static Future<void> saveBuffer(int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_bufferKey, minutes);
  }
}