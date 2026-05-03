class AppConstants {
  AppConstants._();

  static const String appName = 'Audio Player';
  static const int minAge = 13;

  static const String usersCollection = 'users';
  static const String favoritesCollection = 'favorites';
  static const String listeningStatsCollection = 'listening_stats';

  static const String isFirstLaunch = 'is_first_launch';
  static const String biometricEnabled = 'biometric_enabled';
  static const String monthlyGoalHours = 'monthly_goal_hours';
  static const String userIdKey = 'user_id';

  static const String baseUrl = 'https://quran.yousefheiba.com';
  static const int apiTimeoutSeconds = 30;

  static const int defaultMonthlyGoalHours = 20;

  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration snackBarDuration = Duration(seconds: 3);
}
