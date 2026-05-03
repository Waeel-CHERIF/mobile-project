import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_player_app/core/constants/app_colors.dart';

class AudioControls extends StatelessWidget {
  final bool isPlaying;
  final LoopMode loopMode;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onToggleRepeat;
  final VoidCallback? onFavorite;
  final bool isFavorite;

  const AudioControls({super.key, required this.isPlaying, required this.loopMode, required this.onPlayPause, required this.onNext, required this.onPrevious, required this.onToggleRepeat, this.onFavorite, this.isFavorite = false});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        IconButton(icon: Icon(_getRepeatIcon(), color: loopMode != LoopMode.off ? AppColors.primary : AppColors.textSecondary, size: 28), onPressed: onToggleRepeat),
        IconButton(icon: const Icon(Icons.skip_previous_rounded, color: AppColors.textPrimary, size: 40), onPressed: onPrevious),
        Container(decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 20, spreadRadius: 5)]), child: IconButton(icon: Icon(isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, color: AppColors.textPrimary, size: 48), onPressed: onPlayPause, iconSize: 48)),
        IconButton(icon: const Icon(Icons.skip_next_rounded, color: AppColors.textPrimary, size: 40), onPressed: onNext),
        IconButton(icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? AppColors.error : AppColors.textSecondary, size: 28), onPressed: onFavorite),
      ]),
      const SizedBox(height: 8),
      if (loopMode != LoopMode.off) Text(_getRepeatText(), style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w500)),
    ]);
  }

  IconData _getRepeatIcon() { switch (loopMode) { case LoopMode.one: return Icons.repeat_one; case LoopMode.all: return Icons.repeat; case LoopMode.off: return Icons.repeat; } }
  String _getRepeatText() { switch (loopMode) { case LoopMode.one: return 'Repeat One'; case LoopMode.all: return 'Repeat All'; case LoopMode.off: return ''; } }
}
