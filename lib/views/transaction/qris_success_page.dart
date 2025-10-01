// lib/pages/success/success_page.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import '../../viewmodels/transaction/transaction.dart';
import '../../viewmodels/transaction/transaction_repository.dart';
import '../history/transaction_history_page.dart';
import '../dashboard/home_dashboard.dart';

class SuccessPage extends StatefulWidget {
  final int nominal;

  const SuccessPage({super.key, required this.nominal});

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  late ConfettiController _confettiController;

  static final List<String> dummyNames = [
    "Monica Adina",
    "Budi Santoso",
    "Rina Kartika",
  ];

  static final List<String> dummyBanks = [
    "BCA",
    "OVO",
    "Gopay",
  ];

  String get randomName => dummyNames[Random().nextInt(dummyNames.length)];
  String get randomBank => dummyBanks[Random().nextInt(dummyBanks.length)];

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    _confettiController.play();

    // Simpan transaksi ke repository
    final now = DateTime.now();
    final tx = Transaction(
      customerName: randomName,
      bank: randomBank,
      time: "${now.hour}:${now.minute.toString().padLeft(2, '0')}",
      type: "Pembayaran Masuk", // atau "Refund" sesuai flow
      amount: widget.nominal,
      date: now,
    );
    TransactionRepository().addTransaction(tx);
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  String _formatRupiah(int value) {
    return "Rp ${value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => "${m[1]}.",
    )}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Stack(
        children: [
          Column(
            children: [
              // Header hijau
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 60, bottom: 40),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF01BDB1), Color(0xFF007C80)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check,
                          size: 64, color: Colors.green),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Transaksi Berhasil!",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Kartu info transaksi
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Nominal Transaksi",
                          style: TextStyle(
                              fontSize: 14, color: Colors.black54)),
                      const SizedBox(height: 6),
                      Text(
                        "+ ${_formatRupiah(widget.nominal)}",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const Divider(height: 40),
                      // Info customer dummy
                      Text(
                        TransactionRepository()
                            .transactions
                            .last
                            .customerName,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        TransactionRepository().transactions.last.bank,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54),
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const TransactionHistoryPage(),
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: Color(0xFFFFB726), width: 2),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "Lihat Detail Transaksi",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFFFB726),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (_) => const HomeDashboard(),
                                  ),
                                  (route) => false,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFB726),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "Kembali ke Dashboard",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
              ],
              numberOfParticles: 20,
              gravity: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
