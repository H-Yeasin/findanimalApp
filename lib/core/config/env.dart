class Env {
  const Env._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.hesteka.com/api/v1',
  );

  static const String googleMapsApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
    defaultValue: '',
  );

  static const String stripePublishableKey = String.fromEnvironment(
    'STRIPE_PUBLISHABLE_KEY',
    defaultValue:
        'pk_live_51TMBAXLAW390akmBn8xeKSenemW4JgF2lNaka8yws7y0ymlIoIgh7wtKrpAp66nM21BczJCHVMbNyTOchDUkJQEE00f5Pacgfi',
  );

  static const String paypalClientId = String.fromEnvironment(
    'PAYPAL_CLIENT_ID',
    defaultValue: 'YOUR_PAYPAL_CLIENT_ID',
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

    if (stripePublishableKey.isEmpty) {
      errors.add('STRIPE_PUBLISHABLE_KEY is required.');
    } else if (stripePublishableKey.startsWith('pk_test_')) {
      errors.add('STRIPE_PUBLISHABLE_KEY must be a live publishable key.');
    }

    if (paypalClientId.isEmpty) {
      errors.add('PAYPAL_CLIENT_ID is required.');
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
