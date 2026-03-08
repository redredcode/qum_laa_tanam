import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../night_routine/models/task_model.dart';
import '../../night_routine/services/prayer_time_service.dart';
import '../../night_routine/services/routine_storage_service.dart';
import '../widgets/add_task_sheet.dart';
import '../widgets/fajr_countdown_section.dart';
import '../widgets/recommended_chip.dart';
import '../widgets/routine_card.dart';
import '../widgets/routine_plan_section.dart';
import '../widgets/routine_task_section.dart';

class RoutineScreen extends StatefulWidget {
  const RoutineScreen({super.key});

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  int _bufferMinutes = 15;
  int _tasksTotalMinutes = 0;
  List<RoutineTask> _tasks = [];
  bool _loaded = false;

  int get _totalMinutes => _bufferMinutes + _tasksTotalMinutes;

  // ── Calculated times ──────────────────────

  DateTime get _wakeUpTime =>
      PrayerTimeService.instance.fajr.subtract(Duration(minutes: _totalMinutes));

  // 3 sleep options: 3, 4, 5 cycles (270, 360, 450 min)
  static const List<int> _cycleOptions = [3, 4, 5];
  static const int _idealSleepMinutes = 360; // 6h = 4 cycles

  List<DateTime> get _sleepOptions => _cycleOptions
      .map((c) => _wakeUpTime.subtract(Duration(minutes: 90 * c)))
      .toList();

  /// Index of the cycle option closest to 7.5h of sleep.
  int get _recommendedIndex {
    int best = 0;
    int bestDiff = 9999;
    for (int i = 0; i < _cycleOptions.length; i++) {
      final diff = (_cycleOptions[i] * 90 - _idealSleepMinutes).abs();
      if (diff < bestDiff) {
        bestDiff = diff;
        best = i;
      }
    }
    return best;
  }

  /// The card shows the recommended option by default.
  DateTime get _sleepByTime => _sleepOptions[_recommendedIndex];

  String _fmt(DateTime dt) => DateFormat.jm().format(dt);

  // ─────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final tasks = await RoutineStorageService.loadTasks();
    final buffer = await RoutineStorageService.loadBuffer();
    setState(() {
      _tasks = tasks;
      _bufferMinutes = buffer;
      _tasksTotalMinutes = _tasks.fold(0, (sum, t) => sum + t.totalMinutes);
      _loaded = true;
    });
  }

  void _onTasksChanged(int newTotal) {
    setState(() => _tasksTotalMinutes = newTotal);
    RoutineStorageService.saveTasks(_tasks);
  }

  void _onBufferChanged(int v) {
    setState(() => _bufferMinutes = v);
    RoutineStorageService.saveBuffer(v);
  }

  Future<void> _openAddTask() async {
    final task = await showAddTaskSheet(context);
    if (task != null) {
      setState(() {
        _tasks.add(task);
        _tasksTotalMinutes = _tasks.fold(0, (sum, t) => sum + t.totalMinutes);
      });
      RoutineStorageService.saveTasks(_tasks);
    }
  }

  void _showSleepOptions() {
    final options = _sleepOptions;
    final recommended = _recommendedIndex;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF111111),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Sleep Cycle Options',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              'Based on 90-min cycles · Wake up at ${_fmt(_wakeUpTime)}',
              style: const TextStyle(color: Colors.white38, fontSize: 13),
            ),
            const SizedBox(height: 20),
            ...List.generate(options.length, (i) {
              final cycles = _cycleOptions[i];
              final sleepMinutes = cycles * 90;
              final sleepHours = sleepMinutes ~/ 60;
              final sleepMins = sleepMinutes % 60;
              final sleepLabel = sleepMins == 0
                  ? '${sleepHours}h sleep'
                  : '${sleepHours}h ${sleepMins}m sleep';
              final isRecommended = i == recommended;

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isRecommended
                        ? Colors.lightGreenAccent.withOpacity(0.4)
                        : Colors.white12,
                    width: 1.2,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _fmt(options[i]),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '$cycles cycles · $sleepLabel',
                            style: const TextStyle(color: Colors.white38, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    if (isRecommended) const RecommendedChip(),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white24)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Fajr Countdown
              const FajrCountdownSection(),
              const SizedBox(height: 32),

              /// Sleep by — tapping shows all 3 cycle options
              GestureDetector(
                onTap: _showSleepOptions,
                child: RoutineCard(
                  icon: Icons.nightlight_round,
                  label: 'Sleep by',
                  value: _fmt(_sleepByTime),
                  trailing: const RecommendedChip(),
                ),
              ),
              const SizedBox(height: 12),

              /// Wake up at — calculated from Fajr - total routine time
              RoutineCard(
                icon: Icons.wb_sunny_outlined,
                label: 'Wake up at',
                value: _fmt(_wakeUpTime),
                trailing: const Icon(Icons.volume_up_outlined, color: Colors.white38, size: 20),
              ),
              const SizedBox(height: 32),

              /// Routine Plan header + Fajr/Buffer cards
              RoutinePlanSection(
                bufferMinutes: _bufferMinutes,
                totalMinutes: _totalMinutes,
                onBufferChanged: _onBufferChanged,
              ),
              const SizedBox(height: 12),

              /// Task cards
              RoutineTasksSection(
                tasks: _tasks,
                onTotalMinutesChanged: _onTasksChanged,
              ),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddTask,
        backgroundColor: Colors.lightGreenAccent.withOpacity(0.9),
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}