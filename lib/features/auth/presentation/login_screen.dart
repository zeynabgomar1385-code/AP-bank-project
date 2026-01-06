import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/widgets_imports.dart';
import 'package:flutter_application_1/features/auth/presentation/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _loading = false;

  final Map<String, String> _fakeUsers = {
    'admin': '1234',
    'zey': '1234',
    'user': 'password',
  };

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    setState(() {
      _loading = true;
    });

    final username = _usernameCtrl.text.trim();
    final password = _passwordCtrl.text.trim();

    try {
      await Future.delayed(const Duration(milliseconds: 600));

      final ok = _fakeUsers[username] == password;

      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      if (ok) {
        Navigator.of(context).pushReplacementNamed(
          '/home',
          arguments: {
            'username': username,
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('نام کاربری یا رمز اشتباه است')),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      print('Login error: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('خطا در اتصال به سرور')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.account_balance, size: 60),
                  const SizedBox(height: 16),
                  Text(
                    'AP Bank',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 24),
                  AppTextField(
                    controller: _usernameCtrl,
                    label: 'Username',
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: _passwordCtrl,
                    label: 'Password',
                    obscure: true,
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    text: 'Login',
                    isLoading: _loading,
                    onPressed: _onLogin,
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: const Text('Create new account'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
