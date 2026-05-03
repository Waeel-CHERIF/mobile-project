class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? name(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    if (value.length < 2) {
      return '$fieldName must be at least 2 characters';
    }
    return null;
  }

  static String? dateOfBirth(DateTime? value, int minAge) {
    if (value == null) {
      return 'Date of birth is required';
    }
    final now = DateTime.now();
    final age = now.year - value.year -
        ((now.month < value.month || (now.month == value.month && now.day < value.day)) ? 1 : 0);
    if (age < minAge) {
      return 'You must be at least $minAge years old';
    }
    if (value.isAfter(now)) {
      return 'Date of birth cannot be in the future';
    }
    return null;
  }
}
