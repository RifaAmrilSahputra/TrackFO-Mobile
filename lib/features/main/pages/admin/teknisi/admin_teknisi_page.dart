import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/providers/auth_provider.dart';
import '../../../../../core/providers/teknisi_provider.dart';
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
      _teknisiProvider.fetchTeknisiData();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
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

    if (_searchQuery.isNotEmpty) {
      filtered = _teknisiProvider.searchTeknisi(_searchQuery);
    }

    if (_selectedFilter != 'Semua') {
      filtered = filtered.where((teknisi) {
        return teknisi.areaKerja?.toLowerCase().contains(
              _selectedFilter.toLowerCase(),
            ) ??
            false;
      }).toList();
    }

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
          if (result == true && mounted) {
            _teknisiProvider.fetchTeknisiData();
          }
        },
        backgroundColor: AppTheme.kIndigo,
        icon: const Icon(Icons.add, color: Colors.white, size: 18),
        label: const Text(
          'Tambah Teknisi',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.kIndigo),
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Memuat data...',
                          style: TextStyle(
                            color: AppTheme.kTextSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (teknisiProvider.hasError) {
                  return _buildErrorState(teknisiProvider, theme);
                }

                final filteredTeknisiList = _filterTeknisi(teknisiProvider.teknisiList);
                final uniqueAreas = _getUniqueAreas(teknisiProvider.teknisiList);

                return Column(
                  children: [
                    _buildHeader(theme, teknisiProvider, uniqueAreas),
                    Expanded(
                      child: filteredTeknisiList.isEmpty
                          ? _buildEmptyState(teknisiProvider, theme)
                          : _buildTeknisiList(filteredTeknisiList),
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

  Widget _buildHeader(ThemeData theme, TeknisiProvider teknisiProvider, List<String> uniqueAreas) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page Title
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.kIndigo, AppTheme.kCyan],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.people,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kelola Teknisi',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    '${teknisiProvider.totalTeknisi} teknisi terdaftar',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Cari teknisi...',
                prefixIcon: Container(
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    Icons.search,
                    color: AppTheme.kIndigo,
                    size: 20,
                  ),
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppTheme.kTextSecondary, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: theme.cardColor,
                contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Filter & Sort Row
          Row(
            children: [
              Expanded(
                child: _buildFilterDropdown(uniqueAreas),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildSortDropdown(),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Results Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Menampilkan ${_filterTeknisi(teknisiProvider.teknisiList).length} teknisi',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              if (_selectedFilter != 'Semua' || _searchQuery.isNotEmpty)
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
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.kRose.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.clear, color: AppTheme.kRose, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          'Reset',
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
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(List<String> uniqueAreas) {
    final theme = Theme.of(context);
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.15)),
      ),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        isDense: true,
        initialValue: _selectedFilter,
        icon: const Icon(Icons.keyboard_arrow_down, size: 18),
        decoration: const InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.filter_list, color: AppTheme.kLime, size: 16),
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
        items: [
          const DropdownMenuItem(value: 'Semua', child: Text('Semua', style: TextStyle(fontSize: 11))),
          ...uniqueAreas.map((area) => DropdownMenuItem(
            value: area,
            child: Text(
              area.length > 18 ? '${area.substring(0, 16)}...' : area,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11),
            ),
          )),
        ],
        onChanged: (value) => _onFilterChanged(value ?? 'Semua'),
      ),
    );
  }

  Widget _buildSortDropdown() {
    final theme = Theme.of(context);
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.15)),
      ),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        isDense: true,
        initialValue: _sortBy,
        icon: const Icon(Icons.keyboard_arrow_down, size: 18),
        decoration: const InputDecoration(
          border: InputBorder.none,
          icon: Icon(Icons.sort, color: AppTheme.kAmber, size: 16),
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
        items: const [
          DropdownMenuItem(value: 'Nama', child: Text('Nama', style: TextStyle(fontSize: 11))),
          DropdownMenuItem(value: 'Area', child: Text('Area', style: TextStyle(fontSize: 11))),
          DropdownMenuItem(value: 'Email', child: Text('Email', style: TextStyle(fontSize: 11))),
          DropdownMenuItem(value: 'Tanggal Daftar', child: Text('Tanggal', style: TextStyle(fontSize: 11))),
        ],
        onChanged: (value) => _onSortChanged(value ?? 'Nama'),
      ),
    );
  }

  Widget _buildErrorState(TeknisiProvider teknisiProvider, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppTheme.kRose.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.error_outline,
                color: AppTheme.kRose,
                size: 36,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Terjadi Kesalahan',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppTheme.kRose,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              teknisiProvider.error ?? 'Unknown error',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.kTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                teknisiProvider.clearError();
                teknisiProvider.fetchTeknisiData();
              },
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.kIndigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(TeknisiProvider teknisiProvider, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.kIndigo.withValues(alpha: 0.1),
                    AppTheme.kCyan.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                teknisiProvider.hasData ? Icons.search_off : Icons.people_outline,
                size: 40,
                color: AppTheme.kIndigo.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              teknisiProvider.hasData
                  ? _searchQuery.isNotEmpty || _selectedFilter != 'Semua'
                      ? 'Tidak ada hasil'
                      : 'Belum ada teknisi'
                  : 'Belum ada data',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              teknisiProvider.hasData
                  ? 'Coba ubah filter atau kata kunci'
                  : 'Silakan tambahkan teknisi baru',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (teknisiProvider.hasData)
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _selectedFilter = 'Semua';
                    _searchQuery = '';
                    _searchController.clear();
                    _sortBy = 'Nama';
                  });
                },
                icon: const Icon(Icons.clear, size: 18),
                label: const Text('Reset Filter'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeknisiList(List<TeknisiUser> filteredTeknisi) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final crossAxisCount = screenWidth > 1200 ? 4 : screenWidth > 900 ? 3 : screenWidth > 600 ? 2 : 1;
        final childAspectRatio = screenWidth > 1200 ? 0.9 : screenWidth > 900 ? 0.95 : screenWidth > 600 ? 1.2 : 1.6;

        return RefreshIndicator(
          onRefresh: () async => await _teknisiProvider.fetchTeknisiData(),
          color: AppTheme.kIndigo,
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: childAspectRatio,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final teknisi = filteredTeknisi[index];
                      return ModernTeknisiCard(
                        teknisi: teknisi,
                        onTap: () => _showTeknisiDetail(context, teknisi),
                        onEdit: () => _showEditDialog(teknisi),
                        onDelete: () => _showDeleteConfirmation(teknisi),
                      );
                    },
                    childCount: filteredTeknisi.length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
        );
      },
    );
  }

  void _showTeknisiDetail(BuildContext context, TeknisiUser teknisi) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ModernTeknisiDetailSheet(teknisi: teknisi),
    );
  }

  void _showEditDialog(TeknisiUser teknisi) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Edit ${teknisi.name}'),
        content: const Text('Fitur edit akan segera tersedia'),
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
      builder: (context) => _DeleteConfirmationDialog(
        teknisi: teknisi,
        onConfirm: () async {
          Navigator.of(context).pop(); // Close dialog
          await _performDelete(teknisi);
        },
      ),
    );
  }

  Future<void> _performDelete(TeknisiUser teknisi) async {
    // Show loading indicator
    _showLoadingDialog();

    try {
      final success = await _teknisiProvider.deleteTeknisi(teknisi.id);

      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      if (success) {
        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_circle, color: AppTheme.kLime, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Teknisi ${teknisi.name} berhasil dihapus',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              backgroundColor: AppTheme.kLime,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      } else {
        // Show error message
        if (mounted) {
          _showErrorDialog(_teknisiProvider.error ?? 'Gagal menghapus teknisi');
        }
      }
    } catch (e) {
      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      // Show error message
      if (mounted) {
        _showErrorDialog(e.toString().replaceAll('Exception: ', ''));
      }
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.kIndigo),
              ),
            ),
            const SizedBox(width: 16),
            const Text('Menghapus teknisi...'),
          ],
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.kRose.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.error_outline, color: AppTheme.kRose),
            ),
            const SizedBox(width: 12),
            const Text('Gagal'),
          ],
        ),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.kIndigo,
              foregroundColor: Colors.white,
            ),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}

/// Modern teknisi card dengan desain minimalis
class ModernTeknisiCard extends StatelessWidget {
  final TeknisiUser teknisi;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ModernTeknisiCard({
    super.key,
    required this.teknisi,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initials = teknisi.name.isNotEmpty ? teknisi.name.substring(0, 1).toUpperCase() : '?';

    return Material(
      color: theme.cardColor,
      borderRadius: BorderRadius.circular(14),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.08)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Row
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppTheme.kIndigo, AppTheme.kCyan],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          teknisi.name.length > 20 ? '${teknisi.name.substring(0, 18)}...' : teknisi.name,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          teknisi.email.length > 24 ? '${teknisi.email.substring(0, 22)}...' : teknisi.email,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 11,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  _buildMenuButton(theme),
                ],
              ),
              const SizedBox(height: 12),

              // Info Row
              if (teknisi.phone != null || teknisi.areaKerja != null)
                Row(
                  children: [
                    if (teknisi.phone != null)
                      _buildInfoItem(Icons.phone, teknisi.phone!, theme),
                    if (teknisi.phone != null && teknisi.areaKerja != null)
                      const SizedBox(width: 10),
                    if (teknisi.areaKerja != null)
                      Expanded(
                        child: _buildInfoItem(Icons.location_on, teknisi.areaKerja!, theme),
                      ),
                  ],
                ),
              if (teknisi.phone != null || teknisi.areaKerja != null)
                const SizedBox(height: 10),

              // Roles
              if (teknisi.roles.isNotEmpty)
                Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: teknisi.roles.take(2).map((role) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.kIndigo.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        role.toLowerCase(),
                        style: TextStyle(
                          fontSize: 10,
                          color: AppTheme.kIndigo,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              if (teknisi.roles.isNotEmpty) const SizedBox(height: 10),

              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDate(teknisi.createdAt),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.kLime.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      'Aktif',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppTheme.kLime,
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

  Widget _buildMenuButton(ThemeData theme) {
    return PopupMenuButton<String>(
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
              Icon(Icons.edit, size: 16),
              SizedBox(width: 8),
              Text('Edit', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              const Icon(Icons.delete, size: 16, color: AppTheme.kRose),
              const SizedBox(width: 8),
              Text('Hapus', style: TextStyle(color: AppTheme.kRose, fontSize: 12)),
            ],
          ),
        ),
      ],
      child: Icon(
        Icons.more_vert,
        color: theme.colorScheme.onSurfaceVariant,
        size: 20,
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text, ThemeData theme) {
    return Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: icon == Icons.phone ? AppTheme.kCyan : AppTheme.kLime),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              text.length > 16 ? '${text.substring(0, 14)}...' : text,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 11,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

/// Custom dialog for delete confirmation
class _DeleteConfirmationDialog extends StatelessWidget {
  final TeknisiUser teknisi;
  final VoidCallback onConfirm;

  const _DeleteConfirmationDialog({
    required this.teknisi,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.kRose.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.warning_amber_rounded, color: AppTheme.kRose),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Hapus Teknisi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                Text(
                  'Tindakan ini tidak dapat dibatalkan',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.kIndigo, AppTheme.kCyan],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      teknisi.name.isNotEmpty ? teknisi.name.substring(0, 1).toUpperCase() : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        teknisi.name.length > 24 ? '${teknisi.name.substring(0, 22)}...' : teknisi.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        teknisi.email.length > 30 ? '${teknisi.email.substring(0, 28)}...' : teknisi.email,
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Apakah Anda yakin ingin menghapus teknisi ${teknisi.name}? Semua data terkait teknisi ini akan dihapus permanen.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Batal',
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.kRose,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          child: const Text(
            'Ya, Hapus',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
    );
  }
}

/// Modern bottom sheet untuk detail teknisi
class ModernTeknisiDetailSheet extends StatelessWidget {
  final TeknisiUser teknisi;

  const ModernTeknisiDetailSheet({super.key, required this.teknisi});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final initials = teknisi.name.isNotEmpty ? teknisi.name.substring(0, 1).toUpperCase() : '?';

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.5,
      maxChildSize: 0.85,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppTheme.kIndigo, AppTheme.kCyan],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          initials,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            teknisi.name,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            teknisi.email,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildInfoCard(
                      icon: Icons.phone,
                      label: 'Telepon',
                      value: teknisi.phone ?? 'Tidak tersedia',
                      color: AppTheme.kCyan,
                      theme: theme,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      icon: Icons.location_on,
                      label: 'Area Kerja',
                      value: teknisi.areaKerja ?? 'Tidak tersedia',
                      color: AppTheme.kLime,
                      theme: theme,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      icon: Icons.home,
                      label: 'Alamat',
                      value: teknisi.alamat ?? 'Tidak tersedia',
                      color: AppTheme.kAmber,
                      theme: theme,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      icon: Icons.my_location,
                      label: 'Koordinat',
                      value: teknisi.koordinat ?? 'Tidak tersedia',
                      color: AppTheme.kRose,
                      theme: theme,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Role',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: teknisi.roles.map((role) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.kIndigo.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppTheme.kIndigo.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Text(
                            role.toLowerCase(),
                            style: TextStyle(
                              color: AppTheme.kIndigo,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Terdaftar',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatFullDate(teknisi.createdAt),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
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

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required ThemeData theme,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatFullDate(DateTime date) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

