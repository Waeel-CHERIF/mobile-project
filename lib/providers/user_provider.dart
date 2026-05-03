import 'package:flutter/foundation.dart';
import 'package:audio_player_app/data/models/listening_stats.dart';
import 'package:audio_player_app/data/repositories/user_repository.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository _userRepository;
  ListeningStats? _listeningStats;
  bool _isLoading = false;
  String? _errorMessage;
  int _monthlyGoalHours;

  ListeningStats? get listeningStats => _listeningStats;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get monthlyGoalHours => _monthlyGoalHours;

  double get monthlyProgressPercent {
    if (_listeningStats == null) return 0.0;
    return (_listeningStats!.currentMonthHours / _monthlyGoalHours).clamp(0.0, 1.0);
  }

  double get currentMonthHours => _listeningStats?.currentMonthHours ?? 0.0;

  UserProvider({required UserRepository userRepository, int? monthlyGoalHours})
      : _userRepository = userRepository, _monthlyGoalHours = monthlyGoalHours ?? 20;

  Future<void> loadListeningStats(String userId) async {
    _setLoading(true); _clearError();
    try {
      _monthlyGoalHours = _userRepository.getMonthlyGoalHours();
      _listeningStats = await _userRepository.getListeningStats(userId);
      notifyListeners();
    } catch (e) { _setError(e.toString()); }
    finally { _setLoading(false); }
  }

  void subscribeToStats(String userId) {
    _userRepository.getListeningStatsStream(userId).listen((stats) { _listeningStats = stats; notifyListeners(); });
  }

  Future<void> setMonthlyGoal(int hours) async {
    if (hours < 1) return;
    _monthlyGoalHours = hours;
    await _userRepository.setMonthlyGoalHours(hours);
    notifyListeners();
  }

  Future<void> recordListening(String userId, String trackId, Duration duration) async {
    try { await _userRepository.recordListening(userId, trackId, duration); }
    catch (e) { _setError(e.toString()); }
  }

  void _setLoading(bool loading) { _isLoading = loading; notifyListeners(); }
  void _setError(String error) { _errorMessage = error; notifyListeners(); }
  void _clearError() { _errorMessage = null; notifyListeners(); }
}
