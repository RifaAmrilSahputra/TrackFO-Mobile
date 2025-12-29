import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/auth_provider.dart';
import 'pages/admin/dashboard/admin_dashboard_page.dart';
import 'pages/admin/gangguan/admin_gangguan_page.dart';
import 'pages/admin/teknisi/admin_teknisi_page.dart';
import 'pages/admin/setting/admin_setting_page.dart';
import 'pages/teknisi/dashboard/teknisi_dashboard_page.dart';
import 'pages/teknisi/gangguan/teknisi_gangguan_page.dart';
import 'pages/teknisi/map/teknisi_map_page.dart';
import 'pages/teknisi/akun/teknisi_akun_page.dart';
import 'widgets/main_bottom_nav.dart';

/// MainShell is the primary app layout that contains BottomNav,
/// and area for main pages like Dashboard, Tasks, Profile.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    // CRITICAL: If not authenticated, don't show MainShell content
    if (!auth.isAuthenticated) {
      return const SizedBox.shrink(); // Return empty widget
    }

    // CRITICAL: If role is empty, don't show MainShell content
    if (auth.role.isEmpty) {
      return const SizedBox.shrink(); // Return empty widget
    }

    // Titles vary by role
    final titles = auth.role == 'admin'
        ? ['Dashboard', 'Gangguan', 'Teknisi', 'Setting']
        : ['Dashboard', 'Gangguan', 'Map', 'Akun'];

    // Ensure we use a safe index for UI elements (avoid RangeError when role changes)
    final int safeIndex = _currentIndex >= titles.length
        ? titles.length - 1
        : _currentIndex;

    Widget body;
    switch (safeIndex) {
      case 1:
        body = auth.role == 'admin'
            ? const AdminGangguanPage()
            : const TeknisiGangguanPage();
        break;
      case 2:
        body = auth.role == 'admin'
            ? const AdminTeknisiPage()
            : const TeknisiMapPage();
        break;
      case 3:
        body = auth.role == 'admin'
            ? const AdminSettingPage()
            : const TeknisiAkunPage();
        break;
      case 0:
      default:
        body = auth.role == 'admin'
            ? const AdminDashboardPage()
            : const TeknisiDashboardPage();
    }

    return Scaffold(
      body: body,
      bottomNavigationBar: MainBottomNav(
        currentIndex: safeIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}
