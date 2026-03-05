import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qum_la_tanam/features/ui/widgets/voice_countdown_badge.dart';

import '../../night_routine/services/prayer_time_service.dart';

class FajrCountdownSection extends StatefulWidget {
  const FajrCountdownSection({super.key});

  @override
  State<FajrCountdownSection> createState() => _FajrCountdownSectionState();
}

class _FajrCountdownSectionState extends State<FajrCountdownSection> {
  late Timer _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateRemaining());
  }

  void _updateRemaining() {
    final diff = PrayerTimeService.instance.fajr.difference(DateTime.now());
    if (mounted) setState(() => _remaining = diff.isNegative ? Duration.zero : diff);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final h = _twoDigits(_remaining.inHours);
    final m = _twoDigits(_remaining.inMinutes.remainder(60));
    final s = _twoDigits(_remaining.inSeconds.remainder(60));

    return Column(
      children: [
        const Text(
          'TIME UNTIL FAJR',
          style: TextStyle(
            color: Colors.white54,
            fontSize: 13,
            letterSpacing: 2.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$h:$m:$s',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 64,
            fontWeight: FontWeight.w300,
            letterSpacing: 2,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 16),
        const VoiceCountdownBadge(),
      ],
    );
  }
}