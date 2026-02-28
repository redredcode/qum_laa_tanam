import 'package:flutter/material.dart';

class RoutineScreen extends StatefulWidget {
  const RoutineScreen({super.key});

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen> {
  // TimeOfDay _fajrTimeStartsAt = const TimeOfDay(hour: 4, minute: 53);
  //
  // void _showTimePicker() {
  //   showTimePicker(
  //     context: context,
  //     initialTime: TimeOfDay.now(),
  //   ).then((value) {
  //     setState(() {
  //       _fajrTimeStartsAt = value!;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('Qum laa tanam')
          ],
        ),
      ),
    );
  }
}
