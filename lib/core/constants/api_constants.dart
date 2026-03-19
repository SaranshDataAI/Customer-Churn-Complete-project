import 'environment.dart';

class ApiConstants {
  static String get baseUrl => Environment.apiBaseUrl;
  static const String predictEndpoint = '/predict';
  static Duration get timeout => Environment.apiTimeout;
}
