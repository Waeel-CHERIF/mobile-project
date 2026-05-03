import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audio_player_app/core/constants/app_colors.dart';
import 'package:audio_player_app/core/constants/app_strings.dart';
import 'package:audio_player_app/core/router/app_router.dart';
import 'package:audio_player_app/providers/audio_provider.dart';
import 'package:audio_player_app/providers/favorites_provider.dart';
import 'package:audio_player_app/providers/auth_provider.dart';
import 'package:audio_player_app/features/player/widgets/audio_controls.dart';
import 'package:audio_player_app/features/player/widgets/progress_bar.dart';
import 'package:audio_player_app/features/player/widgets/playlist_view.dart';

class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({super.key});
  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  @override
  void initState() { super.initState(); _loadData(); }

  Future<void> _loadData() async {
    final audioProvider = context.read<AudioProvider>();
    if (audioProvider.categories.isEmpty) await audioProvider.loadCategories();
    if (!mounted) return;
    final authProvider = context.read<AuthProvider>();
    final favoritesProvider = context.read<FavoritesProvider>();
    if (authProvider.currentUser != null) {
      favoritesProvider.subscribeToFavorites(authProvider.currentUser!.uid);
      favoritesProvider.loadFavorites(authProvider.currentUser!.uid);
    }
  }

  Future<void> _handleFavorite() async {
    final audioProvider = context.read<AudioProvider>();
    final authProvider = context.read<AuthProvider>();
    final favoritesProvider = context.read<FavoritesProvider>();
    if (audioProvider.currentTrack == null || authProvider.currentUser == null) return;
    final track = audioProvider.currentTrack!;
    final userId = authProvider.currentUser!.uid;
    if (favoritesProvider.isFavorite(track.id)) { await favoritesProvider.removeFromFavorites(userId, track.id); }
    else { await favoritesProvider.addToFavorites(userId, track); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.nowPlaying), leading: IconButton(icon: const Icon(Icons.keyboard_arrow_down), onPressed: () => AppRouter.pop(context))),
      body: Consumer2<AudioProvider, FavoritesProvider>(builder: (context, audioProvider, favoritesProvider, _) {
        final track = audioProvider.currentTrack;
        return SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(children: [
          const SizedBox(height: 20),
          Container(width: 250, height: 250, decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.primary.withValues(alpha: 0.3), AppColors.primaryDark.withValues(alpha: 0.1)], begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 30, spreadRadius: 10)]), child: Center(child: Icon(Icons.music_note, size: 80, color: AppColors.primary.withValues(alpha: 0.5)))),
          const SizedBox(height: 32),
          Text(track?.title ?? 'No Track Selected', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary), textAlign: TextAlign.center),
          if (track?.categoryName != null) ...[const SizedBox(height: 8), Text(track!.categoryName!, style: const TextStyle(fontSize: 16, color: AppColors.textSecondary))],
          const SizedBox(height: 32),
          AudioProgressBar(position: audioProvider.position, duration: audioProvider.duration, onSeek: audioProvider.seekTo),
          const SizedBox(height: 24),
          AudioControls(isPlaying: audioProvider.isPlaying, loopMode: audioProvider.loopMode, onPlayPause: audioProvider.togglePlayPause, onNext: audioProvider.seekToNext, onPrevious: audioProvider.seekToPrevious, onToggleRepeat: audioProvider.toggleRepeat, onFavorite: _handleFavorite, isFavorite: track != null ? favoritesProvider.isFavorite(track.id) : false),
          const SizedBox(height: 40),
          const Align(alignment: Alignment.centerLeft, child: Text(AppStrings.playlist, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary))),
          const SizedBox(height: 16),
          PlaylistView(categories: audioProvider.categories, currentTrack: audioProvider.currentTrack, onPlayTrack: (track, list) => audioProvider.playTrack(track, playlist: list), onToggleFavorite: _handleFavorite, isFavorite: favoritesProvider.isFavorite),
          const SizedBox(height: 50),
        ]));
      }),
    );
  }
}
