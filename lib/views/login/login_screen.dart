import 'package:flutter/material.dart';
import 'forgot_password_screen.dart';
import '../dashboard/home_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _merchantIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isFilled = false;

  @override
  void initState() {
    super.initState();
    _merchantIdController.addListener(_checkFilled);
    _passwordController.addListener(_checkFilled);
  }

  void _checkFilled() {
    setState(() {
      _isFilled = _merchantIdController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _merchantIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // 1️⃣ Logo di atas panel input
              Image.asset(
                'Assets/Icons/Logo login.png',
                width: 100,
              ),

              const SizedBox(height: 40),

              // 2️⃣ Merchant ID
              TextField(
                controller: _merchantIdController,
                decoration: const InputDecoration(
                  labelText: 'Merchant ID',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // 3️⃣ Password + toggle eye
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // 4️⃣ Lupa Password
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ForgotPasswordScreen()),
                    );
                  },
                  child: const Text('Lupa Password?'),
                ),
              ),
              const SizedBox(height: 16),

              // 5️⃣ Tombol Masuk
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isFilled ? const Color(0xFF66BB6A) : Colors.grey,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _isFilled
                      ? () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const HomeDashboard()),
                          );
                        }
                      : null,
                  child: const Text('Masuk'),
                ),
              ),
              const SizedBox(height: 8),

              // 6️⃣ Tombol Daftar Merchant
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: buka website BSI pakai url_launcher
                  },
                  child: const Text('Daftar Merchant'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
