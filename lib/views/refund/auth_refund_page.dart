// lib/views/refund/auth_refund_page.dart
import 'package:flutter/material.dart';
import '../../viewmodels/transaction/transaction.dart';
import 'refund_success_page.dart';

class AuthRefundPage extends StatefulWidget {
  final Transaction transaction;
  final int refundAmount;

  const AuthRefundPage({
    super.key,
    required this.transaction,
    required this.refundAmount,
  });

  @override
  State<AuthRefundPage> createState() => _AuthRefundPageState();
}

class _AuthRefundPageState extends State<AuthRefundPage> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isFilled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Autentikasi Refund")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Masukkan Password",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // 🔹 Input password
            TextField(
              controller: _passwordController,
              obscureText: true,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Password Merchant",
              ),
              onChanged: (val) {
                setState(() {
                  _isFilled = val.isNotEmpty;
                });
              },
              onSubmitted: (_) {
                if (_isFilled) {
                  _onAuthSuccess(context);
                }
              },
            ),

            const Spacer(),

            // 🔹 Tombol Done
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isFilled ? () => _onAuthSuccess(context) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  disabledBackgroundColor: Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Done",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onAuthSuccess(BuildContext context) {
    // 🔹 Setelah autentikasi berhasil → masuk ke halaman sukses
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => RefundSuccessPage(
          transaction: widget.transaction,
          refundAmount: widget.refundAmount,
        ),
      ),
    );
  }
}
