import 'package:flutter/material.dart';
import 'package:wemove_intern_project_01/base_api/base_api_services.dart';
import 'package:wemove_intern_project_01/pages/forgot_password_page.dart';
import 'package:wemove_intern_project_01/pages/landing_page.dart';
import 'package:wemove_intern_project_01/services/login_services.dart';
import 'package:wemove_intern_project_01/utils/custom_button.dart';
import 'package:wemove_intern_project_01/utils/custom_text.dart';
import 'package:wemove_intern_project_01/utils/custom_textfield.dart';
import 'package:wemove_intern_project_01/utils/prompt_handler.dart';

/*
   "identifier": "invokerphil@gmail.com",
    "password": "jaeger"

    Account 2 
    parohinogsebastian@gmail.com
    pass1234
 */

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  //Creating aa Login services object
  final LoginServices loginServices = LoginServices(BaseApiServices());

  bool isLoading = false;

  final PromptHandler promptHandler = PromptHandler();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  // Login method
  void loginUser() async {
    print("Login process started..."); // for debugging purposes
    setState(() => isLoading = true);
    FocusScope.of(context).unfocus();

    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    try {
      print("Sending login request..."); // same for debugging purposes
      final response = await loginServices.postLogin(
        username: username,
        password: password,
      );

      print("Response received: $response"); // another debugging purpses

      // ignore: unnecessary_type_check
      if (response is Map<String, dynamic> &&
          response.containsKey("success") &&
          response["success"] == true) {
        print("Login successful, navigating...");
        promptHandler.showSuccess('Login Complete!');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LandingPage()),
        );
      } else {
        print("Login failed: ${response['message']}"); // debugging purposes
        promptHandler.showError(response['message'] ?? 'Login Failed');
      }
    } catch (e) {
      print("Exception caught: $e"); // for debugging
      promptHandler.showWarning('An error occurred. Please try again.');
    } finally {
      print("Resetting loading state..."); // debugging
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SingleChildScrollView(
                child: Column(
                  spacing: 3,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // WeMove Image
                    Image.asset('lib/images/wemove.png'),

                    const SizedBox(height: 10),

                    // Username Label
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [CustomText(text: "Username")],
                      ),
                    ),

                    // Username Input
                    CustomTextField(
                      hint: "Username",
                      controller: _usernameController,
                      focusNode: _usernameFocusNode,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Username cannot be empty";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 10),

                    // Password Label
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: const [CustomText(text: "Password")],
                      ),
                    ),

                    // Password Input
                    CustomTextField(
                      hint: "Password",
                      controller: _passwordController,
                      focusNode: _passwordFocusNode,
                      isPassword: true,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Password cannot be empty";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // Sign-in Button
                    CustomButton(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          loginUser();
                        }
                      },
                      text: isLoading ? "Signing In..." : "Sign In",
                    ),

                    const SizedBox(height: 10),

                    CustomText(
                      text: "Sign in using Phone Number",
                      color: Color(0xFF440099),
                    ),

                    const SizedBox(height: 70),

                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPasswordPage(),
                          ),
                        );
                      },
                      child: CustomText(
                        text: "Forgot Password?",
                        color: Color(0xFF440099),
                      ),
                    ),

                    const SizedBox(height: 5),

                    CustomText(
                      text: "Don't have an account?",
                      color: Color(0xFF440099),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
