import 'package:flutter/material.dart';
import 'package:audio_player_app/core/constants/app_colors.dart';
import 'package:audio_player_app/core/utils/formatters.dart';

class ListeningStatsCard extends StatelessWidget {
  final Duration totalListeningTime;
  final double currentMonthHours;

  const ListeningStatsCard({super.key, required this.totalListeningTime, required this.currentMonthHours});

  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(
      gradient: LinearGradient(colors: [AppColors.primary, AppColors.primaryDark], begin: Alignment.topLeft, end: Alignment.bottomRight),
      borderRadius: BorderRadius.circular(16),
    ), child: Column(children: [
      Row(children: [
        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.headphones, color: Colors.white, size: 24)),
        const SizedBox(width: 12),
        const Text('Total Listening Time', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
      ]),
      const SizedBox(height: 16),
      Text(AppFormatters.formatListeningTime(totalListeningTime), style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
      const SizedBox(height: 8),
      Text('${currentMonthHours.toStringAsFixed(1)} hours this month', style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.8))),
    ]));
  }
}
