import 'package:flutter/material.dart';
import '../../core/services/teknisi_service.dart';
import '../../models/teknisi_user.dart';

class TeknisiProvider extends ChangeNotifier {
  final TeknisiService _teknisiService;
  List<TeknisiUser> _teknisiList = [];
  bool _isLoading = false;
  String? _error;
  bool _isCreating = false;
  bool _isUpdating = false;
  bool _isDeleting = false;

  TeknisiProvider(this._teknisiService);

  List<TeknisiUser> get teknisiList => _teknisiList;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;
  bool get hasData => _teknisiList.isNotEmpty;
  bool get isCreating => _isCreating;
  bool get isUpdating => _isUpdating;
  bool get isDeleting => _isDeleting;
  bool get isAnyOperationRunning => _isCreating || _isUpdating || _isDeleting;

  /// Mengambil semua data teknisi dari server
  Future<void> fetchTeknisiData() async {
    if (_isLoading) return; // Prevent multiple simultaneous requests

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final teknisiData = await _teknisiService.getAllTeknisi();
      _teknisiList = teknisiData;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Membuat teknisi baru
  Future<bool> createTeknisi(Map<String, dynamic> teknisiData) async {
    if (_isCreating) return false;

    _isCreating = true;
    _error = null;
    notifyListeners();

    try {
      final newTeknisi = await _teknisiService.createTeknisi(teknisiData);
      _teknisiList.add(newTeknisi);
      _teknisiList.sort((a, b) => a.name.compareTo(b.name)); // Sort by name
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _isCreating = false;
      notifyListeners();
    }
  }

  /// Memperbarui data teknisi
  Future<bool> updateTeknisi(String id, Map<String, dynamic> teknisiData) async {
    if (_isUpdating) return false;

    _isUpdating = true;
    _error = null;
    notifyListeners();

    try {
      final updatedTeknisi = await _teknisiService.updateTeknisi(id, teknisiData);
      
      // Update teknisi dalam list
      final index = _teknisiList.indexWhere((teknisi) => teknisi.id == id);
      if (index != -1) {
        _teknisiList[index] = updatedTeknisi;
        _teknisiList.sort((a, b) => a.name.compareTo(b.name)); // Sort by name
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _isUpdating = false;
      notifyListeners();
    }
  }

  /// Menghapus teknisi
  Future<bool> deleteTeknisi(String id) async {
    if (_isDeleting) return false;

    _isDeleting = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _teknisiService.deleteTeknisi(id);
      
      if (success) {
        _teknisiList.removeWhere((teknisi) => teknisi.id == id);
        notifyListeners();
      }
      return success;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    } finally {
      _isDeleting = false;
      notifyListeners();
    }
  }

  /// Mendapatkan teknisi berdasarkan ID dari cache (local list)
  TeknisiUser? getTeknisiById(String id) {
    try {
      return _teknisiList.firstWhere((teknisi) => teknisi.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Refresh data setelah operasi CRUD
  Future<void> refreshData() async {
    await fetchTeknisiData();
  }

  /// Menghapus error dan memulai ulang state
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Reset provider state
  void reset() {
    _teknisiList = [];
    _isLoading = false;
    _isCreating = false;
    _isUpdating = false;
    _isDeleting = false;
    _error = null;
    notifyListeners();
  }

  /// Mencari teknisi berdasarkan nama atau email
  List<TeknisiUser> searchTeknisi(String query) {
    if (query.isEmpty) return _teknisiList;
    
    return _teknisiList.where((teknisi) {
      return teknisi.name.toLowerCase().contains(query.toLowerCase()) ||
             teknisi.email.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  /// Mendapatkan jumlah total teknisi
  int get totalTeknisi => _teknisiList.length;

  /// Mendapatkan teknisi berdasarkan index
  TeknisiUser? getTeknisiAt(int index) {
    if (index >= 0 && index < _teknisiList.length) {
      return _teknisiList[index];
    }
    return null;
  }

  /// Validasi data teknisi sebelum operasi CRUD
  Map<String, String> validateTeknisiData(Map<String, dynamic> data) {
    final errors = <String, String>{};

    // Validasi nama
    final name = data['name']?.toString().trim();
    if (name == null || name.isEmpty) {
      errors['name'] = 'Nama harus diisi';
    } else if (name.length < 3) {
      errors['name'] = 'Nama harus minimal 3 karakter';
    }

    // Validasi email
    final email = data['email']?.toString().trim();
    if (email == null || email.isEmpty) {
      errors['email'] = 'Email harus diisi';
    } else if (!_isValidEmail(email)) {
      errors['email'] = 'Format email tidak valid';
    }

    // Validasi area kerja
    final areaKerja = data['area_kerja']?.toString().trim();
    if (areaKerja == null || areaKerja.isEmpty) {
      errors['area_kerja'] = 'Area kerja harus diisi';
    }

    // Validasi roles
    final roles = data['roles'] as List<dynamic>?;
    if (roles == null || roles.isEmpty) {
      errors['roles'] = 'Minimal satu role harus dipilih';
    }

    // Validasi phone (optional tapi jika ada harus valid)
    final phone = data['phone']?.toString().trim();
    if (phone != null && phone.isNotEmpty && !_isValidPhone(phone)) {
      errors['phone'] = 'Format nomor telepon tidak valid';
    }

    return errors;
  }

  /// Validasi format email
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    );
    return emailRegex.hasMatch(email);
  }

  /// Validasi format nomor telepon
  bool _isValidPhone(String phone) {
    // Format Indonesia: +62xxxxxxxxxx atau 08xxxxxxxxxx
    final phoneRegex = RegExp(
      r'^(\+62|62|0)8[1-9][0-9]{6,9}$'
    );
    return phoneRegex.hasMatch(phone.replaceAll(RegExp(r'[^\d+]'), ''));
  }
}
