import 'package:wemove_intern_project_01/base_api/base_api_services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NewPasswordService {
  final BaseApiServices apiServices;

  NewPasswordService(this.apiServices);

  //Patch New Password
  Future<Map<String, dynamic>> patchNewPassword({
    required String tempId,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    final String endpoint = 'v1/customer/otp/forgot/change-pass/$tempId';

    final Map<String, String> body = {
      'newPass': newPassword,
      'confirmPass': confirmNewPassword,
    };

    try {
      final headers = await apiServices.getHeaders();

      final String fullUrl =
          '${apiServices.baseUrl}${apiServices.baseUrl.endsWith('/') ? '' : '/'}$endpoint';

      print("PATCH Request URL: $fullUrl"); //For Debugging
      print("Request Headers: $headers");
      print("Request Body: ${jsonEncode(body)}");

      //Patch
      final response = await http.patch(
        Uri.parse(fullUrl),
        headers: headers,
        body: jsonEncode(body),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode < 600) {
        return jsonDecode(response.body);
      } else {
        return {
          "success": false,
          "message":
              "Server error: ${response.statusCode} - ${response.reasonPhrase}"
        };
      }
    } catch (e) {
      print("Exception in patchNewPassword: $e");
      return {"success": false, "message": "An error occurred: $e"};
    }
  }
}
