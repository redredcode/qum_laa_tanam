import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../night_routine/services/location_service.dart';

import '../../../utils/constants/colors.dart';
import '../../night_routine/services/prayer_time_service.dart';

class RoutinePlanSection extends StatelessWidget {
  final int bufferMinutes;
  final int totalMinutes;
  final ValueChanged<int> onBufferChanged;

  const RoutinePlanSection({
    super.key,
    required this.bufferMinutes,
    required this.totalMinutes,
    required this.onBufferChanged,
  });

  @override
  Widget build(BuildContext context) {
    final fajrTime = DateFormat.jm().format(PrayerTimeService.instance.fajr);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Routine Plan',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            _TotalChip(label: _formatTotal(totalMinutes)),
          ],
        ),
        const SizedBox(height: 16),

        // Fajr Prayer card
        _PlanCard(
          icon: Icons.mosque_outlined,
          title: 'Fajr Prayer',
          subtitle: LocationService.instance.cityName,
          trailing: Row(
            children: [
              Text(
                fajrTime,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.access_time, color: Colors.white54, size: 22),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Buffer Time card
        _PlanCard(
          icon: Icons.bed_outlined,
          title: 'Buffer Time',
          subtitle: 'Waking up & Wudu',
          trailing: _BufferInput(
            value: bufferMinutes,
            onChanged: onBufferChanged,
          ),
        ),
      ],
    );
  }

  String _formatTotal(int minutes) {
    if (minutes < 60) return 'Total: ${minutes}m';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m == 0 ? 'Total: ${h}h' : 'Total: ${h}h ${m}m';
  }
}

// ─────────────────────────────────────────────
// PLAN CARD
// ─────────────────────────────────────────────

class _PlanCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;

  const _PlanCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.buttonPrimary.withOpacity(0.2),
          width: 1.2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.07),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white54, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(subtitle,
                      style: const TextStyle(color: Colors.white38, fontSize: 13)),
                ],
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// BUFFER INPUT
// ─────────────────────────────────────────────

class _BufferInput extends StatefulWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _BufferInput({required this.value, required this.onChanged});

  @override
  State<_BufferInput> createState() => _BufferInputState();
}

class _BufferInputState extends State<_BufferInput> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 56,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.07),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.buttonPrimary.withOpacity(0.2),
              width: 1.2,
            ),
          ),
          child: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),
            ],
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            decoration: const InputDecoration.collapsed(hintText: ''),
            onChanged: (v) {
              final parsed = int.tryParse(v);
              if (parsed != null && parsed > 0) widget.onChanged(parsed);
            },
          ),
        ),
        const SizedBox(width: 8),
        const Text('min', style: TextStyle(color: Colors.white54, fontSize: 15)),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// TOTAL CHIP
// ─────────────────────────────────────────────

class _TotalChip extends StatelessWidget {
  final String label;
  const _TotalChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blueGrey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.buttonPrimary.withOpacity(0.2),
          width: 1.2,
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}