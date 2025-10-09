// lib/views/refund/refund_success_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../viewmodels/transaction/transaction.dart';
import '../../viewmodels/transaction/transaction_repository.dart';
import '../dashboard/home_dashboard.dart';
import '../history/transaction_history_page.dart';

class RefundSuccessPage extends StatefulWidget {
  final Transaction transaction;
  final int refundAmount;

  const RefundSuccessPage({
    super.key,
    required this.transaction,
    required this.refundAmount,
  });

  @override
  State<RefundSuccessPage> createState() => _RefundSuccessPageState();
}

class _RefundSuccessPageState extends State<RefundSuccessPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // 🔹 Tambahkan transaksi refund ke repository
    final refundTx = Transaction(
      customerName: widget.transaction.customerName,
      bank: widget.transaction.bank,
      time: DateFormat('HH:mm').format(DateTime.now()),
      type: "Refund",
      amount: widget.refundAmount,
      date: DateTime.now(),
    );
    TransactionRepository().addTransaction(refundTx);

    // 🔹 Animasi centang
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatRupiah(int amount) =>
      "Rp ${NumberFormat('#,###', 'id_ID').format(amount)}";

  @override
  Widget build(BuildContext context) {
    final tx = widget.transaction;
    final refundAmount = widget.refundAmount;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // 🔹 Header hijau toska + centang
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 100, bottom: 40),
            decoration: BoxDecoration(
              color: const Color(0xFF01BDB1).withOpacity(0.6),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: Column(
              children: [
                ScaleTransition(
                  scale: CurvedAnimation(
                    parent: _controller,
                    curve: Curves.elasticOut,
                  ),
                  child: const Icon(Icons.check_circle,
                      size: 100, color: Colors.white),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Refund Berhasil!",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 🔹 Detail transaksi awal & refund
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text("Transaksi Awal",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.arrow_downward,
                        color: Colors.green),
                    title: Text(tx.customerName),
                    subtitle: Text(tx.bank),
                    trailing: Text(
                      "+ ${_formatRupiah(tx.amount)}",
                      style: const TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                const Text("Transaksi Refund",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.arrow_upward,
                        color: Colors.redAccent),
                    title: Text(tx.customerName),
                    subtitle: Text(tx.bank),
                    trailing: Text(
                      "- ${_formatRupiah(refundAmount)}",
                      style: const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 🔹 Tombol aksi
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (_) => const HomeDashboard()),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      "Kembali ke Dashboard",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => TransactionHistoryPage(
                          ),
                        ),
                        (route) => route.isFirst,
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Colors.teal),
                    ),
                    child: const Text(
                      "Lihat Transaksi",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
