class ApiUtils {
  static const String baseUrl = 'http://10.0.2.2:8000/api/';

  static String buildUrl(String endpoint) {
    return baseUrl + endpoint;
  }
}