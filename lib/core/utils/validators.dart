class Validators {
  const Validators._();

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

    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(value.trim())) {
      return invalidMessage ?? 'Enter a valid email';
    }

    return null;
  }
}
