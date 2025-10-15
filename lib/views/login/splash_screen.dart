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
        fit: StackFit.expand, // Penting: Memastikan children mengisi penuh
        children: [
          // 1️⃣ Background gradient
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

          // 2️⃣ Background vector - TANPA Container wrapper
          Positioned.fill(
            child: Image.asset(
              'Assets/Icons/Vector 894 (Stroke).png',
              fit: BoxFit.cover, // Cover full screen
              alignment: Alignment.center,
            ),
          ),

          // 3️⃣ Logo di tengah
          Center(
            child: Image.asset(
              'Assets/Icons/Logo.png',
              width: 150,
            ),
          ),
        ],
      ),
    );
  }
}