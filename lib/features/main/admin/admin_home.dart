import 'package:flutter/material.dart';
import '../widgets/admin_components.dart';

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

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  static const Color bg = Color(0xFFF8FAFF);
  static const Color indigo = Color(0xFF4F46E5);
  static const Color indigoLight = Color(0xFF818CF8);
  static const Color cyan = Color(0xFF06B6D4);
  static const Color lime = Color(0xFF10B981);
  static const Color amber = Color(0xFFF59E0B);
  static const Color rose = Color(0xFFF43F5E);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
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
                  StatCard('Total Users', '1,245', Icons.people, cyan),
                  StatCard('Active Users', '312', Icons.flash_on, lime),
                  StatCard('Reports', '27', Icons.warning, rose),
                  StatCard('Dosen', '48', Icons.school, indigo),
                  StatCard('Mahasiswa', '1.1K', Icons.groups, amber),
                  StatCard(
                    'Blocked',
                    '5',
                    Icons.block,
                    const Color(0xFFEF4444),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // === CHARTS SECTION ===
              const Text(
                'Analytics',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
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
                    MiniLineChart(indigo),
                  ),
                  ChartCard(
                    'Reports Trend',
                    'Monthly overview',
                    MiniLineChart(rose),
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
                    MiniBarChart(cyan),
                  ),
                  ChartCard(
                    'Growth Rate',
                    'Weekly progress',
                    MiniBarChart(lime),
                  ),
                  ChartCard(
                    'Active Sessions',
                    'Current status',
                    MiniDonutChart(amber),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // === RECENT ACTIVITIES ===
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Activities',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 12,
                        color: indigo,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.05 * 255).round()),
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
                      kCyan,
                      '2 min ago',
                    ),
                    ActivityTile(
                      'Report submitted',
                      'New report from Siti Aminah',
                      Icons.report,
                      kRose,
                      '15 min ago',
                    ),
                    ActivityTile(
                      'System backup',
                      'Automatic backup completed successfully',
                      Icons.backup,
                      kLime,
                      '1 hour ago',
                    ),
                    ActivityTile(
                      'Admin login',
                      'Successful login from new device',
                      Icons.login,
                      kIndigo,
                      '2 hours ago',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // === QUICK ACTIONS ===
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.05 * 255).round()),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    QuickActionBtn(Icons.person_add, 'Add User', cyan),
                    QuickActionBtn(Icons.edit, 'Manage', indigo),
                    QuickActionBtn(Icons.analytics, 'Analytics', amber),
                    QuickActionBtn(Icons.settings, 'Settings', lime),
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
