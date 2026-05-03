import 'package:flutter/foundation.dart';
import 'package:audio_player_app/data/models/app_user.dart';
import 'package:audio_player_app/data/repositories/auth_repository.dart';
import 'package:audio_player_app/services/biometric_service.dart';
import 'package:audio_player_app/services/local_storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  final BiometricService _biometricService;
  final LocalStorageService _localStorage;

  AppUser? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;

  AppUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;

  AuthProvider({required AuthRepository authRepository, required BiometricService biometricService, required LocalStorageService localStorage})
      : _authRepository = authRepository, _biometricService = biometricService, _localStorage = localStorage;

  Future<void> signUp({required String email, required String password, required String firstName, required String lastName, required DateTime dateOfBirth}) async {
    _setLoading(true); _clearError();
    try {
      _currentUser = await _authRepository.signUp(email: email, password: password, firstName: firstName, lastName: lastName, dateOfBirth: dateOfBirth);
      _isAuthenticated = true;
      await _localStorage.setUserId(_currentUser!.uid);
      notifyListeners();
    } catch (e) { _setError(e.toString()); rethrow; }
    finally { _setLoading(false); }
  }

  Future<void> signIn({required String email, required String password}) async {
    _setLoading(true); _clearError();
    try {
      _currentUser = await _authRepository.signIn(email: email, password: password);
      _isAuthenticated = true;
      await _localStorage.setUserId(_currentUser!.uid);
      notifyListeners();
    } catch (e) { _setError(e.toString()); rethrow; }
    finally { _setLoading(false); }
  }

  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _authRepository.signOut();
      await _localStorage.clearUserData();
      _currentUser = null; _isAuthenticated = false;
      notifyListeners();
    } catch (e) { _setError(e.toString()); }
    finally { _setLoading(false); }
  }

  Future<void> resetPassword(String email) async {
    _setLoading(true); _clearError();
    try { await _authRepository.resetPassword(email); }
    catch (e) { _setError(e.toString()); rethrow; }
    finally { _setLoading(false); }
  }

  Future<bool> authenticateWithBiometrics() async => await _biometricService.authenticate();
  Future<bool> isBiometricAvailable() async => await _biometricService.isBiometricAvailable();

  void _setLoading(bool loading) { _isLoading = loading; notifyListeners(); }
  void _setError(String error) { _errorMessage = error; notifyListeners(); }
  void _clearError() { _errorMessage = null; notifyListeners(); }
}
