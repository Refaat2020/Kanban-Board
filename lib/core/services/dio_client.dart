abstract class DioClient {
  Future<dynamic> getRequest(String apiUrl,
      {Map<String, dynamic>? prams, bool? responseBytes});
  Future<dynamic> postRequest(dynamic body, String apiUrl,
      {bool hasImages = false});
}
