import 'package:flutter/material.dart';
import 'package:audio_player_app/core/constants/app_colors.dart';
import 'package:audio_player_app/core/utils/formatters.dart';

class AudioProgressBar extends StatelessWidget {
  final Duration position;
  final Duration? duration;
  final ValueChanged<Duration>? onSeek;

  const AudioProgressBar({super.key, required this.position, this.duration, this.onSeek});

  @override
  Widget build(BuildContext context) {
    final totalDuration = duration ?? Duration.zero;
    final progress = totalDuration.inMilliseconds > 0 ? position.inMilliseconds / totalDuration.inMilliseconds : 0.0;

    return Column(children: [
      GestureDetector(onHorizontalDragUpdate: (details) {
        if (onSeek != null && totalDuration.inMilliseconds > 0) {
          final box = context.findRenderObject() as RenderBox;
          final dx = details.localPosition.dx;
          final newPosition = (dx / box.size.width) * totalDuration.inMilliseconds;
          onSeek!(Duration(milliseconds: newPosition.toInt()));
        }
      }, child: Container(height: 24, padding: const EdgeInsets.symmetric(vertical: 8), child: Stack(children: [
        Container(height: 4, decoration: BoxDecoration(color: AppColors.progressBg, borderRadius: BorderRadius.circular(2))),
        FractionallySizedBox(widthFactor: progress.clamp(0.0, 1.0), child: Container(height: 4, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2)))),
      ]))),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(AppFormatters.formatDuration(position), style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        Text(AppFormatters.formatDuration(totalDuration), style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      ])),
    ]);
  }
}
