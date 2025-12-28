import 'package:flutter/material.dart';
import '../../core/storage/secure_storage.dart';
import '../../core/services/auth_service.dart';

/// AuthProvider manages auth token, role and a loading state.
/// - `isLoading` is true while storage is being read.
/// - `isAuthenticated` reflects presence of a token.
class AuthProvider extends ChangeNotifier {
  String? _token;
  String _role = 'teknisi';
  bool _isLoading = true;
  bool _isLoggingOut = false;

  late final AuthService _authService;

  AuthProvider() {
    // Start loading from storage when provider is created.
    _authService = AuthService();
    loadFromStorage();
  }

  String? get token => _token;
  String get role => _role;
  bool get isLoading => _isLoading;
  bool get isLoggingOut => _isLoggingOut;

  bool get isAuthenticated => _token != null;

  /// Initialize provider by loading existing token/role from secure storage
  Future<void> loadFromStorage() async {
    _isLoading = true;
    notifyListeners();
    try {
      final t = await SecureStorage.getToken();
      final r = await SecureStorage.getRole();
      _token = t;
      _role = r ?? 'teknisi';
    } catch (_) {
      _token = null;
      _role = 'teknisi';
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

  /// Hybrid logout approach - try backend logout, then always cleanup local data
  Future<void> logout() async {
    _isLoggingOut = true;
    notifyListeners();

    try {
      // Step 1: Try backend logout if we have a token
      if (_token != null) {
        final backendSuccess = await _authService.logout(_token!);
        if (backendSuccess) {
          print('Backend logout successful');
        } else {
          print('Backend logout failed, but continuing with local cleanup');
        }
      }
    } catch (e) {
      // Log any unexpected errors during backend logout
      print('Error during backend logout: $e');
    } finally {
      // Step 2: Always cleanup local data regardless of backend success
      _token = null;
      _role = 'teknisi';
      await SecureStorage.logout();
      
      _isLoggingOut = false;
      notifyListeners();
    }
  }
}
