import 'package:flutter/material.dart';
import 'package:qum_la_tanam/ui/screens/home_screen.dart';

class QumLaTanam extends StatelessWidget{
  const QumLaTanam({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}