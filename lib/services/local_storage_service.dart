import 'package:shared_preferences/shared_preferences.dart';
import 'package:audio_player_app/core/constants/app_constants.dart';

class LocalStorageService {
  static LocalStorageService? _instance;
  SharedPreferences? _prefs;

  LocalStorageService._();

  static Future<LocalStorageService> getInstance() async {
    _instance ??= LocalStorageService._();
    _instance!._prefs = await SharedPreferences.getInstance();
    return _instance!;
  }

  Future<void> setBool(String key, bool value) async => await _prefs?.setBool(key, value);
  bool getBool(String key, {bool defaultValue = false}) => _prefs?.getBool(key) ?? defaultValue;

  Future<void> setString(String key, String value) async => await _prefs?.setString(key, value);
  String? getString(String key) => _prefs?.getString(key);

  Future<void> setInt(String key, int value) async => await _prefs?.setInt(key, value);
  int getInt(String key, {int defaultValue = 0}) => _prefs?.getInt(key) ?? defaultValue;

  Future<void> setDouble(String key, double value) async => await _prefs?.setDouble(key, value);
  double getDouble(String key, {double defaultValue = 0.0}) => _prefs?.getDouble(key) ?? defaultValue;

  Future<void> remove(String key) async => await _prefs?.remove(key);
  Future<void> clear() async => await _prefs?.clear();

  bool get isFirstLaunch => getBool(AppConstants.isFirstLaunch, defaultValue: true);
  Future<void> setFirstLaunchCompleted() async => await setBool(AppConstants.isFirstLaunch, false);

  bool get isBiometricEnabled => getBool(AppConstants.biometricEnabled, defaultValue: false);
  Future<void> setBiometricEnabled(bool enabled) async => await setBool(AppConstants.biometricEnabled, enabled);

  int get monthlyGoalHours => getInt(AppConstants.monthlyGoalHours, defaultValue: AppConstants.defaultMonthlyGoalHours);
  Future<void> setMonthlyGoalHours(int hours) async => await setInt(AppConstants.monthlyGoalHours, hours);

  String? get userId => getString(AppConstants.userIdKey);
  Future<void> setUserId(String id) async => await setString(AppConstants.userIdKey, id);

  Future<void> clearUserData() async {
    await remove(AppConstants.isFirstLaunch);
    await remove(AppConstants.biometricEnabled);
    await remove(AppConstants.monthlyGoalHours);
    await remove(AppConstants.userIdKey);
  }
}
