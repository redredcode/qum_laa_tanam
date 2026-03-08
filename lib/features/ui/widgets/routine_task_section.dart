import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/constants/colors.dart';
import '../../night_routine/models/task_model.dart';
import '../../night_routine/services/routine_storage_service.dart';

class RoutineTasksSection extends StatefulWidget {
  final List<RoutineTask> tasks;
  final ValueChanged<int> onTotalMinutesChanged;

  const RoutineTasksSection({
    super.key,
    required this.tasks,
    required this.onTotalMinutesChanged,
  });

  @override
  State<RoutineTasksSection> createState() => _RoutineTasksSectionState();
}

class _RoutineTasksSectionState extends State<RoutineTasksSection> {
  void _notify() {
    final total = widget.tasks.fold(0, (sum, t) => sum + t.totalMinutes);
    widget.onTotalMinutesChanged(total);
  }

  void _deleteTask(String id) {
    setState(() => widget.tasks.removeWhere((t) => t.id == id));
    _notify();
  }

  void _toggleTask(RoutineTask task, bool val) {
    setState(() => task.isEnabled = val);
    _notify();
  }

  void _updateTime(RoutineTask task, {int? hours, int? mins}) {
    setState(() {
      if (hours != null) task.hours = hours;
      if (mins != null) task.mins = mins;
    });
    _notify();
  }

  void _restoreDefaults() {
    setState(() {
      // Merge: keep existing tasks, append any default not already present
      for (final def in defaultRoutineTasks) {
        if (!widget.tasks.any((t) => t.id == def.id)) {
          widget.tasks.add(RoutineTask(
            id: def.id,
            name: def.name,
            icon: def.icon,
            hours: def.hours,
            mins: def.mins,
          ));
        }
      }
    });
    _notify();
    RoutineStorageService.saveTasks(widget.tasks);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...widget.tasks.map((task) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _TaskCard(
            key: ValueKey(task.id),
            task: task,
            onToggle: (v) => _toggleTask(task, v),
            onDelete: () => _deleteTask(task.id),
            onTimeChanged: ({int? hours, int? mins}) =>
                _updateTime(task, hours: hours, mins: mins),
          ),
        )),
        const SizedBox(height: 4),
        _RestoreDefaultsButton(onRestore: _restoreDefaults),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// TASK CARD
// ─────────────────────────────────────────────

class _TaskCard extends StatelessWidget {
  final RoutineTask task;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDelete;
  final void Function({int? hours, int? mins}) onTimeChanged;

  const _TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.onTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.buttonPrimary.withOpacity(0.2),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _CircleIcon(icon: task.icon),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  task.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Switch(
                value: task.isEnabled,
                onChanged: onToggle,
                activeColor: Colors.black,
                activeTrackColor: Colors.lightGreenAccent.withOpacity(0.9),
                inactiveThumbColor: Colors.white38,
                inactiveTrackColor: Colors.white12,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _TimeField(
                label: 'Hours',
                initialValue: task.hours,
                max: 23,
                onChanged: (v) => onTimeChanged(hours: v),
              ),
              const SizedBox(width: 10),
              _TimeField(
                label: 'Mins',
                initialValue: task.mins,
                max: 59,
                onChanged: (v) => onTimeChanged(mins: v),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onDelete,
                child: const Icon(Icons.delete_outline, color: Colors.white24, size: 22),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// CIRCLE ICON
// ─────────────────────────────────────────────

class _CircleIcon extends StatelessWidget {
  final IconData icon;
  const _CircleIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.07),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.lightGreenAccent.withOpacity(0.9), size: 20),
    );
  }
}

// ─────────────────────────────────────────────
// TIME INPUT FIELD
// ─────────────────────────────────────────────

class _TimeField extends StatefulWidget {
  final String label;
  final int initialValue; // initialValue only — no syncing after init
  final int max;
  final ValueChanged<int> onChanged;

  const _TimeField({
    required this.label,
    required this.initialValue,
    required this.max,
    required this.onChanged,
  });

  @override
  State<_TimeField> createState() => _TimeFieldState();
}

class _TimeFieldState extends State<_TimeField> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialValue.toString().padLeft(2, '0'),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label,
            style: const TextStyle(color: Colors.white38, fontSize: 12)),
        const SizedBox(height: 4),
        Container(
          width: 72,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.buttonPrimary.withOpacity(0.2),
              width: 1.2,
            ),
          ),
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(2),
            ],
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
            decoration: const InputDecoration.collapsed(hintText: '00'),
            onChanged: (v) {
              final parsed = int.tryParse(v) ?? 0;
              widget.onChanged(parsed.clamp(0, widget.max));
            },
            onTap: () => _controller.selection = TextSelection(
              baseOffset: 0,
              extentOffset: _controller.text.length,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// RESTORE DEFAULTS BUTTON
// ─────────────────────────────────────────────

class _RestoreDefaultsButton extends StatelessWidget {
  final VoidCallback onRestore;
  const _RestoreDefaultsButton({required this.onRestore});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onRestore,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.buttonPrimary.withOpacity(0.2),
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restore, color: Colors.lightGreenAccent.withOpacity(0.9), size: 18),
            const SizedBox(width: 8),
            Text(
              'Restore Defaults',
              style: TextStyle(
                color: Colors.lightGreenAccent.withOpacity(0.9),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}