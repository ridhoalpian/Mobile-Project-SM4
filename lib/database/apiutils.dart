class ApiUtils {
  static const String baseUrl = 'http://192.168.0.101:8000/';

  static String buildUrl(String endpoint) {
    return baseUrl + endpoint;
  }
}