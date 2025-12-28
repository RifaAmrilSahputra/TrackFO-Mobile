import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/auth_provider.dart';
import 'admin/admin_home.dart';
import 'user/user_home.dart';
import 'widgets/main_app_bar.dart';
import 'widgets/main_bottom_nav.dart';
import 'widgets/main_header.dart';

/// MainShell is the primary app layout that contains AppBar, BottomNav,
/// and area for main pages like Dashboard, Tasks, Profile.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  static const List<String> _titles = ['Dashboard', 'Tasks', 'Profile'];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    Widget body;
    switch (_currentIndex) {
      case 1:
        body = const Center(child: Text('Tasks page (placeholder)'));
        break;
      case 2:
        body = Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Role: ${auth.role}'),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  await auth.logout();
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        );
        break;
      case 0:
      default:
        // Dashboard: role-aware content
        body = auth.role == 'admin' ? const AdminHome() : const UserHome();
    }

    return Scaffold(
      appBar: MainAppBar(title: _titles[_currentIndex]),
      body: SafeArea(
        child: Column(
          children: [
            MainHeader(title: _titles[_currentIndex], subtitle: auth.role),
            Expanded(child: body),
          ],
        ),
      ),
      bottomNavigationBar: MainBottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}
