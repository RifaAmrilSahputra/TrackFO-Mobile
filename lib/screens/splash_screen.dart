import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/providers/auth_provider.dart';
import '../theme/app_theme.dart';

/// Minimalist splash screen dengan tema yang konsisten dengan halaman login.
/// Saat splash screen tampil, sistem memvalidasi status login di background.
/// Splash screen akan ditampilkan minimal selama 1.5 detik untuk UX yang baik.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Validasi login di background
    final authProvider = context.read<AuthProvider>();
    
    // Jalankan validasi dengan durasi minimum 1.5 detik
    await Future.wait([
      authProvider.validateAndRefresh(),
      Future.delayed(const Duration(milliseconds: 1500)),
    ]);
    
    // Navigation akan ditangani oleh AuthGate yang mendengarkan perubahan state
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.kBg,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.kIndigo,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 40,
                ),
              ),

              const SizedBox(height: 24),

              // App Name
              Text(
                'TrackFO',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.kTextPrimary,
                  letterSpacing: -0.5,
                ),
              ),

              const SizedBox(height: 8),

              // Tagline
              Text(
                'Sistem Pelacakan Teknisi',
                style: TextStyle(
                  fontSize: 14,
                  color: AppTheme.kTextSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 48),

              // Loading indicator
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation(AppTheme.kIndigo),
                ),
              ),

              const SizedBox(height: 16),

              // Loading text
              Text(
                'Memuat...',
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.kTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

