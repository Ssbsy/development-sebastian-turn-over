import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:wemove_intern_project_01/base_api/base_api_services.dart';
import 'package:wemove_intern_project_01/pages/new_password_page.dart';
import 'package:wemove_intern_project_01/services/resend_otp_service.dart';
import 'package:wemove_intern_project_01/services/verify_otp_services.dart';
import 'package:wemove_intern_project_01/utils/custom_button.dart';
import 'package:wemove_intern_project_01/utils/custom_text.dart';
import 'package:wemove_intern_project_01/utils/prompt_handler.dart';

class EnterOtpPage extends StatefulWidget {
  final TextEditingController emailController;
  final String tempId;

  const EnterOtpPage({
    super.key,
    required this.emailController,
    required this.tempId,
  });

  @override
  State<EnterOtpPage> createState() => _EnterOtpPageState();
}

class _EnterOtpPageState extends State<EnterOtpPage> {
  final TextEditingController otpController = TextEditingController();
  final PromptHandler promptHandler = PromptHandler();
  final VerifyOtpServices verifyOTP = VerifyOtpServices(BaseApiServices());
  final ResendOtpService resendOTP = ResendOtpService(BaseApiServices());

  bool isLoading = false;

  //Verify OTP
  void _verifyOTP() async {
    print("Verifying OTP...");
    setState(() => isLoading = true);
    FocusScope.of(context).unfocus();

    String otp = otpController.text.trim();

    try {
      final response = await verifyOTP.postVerifyOTP(
        tempId: widget.tempId,
        otp: int.tryParse(otp),
      );

      print("Response received: $response");

      if (response is Map<String, dynamic> &&
          response.containsKey("success") &&
          response["success"] == true) {
        print("OTP verified successfully!");
        promptHandler.showSuccess('OTP Verified!');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => NewPasswordPage(
              tempId: response["tempId"],
            ),
          ),
        );

        // Navigate to the reset password page or home page
      } else {
        print("OTP verification failed: ${response['message']}");
        promptHandler
            .showError(response['message'] ?? 'OTP verification failed');
      }
    } catch (e) {
      print("Exception caught: $e");
      promptHandler.showWarning('An error occurred. Please try again.');
    } finally {
      print("Resetting loading state...");
      setState(() => isLoading = false);
    }
  }

  //Verify OTP
  void _resendOTP() async {
    print("Resending OTP...");
    setState(() => isLoading = true);
    FocusScope.of(context).unfocus();

    String otp = otpController.text.trim();

    try {
      final response = await resendOTP.postResendOTP(
        tempId: widget.tempId,
      );

      print("Response received: $response");

      if (response is Map<String, dynamic> &&
          response.containsKey("success") &&
          response["success"] == true) {
        print("OTP resent successfully!");
        promptHandler.showSuccess('OTP Resent!');

        // Navigate to the reset password page or home page
      } else {
        print("OTP Resent failed: ${response['message']}");
        promptHandler.showError(response['message'] ?? 'OTP Resent failed');
      }
    } catch (e) {
      print("Exception caught: $e");
      promptHandler.showWarning('An error occurred. Please try again.');
    } finally {
      print("Resetting loading state...");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomText(
                text: "Enter OTP",
                fontSize: 29,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomText(
                text: "Your verification code has been sent to",
                fontSize: 16,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomText(
                text: widget.emailController.text,
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Pinput(
                controller: otpController,
                length: 6,
                onCompleted: (pin) => {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 5,
                children: [
                  Image.asset('lib/images/solar_phone-outline.png'),
                  CustomText(
                    text: 'Call me instead',
                    color: Color(0xFF440099),
                    fontSize: 14,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: 'Didn’t received OTP? ',
                  ),
                  GestureDetector(
                    onTap: () => _resendOTP(),
                    child: CustomText(
                      text: 'RESEND',
                      color: Color(0xFF440099),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomButton(
                onTap: () {
                  _verifyOTP();
                },
                text: "Confirm",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
