/// Input validation utilities for SmartPark AI
class Validators {
  Validators._();

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Phone is optional
    }
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 10) {
      return 'Enter a valid phone number (min 10 digits)';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    if (!RegExp(r'[!@#\$&*~%^()_\-+=\[\]{}|;:,.<>?]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  /// Validates confirm password matches original password
  static String? Function(String?) validateConfirmPassword(
      String originalPassword) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return 'Please confirm your password';
      }
      if (value != originalPassword) {
        return 'Passwords do not match';
      }
      return null;
    };
  }

  static String? validateVehicleNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vehicle number is required';
    }
    return null;
  }
}
