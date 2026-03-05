import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';

class RecommendedChip extends StatelessWidget {
  const RecommendedChip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.greenAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        'Recommended',
        style: TextStyle(
          color: Color(0xFF9ACD32),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}