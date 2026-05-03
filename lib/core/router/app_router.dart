import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:audio_player_app/features/auth/screens/login_screen.dart';
import 'package:audio_player_app/features/auth/screens/register_screen.dart';
import 'package:audio_player_app/features/auth/screens/forgot_password_screen.dart';
import 'package:audio_player_app/features/biometric/screens/biometric_setup_screen.dart';
import 'package:audio_player_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:audio_player_app/features/player/screens/now_playing_screen.dart';
import 'package:audio_player_app/features/favorites/screens/favorites_screen.dart';

class AppRouter {
  AppRouter._();

  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String biometricSetup = '/biometric-setup';
  static const String dashboard = '/dashboard';
  static const String nowPlaying = '/now-playing';
  static const String favorites = '/favorites';

  static final GoRouter router = GoRouter(
    initialLocation: login,
    routes: [
      GoRoute(path: login, builder: (context, state) => const LoginScreen()),
      GoRoute(path: register, builder: (context, state) => const RegisterScreen()),
      GoRoute(path: forgotPassword, builder: (context, state) => const ForgotPasswordScreen()),
      GoRoute(path: biometricSetup, builder: (context, state) => const BiometricSetupScreen()),
      GoRoute(path: dashboard, builder: (context, state) => const DashboardScreen()),
      GoRoute(path: nowPlaying, builder: (context, state) => const NowPlayingScreen()),
      GoRoute(path: favorites, builder: (context, state) => const FavoritesScreen()),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Route not found: ${state.uri.path}')),
    ),
  );

  static void navigateTo(BuildContext context, String route, {Object? extra}) {
    context.push(route, extra: extra);
  }

  static void go(BuildContext context, String route) {
    context.go(route);
  }

  static void pop(BuildContext context) {
    context.pop();
  }
}
