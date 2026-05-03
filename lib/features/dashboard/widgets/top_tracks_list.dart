import 'package:flutter/material.dart';
import 'package:audio_player_app/core/constants/app_colors.dart';

class TopTracksList extends StatelessWidget {
  final List<MapEntry<String, String>> topTracks;
  final Function(String trackId)? onTap;

  const TopTracksList({super.key, required this.topTracks, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Most Listened Tracks', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
      const SizedBox(height: 12),
      if (topTracks.isEmpty) const Center(child: Padding(padding: EdgeInsets.all(24), child: Text('No tracks listened yet', style: TextStyle(color: AppColors.textHint))))
      else ListView.separated(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        itemCount: topTracks.length > 5 ? 5 : topTracks.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final track = topTracks[index];
          return GestureDetector(onTap: onTap != null ? () => onTap!(track.key) : null, child: Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.cardBg, borderRadius: BorderRadius.circular(12)), child: Row(children: [
            Container(width: 32, height: 32, decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)), child: Center(child: Text('${index + 1}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14)))),
            const SizedBox(width: 12),
            Expanded(child: Text(track.value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis)),
            const Icon(Icons.play_circle_outline, color: AppColors.textHint, size: 24),
          ])));
        },
      ),
    ]);
  }
}
