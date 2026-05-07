class Validators {
  const Validators._();

  static final RegExp _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? required(
    String? value, {
    String field = 'Field',
    String? requiredMessage,
  }) {
    if (value == null || value.trim().isEmpty) {
      return requiredMessage ?? '$field is required';
    }
    return null;
  }

  static String? email(
    String? value, {
    String? requiredMessage,
    String? invalidMessage,
  }) {
    if (value == null || value.trim().isEmpty) {
      return requiredMessage ?? 'Email is required';
    }

    if (!isEmail(value)) {
      return invalidMessage ?? 'Enter a valid email';
    }

    return null;
  }

  static bool isEmail(String value) {
    return _emailRegex.hasMatch(value.trim());
  }
}
