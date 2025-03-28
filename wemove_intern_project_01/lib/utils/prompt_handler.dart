import 'package:get/get.dart';
import 'package:flutter/material.dart';

class PromptHandler {
  // Success
  void showSuccess(String message) {
    Get.snackbar(
      'Success!',
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // Error
  void showError(String message) {
    Get.snackbar(
      'Error!',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  // Warning
  void showWarning(String message) {
    Get.snackbar(
      'Warning!',
      message,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }

  //Custom Dialog
  void showDialog(String message) {
    Get.snackbar(
      '',
      message,
      backgroundColor: Colors.black,
      colorText: Colors.white,
    );
  }
}
