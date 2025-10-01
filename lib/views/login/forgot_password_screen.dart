import 'package:flutter/material.dart';
import 'otp_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _merchantIdController = TextEditingController();
  bool _isFilled = false;

  @override
  void initState() {
    super.initState();
    _merchantIdController.addListener(() {
      setState(() {
        _isFilled = _merchantIdController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _merchantIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lupa Password'),
        backgroundColor: const Color.fromARGB(245, 254, 255, 255),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // Label Merchant ID
            const Text(
              'Merchant ID',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),

            // Input Merchant ID
            TextField(
              controller: _merchantIdController,
              decoration: const InputDecoration(
                hintText: 'Masukkan Merchant ID',
                border: OutlineInputBorder(),
              ),
            ),

            const Spacer(),

            // Tombol Lanjutkan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isFilled
                      ? const Color(0xFF66BB6A) // hijau lembut
                      : Colors.grey, // abu-abu
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: _isFilled
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const OtpScreen()),
                          );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Merchant ID: ${_merchantIdController.text}',
                            ),
                          ),
                        );
                      }
                    : null,
                child: const Text('Lanjutkan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
