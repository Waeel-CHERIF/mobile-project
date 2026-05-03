import 'package:audio_player_app/data/models/listening_stats.dart';
import 'package:audio_player_app/services/firestore_service.dart';
import 'package:audio_player_app/services/local_storage_service.dart';

class UserRepository {
  final FirestoreService _firestoreService;
  final LocalStorageService _localStorage;

  UserRepository({required FirestoreService firestoreService, required LocalStorageService localStorage})
      : _firestoreService = firestoreService, _localStorage = localStorage;

  Future<ListeningStats> getListeningStats(String userId) async {
    final data = await _firestoreService.getListeningStats(userId);
    return _parseStatsData(userId, data);
  }

  Stream<ListeningStats> getListeningStatsStream(String userId) {
    return _firestoreService.getListeningStatsStream(userId).map((data) => _parseStatsData(userId, data));
  }

  Future<void> recordListening(String userId, String trackId, Duration duration) async {
    await _firestoreService.recordListening(userId, trackId, duration);
  }

  int getMonthlyGoalHours() => _localStorage.monthlyGoalHours;
  Future<void> setMonthlyGoalHours(int hours) async => await _localStorage.setMonthlyGoalHours(hours);

  ListeningStats _parseStatsData(String userId, Map<String, dynamic> data) {
    final totalSeconds = (data['totalSeconds'] as num?)?.toInt() ?? 0;
    final trackCounts = <String, int>{};
    final monthlyHours = <String, double>{};

    if (data['trackCounts'] != null) {
      (data['trackCounts'] as Map<String, dynamic>).forEach((key, value) {
        trackCounts[key] = (value as num).toInt();
      });
    }

    data.forEach((key, value) {
      if (key != 'totalSeconds' && key != 'trackCounts' && key != 'createdAt' && key != 'updatedAt') {
        monthlyHours[key] = (value as num).toDouble();
      }
    });

    return ListeningStats(
      userId: userId,
      totalListeningTime: Duration(seconds: totalSeconds),
      monthlyListeningHours: monthlyHours,
      trackPlayCounts: trackCounts,
    );
  }
}
