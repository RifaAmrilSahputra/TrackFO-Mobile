import 'package:flutter/material.dart';
import '../../core/storage/secure_storage.dart';

/// AuthProvider manages auth token, role and a loading state.
/// - `isLoading` is true while storage is being read.
/// - `isAuthenticated` reflects presence of a token.
class AuthProvider extends ChangeNotifier {
  String? _token;
  String _role = 'user';
  bool _isLoading = true;

  AuthProvider() {
    // Start loading from storage when provider is created.
    loadFromStorage();
  }

  String? get token => _token;
  String get role => _role;
  bool get isLoading => _isLoading;

  bool get isAuthenticated => _token != null;

  /// Initialize provider by loading existing token/role from secure storage
  Future<void> loadFromStorage() async {
    _isLoading = true;
    notifyListeners();
    try {
      final t = await SecureStorage.getToken();
      final r = await SecureStorage.getRole();
      _token = t;
      _role = r ?? 'user';
    } catch (_) {
      _token = null;
      _role = 'user';
    }
    _isLoading = false;
    notifyListeners();
  }

  /// Persist token and role and update state
  Future<void> setAuth({required String token, required String role}) async {
    _token = token;
    _role = role;
    await SecureStorage.saveAuth(token: token, role: role);
    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    _role = 'user';
    await SecureStorage.logout();
    notifyListeners();
  }
}
