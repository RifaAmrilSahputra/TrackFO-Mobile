import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../core/storage/secure_storage.dart';
import '../../core/services/auth_service.dart';

/// AuthProvider manages auth token, role and a loading state.
/// - `isLoading` is true while storage is being read.
/// - `isAuthenticated` reflects presence of a token.
class AuthProvider extends ChangeNotifier {
  String? _token;
  String _role = '';
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

  bool get isAuthenticated => _token != null && _token!.isNotEmpty;

  /// Initialize provider by loading existing token/role from secure storage
  Future<void> loadFromStorage() async {
    _isLoading = true;
    notifyListeners();
    try {
      final t = await SecureStorage.getToken();
      final r = await SecureStorage.getRole();
      _token = t;
      _role = (r != null && r.isNotEmpty) ? r : ''; // Don't default to 'teknisi'
    } catch (e) {
      _token = null;
      _role = '';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Validates token with backend and refreshes auth state if needed.
  /// Called during splash screen to check if user is still logged in.
  /// Returns true if validation passed, false if token is invalid/expired.
  Future<bool> validateAndRefresh() async {
    if (_token == null || _token!.isEmpty) {
      return false;
    }

    try {
      final isValid = await _authService.validateToken(_token!);
      
      if (!isValid) {
        // Token is invalid, clear auth state
        await logout();
        return false;
      }
      
      return true;
    } catch (e) {
      // On error, assume token is valid to avoid logging out on network issues
      return true;
    }
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
          // Backend logout successful
        } else {
          // Backend logout failed, but continuing with local cleanup
        }
      }
    } catch (e) {
      // Handle unexpected errors during backend logout
    } finally {
      // Step 2: Always cleanup local data regardless of backend success
      _token = null;
      _role = ''; // Clear role completely after logout
      await SecureStorage.logout();

      _isLoggingOut = false;
      // Logout completed - auth state cleared, role reset to empty
      notifyListeners();
      
      // Step 3: Force navigation to login - small delay to ensure state propagation
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }
}
