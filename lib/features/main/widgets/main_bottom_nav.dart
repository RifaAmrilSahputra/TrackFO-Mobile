import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/auth_provider.dart';

/// Reusable Bottom Navigation used by `MainShell`.
class MainBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const MainBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final role = context.watch<AuthProvider>().role;

    final adminItems = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(
        icon: Icon(Icons.dashboard_outlined),
        label: 'Dashboard',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.report_problem_outlined),
        label: 'Gangguan',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.engineering_outlined),
        label: 'Teknisi',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.settings_outlined),
        label: 'Setting',
      ),
    ];

    final teknisiItems = <BottomNavigationBarItem>[
      const BottomNavigationBarItem(
        icon: Icon(Icons.dashboard_outlined),
        label: 'Dashboard',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.report_problem_outlined),
        label: 'Gangguan',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.map_outlined),
        label: 'Map',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        label: 'Akun',
      ),
    ];

    final items = role == 'admin' ? adminItems : teknisiItems;

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: theme.colorScheme.primary,
      unselectedItemColor: theme.disabledColor,
      showUnselectedLabels: true,
      elevation: 8,
      items: items,
    );
  }
}
