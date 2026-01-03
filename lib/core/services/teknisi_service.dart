import 'package:dio/dio.dart';
import '../constants/api.dart';
import '../../models/teknisi_user.dart';

class TeknisiService {
  late final Dio _dio;
  final String token;

  TeknisiService(this.token) {
    _dio = Dio(
      BaseOptions(
        baseUrl: Api.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        responseType: ResponseType.json,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ),
    );

    // Add logging interceptor
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true),
    );
  }

  Future<List<TeknisiUser>> getAllTeknisi() async {
    try {
      final res = await _dio.get('/users/teknisi');

      final data = res.data;

      // Memeriksa apakah respons dari server sesuai format yang diharapkan
      if (data is Map &&
          data.containsKey('success') &&
          data['success'] == true) {
        final teknisiData = data['data'] as List<dynamic>?;
        if (teknisiData != null) {
          return teknisiData.map((json) => TeknisiUser.fromJson(json)).toList();
        } else {
          return [];
        }
      } else {
        throw Exception('Format respons tidak sesuai dari server');
      }
    } on DioException catch (e) {
      // Memetakan DioException ke pesan yang ramah pengguna
      String message = 'Terjadi kesalahan jaringan';

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        message = 'Koneksi timeout. Periksa koneksi Anda.';
      } else if (e.type == DioExceptionType.badResponse) {
        final resp = e.response?.data;
        if (resp is Map && resp['message'] != null) {
          message = resp['message'].toString();
        } else if (e.response?.statusCode == 403) {
          message =
              'Akses ditolak. Anda tidak memiliki hak akses untuk data ini.';
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

  /// Mendapatkan teknisi berdasarkan ID
  Future<TeknisiUser> getTeknisiById(String id) async {
    try {
      final res = await _dio.get('/users/$id');

      final data = res.data;

      if (data is Map &&
          data.containsKey('success') &&
          data['success'] == true) {
        final teknisiData = data['data'];
        if (teknisiData != null) {
          return TeknisiUser.fromJson(teknisiData);
        } else {
          throw Exception('Data teknisi tidak ditemukan');
        }
      } else {
        throw Exception('Format respons tidak sesuai dari server');
      }
    } on DioException catch (e) {
      String message = 'Terjadi kesalahan jaringan';

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        message = 'Koneksi timeout. Periksa koneksi Anda.';
      } else if (e.type == DioExceptionType.badResponse) {
        final resp = e.response?.data;
        if (resp is Map && resp['message'] != null) {
          message = resp['message'].toString();
        } else if (e.response?.statusCode == 403) {
          message = 'Akses ditolak. Anda tidak memiliki hak akses untuk data ini.';
        } else if (e.response?.statusCode == 404) {
          message = 'Teknisi tidak ditemukan';
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

  /// Membuat teknisi baru
  Future<TeknisiUser> createTeknisi(Map<String, dynamic> teknisiData) async {
    try {
      // Endpoint yang benar sesuai backend: POST /api/users
      final res = await _dio.post('/users', data: teknisiData);

      final data = res.data;

      if (data is Map &&
          data.containsKey('success') &&
          data['success'] == true) {
        final createdTeknisi = data['data'];
        if (createdTeknisi != null) {
          return TeknisiUser.fromJson(createdTeknisi);
        } else {
          throw Exception('Gagal membuat teknisi: data tidak valid');
        }
      } else {
        throw Exception('Format respons tidak sesuai dari server');
      }
    } on DioException catch (e) {
      String message = 'Terjadi kesalahan jaringan';

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        message = 'Koneksi timeout. Periksa koneksi Anda.';
      } else if (e.type == DioExceptionType.badResponse) {
        final resp = e.response?.data;
        if (resp is Map && resp['message'] != null) {
          message = resp['message'].toString();
        } else if (e.response?.statusCode == 403) {
          message = 'Akses ditolak. Anda tidak memiliki hak untuk menambah teknisi.';
        } else if (e.response?.statusCode == 400) {
          message = 'Data tidak valid. Periksa kembali input Anda.';
        } else if (e.response?.statusCode == 409) {
          message = 'Email sudah terdaftar. Gunakan email lain.';
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

  /// Memperbarui data teknisi
  Future<TeknisiUser> updateTeknisi(String id, Map<String, dynamic> teknisiData) async {
    try {
      final res = await _dio.put('/users/$id', data: teknisiData);

      final data = res.data;

      if (data is Map &&
          data.containsKey('success') &&
          data['success'] == true) {
        final updatedTeknisi = data['data'];
        if (updatedTeknisi != null) {
          return TeknisiUser.fromJson(updatedTeknisi);
        } else {
          throw Exception('Gagal memperbarui teknisi: data tidak valid');
        }
      } else {
        throw Exception('Format respons tidak sesuai dari server');
      }
    } on DioException catch (e) {
      String message = 'Terjadi kesalahan jaringan';

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        message = 'Koneksi timeout. Periksa koneksi Anda.';
      } else if (e.type == DioExceptionType.badResponse) {
        final resp = e.response?.data;
        if (resp is Map && resp['message'] != null) {
          message = resp['message'].toString();
        } else if (e.response?.statusCode == 403) {
          message = 'Akses ditolak. Anda tidak memiliki hak untuk mengubah data teknisi.';
        } else if (e.response?.statusCode == 404) {
          message = 'Teknisi tidak ditemukan';
        } else if (e.response?.statusCode == 400) {
          message = 'Data tidak valid. Periksa kembali input Anda.';
        } else if (e.response?.statusCode == 409) {
          message = 'Email sudah digunakan oleh teknisi lain.';
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

  /// Menghapus teknisi
  Future<bool> deleteTeknisi(String id) async {
    try {
      // Coba endpoint /users/:id (tanpa /teknisi)
      final res = await _dio.delete('/users/$id');

      final data = res.data;

      if (data is Map &&
          data.containsKey('success') &&
          data['success'] == true) {
        return true;
      } else {
        throw Exception('Format respons tidak sesuai dari server');
      }
    } on DioException catch (e) {
      String message = 'Terjadi kesalahan jaringan';

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        message = 'Koneksi timeout. Periksa koneksi Anda.';
      } else if (e.type == DioExceptionType.badResponse) {
        final resp = e.response?.data;
        if (resp is Map && resp['message'] != null) {
          message = resp['message'].toString();
        } else if (e.response?.statusCode == 403) {
          message = 'Akses ditolak. Anda tidak memiliki hak untuk menghapus teknisi.';
        } else if (e.response?.statusCode == 404) {
          message = 'Teknisi tidak ditemukan';
        } else if (e.response?.statusCode == 409) {
          message = 'Tidak dapat menghapus teknisi yang masih memiliki tugas aktif.';
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
}
