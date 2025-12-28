import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/providers/auth_provider.dart';
import 'app.dart';

/// Thin `main.dart` that bootstraps providers and runs the app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authProvider = AuthProvider();

  runApp(ChangeNotifierProvider.value(value: authProvider, child: const App()));
}
