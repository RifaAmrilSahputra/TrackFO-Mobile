import 'package:flutter/material.dart';
import '../../features/main/main_shell.dart';

class AppNavigator {
  /// Navigate to the main shell after login.
  static void navigateToHome(BuildContext context, String role) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainShell()),
    );
  }
}
