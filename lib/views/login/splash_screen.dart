import 'dart:async';
import 'package:flutter/material.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1️⃣ Background warna (gradient hijau toska light → medium)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF4DD0E1), // toska light
                  Color(0xFF0097A7), // toska medium
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // 2️⃣ Background vector full width + bayangan
          Align(
            alignment: Alignment.center,
            child: Container(
              width: double.infinity, // penuh sampai tepi layar
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15), // bayangan tipis
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/Icons/Vector 894 (Stroke).png',
                fit: BoxFit.cover, // isi penuh lebar layar
              ),
            ),
          ),

          // 3️⃣ Logo di atas vector
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/Icons/Logo.png',
              width: 150,
            ),
          ),
        ],
      ),
    );
  }
}
