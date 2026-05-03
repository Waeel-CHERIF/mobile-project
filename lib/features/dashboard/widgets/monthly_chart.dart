import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:audio_player_app/core/constants/app_colors.dart';

class MonthlyChart extends StatelessWidget {
  final Map<String, double> dailyData;

  const MonthlyChart({super.key, required this.dailyData});

  @override
  Widget build(BuildContext context) {
    final entries = dailyData.entries.toList();
    final maxHours = entries.map((e) => e.value).fold<double>(1.0, (max, val) => val > max ? val : max);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Last 7 Days', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
      const SizedBox(height: 16),
      SizedBox(height: 200, child: BarChart(BarChartData(
        alignment: BarChartAlignment.spaceAround, maxY: maxHours * 1.2,
        barTouchData: BarTouchData(enabled: true, touchTooltipData: BarTouchTooltipData(
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            final day = entries[group.x.toInt()].key.split('-').last;
            return BarTooltipItem('Day $day\n${rod.toY.toStringAsFixed(1)}h', const TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
          },
          getTooltipColor: (_) => AppColors.surface,
          tooltipPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), tooltipMargin: 8,
        )),
        titlesData: FlTitlesData(show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30, getTitlesWidget: (value, meta) {
            final index = value.toInt();
            if (index < 0 || index >= entries.length) return const Text('');
            final day = entries[index].key.split('-').last;
            return Padding(padding: const EdgeInsets.only(top: 8), child: Text('Day $day', style: const TextStyle(color: AppColors.textHint, fontSize: 10)));
          })),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40, getTitlesWidget: (value, meta) => Text('${value.toInt()}h', style: const TextStyle(color: AppColors.textHint, fontSize: 10)))),
        ),
        gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: maxHours / 4, getDrawingHorizontalLine: (value) => FlLine(color: AppColors.progressBg.withValues(alpha: 0.3), strokeWidth: 1)),
        borderData: FlBorderData(show: false),
        barGroups: entries.asMap().entries.map((entry) => BarChartGroupData(x: entry.key, barRods: [
          BarChartRodData(toY: entry.value.value, color: AppColors.primary, width: 16, borderRadius: const BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)), backDrawRodData: BackgroundBarChartRodData(show: true, toY: maxHours * 1.2, color: AppColors.progressBg.withValues(alpha: 0.2))),
        ])).toList(),
      ))),
    ]);
  }
}
