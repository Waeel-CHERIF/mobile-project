import 'package:flutter/foundation.dart';
import 'package:audio_player_app/data/models/track.dart';
import 'package:audio_player_app/data/repositories/favorites_repository.dart';

class FavoritesProvider extends ChangeNotifier {
  final FavoritesRepository _favoritesRepository;
  List<Track> _favorites = [];
  bool _isLoading = false;
  String? _errorMessage;
  Set<String> _favoriteIds = {};

  List<Track> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Set<String> get favoriteIds => _favoriteIds;

  FavoritesProvider({required FavoritesRepository favoritesRepository}) : _favoritesRepository = favoritesRepository;

  Future<void> loadFavorites(String userId) async {
    _setLoading(true); _clearError();
    try {
      _favorites = await _favoritesRepository.getFavorites(userId);
      _favoriteIds = _favorites.map((t) => t.id).toSet();
      notifyListeners();
    } catch (e) { _setError(e.toString()); }
    finally { _setLoading(false); }
  }

  void subscribeToFavorites(String userId) {
    _favoritesRepository.getFavoritesStream(userId).listen((favorites) {
      _favorites = favorites;
      _favoriteIds = favorites.map((t) => t.id).toSet();
      notifyListeners();
    });
  }

  Future<void> addToFavorites(String userId, Track track) async {
    try {
      await _favoritesRepository.addToFavorites(userId, track);
      if (!_favoriteIds.contains(track.id)) { _favoriteIds.add(track.id); _favorites.insert(0, track); notifyListeners(); }
    } catch (e) { _setError(e.toString()); rethrow; }
  }

  Future<void> removeFromFavorites(String userId, String trackId) async {
    try {
      await _favoritesRepository.removeFromFavorites(userId, trackId);
      _favoriteIds.remove(trackId);
      _favorites.removeWhere((t) => t.id == trackId);
      notifyListeners();
    } catch (e) { _setError(e.toString()); rethrow; }
  }

  bool isFavorite(String trackId) => _favoriteIds.contains(trackId);

  void _setLoading(bool loading) { _isLoading = loading; notifyListeners(); }
  void _setError(String error) { _errorMessage = error; notifyListeners(); }
  void _clearError() { _errorMessage = null; notifyListeners(); }
}
