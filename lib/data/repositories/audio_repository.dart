import 'package:audio_player_app/data/models/category.dart';
import 'package:audio_player_app/data/models/track.dart';
import 'package:audio_player_app/data/remote/quran_api_client.dart';

class AudioRepository {
  final QuranApiClient _apiClient;

  AudioRepository({required QuranApiClient apiClient}) : _apiClient = apiClient;

  Future<List<Category>> fetchAllCategories() async => await _apiClient.fetchAllWithTracks();
  Future<List<Category>> fetchCategories() async => await _apiClient.fetchCategories();
  Future<Category> fetchCategoryTracks(String categoryId) async => await _apiClient.fetchCategoryDetails(categoryId);

  List<Track> getAllTracks(List<Category> categories) {
    return categories.expand((category) => category.tracks).toList();
  }

  List<Track> getTracksByCategory(List<Category> categories, String categoryId) {
    return categories.firstWhere((c) => c.id == categoryId).tracks;
  }
}
