import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/providers/auth_provider.dart';
import '../../../../../core/providers/theme_provider.dart';
import '../../../../../theme/app_theme.dart';
import '../../../widgets/logout_dialog.dart';

class AdminSettingPage extends StatefulWidget {
  const AdminSettingPage({super.key});

  @override
  State<AdminSettingPage> createState() => _AdminSettingPageState();
}

class _AdminSettingPageState extends State<AdminSettingPage> {
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Admin Profile Card
            _buildProfileCard(context, auth),
            const SizedBox(height: 20),
            
            // Settings Sections
            _buildSettingsSection(context),
            const SizedBox(height: 20),
            
            // Account Management Section
            _buildAccountSection(context),
            const SizedBox(height: 20),
            
            // Security Section
            _buildSecuritySection(context),
            const SizedBox(height: 20),
            
            // Support Section
            _buildSupportSection(context),
            const SizedBox(height: 32),
            
            // Logout Section
            _buildLogoutSection(context, auth),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, AuthProvider auth) {
    final theme = Theme.of(context);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Admin Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.kIndigo, AppTheme.kCyan],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    'A',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Status Indicator
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppTheme.kLime,
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Admin Info
          Text(
            'Admin Panel',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.kIndigo.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.kIndigo.withValues(alpha: 0.3)),
            ),
            child: Text(
              auth.role,
              style: TextStyle(
                color: AppTheme.kIndigo,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 8),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.circle,
                size: 8,
                color: AppTheme.kLime,
              ),
              const SizedBox(width: 6),
              Text(
                auth.isAuthenticated ? 'Aktif' : 'Tidak Aktif',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.kLime,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final theme = Theme.of(context);

    return _buildSectionCard(
      context,
      title: 'Pengaturan Aplikasi',
      subtitle: 'Preferensi umum aplikasi',
      icon: Icons.settings,
      color: AppTheme.kCyan,
      children: [
        _buildSettingTile(
          context,
          icon: Icons.notifications,
          title: 'Notifikasi',
          subtitle: 'Atur notifikasi push',
          trailing: Switch(
            value: true,
            onChanged: (value) {},
            activeThumbColor: AppTheme.kCyan,
          ),
        ),
        _buildSettingTile(
          context,
          icon: Icons.language,
          title: 'Bahasa',
          subtitle: 'Indonesia',
          trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
          onTap: () {},
        ),
        _buildThemeTile(context, themeProvider, theme),
      ],
    );
  }

  Widget _buildThemeTile(BuildContext context, ThemeProvider themeProvider, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showThemeDialog(context, themeProvider),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.palette,
                    color: AppTheme.kIndigo,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tema',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        themeProvider.themeMode.label,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context, ThemeProvider themeProvider) {
    final theme = Theme.of(context);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          'Pilih Tema',
          style: TextStyle(color: theme.colorScheme.onSurface),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThemeOption(
              context,
              icon: Icons.light_mode,
              title: 'Mode Terang',
              subtitle: 'Tampilan terang untuk siang hari',
              isSelected: themeProvider.themeMode == ThemeModeOption.light,
              onTap: () {
                themeProvider.setThemeMode(ThemeModeOption.light);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 8),
            _buildThemeOption(
              context,
              icon: Icons.dark_mode,
              title: 'Mode Gelap',
              subtitle: 'Tampilan gelap untuk malam hari',
              isSelected: themeProvider.themeMode == ThemeModeOption.dark,
              onTap: () {
                themeProvider.setThemeMode(ThemeModeOption.dark);
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 8),
            _buildThemeOption(
              context,
              icon: Icons.brightness_auto,
              title: 'Mode Sistem',
              subtitle: 'Ikuti pengaturan sistem',
              isSelected: themeProvider.themeMode == ThemeModeOption.system,
              onTap: () {
                themeProvider.setThemeMode(ThemeModeOption.system);
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(color: theme.colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.kIndigo.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppTheme.kIndigo : Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.kIndigo.withValues(alpha: 0.2)
                      : theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? AppTheme.kIndigo : theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected ? AppTheme.kIndigo : theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: AppTheme.kIndigo,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    final theme = Theme.of(context);

    return _buildSectionCard(
      context,
      title: 'Manajemen Akun',
      subtitle: 'Pengaturan akun dan profil',
      icon: Icons.person,
      color: AppTheme.kIndigo,
      children: [
        _buildSettingTile(
          context,
          icon: Icons.edit,
          title: 'Edit Profil',
          subtitle: 'Ubah informasi profil admin',
          trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
          onTap: () {},
        ),
        _buildSettingTile(
          context,
          icon: Icons.lock,
          title: 'Ubah Kata Sandi',
          subtitle: 'Perbarui kata sandi akun',
          trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
          onTap: () {},
        ),
        _buildSettingTile(
          context,
          icon: Icons.history,
          title: 'Aktivitas',
          subtitle: 'Riwayat login dan aktivitas',
          trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSecuritySection(BuildContext context) {
    final theme = Theme.of(context);

    return _buildSectionCard(
      context,
      title: 'Keamanan',
      subtitle: 'Pengaturan keamanan akun',
      icon: Icons.security,
      color: AppTheme.kAmber,
      children: [
        _buildSettingTile(
          context,
          icon: Icons.fingerprint,
          title: 'Autentikasi Dua Faktor',
          subtitle: 'Tingkatkan keamanan akun',
          trailing: Switch(
            value: false,
            onChanged: (value) {},
            activeThumbColor: AppTheme.kAmber,
          ),
        ),
        _buildSettingTile(
          context,
          icon: Icons.devices,
          title: 'Perangkat Terhubung',
          subtitle: 'Kelola perangkat login',
          trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
          onTap: () {},
        ),
        _buildSettingTile(
          context,
          icon: Icons.restore,
          title: 'Sesi Aktif',
          subtitle: 'Kelola sesi login',
          trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    final theme = Theme.of(context);

    return _buildSectionCard(
      context,
      title: 'Bantuan & Dukungan',
      subtitle: 'Hubungi kami atau pelajari lebih lanjut',
      icon: Icons.help,
      color: AppTheme.kLime,
      children: [
        _buildSettingTile(
          context,
          icon: Icons.help_center,
          title: 'Pusat Bantuan',
          subtitle: 'FAQ dan panduan penggunaan',
          trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
          onTap: () {},
        ),
        _buildSettingTile(
          context,
          icon: Icons.contact_support,
          title: 'Kontak Dukungan',
          subtitle: 'Hubungi tim support',
          trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
          onTap: () {},
        ),
        _buildSettingTile(
          context,
          icon: Icons.info,
          title: 'Tentang Aplikasi',
          subtitle: 'Versi dan informasi aplikasi',
          trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildLogoutSection(BuildContext context, AuthProvider auth) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppTheme.kRose.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.kRose.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.logout,
                  color: AppTheme.kRose,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Keluar dari Akun',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Keluar dari aplikasi dan hapus data login',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: auth.isLoggingOut 
                ? null 
                : () => LogoutDialog.showForAdmin(context),
              icon: auth.isLoggingOut
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.logout, color: Colors.white),
              label: Text(
                auth.isLoggingOut ? 'Logging out...' : 'Logout',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.kRose,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Section Content
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: AppTheme.kIndigo,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (trailing != null) trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

