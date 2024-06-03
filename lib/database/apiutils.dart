class ApiUtils {
  static const String baseUrl = 'http://192.168.0.102:8000/';
  // static const String baseUrl = 'https://sim-pasdata.framework-tif.com/';

  static String buildUrl(String endpoint) {
    return baseUrl + endpoint;
  }
}