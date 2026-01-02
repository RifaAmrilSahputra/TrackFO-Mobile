import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/providers/auth_provider.dart';
import '../../../../../core/providers/teknisi_provider.dart';
import '../../../../../core/providers/theme_provider.dart';
import '../../../../../core/services/teknisi_service.dart';
import '../../../../../models/teknisi_user.dart';
import 'add_teknisi_page.dart';
import '../../../../../theme/app_theme.dart';

class AdminTeknisiPage extends StatefulWidget {
  const AdminTeknisiPage({super.key});

  @override
  State<AdminTeknisiPage> createState() => _AdminTeknisiPageState();
}

class _AdminTeknisiPageState extends State<AdminTeknisiPage> {
  late TeknisiProvider _teknisiProvider;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'Semua';
  String _sortBy = 'Nama';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeProvider();
  }

  void _initializeProvider() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.token != null) {
      final teknisiService = TeknisiService(authProvider.token!);
      _teknisiProvider = TeknisiProvider(teknisiService);

      // Start fetching data
      _teknisiProvider.fetchTeknisiData();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  void _onSortChanged(String sortBy) {
    setState(() {
      _sortBy = sortBy;
    });
  }

  List<TeknisiUser> _filterTeknisi(List<TeknisiUser> teknisiList) {
    List<TeknisiUser> filtered = teknisiList;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = _teknisiProvider.searchTeknisi(_searchQuery);
    }

    // Apply area filter
    if (_selectedFilter != 'Semua') {
      filtered = filtered.where((teknisi) {
        return teknisi.areaKerja?.toLowerCase().contains(
              _selectedFilter.toLowerCase(),
            ) ??
            false;
      }).toList();
    }

    // Apply sorting
    switch (_sortBy) {
      case 'Nama':
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'Area':
        filtered.sort(
          (a, b) => (a.areaKerja ?? '').compareTo(b.areaKerja ?? ''),
        );
        break;
      case 'Email':
        filtered.sort((a, b) => a.email.compareTo(b.email));
        break;
      case 'Tanggal Daftar':
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
    }

    return filtered;
  }

  List<String> _getUniqueAreas(List<TeknisiUser> teknisiList) {
    final areas = <String>{};
    for (final teknisi in teknisiList) {
      if (teknisi.areaKerja != null && teknisi.areaKerja!.isNotEmpty) {
        areas.add(teknisi.areaKerja!);
      }
    }
    return areas.toList()..sort();
  }



  Widget _buildQuickStat(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(height: 3),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppTheme.kTextPrimary,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                color: color,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showEditTeknisiDialog(TeknisiUser teknisi) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${teknisi.name}'),
        content: const Text('Fitur edit teknisi akan segera tersedia'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(TeknisiUser teknisi) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Teknisi'),
        content: Text('Apakah Anda yakin ingin menghapus ${teknisi.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.kRose),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTeknisiPage()),
          );
          if (result == true) {
            _teknisiProvider.fetchTeknisiData();
          }
        },
        backgroundColor: AppTheme.kIndigo,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Tambah Teknisi',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          if (authProvider.token == null) {
            return const Center(child: Text('Token tidak tersedia'));
          }

          return ChangeNotifierProvider.value(
            value: _teknisiProvider,
            child: Consumer<TeknisiProvider>(
              builder: (context, teknisiProvider, child) {
                if (teknisiProvider.isLoading) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Memuat data teknisi...'),
                      ],
                    ),
                  );
                }

                if (teknisiProvider.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 64, color: AppTheme.kRose),
                        const SizedBox(height: 16),
                        Text(
                          'Terjadi Kesalahan',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: AppTheme.kRose,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            teknisiProvider.error ?? 'Unknown error',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppTheme.kTextSecondary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            teknisiProvider.clearError();
                            teknisiProvider.fetchTeknisiData();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.kIndigo,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  );
                }

                final filteredTeknisi = _filterTeknisi(
                  teknisiProvider.teknisiList,
                );
                final uniqueAreas = _getUniqueAreas(
                  teknisiProvider.teknisiList,
                );

                return Column(
                  children: [
                    // Enhanced Statistics Cards
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [AppTheme.kIndigo, AppTheme.kCyan],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.engineering,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total Teknisi',
                                      style: theme.textTheme.titleSmall
                                          ?.copyWith(
                                            color: theme.colorScheme.onSurfaceVariant,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                    Text(
                                      '${teknisiProvider.totalTeknisi} Teknisi',
                                      style: theme.textTheme.titleLarge
                                          ?.copyWith(
                                            color: AppTheme.kIndigo,
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Quick Stats Row
                          Row(
                            children: [
                              _buildQuickStat(
                                'Area Kerja',
                                '${uniqueAreas.length}',
                                Icons.location_on,
                                AppTheme.kLime,
                              ),
                              const SizedBox(width: 12),
                              _buildQuickStat(
                                'Terdaftar Hari Ini',
                                '0',
                                Icons.today,
                                AppTheme.kAmber,
                              ),
                              const SizedBox(width: 12),
                              _buildQuickStat(
                                'Aktif',
                                '${teknisiProvider.totalTeknisi}',
                                Icons.check_circle,
                                AppTheme.kCyan,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Search and Filter Section
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Search Bar
                          Container(
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppTheme.kIndigo.withValues(alpha: 0.1),
                              ),
                            ),
                            child: TextField(
                              controller: _searchController,
                              onChanged: _onSearchChanged,
                              decoration: InputDecoration(
                                hintText: 'Cari nama atau email...',
                                prefixIcon: const Icon(
                                  Icons.search,
                                  color: AppTheme.kIndigo,
                                  size: 18,
                                ),
                                suffixIcon: _searchQuery.isNotEmpty
                                    ? IconButton(
                                        icon: const Icon(
                                          Icons.clear,
                                          color: AppTheme.kTextSecondary,
                                          size: 16,
                                        ),
                                        onPressed: () {
                                          _searchController.clear();
                                          _onSearchChanged('');
                                        },
                                      )
                                    : null,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: theme.colorScheme.surfaceVariant,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Filter and Sort Row
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final screenWidth = constraints.maxWidth;
                              final isVeryNarrow = screenWidth < 350;
                              final isNarrow = screenWidth < 450;

                              if (isVeryNarrow) {
                                // Stack vertically on very narrow screens
                                return Column(
                                  children: [
                                    // Filter Dropdown
                                    Container(
                                      width: double.infinity,
                                      constraints: const BoxConstraints(
                                        maxHeight: 45,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.surfaceVariant,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: AppTheme.kLime.withValues(alpha: 0.3),
                                        ),
                                      ),
                                      child: DropdownButtonFormField<String>(
                                        initialValue: _selectedFilter,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          icon: Icon(
                                            Icons.filter_list,
                                            color: AppTheme.kLime,
                                            size: 12,
                                          ),
                                          hintText: 'Area',
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 2,
                                            horizontal: 4,
                                          ),
                                        ),
                                        items: [
                                          const DropdownMenuItem(
                                            value: 'Semua',
                                            child: Text(
                                              'Semua',
                                              style: TextStyle(fontSize: 9),
                                            ),
                                          ),
                                          ...uniqueAreas.map(
                                            (area) => DropdownMenuItem(
                                              value: area,
                                              child: SizedBox(
                                                width: 80,
                                                child: Text(
                                                  area.length > 10
                                                      ? '${area.substring(0, 8)}...'
                                                      : area,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 9,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                        onChanged: (value) =>
                                            _onFilterChanged(value ?? 'Semua'),
                                      ),
                                    ),
                                    const SizedBox(height: 6),

                                    // Sort Dropdown
                                    Container(
                                      width: double.infinity,
                                      constraints: const BoxConstraints(
                                        maxHeight: 45,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.surfaceVariant,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                          color: AppTheme.kAmber.withValues(alpha: 0.3),
                                        ),
                                      ),
                                      child: DropdownButtonFormField<String>(
                                        initialValue: _sortBy,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          icon: Icon(
                                            Icons.sort,
                                            color: AppTheme.kAmber,
                                            size: 12,
                                          ),
                                          hintText: 'Urut',
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 2,
                                            horizontal: 4,
                                          ),
                                        ),
                                        items: const [
                                          DropdownMenuItem(
                                            value: 'Nama',
                                            child: Text(
                                              'Nama',
                                              style: TextStyle(fontSize: 9),
                                            ),
                                          ),
                                          DropdownMenuItem(
                                            value: 'Area',
                                            child: Text(
                                              'Area',
                                              style: TextStyle(fontSize: 9),
                                            ),
                                          ),
                                          DropdownMenuItem(
                                            value: 'Email',
                                            child: Text(
                                              'Email',
                                              style: TextStyle(fontSize: 9),
                                            ),
                                          ),
                                          DropdownMenuItem(
                                            value: 'Tanggal',
                                            child: Text(
                                              'Tgl',
                                              style: TextStyle(fontSize: 9),
                                            ),
                                          ),
                                        ],
                                        onChanged: (value) =>
                                            _onSortChanged(value ?? 'Nama'),
                                      ),
                                    ),
                                  ],
                                );
                              } else if (isNarrow) {
                                // Stack vertically on narrow screens
                                return Column(
                                  children: [
                                    // Filter Dropdown
                                    Container(
                                      width: double.infinity,
                                      constraints: const BoxConstraints(
                                        maxHeight: 48,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.surfaceVariant,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: AppTheme.kLime.withValues(alpha: 0.3),
                                        ),
                                      ),
                                      child: DropdownButtonFormField<String>(
                                        initialValue: _selectedFilter,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          icon: Icon(
                                            Icons.filter_list,
                                            color: AppTheme.kLime,
                                            size: 14,
                                          ),
                                          hintText: 'Area',
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 4,
                                          ),
                                        ),
                                        items: [
                                          const DropdownMenuItem(
                                            value: 'Semua',
                                            child: Text(
                                              'Semua',
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ),
                                          ...uniqueAreas.map(
                                            (area) => DropdownMenuItem(
                                              value: area,
                                              child: SizedBox(
                                                width: 90,
                                                child: Text(
                                                  area.length > 10
                                                      ? '${area.substring(0, 8)}...'
                                                      : area,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 9,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                        onChanged: (value) =>
                                            _onFilterChanged(value ?? 'Semua'),
                                      ),
                                    ),
                                    const SizedBox(height: 8),

                                    // Sort Dropdown
                                    Container(
                                      width: double.infinity,
                                      constraints: const BoxConstraints(
                                        maxHeight: 48,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.surfaceVariant,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: AppTheme.kAmber.withValues(alpha: 0.3),
                                        ),
                                      ),
                                      child: DropdownButtonFormField<String>(
                                        initialValue: _sortBy,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          icon: Icon(
                                            Icons.sort,
                                            color: AppTheme.kAmber,
                                            size: 14,
                                          ),
                                          hintText: 'Urut',
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 4,
                                          ),
                                        ),
                                        items: const [
                                          DropdownMenuItem(
                                            value: 'Nama',
                                            child: Text(
                                              'Nama',
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ),
                                          DropdownMenuItem(
                                            value: 'Area',
                                            child: Text(
                                              'Area',
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ),
                                          DropdownMenuItem(
                                            value: 'Email',
                                            child: Text(
                                              'Email',
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ),
                                          DropdownMenuItem(
                                            value: 'Tanggal',
                                            child: Text(
                                              'Tanggal',
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ),
                                        ],
                                        onChanged: (value) =>
                                            _onSortChanged(value ?? 'Nama'),
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                // Side by side on wider screens
                                return Row(
                                  children: [
                                    // Filter Dropdown
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.surfaceVariant,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: AppTheme.kLime.withValues(alpha: 0.3),
                                          ),
                                        ),
                                        child: DropdownButtonFormField<String>(
                                          initialValue: _selectedFilter,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            icon: Icon(
                                              Icons.filter_list,
                                              color: AppTheme.kLime,
                                              size: 14,
                                            ),
                                            hintText: 'Filter Area',
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  vertical: 4,
                                                ),
                                          ),
                                          items: [
                                            const DropdownMenuItem(
                                              value: 'Semua',
                                              child: Text(
                                                'Semua Area',
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            ),
                                            ...uniqueAreas.map(
                                              (area) => DropdownMenuItem(
                                                value: area,
                                                child: SizedBox(
                                                  width: 90,
                                                  child: Text(
                                                    area.length > 12
                                                        ? '${area.substring(0, 10)}...'
                                                        : area,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 9,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                          onChanged: (value) =>
                                              _onFilterChanged(
                                                value ?? 'Semua',
                                              ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),

                                    // Sort Dropdown
                                    Expanded(
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.surfaceVariant,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: AppTheme.kAmber.withValues(
                                              alpha: 0.3,
                                            ),
                                          ),
                                        ),
                                        child: DropdownButtonFormField<String>(
                                          initialValue: _sortBy,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            icon: Icon(
                                              Icons.sort,
                                              color: AppTheme.kAmber,
                                              size: 14,
                                            ),
                                            hintText: 'Urutkan',
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                  vertical: 4,
                                                ),
                                          ),
                                          items: const [
                                            DropdownMenuItem(
                                              value: 'Nama',
                                              child: Text(
                                                'Nama',
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            ),
                                            DropdownMenuItem(
                                              value: 'Area',
                                              child: Text(
                                                'Area',
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            ),
                                            DropdownMenuItem(
                                              value: 'Email',
                                              child: Text(
                                                'Email',
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            ),
                                            DropdownMenuItem(
                                              value: 'Tanggal',
                                              child: Text(
                                                'Tanggal',
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            ),
                                          ],
                                          onChanged: (value) =>
                                              _onSortChanged(value ?? 'Nama'),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Teknisi List/Grid with Results Info
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Menampilkan ${filteredTeknisi.length} dari ${teknisiProvider.totalTeknisi} teknisi',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (_selectedFilter != 'Semua' ||
                              _searchQuery.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedFilter = 'Semua';
                                  _searchQuery = '';
                                  _searchController.clear();
                                  _sortBy = 'Nama';
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.kRose.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.clear, color: AppTheme.kRose, size: 12),
                                    const SizedBox(width: 3),
                                    Text(
                                      'Reset Filter',
                                      style: TextStyle(
                                        color: AppTheme.kRose,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Teknisi List/Grid
                    Expanded(
                      child: filteredTeknisi.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.onSurfaceVariant.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Icon(
                                      teknisiProvider.hasData
                                          ? Icons.search_off
                                          : Icons.people_outline,
                                      size: 40,
                                      color: theme.colorScheme.onSurfaceVariant.withValues(
                                        alpha: 0.6,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    teknisiProvider.hasData
                                        ? _searchQuery.isNotEmpty ||
                                                  _selectedFilter != 'Semua'
                                              ? 'Tidak ada teknisi yang sesuai filter'
                                              : 'Tidak ada teknisi yang ditemukan'
                                        : 'Belum ada data teknisi',
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: theme.colorScheme.onSurface,
                                        ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    teknisiProvider.hasData
                                        ? 'Coba ubah kata kunci pencarian atau filter'
                                        : 'Silakan refresh atau coba lagi nanti',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 24),
                                  if (teknisiProvider.hasData)
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          _selectedFilter = 'Semua';
                                          _searchQuery = '';
                                          _searchController.clear();
                                          _sortBy = 'Nama';
                                        });
                                      },
                                      icon: const Icon(Icons.refresh, size: 16),
                                      label: const Text('Reset Filter'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppTheme.kIndigo,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            )
                          : LayoutBuilder(
                              builder: (context, constraints) {
                                final screenWidth = constraints.maxWidth;
                                final crossAxisCount = screenWidth > 1200
                                    ? 4
                                    : screenWidth > 900
                                    ? 3
                                    : screenWidth > 600
                                    ? 2
                                    : 1;
                                final childAspectRatio = screenWidth > 1200
                                    ? 0.9
                                    : screenWidth > 900
                                    ? 1.0
                                    : screenWidth > 600
                                    ? 1.4
                                    : 2.5;

                                return RefreshIndicator(
                                  onRefresh: () async {
                                    await _teknisiProvider.fetchTeknisiData();
                                  },
                                  color: AppTheme.kIndigo,
                                  child: CustomScrollView(
                                    controller: _scrollController,
                                    slivers: [
                                      SliverPadding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                        sliver: SliverGrid(
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: crossAxisCount,
                                                childAspectRatio:
                                                    childAspectRatio,
                                                crossAxisSpacing: 8,
                                                mainAxisSpacing: 8,
                                              ),
                                          delegate: SliverChildBuilderDelegate(
                                            (context, index) {
                                              final teknisi =
                                                  filteredTeknisi[index];
                                              return AnimatedContainer(
                                                duration: Duration(
                                                  milliseconds:
                                                      300 + (index * 50),
                                                ),
                                                curve: Curves.easeOutBack,
                                                child: EnhancedTeknisiCard(
                                                  teknisi: teknisi,
                                                  onTap: () =>
                                                      _showTeknisiDetail(
                                                        context,
                                                        teknisi,
                                                      ),
                                                  onEdit: () =>
                                                      _showEditTeknisiDialog(
                                                        teknisi,
                                                      ),
                                                  onDelete: () =>
                                                      _showDeleteConfirmation(
                                                        teknisi,
                                                      ),
                                                ),
                                              );
                                            },
                                            childCount: filteredTeknisi.length,
                                          ),
                                        ),
                                      ),
                                      const SliverToBoxAdapter(
                                        child: SizedBox(
                                          height: 60,
                                        ), // Extra space for FAB
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _showTeknisiDetail(BuildContext context, TeknisiUser teknisi) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TeknisiDetailSheet(teknisi: teknisi),
    );
  }
}

/// Enhanced teknisi card with improved design and actions
class EnhancedTeknisiCard extends StatelessWidget {
  final TeknisiUser teknisi;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const EnhancedTeknisiCard({
    super.key,
    required this.teknisi,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: AppTheme.kIndigo.withValues(alpha: 0.1)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Avatar and Actions
              Row(
                children: [
                  // Avatar - Smaller
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppTheme.kIndigo, AppTheme.kCyan],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            teknisi.name.substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Online Status Indicator
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppTheme.kLime,
                              border: Border.all(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Name and Email - More Compact
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          teknisi.name.length > 16
                              ? '${teknisi.name.substring(0, 14)}...'
                              : teknisi.name,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 1),
                        Text(
                          teknisi.email.length > 20
                              ? '${teknisi.email.substring(0, 18)}...'
                              : teknisi.email,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 9,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Action Menu - Smaller
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          onEdit?.call();
                          break;
                        case 'delete':
                          onDelete?.call();
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 12),
                            SizedBox(width: 4),
                            Text('Edit', style: TextStyle(fontSize: 10)),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 12, color: AppTheme.kRose),
                            SizedBox(width: 4),
                            Text(
                              'Hapus',
                              style: TextStyle(color: AppTheme.kRose, fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    ],
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      child: Icon(
                        Icons.more_vert,
                        color: theme.colorScheme.onSurfaceVariant,
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // Contact Info - More Compact
              if (teknisi.phone != null) ...[
                Row(
                  children: [
                    Icon(Icons.phone, size: 12, color: AppTheme.kCyan),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        teknisi.phone!.length > 12
                            ? '${teknisi.phone!.substring(0, 10)}...'
                            : teknisi.phone!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 9,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
              ],

              if (teknisi.areaKerja != null) ...[
                Row(
                  children: [
                    Icon(Icons.location_on, size: 12, color: AppTheme.kLime),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        teknisi.areaKerja!.length > 14
                            ? '${teknisi.areaKerja!.substring(0, 12)}...'
                            : teknisi.areaKerja!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 9,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
              ],

              // Roles - More Compact
              if (teknisi.roles.isNotEmpty) ...[
                Wrap(
                  spacing: 1,
                  runSpacing: 1,
                  children: teknisi.roles.take(2).map((role) {
                    final displayRole = role.length > 8
                        ? '${role.substring(0, 6)}..'
                        : role;
                    return Container(
                      constraints: const BoxConstraints(maxWidth: 60),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 2,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.kIndigo.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(
                          color: AppTheme.kIndigo.withValues(alpha: 0.3),
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        displayRole.toLowerCase(),
                        style: TextStyle(
                          fontSize: 8,
                          color: AppTheme.kIndigo,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                ),
                if (teknisi.roles.length > 2)
                  Text(
                    '+${teknisi.roles.length - 2} lainnya',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                      fontSize: 8,
                    ),
                  ),
              ],

              const SizedBox(height: 6),

              // Footer with Registration Date - More Compact
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      _formatShortDate(teknisi.createdAt),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                        fontSize: 8,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 3,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.kLime.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Text(
                      'Aktif',
                      style: TextStyle(
                        color: AppTheme.kLime,
                        fontSize: 7,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatShortDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

class TeknisiDetailSheet extends StatelessWidget {
  final TeknisiUser teknisi;

  const TeknisiDetailSheet({super.key, required this.teknisi});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: AppTheme.kTextSecondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppTheme.kCyan, Color.fromARGB(255, 129, 140, 248)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.engineering,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            teknisi.name,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppTheme.kTextPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            teknisi.email,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppTheme.kTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildInfoTile(
                      icon: Icons.phone,
                      label: 'Telepon',
                      value: teknisi.phone ?? 'Tidak tersedia',
                      color: AppTheme.kCyan,
                    ),
                    _buildInfoTile(
                      icon: Icons.location_on,
                      label: 'Area Kerja',
                      value: teknisi.areaKerja ?? 'Tidak tersedia',
                      color: AppTheme.kLime,
                    ),
                    _buildInfoTile(
                      icon: Icons.home,
                      label: 'Alamat',
                      value: teknisi.alamat ?? 'Tidak tersedia',
                      color: AppTheme.kAmber,
                    ),
                    _buildInfoTile(
                      icon: Icons.my_location,
                      label: 'Koordinat',
                      value: teknisi.koordinat ?? 'Tidak tersedia',
                      color: AppTheme.kRose,
                    ),

                    const SizedBox(height: 20),

                    // Roles Section
                    Text(
                      'Role',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.kTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: teknisi.roles.map((role) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.kIndigo.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppTheme.kIndigo.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            role.toLowerCase(),
                            style: TextStyle(
                              color: AppTheme.kIndigo,
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),

                    // Created At
                    Text(
                      'Terdaftar pada',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.kTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatDate(teknisi.createdAt),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.kTextSecondary,
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.kTextSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.kTextPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}, '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')} WIB';
  }
}
