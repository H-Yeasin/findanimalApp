class Env {
  const Env._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.hesteka.com/api/v1',
    // defaultValue: '"http://10.0.2.2:5000/api/v1',
  );

  static const String googleMapsApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
    defaultValue: '',
  );

  static List<String> releaseConfigErrors() {
    final errors = <String>[];

    final apiUri = Uri.tryParse(apiBaseUrl);
    if (apiUri == null || !apiUri.hasAbsolutePath || apiUri.scheme != 'https') {
      errors.add('API_BASE_URL must be an absolute HTTPS URL.');
    }

    if (googleMapsApiKey.isEmpty) {
      errors.add('GOOGLE_MAPS_API_KEY is required.');
    }

    return errors;
  }

  static void validateReleaseConfig() {
    final errors = releaseConfigErrors();
    if (errors.isNotEmpty) {
      throw StateError(
        'Release configuration is incomplete:\n${errors.join('\n')}',
      );
    }
  }
}
