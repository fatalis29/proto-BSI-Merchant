// lib/views/refund/confirm_refund_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../viewmodels/transaction/transaction.dart';
import 'auth_refund_page.dart';

class ConfirmRefundPage extends StatelessWidget {
  final Transaction transaction;
  final int refundAmount;

  const ConfirmRefundPage({
    super.key,
    required this.transaction,
    required this.refundAmount,
  });

  String _formatRupiah(int amount) =>
      "Rp ${NumberFormat('#,###', 'id_ID').format(amount)}";

  @override
  Widget build(BuildContext context) {
    final tx = transaction;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Konfirmasi Refund"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Nominal Refund
            Text(
              "Nominal Refund – ${_formatRupiah(refundAmount)}",
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(height: 20),

            // 🔹 Ringkasan transaksi
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 3))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Total Transaksi: + ${_formatRupiah(tx.amount)}",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text("Nama Nasabah: ${tx.customerName}"),
                  Text("Aplikasi Issuer: ${tx.bank}"),
                  Text("Tanggal: ${DateFormat('d MMMM yyyy', 'id_ID').format(tx.date)}"),
                  Text("Jam: ${tx.time} WIB"),
                ],
              ),
            ),

            const Spacer(),

            // 🔹 Tombol Konfirmasi
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AuthRefundPage(
                        transaction: transaction,     // ✅ kirim transaction
                        refundAmount: refundAmount,   // ✅ kirim refundAmount
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Konfirmasi",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
