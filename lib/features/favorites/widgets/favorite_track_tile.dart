import 'package:flutter/material.dart';
import 'package:audio_player_app/core/constants/app_colors.dart';
import 'package:audio_player_app/data/models/track.dart';
import 'package:audio_player_app/core/utils/formatters.dart';

class FavoriteTrackTile extends StatelessWidget {
  final Track track;
  final VoidCallback onPlay;
  final VoidCallback onRemove;

  const FavoriteTrackTile({super.key, required this.track, required this.onPlay, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(12)), child: Row(children: [
      GestureDetector(onTap: onPlay, child: Container(width: 50, height: 50, decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.primary.withValues(alpha: 0.5), AppColors.primaryDark.withValues(alpha: 0.3)]), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.play_arrow, color: Colors.white, size: 30))),
      const SizedBox(width: 12),
      Expanded(child: GestureDetector(onTap: onPlay, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(track.title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
        if (track.categoryName != null) ...[const SizedBox(height: 4), Text(track.categoryName!, style: const TextStyle(color: AppColors.textHint, fontSize: 12))],
      ]))),
      Text(track.duration != null ? AppFormatters.formatDuration(track.duration!) : '--:--', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
      const SizedBox(width: 8),
      GestureDetector(onTap: onRemove, child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.delete_outline, color: AppColors.error, size: 20))),
    ]));
  }
}
