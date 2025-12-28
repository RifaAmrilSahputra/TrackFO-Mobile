import 'package:flutter/material.dart';
import '../../core/services/auth_service.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/navigation/app_navigator.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final authService = AuthService();

  bool loading = false;

  Future<void> login() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      // capture provider and messenger synchronously to avoid using BuildContext after await
      final authProv = context.read<AuthProvider>();
      final messenger = ScaffoldMessenger.of(context);

      final res = await authService.login(emailCtrl.text.trim(), passCtrl.text);

      // debug: log and briefly show that we got a response
      // (do not expose tokens in production)
      // ignore: avoid_print
      print('DEBUG: login response => $res');
      messenger.showSnackBar(
        const SnackBar(content: Text('Menerima respons dari server')),
      );

      // persist token & role in provider
      final token = res['token'] as String?;
      final role = res['user']?['role'] as String? ?? 'user';

      if (token == null) {
        throw Exception('Token tidak ditemukan');
      }

      await authProv.setAuth(token: token, role: role);

      if (!mounted) {
        return;
      }

      AppNavigator.navigateToHome(context, role);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Login gagal: ${e.toString()}')));
      }
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 28,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 28,
                        backgroundColor: theme.colorScheme.primary,
                        child: Text(
                          'TF',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Text(
                        'TrackFi',
                        style: theme.textTheme.headlineSmall,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            controller: emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              hintText: 'Email',
                            ),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Masukkan email';
                              }
                              if (!RegExp(
                                r"^[\w-.]+@([\w-]+\.)+[\w-]{2,4}",
                              ).hasMatch(v.trim())) {
                                return 'Email tidak valid';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: passCtrl,
                            decoration: const InputDecoration(
                              hintText: 'Password',
                            ),
                            obscureText: true,
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
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: loading ? null : login,
                              child: loading
                                  ? CircularProgressIndicator(
                                      strokeWidth: 2.2,
                                      valueColor: AlwaysStoppedAnimation(
                                        theme.colorScheme.onPrimary,
                                      ),
                                    )
                                  : const Text('Login'),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: null,
                            child: const Text('Lupa password?'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
