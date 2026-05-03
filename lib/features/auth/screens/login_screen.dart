import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audio_player_app/core/constants/app_colors.dart';
import 'package:audio_player_app/core/constants/app_strings.dart';
import 'package:audio_player_app/core/router/app_router.dart';
import 'package:audio_player_app/core/utils/validators.dart';
import 'package:audio_player_app/core/widgets/custom_button.dart';
import 'package:audio_player_app/core/widgets/custom_text_field.dart';
import 'package:audio_player_app/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() { _emailController.dispose(); _passwordController.dispose(); super.dispose(); }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    final authProvider = context.read<AuthProvider>();
    try {
      await authProvider.signIn(email: _emailController.text, password: _passwordController.text);
      if (mounted) AppRouter.go(context, AppRouter.biometricSetup);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceAll('Exception: ', '')), backgroundColor: AppColors.error));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            const SizedBox(height: 60),
            const Text(AppStrings.welcome, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textPrimary), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            const Text('Sign in to continue', style: TextStyle(fontSize: 16, color: AppColors.textSecondary), textAlign: TextAlign.center),
            const SizedBox(height: 48),
            CustomTextField(label: AppStrings.email, hint: 'Enter your email', controller: _emailController, keyboardType: TextInputType.emailAddress, validator: Validators.email, prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textHint), textInputAction: TextInputAction.next),
            const SizedBox(height: 20),
            CustomTextField(label: AppStrings.password, hint: 'Enter your password', controller: _passwordController, obscureText: _obscurePassword, validator: Validators.password, prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textHint), suffixIcon: IconButton(icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: AppColors.textHint), onPressed: () => setState(() => _obscurePassword = !_obscurePassword)), textInputAction: TextInputAction.done),
            const SizedBox(height: 12),
            Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () => AppRouter.navigateTo(context, AppRouter.forgotPassword), child: const Text(AppStrings.forgotPassword))),
            const SizedBox(height: 24),
            Consumer<AuthProvider>(builder: (context, auth, _) => CustomButton(text: AppStrings.login, onPressed: _handleLogin, isLoading: auth.isLoading)),
            const SizedBox(height: 24),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Text(AppStrings.noAccount, style: TextStyle(color: AppColors.textSecondary)), TextButton(onPressed: () => AppRouter.navigateTo(context, AppRouter.register), child: const Text(AppStrings.signUp))]),
          ])),
        ),
      ),
    );
  }
}
