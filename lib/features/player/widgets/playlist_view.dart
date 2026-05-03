import 'package:flutter/material.dart';
import 'package:audio_player_app/core/constants/app_colors.dart';
import 'package:audio_player_app/data/models/category.dart';
import 'package:audio_player_app/data/models/track.dart';

class PlaylistView extends StatelessWidget {
  final List<Category> categories;
  final Track? currentTrack;
  final Function(Track, List<Track>) onPlayTrack;
  final VoidCallback onToggleFavorite;
  final bool Function(String trackId) isFavorite;

  const PlaylistView({super.key, required this.categories, this.currentTrack, required this.onPlayTrack, required this.onToggleFavorite, required this.isFavorite});

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) return const Center(child: Text('No tracks available', style: TextStyle(color: AppColors.textHint)));
    return ListView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: categories.length, itemBuilder: (context, index) => _buildCategorySection(categories[index]));
  }

  Widget _buildCategorySection(Category category) {
    if (category.tracks.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text(category.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary))),
      ListView.separated(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: category.tracks.length, separatorBuilder: (_, __) => const Divider(color: AppColors.progressBg, height: 1),
        itemBuilder: (context, index) {
          final track = category.tracks[index];
          final isCurrentTrack = currentTrack?.id == track.id;
          return ListTile(leading: Container(width: 40, height: 40, decoration: BoxDecoration(color: isCurrentTrack ? AppColors.primary : AppColors.progressBg, borderRadius: BorderRadius.circular(8)), child: Center(child: isCurrentTrack ? const Icon(Icons.equalizer, color: Colors.white, size: 20) : Text('${index + 1}', style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500)))),
            title: Text(track.title, style: TextStyle(color: isCurrentTrack ? AppColors.primary : AppColors.textPrimary, fontWeight: isCurrentTrack ? FontWeight.w600 : FontWeight.normal), maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text(category.name, style: const TextStyle(color: AppColors.textHint, fontSize: 12)),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(icon: Icon(isFavorite(track.id) ? Icons.favorite : Icons.favorite_border, color: isFavorite(track.id) ? AppColors.error : AppColors.textHint, size: 20), onPressed: onToggleFavorite, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
              const SizedBox(width: 8), const Icon(Icons.play_arrow, color: AppColors.textHint),
            ]),
            onTap: () => onPlayTrack(track, category.tracks),
          );
        },
      ),
    ]);
  }
}
