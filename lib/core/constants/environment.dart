class Environment {
  static const bool isProduction = bool.fromEnvironment('dart.vm.product');

  static String get apiBaseUrl {
    if (isProduction) {
      return 'https://chrun-api.onrender.com'; // ✅ FIXED
    } else {
      if (const bool.fromEnvironment('dart.library.html')) {
        return 'http://localhost:8000';
      } else {
        return 'http://10.0.2.2:8000';
      }
    }
  }

  static const Duration apiTimeout = Duration(seconds: 30);
}
