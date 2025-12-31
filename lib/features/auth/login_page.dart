import 'package:flutter/material.dart';
import '../../core/services/auth_service.dart';
import '../../core/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final authService = AuthService();

  bool loading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  Future<void> login() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      final authProv = context.read<AuthProvider>();
      final messenger = ScaffoldMessenger.of(context);

      final res = await authService.login(emailCtrl.text.trim(), passCtrl.text);

      messenger.showSnackBar(
        SnackBar(
          content: const Text('Login berhasil! Mengalihkan...'),
          backgroundColor: AppTheme.kLime,
        ),
      );

      final token = res['token'] as String?;
      final role = res['user']?['role'] as String? ?? 'user';

      if (token == null) {
        throw Exception('Token tidak ditemukan');
      }

      await authProv.setAuth(token: token, role: role);

      if (!mounted) return;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login gagal: ${e.toString()}'),
            backgroundColor: AppTheme.kRose,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> _showForgotPasswordDialog() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lupa Password'),
        content: const Text('Fitur lupa password belum tersedia. Silakan hubungi administrator.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.kBg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Simplified Logo
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppTheme.kIndigo,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 30,
                  ),
                ),

                const SizedBox(height: 16),

                // App Name
                Text(
                  'TrackFO',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.kTextPrimary,
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Sistem Pelacakan Teknisi',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.kTextSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 28),

                // Minimal Login Card
                Container(
                  width: 320,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Masuk',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.kTextPrimary,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 20),

                        // Email Field
                        TextFormField(
                          controller: emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Email',
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              size: 20,
                              color: AppTheme.kIndigo,
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: AppTheme.kIndigo, width: 2),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Masukkan email';
                            }
                            if (!RegExp(r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}").hasMatch(v.trim())) {
                              return 'Email tidak valid';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 12),

                        // Password Field with Enter key support
                        TextFormField(
                          controller: passCtrl,
                          obscureText: _obscurePassword,
                          onFieldSubmitted: (_) => login(),
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'Password',
                            prefixIcon: Icon(
                              Icons.lock_outlined,
                              size: 20,
                              color: AppTheme.kIndigo,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                                size: 20,
                                color: AppTheme.kTextSecondary,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: AppTheme.kIndigo, width: 2),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Masukkan password';
                            }
                            if (v.length < 6) {
                              return 'Password minimal 6 karakter';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Minimal Login Button
                        ElevatedButton(
                          onPressed: loading ? null : login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.kIndigo,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: loading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation(Colors.white),
                                  ),
                                )
                              : const Text(
                                  'Masuk',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                        ),

                        const SizedBox(height: 12),

                        // Forgot Password
                        Center(
                          child: TextButton(
                            onPressed: _showForgotPasswordDialog,
                            child: Text(
                              'Lupa password?',
                              style: TextStyle(
                                color: AppTheme.kIndigo,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Footer
                Text(
                  'TrackFO v1.0',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.kTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
