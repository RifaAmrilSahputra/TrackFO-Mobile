import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Theme mode enum for easy selection
enum ThemeModeOption {
  light('Terang'),
  dark('Gelap'),
  system('Sistem');

  final String label;
  const ThemeModeOption(this.label);
}

/// ThemeProvider manages the app's theme state and persistence.
/// - Loads saved theme preference from shared_preferences on init
/// - Provides theme switching between light, dark, and system
/// - Persists preference when changed
class ThemeProvider extends ChangeNotifier {
  ThemeModeOption _themeMode = ThemeModeOption.dark;
  bool _isInitialized = false;

  ThemeModeOption get themeMode => _themeMode;
  bool get isInitialized => _isInitialized;

  /// Get the Flutter ThemeMode from our custom enum
  ThemeMode get flutterThemeMode {
    switch (_themeMode) {
      case ThemeModeOption.light:
        return ThemeMode.light;
      case ThemeModeOption.dark:
        return ThemeMode.dark;
      case ThemeModeOption.system:
        return ThemeMode.system;
    }
  }

  /// Initialize provider by loading saved theme preference
  Future<void> initializeTheme() async {
    if (_isInitialized) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedMode = prefs.getString('theme_mode');
      
      if (savedMode != null) {
        _themeMode = ThemeModeOption.values.firstWhere(
          (mode) => mode.name == savedMode,
          orElse: () => ThemeModeOption.dark,
        );
      }
      // Default to dark if no saved preference
    } catch (e) {
      _themeMode = ThemeModeOption.dark;
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  /// Set theme mode and persist to storage
  Future<void> setThemeMode(ThemeModeOption mode) async {
    if (_themeMode == mode) return; // No change
    
    _themeMode = mode;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('theme_mode', mode.name);
    } catch (e) {
      // Silently fail - theme change already applied in memory
    }
  }

  /// Toggle between light and dark mode
  void toggleTheme() {
    if (_themeMode == ThemeModeOption.dark) {
      setThemeMode(ThemeModeOption.light);
    } else {
      setThemeMode(ThemeModeOption.dark);
    }
  }
}

