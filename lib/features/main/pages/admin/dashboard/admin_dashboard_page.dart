import 'package:flutter/material.dart';
import '../../../widgets/admin_components.dart';
import 'package:trackfi/theme/app_theme.dart';

/// Simple responsive grid wrapper to avoid horizontal overflow on small screens.
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int maxColumns;
  final double spacing;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.maxColumns = 3,
    this.spacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final int cols;
        if (maxWidth < 600) {
          cols = 1;
        } else if (maxWidth < 900) {
          cols = (maxColumns >= 2) ? 2 : maxColumns;
        } else {
          cols = maxColumns;
        }

        final itemWidth = (maxWidth - spacing * (cols - 1)) / cols;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: children
              .map((c) => SizedBox(width: itemWidth, child: c))
              .toList(),
        );
      },
    );
  }
}

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top header removed as requested.
              // Use responsive grid to avoid horizontal overflow on small screens.
              ResponsiveGrid(
                maxColumns: 3,
                spacing: 12,
                children: [
                  StatCard('Total Users', '1,245', Icons.people, AppTheme.kCyan),
                  StatCard('Active Users', '312', Icons.flash_on, AppTheme.kLime),
                  StatCard('Reports', '27', Icons.warning, AppTheme.kRose),
                  StatCard('Dosen', '48', Icons.school, AppTheme.kIndigo),
                  StatCard('Mahasiswa', '1.1K', Icons.groups, AppTheme.kAmber),
                  StatCard(
                    'Blocked',
                    '5',
                    Icons.block,
                    AppTheme.kRose,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // === CHARTS SECTION ===
              Text(
                'Analytics',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              // Charts: responsive layout to prevent overflow
              ResponsiveGrid(
                maxColumns: 2,
                spacing: 12,
                children: [
                  ChartCard(
                    'User Activity',
                    'Last 7 days',
                    MiniLineChart(AppTheme.kIndigo),
                  ),
                  ChartCard(
                    'Reports Trend',
                    'Monthly overview',
                    MiniLineChart(AppTheme.kRose),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ResponsiveGrid(
                maxColumns: 3,
                spacing: 12,
                children: [
                  ChartCard(
                    'Login Frequency',
                    'Daily average',
                    MiniBarChart(AppTheme.kCyan),
                  ),
                  ChartCard(
                    'Growth Rate',
                    'Weekly progress',
                    MiniBarChart(AppTheme.kLime),
                  ),
                  ChartCard(
                    'Active Sessions',
                    'Current status',
                    MiniDonutChart(AppTheme.kAmber),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // === RECENT ACTIVITIES ===
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Activities',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'View All',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    ActivityTile(
                      'New user registered',
                      'Budi Santoso just joined as Mahasiswa',
                      Icons.person_add,
                      AppTheme.kCyan,
                      '2 min ago',
                    ),
                    ActivityTile(
                      'Report submitted',
                      'New report from Siti Aminah',
                      Icons.report,
                      AppTheme.kRose,
                      '15 min ago',
                    ),
                    ActivityTile(
                      'System backup',
                      'Automatic backup completed successfully',
                      Icons.backup,
                      AppTheme.kLime,
                      '1 hour ago',
                    ),
                    ActivityTile(
                      'Admin login',
                      'Successful login from new device',
                      Icons.login,
                      AppTheme.kIndigo,
                      '2 hours ago',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // === QUICK ACTIONS ===
              Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    QuickActionBtn(Icons.person_add, 'Add User', AppTheme.kCyan),
                    QuickActionBtn(Icons.edit, 'Manage', AppTheme.kIndigo),
                    QuickActionBtn(Icons.analytics, 'Analytics', AppTheme.kAmber),
                    QuickActionBtn(Icons.settings, 'Settings', AppTheme.kLime),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
