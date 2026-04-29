class Env {
  const Env._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.hesteka.com/api/v1',
    // defaultValue: 'http://localhost:5000/api/v1',
  );

  static const String googleMapsApiKey = String.fromEnvironment(
    'GOOGLE_MAPS_API_KEY',
    defaultValue: 'AIzaSyAcK838ls0dZgDjKmjbBQMBJfd_8B7hwlQ',
  );

  static const String stripePublishableKey = String.fromEnvironment(
    'STRIPE_PUBLISHABLE_KEY',
    defaultValue:
        'pk_test_51ShzG65v6xjmDo05UhGMIsToDUCvN1B0ZrJlTjiYYNuwQ2xrc4ZnHAhPP3mbMQkGHo5gJqlrlQuobgQpSvLSbZOj00U9EPKZMw',
  );
}




