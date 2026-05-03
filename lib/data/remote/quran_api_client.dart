import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:audio_player_app/core/constants/app_constants.dart';
import 'package:audio_player_app/data/models/category.dart';

class QuranApiClient {
  final http.Client _client;
  final String baseUrl;

  QuranApiClient({http.Client? client})
      : _client = client ?? http.Client(), baseUrl = AppConstants.baseUrl;

  Map<String, String> get _headers => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

  Future<List<Category>> fetchCategories() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/api/surahs'),
        headers: _headers,
      ).timeout(const Duration(seconds: AppConstants.apiTimeoutSeconds));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((item) => Category.fromApi(item as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  Future<Category> fetchCategoryDetails(String categoryId) async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/api/surahs/$categoryId'),
        headers: _headers,
      ).timeout(const Duration(seconds: AppConstants.apiTimeoutSeconds));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return Category.fromApi(data);
      } else {
        throw Exception('Failed to load category: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching category details: $e');
    }
  }

  Future<List<Category>> fetchAllWithTracks() async {
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/api/surahs'),
        headers: _headers,
      ).timeout(const Duration(seconds: AppConstants.apiTimeoutSeconds));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data
            .map((item) => Category.fromApi(item as Map<String, dynamic>))
            .where((category) => category.tracks.isNotEmpty)
            .toList();
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching data: $e');
    }
  }

  void dispose() => _client.close();
}
