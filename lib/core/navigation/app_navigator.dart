import 'package:flutter/material.dart';

class AppNavigator {
  /// Navigate to the main shell after login using named routes
  static void navigateToHome(BuildContext context, String role) {
    // Use named route to avoid conflicts
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/home', 
      (route) => false, // Remove all previous routes
    );
  }
}
