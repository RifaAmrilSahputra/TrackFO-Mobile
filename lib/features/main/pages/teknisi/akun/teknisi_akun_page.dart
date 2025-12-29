import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../core/providers/auth_provider.dart';

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
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Role: ${auth.role}'),
            const SizedBox(height: 24),
            if (auth.isAuthenticated) ...[
              Text('Logged in as: ${auth.role}'),
              const SizedBox(height: 24),
            ],
            ElevatedButton.icon(
              onPressed: auth.isLoggingOut 
                ? null 
                : () => _showLogoutDialog(context, auth),
              icon: auth.isLoggingOut
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.logout),
              label: Text(
                auth.isLoggingOut ? 'Logging out...' : 'Logout',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider auth) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                _performLogout(context, auth);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Logout', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _performLogout(BuildContext context, AuthProvider auth) async {
    if (!mounted) return; // Check if widget is still mounted
    
    // Get messenger before any async operations
    final messenger = ScaffoldMessenger.of(context);
    
    try {
      // Show loading indicator
      if (mounted) {
        messenger.showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 12),
                Text('Memproses logout...'),
              ],
            ),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.blue,
          ),
        );
      }
      
      await auth.logout();
      
      // Show success message
      if (mounted) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Berhasil logout'),
            backgroundColor: Colors.green,
          ),
        );
      }
      
      // Let AuthGate handle navigation automatically based on auth state change
    } catch (e) {
      // Show error message only if still mounted
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text('Error saat logout: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
