import 'package:flutter/material.dart';
import 'package:wemove_intern_project_01/base_api/base_api_services.dart';
import 'package:wemove_intern_project_01/pages/enter_otp_page.dart';
import 'package:wemove_intern_project_01/services/forgot_password_services.dart';
import 'package:wemove_intern_project_01/utils/custom_button.dart';
import 'package:wemove_intern_project_01/utils/custom_text.dart';
import 'package:wemove_intern_project_01/utils/custom_textfield.dart';
import 'package:wemove_intern_project_01/utils/prompt_handler.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final ForgotPasswordServices forgotPassword =
      ForgotPasswordServices(BaseApiServices());
  final PromptHandler promptHandler = PromptHandler();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  // ForgotPassword
  void _forgotPassword() async {
    print("Sending OTP to email...");
    setState(() => isLoading = true);
    FocusScope.of(context).unfocus();

    String username = _emailController.text.trim();

    try {
      print("Sending request...");
      final response = await forgotPassword.postForgotPassword(
        username: username,
      );

      print("Response received: $response");

      if (response is Map<String, dynamic> &&
          response.containsKey("success") &&
          response["success"] == true &&
          response.containsKey("tempId")) {
        print("OTP sent, navigating...");
        promptHandler.showSuccess('OTP Sent!');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => EnterOtpPage(
              emailController: _emailController,
              tempId: response["tempId"],
            ),
          ),
        );
      } else {
        print("Sending OTP failed: ${response['message']}");
        promptHandler.showError(response['message'] ?? 'Sending OTP failed');
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
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CustomText(
                  text: "Forgot Password",
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: CustomText(
                  text: "Enter your email address to reset your password",
                  fontSize: 13,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CustomTextField(
                  hint: "email",
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Email cannot be empty";
                    }
                    if (!RegExp(
                            r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                        .hasMatch(value)) {
                      return "Enter a valid email address";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: CustomButton(
                    onTap: () {
                      // //For testing
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => EnterOtpPage(),
                      //   ),
                      // );
                      if (_formKey.currentState!.validate()) {
                        _forgotPassword();
                      }
                    },
                    text: "Continue"),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('lib/images/Vector.png'),
                    CustomText(
                      text: "You will receive an SMS or call for verification",
                      fontSize: 11,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
