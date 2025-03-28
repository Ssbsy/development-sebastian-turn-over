import 'package:wemove_intern_project_01/base_api/base_api_services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ResendOtpService {
  final BaseApiServices apiServices;

  ResendOtpService(this.apiServices);

  //Post ResendOTP
  Future<Map<String, dynamic>> postResendOTP({
    required String tempId,
  }) async {
    const endpoint = 'v1/customer/otp/registration/resend';
    final body = {
      'tempId': tempId,
    };

    try {
      final headers = await apiServices.getHeaders();
      final response = await http.post(
        Uri.parse('${apiServices.baseUrl}$endpoint'),
        headers: headers,
        body: jsonEncode(body),
      );

      print("Raw API response: ${response.body}"); // for Debugging

      if (response.statusCode < 600) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return responseData;
      } else {
        print("Server error: ${response.statusCode} - ${response.body}");
        return {
          "success": false,
          "message": "Server error: ${response.statusCode}"
        };
      }
    } catch (e) {
      print("Exception in postLogin: $e");
      return {"success": false, "message": "An error occurred: $e"};
    }
  }
}
