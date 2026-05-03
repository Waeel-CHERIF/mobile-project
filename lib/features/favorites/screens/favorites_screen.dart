import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audio_player_app/core/constants/app_colors.dart';
import 'package:audio_player_app/core/constants/app_strings.dart';
import 'package:audio_player_app/core/router/app_router.dart';
import 'package:audio_player_app/providers/favorites_provider.dart';
import 'package:audio_player_app/providers/auth_provider.dart';
import 'package:audio_player_app/providers/audio_provider.dart';
import 'package:audio_player_app/services/biometric_service.dart';
import 'package:audio_player_app/features/favorites/widgets/favorite_track_tile.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() { super.initState(); _loadFavorites(); }

  Future<void> _loadFavorites() async {
    final authProvider = context.read<AuthProvider>();
    final favoritesProvider = context.read<FavoritesProvider>();
    if (authProvider.currentUser != null) {
      favoritesProvider.subscribeToFavorites(authProvider.currentUser!.uid);
      favoritesProvider.loadFavorites(authProvider.currentUser!.uid);
    }
  }

  Future<void> _removeFavorite(String trackId) async {
    final biometricService = BiometricService();
    final authenticated = await biometricService.authenticate(reason: AppStrings.deleteFavoriteMessage);
    if (!authenticated) return;
    if (!mounted) return;
    final authProvider = context.read<AuthProvider>();
    final favoritesProvider = context.read<FavoritesProvider>();
    if (authProvider.currentUser != null) {
      await favoritesProvider.removeFromFavorites(authProvider.currentUser!.uid, trackId);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Removed from favorites'), backgroundColor: AppColors.success));
    }
  }

  void _confirmDelete(String trackId, String trackTitle) {
    showDialog(context: context, builder: (context) => AlertDialog(
      backgroundColor: AppColors.surface,
      title: const Text(AppStrings.confirmDelete, style: TextStyle(color: AppColors.textPrimary)),
      content: Text('Remove "$trackTitle" from favorites?', style: const TextStyle(color: AppColors.textSecondary)),
      actions: [
        TextButton(onPressed: () => AppRouter.pop(context), child: const Text(AppStrings.cancel)),
        ElevatedButton(onPressed: () { AppRouter.pop(context); _removeFavorite(trackId); }, style: ElevatedButton.styleFrom(backgroundColor: AppColors.error), child: const Text(AppStrings.delete)),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.favorites), leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => AppRouter.pop(context))),
      body: Consumer<FavoritesProvider>(builder: (context, favProvider, _) {
        if (favProvider.isLoading) return const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)));
        if (favProvider.favorites.isEmpty) {
          return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.favorite_border, size: 80, color: AppColors.textHint), const SizedBox(height: 16),
            const Text(AppStrings.noFavorites, style: TextStyle(fontSize: 18, color: AppColors.textHint)),
            const SizedBox(height: 24),
            ElevatedButton.icon(onPressed: () { AppRouter.pop(context); AppRouter.navigateTo(context, AppRouter.nowPlaying); }, icon: const Icon(Icons.music_note), label: const Text('Browse Tracks'), style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12))),
          ]));
        }
        return ListView.separated(padding: const EdgeInsets.all(16), itemCount: favProvider.favorites.length, separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final track = favProvider.favorites[index];
            return FavoriteTrackTile(track: track, onPlay: () { context.read<AudioProvider>().playTrack(track); AppRouter.navigateTo(context, AppRouter.nowPlaying); }, onRemove: () => _confirmDelete(track.id, track.title));
          },
        );
      }),
    );
  }
}
