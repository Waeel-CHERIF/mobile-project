import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audio_player_app/core/constants/app_colors.dart';
import 'package:audio_player_app/core/constants/app_strings.dart';
import 'package:audio_player_app/core/router/app_router.dart';
import 'package:audio_player_app/core/utils/validators.dart';
import 'package:audio_player_app/core/widgets/custom_button.dart';
import 'package:audio_player_app/core/widgets/custom_text_field.dart';
import 'package:audio_player_app/providers/auth_provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() { _emailController.dispose(); super.dispose(); }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    final authProvider = context.read<AuthProvider>();
    try {
      await authProvider.resetPassword(_emailController.text);
      setState(() => _emailSent = true);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceAll('Exception: ', '')), backgroundColor: AppColors.error));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.resetPassword), leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => AppRouter.pop(context))),
      body: SafeArea(child: Padding(padding: const EdgeInsets.all(24), child: _emailSent ? _buildSuccessView() : _buildFormView())),
    );
  }

  Widget _buildFormView() {
    return Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const SizedBox(height: 40),
      const Icon(Icons.lock_reset, size: 80, color: AppColors.primary),
      const SizedBox(height: 24),
      const Text(AppStrings.resetPassword, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary), textAlign: TextAlign.center),
      const SizedBox(height: 8),
      const Text('Enter your email and we\'ll send you a link to reset your password.', style: TextStyle(fontSize: 14, color: AppColors.textSecondary), textAlign: TextAlign.center),
      const SizedBox(height: 32),
      CustomTextField(label: AppStrings.email, hint: 'Enter your email', controller: _emailController, keyboardType: TextInputType.emailAddress, validator: Validators.email, textInputAction: TextInputAction.done),
      const SizedBox(height: 32),
      Consumer<AuthProvider>(builder: (context, auth, _) => CustomButton(text: 'Send Reset Link', onPressed: _handleResetPassword, isLoading: auth.isLoading)),
    ]));
  }

  Widget _buildSuccessView() {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.check_circle, size: 80, color: AppColors.success),
      const SizedBox(height: 24),
      const Text('Email Sent!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      const SizedBox(height: 8),
      Text('We\'ve sent a password reset link to\n${_emailController.text}', style: const TextStyle(fontSize: 14, color: AppColors.textSecondary), textAlign: TextAlign.center),
      const SizedBox(height: 32),
      CustomButton(text: 'Back to Login', onPressed: () => AppRouter.go(context, AppRouter.login)),
    ]);
  }
}
