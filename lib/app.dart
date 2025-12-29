import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'widgets/auth_gate.dart';

/// Root application widget. Keeps `main.dart` thin and hosts the
/// top-level `MaterialApp` and theme.
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Debug: Orange background for App level
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: Container(
        color: Colors.orange,
        child: const AuthGate(),
      ),
    );
  }
}
