import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utils/constants/colors.dart';
import '../../night_routine/models/task_model.dart';

/// Call this to open the bottom sheet. Returns the new task or null if dismissed.
Future<RoutineTask?> showAddTaskSheet(BuildContext context) {
  return showModalBottomSheet<RoutineTask>(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0xFF111111),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => const _AddTaskSheet(),
  );
}

class _AddTaskSheet extends StatefulWidget {
  const _AddTaskSheet();

  @override
  State<_AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<_AddTaskSheet> {
  final _nameController = TextEditingController();
  final _hoursController = TextEditingController(text: '00');
  final _minsController = TextEditingController(text: '00');

  bool get _isValid => _nameController.text.trim().isNotEmpty;

  void _submit() {
    if (!_isValid) return;
    final task = RoutineTask(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      icon: Icons.task_alt_outlined,
      hours: int.tryParse(_hoursController.text) ?? 0,
      mins: int.tryParse(_minsController.text) ?? 0,
    );
    Navigator.of(context).pop(task);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _hoursController.dispose();
    _minsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 24, 20, 24 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
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

          const Text('New Task',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          // Task name
          _SheetField(
            controller: _nameController,
            hint: 'Task name',
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),

          // Hours + Mins
          Row(
            children: [
              Expanded(
                child: _SheetField(
                  controller: _hoursController,
                  hint: 'Hours',
                  numeric: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SheetField(
                  controller: _minsController,
                  hint: 'Mins',
                  numeric: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Add button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isValid ? _submit : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightGreenAccent.withOpacity(0.9),
                disabledBackgroundColor: Colors.lightGreenAccent.withOpacity(0.1),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Add Task',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool numeric;
  final ValueChanged<String>? onChanged;

  const _SheetField({
    required this.controller,
    required this.hint,
    this.numeric = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.buttonPrimary.withOpacity(0.2), width: 1.2),
      ),
      child: TextField(
        controller: controller,
        keyboardType: numeric ? TextInputType.number : TextInputType.text,
        inputFormatters: numeric
            ? [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(2)]
            : null,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white38),
          border: InputBorder.none,
        ),
        onChanged: onChanged,
      ),
    );
  }
}