import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audio_player_app/core/constants/app_colors.dart';
import 'package:audio_player_app/core/constants/app_constants.dart';
import 'package:audio_player_app/core/constants/app_strings.dart';
import 'package:audio_player_app/core/router/app_router.dart';
import 'package:audio_player_app/core/utils/formatters.dart';
import 'package:audio_player_app/core/utils/validators.dart';
import 'package:audio_player_app/core/widgets/custom_button.dart';
import 'package:audio_player_app/core/widgets/custom_text_field.dart';
import 'package:audio_player_app/providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  DateTime? _selectedDate;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _firstNameController.dispose(); _lastNameController.dispose();
    _emailController.dispose(); _passwordController.dispose(); _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePickerDialog(context: context, minDate: DateTime(1900), maxDate: DateTime.now());
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select your date of birth'), backgroundColor: AppColors.error)); return; }
    final authProvider = context.read<AuthProvider>();
    try {
      await authProvider.signUp(email: _emailController.text, password: _passwordController.text, firstName: _firstNameController.text, lastName: _lastNameController.text, dateOfBirth: _selectedDate!);
      if (mounted) AppRouter.go(context, AppRouter.biometricSetup);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceAll('Exception: ', '')), backgroundColor: AppColors.error));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.createAccount), leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => AppRouter.pop(context))),
      body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        CustomTextField(label: AppStrings.firstName, hint: 'Enter your first name', controller: _firstNameController, validator: (v) => Validators.name(v, 'First name'), textInputAction: TextInputAction.next),
        const SizedBox(height: 20),
        CustomTextField(label: AppStrings.lastName, hint: 'Enter your last name', controller: _lastNameController, validator: (v) => Validators.name(v, 'Last name'), textInputAction: TextInputAction.next),
        const SizedBox(height: 20),
        CustomTextField(label: AppStrings.email, hint: 'Enter your email', controller: _emailController, keyboardType: TextInputType.emailAddress, validator: Validators.email, textInputAction: TextInputAction.next),
        const SizedBox(height: 20),
        CustomTextField(label: AppStrings.dateOfBirth, hint: 'Select your date of birth', controller: TextEditingController(text: _selectedDate != null ? AppFormatters.formatDate(_selectedDate!) : ''), validator: (v) => Validators.dateOfBirth(_selectedDate, AppConstants.minAge), readOnly: true, onTap: _selectDate, suffixIcon: const Icon(Icons.calendar_today, color: AppColors.textHint)),
        const SizedBox(height: 20),
        CustomTextField(label: AppStrings.password, hint: 'Create a password', controller: _passwordController, obscureText: _obscurePassword, validator: Validators.password, suffixIcon: IconButton(icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: AppColors.textHint), onPressed: () => setState(() => _obscurePassword = !_obscurePassword)), textInputAction: TextInputAction.next),
        const SizedBox(height: 20),
        CustomTextField(label: AppStrings.confirmPassword, hint: 'Confirm your password', controller: _confirmPasswordController, obscureText: _obscureConfirmPassword, validator: (v) => Validators.confirmPassword(v, _passwordController.text), suffixIcon: IconButton(icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility, color: AppColors.textHint), onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword)), textInputAction: TextInputAction.done),
        const SizedBox(height: 32),
        Consumer<AuthProvider>(builder: (context, auth, _) => CustomButton(text: AppStrings.signUp, onPressed: _handleRegister, isLoading: auth.isLoading)),
        const SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Text(AppStrings.hasAccount, style: TextStyle(color: AppColors.textSecondary)), TextButton(onPressed: () => AppRouter.pop(context), child: const Text(AppStrings.login))]),
      ])))),
    );
  }
}
