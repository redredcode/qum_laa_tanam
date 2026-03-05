import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';

class VoiceCountdownBadge extends StatefulWidget {
  const VoiceCountdownBadge({super.key});

  @override
  State<VoiceCountdownBadge> createState() => _VoiceCountdownBadgeState();
}

class _VoiceCountdownBadgeState extends State<VoiceCountdownBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _opacityAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.greenAccent.withOpacity(0.04),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FadeTransition(
            opacity: _opacityAnimation,
            child: const Icon(Icons.mic, color: AppColors.greenAccent, size: 16),
          ),
          const SizedBox(width: 8),
          const Text(
            'Voice Countdown Active',
            style: TextStyle(
              color: Color(0xFF9ACD32),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}