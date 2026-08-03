/// Environment Configuration Manager
enum Environment { dev, staging, prod }

class EnvConfig {
  static Environment currentEnv = Environment.dev;

  static String get googleMapsApiKey {
    switch (currentEnv) {
      case Environment.prod:
        return 'PROD_GOOGLE_MAPS_KEY';
      case Environment.staging:
        return 'STAGING_GOOGLE_MAPS_KEY';
      case Environment.dev:
      default:
        return 'DEV_GOOGLE_MAPS_KEY';
    }
  }

  static String get razorpayKeyId {
    switch (currentEnv) {
      case Environment.prod:
        return 'rzp_live_PROD_KEY';
      case Environment.staging:
      case Environment.dev:
      default:
        return 'rzp_test_MOCK_KEY';
    }
  }
}
