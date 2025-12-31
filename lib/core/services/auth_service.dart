import 'package:dio/dio.dart';
import '../constants/api.dart';

class AuthService {
  late final Dio _dio;

  AuthService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: Api.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        responseType: ResponseType.json,
      ),
    );

    // Add simple logging for debugging
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  /// Logs in against the Node backend and returns a normalized map:
  /// { 'token': String, 'user': { 'role': 'admin'|'teknisi', ... } }
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final res = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      final data = res.data;

      // Node backend wraps result under `data` and includes success/message
      final payload = data is Map && data.containsKey('data')
          ? data['data']
          : data;

      final token = payload['token'] as String?;
      final user = payload['user'] as Map<String, dynamic>?;

      if (token == null || user == null) {
        throw Exception('Response tidak sesuai dari server');
      }

      // backend returns roles as array of uppercase names, choose primary role
      String role = 'teknisi';
      final roles = user['roles'];
      if (roles is List && roles.isNotEmpty) {
        final rolesUpper = roles
            .map((r) => r.toString().toUpperCase())
            .toList();
        if (rolesUpper.contains('ADMIN')) role = 'admin';
      } else if (user.containsKey('roles') && user['roles'] is String) {
        final r = (user['roles'] as String).toLowerCase();
        if (r.contains('admin')) role = 'admin';
      }

      return {
        'token': token,
        'user': {
          'id': user['id'],
          'name': user['name'],
          'email': user['email'],
          'role': role,
        },
      };
    } on DioException catch (e) {
      // Map DioException to friendly messages
      String message = 'Terjadi kesalahan jaringan';

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        message = 'Koneksi timeout. Periksa koneksi Anda.';
      } else if (e.type == DioExceptionType.badResponse) {
        final resp = e.response?.data;
        if (resp is Map && resp['message'] != null) {
          message = resp['message'].toString();
        } else if (e.response?.statusCode != null) {
          message = 'Server error: ${e.response?.statusCode}';
        }
      } else if (e.type == DioExceptionType.cancel) {
        message = 'Permintaan dibatalkan';
      } else if (e.type == DioExceptionType.unknown) {
        message = e.message ?? 'Unknown error';
      }

      throw Exception(message);
    }
  }

  /// Logs out by calling backend endpoint and invalidate token on server
  /// Returns true if backend logout successful, false if failed
  Future<bool> logout(String token) async {
    try {
      final res = await _dio.post(
        '/auth/logout',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final data = res.data;
      
      // Backend should return success status
      if (data is Map && data.containsKey('success')) {
        return data['success'] == true;
      }
      
      // If no success field, assume success for 2xx responses
      return true;
    } on DioException catch (_) {
      // Handle logout attempt failure
      // Don't throw exception for logout failures - we want to continue with local cleanup
      return false;
    }
  }

  /// Validates the current token with the backend.
  /// Returns true if token is valid, false if invalid/expired.
  Future<bool> validateToken(String token) async {
    try {
      final res = await _dio.get(
        '/auth/me',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      final data = res.data;
      
      // If we get a valid response with user data, token is valid
      if (data is Map && data.containsKey('data')) {
        return true;
      }
      
      // Also consider success if response is 2xx
      return res.statusCode != null && res.statusCode! >= 200 && res.statusCode! < 300;
    } on DioException catch (e) {
      // Token is invalid if we get 401 or other errors
      if (e.response?.statusCode == 401) {
        return false;
      }
      // For connection errors, we can't validate - assume valid for now
      // This prevents logging out user on network issues
      return true;
    }
  }
}
