import 'package:flutter/material.dart';
import 'package:wemove_intern_project_01/base_api/base_api_services.dart';
import 'package:wemove_intern_project_01/pages/login_page.dart';
import 'package:wemove_intern_project_01/services/new_password_service.dart';
import 'package:wemove_intern_project_01/utils/custom_button.dart';
import 'package:wemove_intern_project_01/utils/custom_text.dart';
import 'package:wemove_intern_project_01/utils/custom_textfield.dart';
import 'package:wemove_intern_project_01/utils/prompt_handler.dart';

class NewPasswordPage extends StatefulWidget {
  final String tempId;
  const NewPasswordPage({super.key, required this.tempId});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();
  bool isLoading = false;
  final PromptHandler promptHandler = PromptHandler();

  final NewPasswordService newPassword = NewPasswordService(BaseApiServices());

  //
  void _changePassword(String tempId) async {
    setState(() => isLoading = true);
    FocusScope.of(context).unfocus();

    String newPassword = _newPasswordController.text.trim();
    String confirmNewPassword = _confirmNewPasswordController.text.trim();

    if (newPassword.isEmpty || confirmNewPassword.isEmpty) {
      promptHandler.showError("Please fill in all fields.");
      setState(() => isLoading = false);
      return;
    }

    if (newPassword != confirmNewPassword) {
      promptHandler.showError("Passwords do not match.");
      setState(() => isLoading = false);
      return;
    }

    try {
      final newPasswordService = NewPasswordService(BaseApiServices());
      final response = await newPasswordService.patchNewPassword(
        tempId: tempId,
        newPassword: newPassword,
        confirmNewPassword: confirmNewPassword,
      );

      if (response["success"] == true) {
        promptHandler.showSuccess('Password changed successfully!');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        promptHandler
            .showError(response['message'] ?? 'Password change failed.');
      }
    } catch (e) {
      promptHandler.showWarning('An error occurred. Please try again.');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmNewPasswordController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CustomText(
                  text: 'Create your new password',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: CustomText(
                  text: 'New Password',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: CustomTextField(
                  hint: '',
                  controller: _newPasswordController,
                  isPassword: true,
                  // validator: (value) {
                  //   if(value.trim() == null || value.trim().isEmpty){
                  //     return "Password Cannot be Empty";
                  //   }
                  //   return null;
                  // }
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: CustomText(
                  text: 'Re-enter New Password',
                  fontSize: 14,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: CustomTextField(
                  hint: '',
                  controller: _confirmNewPasswordController,
                  isPassword: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CustomButton(
                  onTap: () {
                    _changePassword(widget.tempId);
                    print("Change password button tapped");
                  },
                  text: 'Confrim',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
