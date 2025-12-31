import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/auth_provider.dart';
import '../screens/splash_screen.dart';
import '../features/auth/login_page.dart';
import '../features/main/main_shell.dart';

/// `AuthGate` decides which top-level screen to show based on auth state.
/// - loading (initial) -> `SplashScreen` (will validate token with backend)
/// - not authenticated -> `LoginPage`
/// - authenticated -> `MainShell`
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    // Show splash screen during initial loading or logging out
    // Note: Validation is triggered by SplashScreen itself
    if (auth.isLoading || auth.isLoggingOut) {
      return const SplashScreen();
    }

    // Show login page if not authenticated
    if (!auth.isAuthenticated || auth.role.isEmpty) {
      return const LoginPage();
    }

    // Show main shell for authenticated users
    return const MainShell();
  }
}
