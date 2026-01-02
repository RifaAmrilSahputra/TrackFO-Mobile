import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/providers/auth_provider.dart';
import '../../../../../core/providers/theme_provider.dart';
import '../../../widgets/logout_dialog.dart';

class TeknisiAkunPage extends StatefulWidget {
  const TeknisiAkunPage({super.key});

  @override
  State<TeknisiAkunPage> createState() => _TeknisiAkunPageState();
}

class _TeknisiAkunPageState extends State<TeknisiAkunPage> {
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final theme = Theme.of(context);
    
    final primaryColor = theme.colorScheme.primary;
    final secondaryColor = theme.colorScheme.secondary;
    final tertiaryColor = theme.colorScheme.tertiary;
    final errorColor = theme.colorScheme.error;
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileCard(context, auth, primaryColor, secondaryColor, tertiaryColor),
            const SizedBox(height: 20),
            _buildSettingsSection(context, themeProvider, primaryColor),
            const SizedBox(height: 20),
            _buildAccountSection(context, primaryColor),
            const SizedBox(height: 20),
            _buildSecuritySection(context, tertiaryColor),
            const SizedBox(height: 20),
            _buildSupportSection(context, tertiaryColor),
            const SizedBox(height: 32),
            _buildLogoutSection(context, auth, errorColor),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, AuthProvider auth, Color primaryColor, Color secondaryColor, Color tertiaryColor) {
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
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, tertiaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                Center(
                  child: Text(
                    'T',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: tertiaryColor,
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Teknisi TrackFi',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
            ),
            child: Text(
              auth.role,
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.circle, size: 8, color: tertiaryColor),
              const SizedBox(width: 6),
              Text(
                auth.isAuthenticated ? 'Online' : 'Offline',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: tertiaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context, ThemeProvider themeProvider, Color primaryColor) {
    final theme = Theme.of(context);

    return _buildSectionCard(
      context,
      title: 'Pengaturan Aplikasi',
      subtitle: 'Preferensi umum aplikasi',
      icon: Icons.settings,
      color: primaryColor,
      children: [
        _buildThemeTile(context, themeProvider, theme, primaryColor),
        _buildSettingTile(
          context,
          Icons.notifications,
          'Notifikasi Tugas',
          'Atur notifikasi untuk tugas baru',
          trailing: Switch(
            value: true,
            onChanged: (value) {},
            activeThumbColor: primaryColor,
          ),
          iconColor: primaryColor,
        ),
      ],
    );
  }

  Widget _buildThemeTile(BuildContext context, ThemeProvider themeProvider, ThemeData theme, Color primaryColor) {
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
                  child: Icon(Icons.palette, color: primaryColor, size: 20),
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
    final primaryColor = theme.colorScheme.primary;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text('Pilih Tema', style: TextStyle(color: theme.colorScheme.onSurface)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThemeOption(context, Icons.light_mode, 'Mode Terang', 'Tampilan terang untuk siang hari',
                themeProvider.themeMode == ThemeModeOption.light, primaryColor, () {
              themeProvider.setThemeMode(ThemeModeOption.light);
              Navigator.pop(context);
            }),
            const SizedBox(height: 8),
            _buildThemeOption(context, Icons.dark_mode, 'Mode Gelap', 'Tampilan gelap untuk malam hari',
                themeProvider.themeMode == ThemeModeOption.dark, primaryColor, () {
              themeProvider.setThemeMode(ThemeModeOption.dark);
              Navigator.pop(context);
            }),
            const SizedBox(height: 8),
            _buildThemeOption(context, Icons.brightness_auto, 'Mode Sistem', 'Ikuti pengaturan sistem',
                themeProvider.themeMode == ThemeModeOption.system, primaryColor, () {
              themeProvider.setThemeMode(ThemeModeOption.system);
              Navigator.pop(context);
            }),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: TextStyle(color: theme.colorScheme.primary)),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(BuildContext context, IconData icon, String title, String subtitle,
      bool isSelected, Color primaryColor, VoidCallback onTap) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor.withValues(alpha: 0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? primaryColor : Colors.transparent, width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isSelected ? primaryColor.withValues(alpha: 0.2) : theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: isSelected ? primaryColor : theme.colorScheme.onSurfaceVariant, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isSelected ? primaryColor : theme.colorScheme.onSurface)),
                    Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
              if (isSelected) Icon(Icons.check_circle, color: primaryColor, size: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context, Color primaryColor) {
    final theme = Theme.of(context);

    return _buildSectionCard(
      context,
      title: 'Manajemen Akun',
      subtitle: 'Pengaturan akun dan profil teknisi',
      icon: Icons.person,
      color: primaryColor,
      children: [
        _buildSettingTile(context, Icons.edit, 'Edit Profil', 'Ubah informasi profil teknisi',
            trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
            onTap: () => _showComingSoon(context, 'Edit Profil', primaryColor), iconColor: primaryColor),
        _buildSettingTile(context, Icons.work, 'Informasi Teknisi', 'Lihat detail area kerja dan spesialisasi',
            trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
            onTap: () => _showComingSoon(context, 'Informasi Teknisi', primaryColor), iconColor: primaryColor),
        _buildSettingTile(context, Icons.history, 'Riwayat Tugas', 'Lihat aktivitas dan tugas sebelumnya',
            trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
            onTap: () => _showComingSoon(context, 'Riwayat Tugas', primaryColor), iconColor: primaryColor),
      ],
    );
  }

  Widget _buildSecuritySection(BuildContext context, Color tertiaryColor) {
    final theme = Theme.of(context);

    return _buildSectionCard(
      context,
      title: 'Keamanan',
      subtitle: 'Pengaturan keamanan akun teknisi',
      icon: Icons.security,
      color: tertiaryColor,
      children: [
        _buildSettingTile(context, Icons.lock, 'Ubah Kata Sandi', 'Perbarui kata sandi akun',
            trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
            onTap: () => _showComingSoon(context, 'Ubah Kata Sandi', tertiaryColor), iconColor: tertiaryColor),
        _buildSettingTile(context, Icons.notifications, 'Notifikasi Tugas', 'Atur notifikasi untuk tugas baru',
            trailing: Switch(value: true, onChanged: (value) {}, activeThumbColor: tertiaryColor),
            iconColor: tertiaryColor),
        _buildSettingTile(context, Icons.access_time, 'Status Kehadiran', 'Atur status online/offline',
            trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
            onTap: () => _showComingSoon(context, 'Status Kehadiran', tertiaryColor), iconColor: tertiaryColor),
      ],
    );
  }

  Widget _buildSupportSection(BuildContext context, Color tertiaryColor) {
    final theme = Theme.of(context);

    return _buildSectionCard(
      context,
      title: 'Bantuan & Dukungan',
      subtitle: 'Hubungi support atau pelajari lebih lanjut',
      icon: Icons.help,
      color: tertiaryColor,
      children: [
        _buildSettingTile(context, Icons.help_center, 'Pusat Bantuan', 'FAQ dan panduan teknisi',
            trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
            onTap: () => _showComingSoon(context, 'Pusat Bantuan', tertiaryColor), iconColor: tertiaryColor),
        _buildSettingTile(context, Icons.contact_support, 'Kontak Supervisor', 'Hubungi supervisor atau support',
            trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
            onTap: () => _showComingSoon(context, 'Kontak Supervisor', tertiaryColor), iconColor: tertiaryColor),
        _buildSettingTile(context, Icons.info, 'Tentang Aplikasi', 'Versi dan informasi aplikasi',
            trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
            onTap: () => _showComingSoon(context, 'Tentang Aplikasi', tertiaryColor), iconColor: tertiaryColor),
      ],
    );
  }

  Widget _buildLogoutSection(BuildContext context, AuthProvider auth, Color errorColor) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 4)),
        ],
        border: Border.all(color: errorColor.withValues(alpha: 0.2)),
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
                  color: errorColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.logout, color: errorColor, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Keluar dari Akun',
                        style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface)),
                    const SizedBox(height: 4),
                    Text('Keluar dari aplikasi teknisi',
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: auth.isLoggingOut ? null : () => LogoutDialog.showForTeknisi(context),
              icon: auth.isLoggingOut
                  ? const SizedBox(
                      width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.logout, color: Colors.white),
              label: Text(auth.isLoggingOut ? 'Logging out...' : 'Logout',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              style: ElevatedButton.styleFrom(
                backgroundColor: errorColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(BuildContext context,
      {required String title, required String subtitle, required IconData icon, required Color color, required List<Widget> children}) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface)),
                      Text(subtitle,
                          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile(BuildContext context, IconData icon, String title, String subtitle,
      {Widget? trailing, VoidCallback? onTap, required Color iconColor}) {
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
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500, color: theme.colorScheme.onSurface)),
                      Text(subtitle,
                          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
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

  void _showComingSoon(BuildContext context, String feature, Color primaryColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature akan segera tersedia!'),
        backgroundColor: primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

