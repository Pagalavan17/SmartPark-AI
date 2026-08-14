/// Environment Configuration Manager
enum Environment { dev, staging, prod }

class EnvConfig {
  static Environment currentEnv = Environment.dev;

  static String get googleMapsApiKey {
    const fromEnv = String.fromEnvironment('MAPS_API_KEY');
    if (fromEnv.isNotEmpty) return fromEnv;
    return 'DEFAULT_MAPS_API_KEY';
  }

  static String get razorpayKeyId {
    switch (currentEnv) {
      case Environment.prod:
        return 'rzp_live_PROD_KEY';
      case Environment.staging:
      case Environment.dev:
        return 'rzp_test_MOCK_KEY';
    }
  }
}
