import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audio_player_app/core/constants/app_colors.dart';
import 'package:audio_player_app/core/constants/app_strings.dart';
import 'package:audio_player_app/core/router/app_router.dart';
import 'package:audio_player_app/core/widgets/custom_button.dart';
import 'package:audio_player_app/providers/auth_provider.dart';
import 'package:audio_player_app/services/biometric_service.dart';
import 'package:audio_player_app/services/local_storage_service.dart';

class BiometricSetupScreen extends StatefulWidget {
  const BiometricSetupScreen({super.key});
  @override
  State<BiometricSetupScreen> createState() => _BiometricSetupScreenState();
}

class _BiometricSetupScreenState extends State<BiometricSetupScreen> {
  bool _isLoading = true;
  bool _isBiometricAvailable = false;
  bool _hasBiometrics = false;
  bool _isAuthenticating = false;

  @override
  void initState() { super.initState(); _checkBiometricStatus(); }

  Future<void> _checkBiometricStatus() async {
    final biometricService = BiometricService();
    final available = await biometricService.isBiometricAvailable();
    final biometrics = await biometricService.getAvailableBiometrics();
    setState(() { _isBiometricAvailable = available; _hasBiometrics = biometrics.isNotEmpty; _isLoading = false; });
  }

  Future<void> _authenticateAndContinue() async {
    if (!_isBiometricAvailable || !_hasBiometrics) { _showNoBiometricsDialog(); return; }
    setState(() => _isAuthenticating = true);
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.authenticateWithBiometrics();
    setState(() => _isAuthenticating = false);
    if (success) {
      final localStorage = await LocalStorageService.getInstance();
      await localStorage.setBiometricEnabled(true);
      await localStorage.setFirstLaunchCompleted();
      if (mounted) AppRouter.go(context, AppRouter.dashboard);
    } else {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(AppStrings.biometricFailed), backgroundColor: AppColors.error));
    }
  }

  void _showNoBiometricsDialog() {
    showDialog(context: context, builder: (context) => AlertDialog(
      backgroundColor: AppColors.surface,
      title: const Text(AppStrings.biometricNotEnrolled, style: TextStyle(color: AppColors.textPrimary)),
      content: const Text(AppStrings.biometricRedirectSettings, style: TextStyle(color: AppColors.textSecondary)),
      actions: [
        TextButton(onPressed: () => AppRouter.pop(context), child: const Text(AppStrings.cancel)),
        ElevatedButton(onPressed: () async { AppRouter.pop(context); await BiometricService().openBiometricSettings(); }, child: const Text('Open Settings')),
      ],
    ));
  }

  Future<void> _skipBiometric() async {
    final localStorage = await LocalStorageService.getInstance();
    await localStorage.setFirstLaunchCompleted();
    await localStorage.setBiometricEnabled(false);
    if (mounted) AppRouter.go(context, AppRouter.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: _isLoading
        ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)))
        : Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.fingerprint, size: 100, color: AppColors.primary),
      const SizedBox(height: 32),
      const Text(AppStrings.biometricSetup, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      const SizedBox(height: 16),
      const Text('Add an extra layer of security using your fingerprint', style: TextStyle(fontSize: 16, color: AppColors.textSecondary), textAlign: TextAlign.center),
      const SizedBox(height: 48),
      CustomButton(text: _isAuthenticating ? 'Authenticating...' : 'Authenticate with Fingerprint', onPressed: _isAuthenticating ? null : () => _authenticateAndContinue(), icon: Icons.fingerprint, isLoading: _isAuthenticating),
      const SizedBox(height: 16),
      TextButton(onPressed: _skipBiometric, child: const Text('Skip for now', style: TextStyle(color: AppColors.textHint))),
      if (!_isBiometricAvailable || !_hasBiometrics) ...[
        const SizedBox(height: 16),
        Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.warning.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.warning.withValues(alpha: 0.3))), child: Row(children: [
          const Icon(Icons.warning_amber, color: AppColors.warning, size: 20), const SizedBox(width: 8),
          Expanded(child: Text(_hasBiometrics ? 'Biometric not available on this device' : 'No fingerprints enrolled. Add one in Settings.', style: const TextStyle(fontSize: 12, color: AppColors.warning))),
        ])),
      ],
    ])),
    ));
  }
}
