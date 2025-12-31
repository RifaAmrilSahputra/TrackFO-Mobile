import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/providers/auth_provider.dart';
import '../../../widgets/admin_components.dart';
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
    
    return Scaffold(
      backgroundColor: kBg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Teknisi Profile Card
            _buildProfileCard(context, auth),
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
        color: Colors.white,
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
          // Teknisi Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [kCyan, kLime],
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
                // Status Indicator
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: kLime,
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Teknisi Info
          Text(
            'Teknisi TrackFi',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: kTextPrimary,
            ),
          ),
          const SizedBox(height: 8),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: kCyan.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kCyan.withValues(alpha: 0.3)),
            ),
            child: Text(
              auth.role,
              style: TextStyle(
                color: kCyan,
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
                color: kLime,
              ),
              const SizedBox(width: 6),
              Text(
                auth.isAuthenticated ? 'Online' : 'Offline',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: kLime,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return _buildSectionCard(
      context,
      title: 'Manajemen Akun',
      subtitle: 'Pengaturan akun dan profil teknisi',
      icon: Icons.person,
      color: kCyan,
      children: [
        _buildSettingTile(
          context,
          icon: Icons.edit,
          title: 'Edit Profil',
          subtitle: 'Ubah informasi profil teknisi',
          trailing: const Icon(Icons.chevron_right, color: kTextSecondary),
          onTap: () => _showComingSoon(context, 'Edit Profil'),
        ),
        _buildSettingTile(
          context,
          icon: Icons.work,
          title: 'Informasi Teknisi',
          subtitle: 'Lihat detail area kerja dan spesialisasi',
          trailing: const Icon(Icons.chevron_right, color: kTextSecondary),
          onTap: () => _showComingSoon(context, 'Informasi Teknisi'),
        ),
        _buildSettingTile(
          context,
          icon: Icons.history,
          title: 'Riwayat Tugas',
          subtitle: 'Lihat aktivitas dan tugas sebelumnya',
          trailing: const Icon(Icons.chevron_right, color: kTextSecondary),
          onTap: () => _showComingSoon(context, 'Riwayat Tugas'),
        ),
      ],
    );
  }

  Widget _buildSecuritySection(BuildContext context) {
    return _buildSectionCard(
      context,
      title: 'Keamanan',
      subtitle: 'Pengaturan keamanan akun teknisi',
      icon: Icons.security,
      color: kAmber,
      children: [
        _buildSettingTile(
          context,
          icon: Icons.lock,
          title: 'Ubah Kata Sandi',
          subtitle: 'Perbarui kata sandi akun',
          trailing: const Icon(Icons.chevron_right, color: kTextSecondary),
          onTap: () => _showComingSoon(context, 'Ubah Kata Sandi'),
        ),
        _buildSettingTile(
          context,
          icon: Icons.notifications,
          title: 'Notifikasi Tugas',
          subtitle: 'Atur notifikasi untuk tugas baru',
          trailing: Switch(
            value: true,
            onChanged: (value) {},
            activeThumbColor: kCyan,
          ),
        ),
        _buildSettingTile(
          context,
          icon: Icons.access_time,
          title: 'Status Kehadiran',
          subtitle: 'Atur status online/offline',
          trailing: const Icon(Icons.chevron_right, color: kTextSecondary),
          onTap: () => _showComingSoon(context, 'Status Kehadiran'),
        ),
      ],
    );
  }

  Widget _buildSupportSection(BuildContext context) {
    return _buildSectionCard(
      context,
      title: 'Bantuan & Dukungan',
      subtitle: 'Hubungi support atau pelajari lebih lanjut',
      icon: Icons.help,
      color: kLime,
      children: [
        _buildSettingTile(
          context,
          icon: Icons.help_center,
          title: 'Pusat Bantuan',
          subtitle: 'FAQ dan panduan teknisi',
          trailing: const Icon(Icons.chevron_right, color: kTextSecondary),
          onTap: () => _showComingSoon(context, 'Pusat Bantuan'),
        ),
        _buildSettingTile(
          context,
          icon: Icons.contact_support,
          title: 'Kontak Supervisor',
          subtitle: 'Hubungi supervisor atau support',
          trailing: const Icon(Icons.chevron_right, color: kTextSecondary),
          onTap: () => _showComingSoon(context, 'Kontak Supervisor'),
        ),
        _buildSettingTile(
          context,
          icon: Icons.info,
          title: 'Tentang Aplikasi',
          subtitle: 'Versi dan informasi aplikasi',
          trailing: const Icon(Icons.chevron_right, color: kTextSecondary),
          onTap: () => _showComingSoon(context, 'Tentang Aplikasi'),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: kRose.withValues(alpha: 0.2)),
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
                  color: kRose.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.logout,
                  color: kRose,
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
                        color: kTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Keluar dari aplikasi teknisi',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: kTextSecondary,
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
                : () => LogoutDialog.showForTeknisi(context),
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
                backgroundColor: kRose,
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
        color: Colors.white,
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
                          color: kTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: kTextSecondary,
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
                    color: kBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: kCyan,
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
                          color: kTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: kTextSecondary,
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

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature akan segera tersedia!'),
        backgroundColor: kCyan,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

