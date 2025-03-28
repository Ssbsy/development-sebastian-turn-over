class BaseApiServices {
  final String baseUrl = "https://api.wemovedelivery.com/api/";

  //Method
  Future<Map<String, String>> getHeaders({String? token}) async {
    return {
      'Content-Type': 'application/json',
      'accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}
