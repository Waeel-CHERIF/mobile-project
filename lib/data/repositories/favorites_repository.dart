import 'package:audio_player_app/data/models/track.dart';
import 'package:audio_player_app/services/firestore_service.dart';

class FavoritesRepository {
  final FirestoreService _firestoreService;

  FavoritesRepository({required FirestoreService firestoreService}) : _firestoreService = firestoreService;

  Future<void> addToFavorites(String userId, Track track) async {
    await _firestoreService.addFavorite(userId, track.toMap());
  }

  Future<void> removeFromFavorites(String userId, String trackId) async {
    await _firestoreService.removeFavorite(userId, trackId);
  }

  Future<List<Track>> getFavorites(String userId) async {
    final data = await _firestoreService.getFavorites(userId);
    return data.map((d) => Track.fromMap(d)).toList();
  }

  Future<bool> isFavorite(String userId, String trackId) async {
    return await _firestoreService.isFavorite(userId, trackId);
  }

  Stream<List<Track>> getFavoritesStream(String userId) {
    return _firestoreService.getFavoritesStream(userId).map(
        (data) => data.map((d) => Track.fromMap(d)).toList());
  }
}
