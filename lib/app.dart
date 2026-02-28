import 'package:flutter/material.dart';

import 'features/ui/screens/routine_screen.dart';

class QumLaTanam extends StatelessWidget{
  const QumLaTanam({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: RoutineScreen(),
    );
  }
}