import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/auth_provider.dart';
import '../screens/splash_screen.dart';
import '../features/auth/login_page.dart';
import '../features/main/main_shell.dart';

/// `AuthGate` decides which top-level screen to show based on auth state.
/// - loading -> `SplashScreen`
/// - not authenticated -> `LoginPage`
/// - authenticated -> `MainShell`
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (auth.isLoading) {
      return const SplashScreen();
    }

    if (!auth.isAuthenticated) {
      return const LoginPage();
    }

    return const MainShell();
  }
}
