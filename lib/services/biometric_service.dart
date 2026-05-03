import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:audio_player_app/core/constants/app_strings.dart';

class BiometricService {
  final LocalAuthentication _localAuth;

  BiometricService({LocalAuthentication? localAuth})
      : _localAuth = localAuth ?? LocalAuthentication();

  Future<bool> isBiometricAvailable() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (e) {
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  Future<bool> authenticate({String? title, String? reason}) async {
    try {
      final isAvailable = await isBiometricAvailable();
      if (!isAvailable) return false;

      return await _localAuth.authenticate(
        localizedReason: reason ?? AppStrings.biometricReason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
          sensitiveTransaction: true,
        ),
      );
    } catch (e) {
      debugPrint('Biometric authentication error: $e');
      return false;
    }
  }

  Future<void> openBiometricSettings() async {
    await _localAuth.stopAuthentication();
  }

  Future<bool> isDeviceSecure() async {
    try {
      return await _localAuth.isDeviceSupported();
    } catch (e) {
      return false;
    }
  }
}
