import 'package:flutter/material.dart';
import 'package:audio_player_app/core/constants/app_colors.dart';
import 'package:audio_player_app/core/constants/app_strings.dart';

class MonthlyGoalProgress extends StatelessWidget {
  final double currentHours;
  final int goalHours;
  final VoidCallback? onEditGoal;

  const MonthlyGoalProgress({super.key, required this.currentHours, required this.goalHours, this.onEditGoal});

  @override
  Widget build(BuildContext context) {
    final progress = (currentHours / goalHours).clamp(0.0, 1.0);
    final remaining = (goalHours - currentHours).clamp(0.0, double.infinity);

    return Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(16)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text(AppStrings.monthlyGoal, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
        if (onEditGoal != null) GestureDetector(onTap: onEditGoal, child: Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Text('${goalHours}h', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 14)))),
      ]),
      const SizedBox(height: 16),
      ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: progress, minHeight: 12, backgroundColor: AppColors.progressBg, valueColor: AlwaysStoppedAnimation<Color>(progress >= 1.0 ? AppColors.success : AppColors.primary))),
      const SizedBox(height: 12),
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('${currentHours.toStringAsFixed(1)}h listened', style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
        Text(remaining > 0 ? '${remaining.toStringAsFixed(1)}h remaining' : 'Goal achieved!', style: TextStyle(color: remaining > 0 ? AppColors.textSecondary : AppColors.success, fontSize: 14, fontWeight: remaining > 0 ? FontWeight.normal : FontWeight.w600)),
      ]),
    ]));
  }
}
